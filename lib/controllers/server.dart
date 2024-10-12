import 'dart:io';
import 'dart:async'; // Importar suporte para Streams
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:path/path.dart' as p;


// Defina a pasta onde os arquivos serão salvos
final String uploadDir = 'uploads/';

// Função para criar a rota do servidor
Router _router() {
  final router = Router();

  // Rota para upload de arquivo
  router.post('/upload', (Request request) async {
    try {
      final contentType = request.headers['Content-Type'] ?? '';

      if (!contentType.startsWith('multipart/form-data')) {
        return Response(400, body: 'Requisição inválida');
      }

      final boundary = contentType.split('boundary=')[1];
      final transformer = MimeMultipartTransformer(boundary);
      final parts = await request.read().transform(transformer).toList();

      for (var part in parts) {
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="(.+)"').firstMatch(contentDisposition!)?.group(1);

        if (filename != null) {
          final file = File(p.join(uploadDir, filename));
          await file.create(recursive: true);
          final sink = file.openWrite();
          await sink.addStream(part);
          await sink.close();
        }
      }

      return Response.ok('Upload realizado com sucesso!');
    } catch (e) {
      return Response(500, body: 'Erro ao processar o upload');
    }
  });

  return router;
}

Future<void> startServer() async {
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router());

  // Inicie o servidor
  final server = await shelf_io.serve(handler, '0.0.0.0', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');

  if (!Directory(uploadDir).existsSync()) {
    Directory(uploadDir).createSync();
  }
}
