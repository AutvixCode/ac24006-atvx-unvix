# Documentação do `main.dart`

Este arquivo define uma aplicação Flutter que permite ao usuário selecionar e fazer upload de arquivos `.fbx` para um servidor. Ele utiliza bibliotecas como `file_picker` para selecionar arquivos e `http` para enviar requisições de upload.

## Funcionalidades

- **Seleção de Arquivos**: Permite que o usuário selecione arquivos `.fbx` do dispositivo.
- **Upload de Arquivos**: Realiza o upload do arquivo selecionado para o servidor.
- **UI Responsiva**: A interface é projetada com widgets responsivos, utilizando gradientes e contêineres customizados.

## Estrutura do Código

### Bibliotecas Importadas

- `file_picker`: Usada para selecionar arquivos do dispositivo.
- `http`: Utilizada para enviar requisições HTTP ao servidor.
- `flutter_svg`: Para carregar e exibir imagens SVG.

### Componentes Principais

- **`MyApp`**: Classe principal que inicializa o aplicativo.
- **`FileUploadScreen`**: Tela principal que contém a interface para seleção e upload de arquivos.

### Estado da Tela

- `selectedFileBytes`: Armazena o conteúdo do arquivo selecionado em formato `Uint8List`.
- `selectedFileName`: Armazena o nome do arquivo selecionado.

### Funções

- **`_pickFile()`**:
  - Abre o seletor de arquivos e permite que o usuário escolha um arquivo `.fbx`.
  - Armazena os dados do arquivo em `selectedFileBytes` e o nome do arquivo em `selectedFileName`.
  
- **`_uploadFile()`**:
  - Realiza o upload do arquivo selecionado para o servidor via uma requisição `MultipartRequest`.
  - Mostra uma notificação (`SnackBar`) ao usuário sobre o sucesso ou erro do upload.

- **`_dialog()`**:
  - Mostra uma caixa de diálogo personalizada ao usuário.
  
### Interface do Usuário

- **Gradiente de fundo**: A tela usa um gradiente de cores entre preto claro e preto escuro.
- **Contêineres**: A interface é composta de caixas com sombra e bordas arredondadas para uma experiência visual mais atraente.
- **Botões**:
  - **Selecionar Arquivo**: Permite ao usuário escolher um arquivo.
  - **Enviar Arquivo**: Faz o upload do arquivo selecionado.

### Requisições HTTP

- O arquivo faz uma requisição POST para `http://172.27.90.203:8080/upload`, enviando o arquivo `.fbx` selecionado.

## Requisitos

- **Flutter** SDK
- **Pacotes**:
  - `file_picker`
  - `http`
  - `flutter_svg`

## Como Usar

1. Clone o repositório.
2. Instale as dependências do projeto com o comando:

    ``` 
   flutter pub get
    ```
