import 'package:flutter/material.dart';

//Classe que desenha o display utilizando um canvas
class Display7Seg extends CustomPainter {
  int num; // Número que o display exibirá
  double tamanho; // Tamanho dos segmentos
  Color pickerColor;

  @override
  Display7Seg(this.num,this.pickerColor,this.tamanho);

  @override
  void paint(Canvas canvas, Size size) {
    final paintOn = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = pickerColor;

    final paintOff = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = Colors.grey;

    //Monta o display
    segA(canvas, size, ligaSegmento('a', num) ? paintOff : paintOn);
    segB(canvas, size, ligaSegmento('b', num) ? paintOff : paintOn);
    segC(canvas, size, ligaSegmento('c', num) ? paintOff : paintOn);
    segD(canvas, size, ligaSegmento('d', num) ? paintOff : paintOn);
    segE(canvas, size, ligaSegmento('e', num) ? paintOff : paintOn);
    segF(canvas, size, ligaSegmento('f', num) ? paintOff : paintOn);
    segG(canvas, size, ligaSegmento('g', num) ? paintOff : paintOn);
  }

  //Simulando a logica de funcionamento de um display fisico
  //recebe o segmento e um numero para verificar se acende ou nao o segmento
  bool ligaSegmento(String segm, int num) {
    List<int> a = [1, 4];
    List<int> b = [5, 6];
    List<int> c = [2];
    List<int> d = [1, 4, 7];
    List<int> e = [1, 3, 4, 5, 7,9];
    List<int> f = [1, 2, 3, 7];
    List<int> g = [0, 1, 7];

    switch (segm) {
      case 'a':
        return a.contains(num);
      case 'b':
        return b.contains(num);
      case 'c':
        return c.contains(num);
      case 'd':
        return d.contains(num);
      case 'e':
        return e.contains(num);
      case 'f':
        return f.contains(num);
      case 'g':
        return g.contains(num);
      default:
        return false;
    }
  }

  //Display desenhado manualmente com os offsets
  //cada funcao é um segmento do display
  void segA(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(20, 11);
    final p2 = Offset(70+tamanho, 11);
    canvas.drawLine(p1, p2, paint);
  }

  void segB(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(75+tamanho, 22);
    final p2 = Offset(75+tamanho, 72+tamanho);
    canvas.drawLine(p1, p2, paint);
  }

  void segC(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(75+tamanho, 87+tamanho);
    final p2 = Offset(75+tamanho, 137+(2*tamanho));
    canvas.drawLine(p1, p2, paint);
  }

  void segD(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(20, 142+(2*tamanho));
    final p2 = Offset(70+tamanho, 142+(2*tamanho));
    canvas.drawLine(p1, p2, paint);
  }

  void segE(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(15, 87+tamanho);
    final p2 = Offset(15, 137+(2*tamanho));
    canvas.drawLine(p1, p2, paint);
  }

  void segF(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(15, 22);
    final p2 = Offset(15, 72+tamanho);
    canvas.drawLine(p1, p2, paint);
  }

  void segG(Canvas canvas, Size size, Paint paint) {
    final p1 = Offset(20, 80+tamanho);
    final p2 = Offset(70+tamanho, 80+tamanho);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(Display7Seg oldDelegate) => false;
}