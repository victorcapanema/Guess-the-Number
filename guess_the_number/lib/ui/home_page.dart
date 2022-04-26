import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'display7Seg.dart';

const request =
    "https://us-central1-ss-devops.cloudfunctions.net/rand?min=1&max=300";

//Cor do display
var pickerColor = Color(0xFFE91E63);
double _currentValue = 0.0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//HOME PAGE DO APP
class _HomePageState extends State<HomePage> {
  final _inputController = TextEditingController();
  int attempts = 0;
  int randomNumber = 502;
  Map<dynamic, dynamic> myJson = new Map();
  String attemptsChar = "0/3";
  String dicaAttempt = "Inicie uma nova partida!";
  Color currentColor = Color(0xff443a49);

  //Requisição para API
  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(request));
    print(json.decode(response.body).toString());
    return json.decode(response.body);
  }

  //Requisita um novo numero / Nova partida
  void getNewNumber() async {
    attempts = 0;
    randomNumber = 0;
    attemptsChar = "0/3";
    _inputController.text = "";
    dicaAttempt = "Digite o palpite!";
    myJson = await getData();

    //No android tem um bug que o focus vai pro lugar errado, essa atribuição corrige
    _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length));

    //Tratamento do retorno da API
    //Verificando se tem um numero valido ou não
    if (myJson.containsKey("StatusCode")) {
      randomNumber = 502;
      setState(() {
        dicaAttempt = "Inicie uma nova partida!";
        _inputController.text = '502';
      });
    } else {
      randomNumber = myJson["value"];
    }
  }

  //Logica das tentativas de acertar o numero
  //e validações das respectivas entradas
  void validaAttempt(int num) {
    if (randomNumber == 0) {
      dicaAttempt = "Inicie uma nova partida!";
    } else {
      if (num == 0) {
        dicaAttempt = "Digite o palpite!";
      } else {
        if (num == randomNumber && attempts < 3) {
          dicaAttempt = "Acertou!";
          randomNumber = 502;
          attempts++;
        } else if (num != randomNumber && attempts < 3) {
          if (attempts == 2) {
            dicaAttempt = "Errou!";
            randomNumber = 502;
          } else if (num < randomNumber) {
            dicaAttempt = "É menor!";
          } else {
            dicaAttempt = "É maior!";
          }
          attempts++;
          attemptsChar = attempts.toString() + "/3";
        } else {
          dicaAttempt = "Inicie uma nova partida!";
        }
      }
    }
  }

  //Validação da entrada
  //Só permite digitar numeros de 1 a 300
  String validaInput(String valor) {
    final double min = 1;
    final double max = 300;

    if (valor == '') {
      return valor;
    } else if (int.parse(valor) < min) {
      return "1";
    } else {
      return int.parse(valor) > max ? valor.substring(0, 2) : valor;
    }
  }

  //Verifica se o texto esta vazio
  //utilizado para fazer validação
  String verificarInputController() {
    if (_inputController.text != "") {
      return _inputController.text;
    } else {
      return '0';
    }
  }

  //Retorna um numero pra ser exibido no display
  //de acordo com o display que chamou e retornado o numero daquela posição
  int displayNumber(int parm) {
    if (_inputController.text != "") {
      switch (parm) {
        case 3:
          if (_inputController.text.length == 3) {
            return int.parse(_inputController.text.substring(2, 3));
          } else {
            return 0;
          }
        case 2:
          if (_inputController.text.length >= 2) {
            return int.parse(_inputController.text.substring(1, 2));
          } else {
            return 0;
          }
        case 1:
          if (_inputController.text.length >= 1) {
            return int.parse(_inputController.text.substring(0, 1));
          } else {
            return 0;
          }
        default:
          {
            return 0;
          }
      }
    } else {
      return 0;
    }
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    Navigator.of(context).pop();
  }

  //Função para selecionar o tamanho do display
  void _showFontSizePickerDialog() async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizePickerDialog(_currentValue),
    );
    if (selectedFontSize != null) {
      setState(() {
        _currentValue = selectedFontSize;
      });
    }
  }

//Layout principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Qual é o número?"),
          backgroundColor: Colors.pink,
          actions: [
            GestureDetector(
              child: Icon(
                Icons.format_size,
                color: Colors.white,
              ),
              onTap: () {_showFontSizePickerDialog();},
            ),
            //Botao para mudar a cor do display
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: currentColor,
                          onColorChanged: changeColor,
                          enableLabel: true,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.palette,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Text(dicaAttempt, style: TextStyle(color: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //controle dos displays que serão exibidos
                  CriarDisplay(displayNumber(1)),
                  if (int.parse(verificarInputController()) > 9)
                    CriarDisplay(displayNumber(2)),
                  if (int.parse(verificarInputController()) > 99)
                    CriarDisplay(displayNumber(3))
                ],
              ),
              Column(
                children: [
                  //Botao Nova Partida
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        getNewNumber();
                      });
                    },
                    child: Text("Nova Partida"),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.white24,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _inputController,
                        inputFormatters: [LengthLimitingTextInputFormatter(3)],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Digite o palpite",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink))),
                        onChanged: (context) {
                          _inputController.text =
                              validaInput(_inputController.text);
                          _inputController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _inputController.text.length));
                        },
                      ),
                      Text(
                        attemptsChar,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
                  //Controla a exibição do botao enviar aproveitando o randomNumber
                  if (randomNumber != 502)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          validaAttempt(_inputController.text != ""
                              ? int.parse(_inputController.text)
                              : 0);
                        });
                      },
                      child: Text("ENVIAR"),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.black,
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    )
                ],
              ),
            ])));
  }
}

//Classe para criar o display
//durante a execução
class CriarDisplay extends StatelessWidget {
  int num;

  CriarDisplay(this.num);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: LayoutBuilder(
            builder: (_, constraints) => Container(
                  width: 90+_currentValue,
                  height: 150+_currentValue,
                  child: CustomPaint(painter: Display7Seg(num, pickerColor, _currentValue/2)),
                )));
  }
}

class FontSizePickerDialog extends StatefulWidget {
  final double initialFontSize;

  const FontSizePickerDialog(this.initialFontSize);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  double _currentValue = 1.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tamanho do Display'),
      content: Container(height: 200,
        child: Slider(
          value: _currentValue,
          min: 0,
          max: 34,
          label: _currentValue.toString(),
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
      ),
      actions: <Widget>[
       TextButton(
          onPressed: () {

            Navigator.pop(context, _currentValue);
          },
          child: Text('Concluir'),
        )
      ],
    );
  }
}