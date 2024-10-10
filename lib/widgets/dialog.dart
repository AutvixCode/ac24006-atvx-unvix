// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../controllers/global_variables.dart';

class SlideIndex extends StatefulWidget {
  final int index;
  SlideIndex(this.index);
  @override
  _SlideIndexState createState() => _SlideIndexState();
}

class _SlideIndexState extends State<SlideIndex> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Iniciar o controlador de página na página inicial passada
    _pageController = PageController(initialPage: widget.index);
    currentIndex = widget.index;
  }

  void _nextPage() {
    if (currentIndex < slideList.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      itemCount: slideList.length,
      itemBuilder: (ctx, i) => SlideItem(i, _previousPage, _nextPage),
    );
  }
}

class SlideItem extends StatelessWidget {
  final int index;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  SlideItem(this.index, this.onPrevious, this.onNext);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        slideList[index].title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onPrevious,
                  child: SvgPicture.asset(
                    arrowLf,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    slideList[index].imageUrl,
                    width: 60,
                    height: 60,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    slideList[index].description,
                    textAlign: TextAlign.center,
                    softWrap: true,  // Permite quebra de linha
                    overflow: TextOverflow.visible, // Garante que o texto sempre será mostrado
                  ),
                ),
                GestureDetector(
                  onTap: onNext,
                  child: SvgPicture.asset(
                    arrowRg,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}


class Slide {
  final String title;
  final String imageUrl;
  final String description;

  Slide(
      {required this.title, required this.imageUrl, required this.description});
}

final slideList = [
  Slide(
    title: "Bem vindo ao Tutorial",
    imageUrl: unityFile,
    description:
        'Essa é uma integração de arquivos .fbx ao software Bim no unity.',
  ),
  Slide(
    title: "Primeiro Passo",
    imageUrl: importFile,
    description:
        'Clique em “Selecionar arquivo” e Importe o arquivo .fbx do seu projeto.',
  ),
  Slide(
    title: "Segundo Passo",
    imageUrl: fileImp,
    description:
        'Caso tenha sido importado ele apresentará a mensagem “Arquivo importado com Sucesso”.',
  ),
  Slide(
      title: "Terceiro Passo",
      imageUrl: sendFile,
      description:
          "Encaminhe o arquivo para o app, selecionado “Enviar arquivo”."),
  Slide(
    title: "Pronto o sorvetin",
    imageUrl: iconLogo,
    description:
        'Se desejar encerrar a sessão deste aplicativo com a sua plataforma, clique no ícone para efetuar o desvinculo do aparelho.',
  ),
];
