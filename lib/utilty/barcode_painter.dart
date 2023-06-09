import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

class BarcodePainter extends StatelessWidget {
  final List<String> input;
  final Size size;
  final Color barColor;
  final Color bgColor;

  const BarcodePainter(this.input, this.size, this.barColor, this.bgColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: Painter(input, size, barColor, bgColor));
  }
}

class Painter extends CustomPainter {
  final List<String> input;
  final Size sizePassed;
  final Color barColor;
  final Color bgColor;

  Painter(this.input, this.sizePassed, this.barColor, this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = barColor;
    final spacePaint = Paint()..color = Colors.white;
    final List<int> eanGuardsIndex = [0, 1, 2, 45, 46, 47, 48, 49, 92, 93, 94];
    final List<int> upcGuardsIndex = [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      45,
      46,
      47,
      48,
      49,
      87,
      86,
      85,
      84,
      91,
      90,
      89,
      88,
      92,
      93,
      94
    ];
    final barWidth = sizePassed.width / input[0].length;

    final barHeight = sizePassed.height;
    final longBarHeight = sizePassed.height + 13;
    if (input[2] != 'qrcode') {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, sizePassed.width, sizePassed.height), spacePaint);

      // Calculate the width and height of each bar

      // Iterate over the string and draw bars or spaces
      for (var i = 0; i < input[0].length; i++) {
        final xPos = i * barWidth;
        if (input[0][i] == '1') {
          if (input[2] == 'ean13' && eanGuardsIndex.contains(i)) {
            canvas.drawRect(
              Rect.fromLTWH(xPos, 0, barWidth, longBarHeight),
              blackPaint,
            );
          } else if (input[2] == 'upc' && upcGuardsIndex.contains(i)) {
            {
              canvas.drawRect(
                Rect.fromLTWH(xPos, 0, barWidth, longBarHeight),
                blackPaint,
              );
            }
          } else {
            canvas.drawRect(
                Rect.fromLTWH(xPos, 0, barWidth, barHeight), blackPaint);
          }
        }
      }
    } else {
      List matrix = jsonDecode(input[0]);
      double modsize = max(5, 0.5);
      double margin = max(4, 0.0);
      int n = matrix.length;
      double size = modsize * (n + 2 * margin);
      canvas.drawRect(Rect.fromLTWH(0, 0, size, size), spacePaint);
      for (var i = 0; i < n; ++i) {
        for (var j = 0; j < n; ++j) {
          if (matrix[i][j] == 1) {
            canvas.drawRect(
                Rect.fromLTWH(modsize * (margin + j), modsize * (margin + i),
                    modsize, modsize),
                blackPaint);
          }
        }
      }
    }

    var textPainter;
    var textOffset;
    const init_x = -15.0;
    if (input[2] == 'ean13') {
      String t1 = input[1].substring(0, 1);
      String t2 = input[1].substring(1, 7);
      String t3 = input[1].substring(7);
      textPainter = createTP(t1);

      textOffset = Offset(init_x, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
      textPainter = createTP(t2);
      textOffset = Offset(init_x + barWidth * 17, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
      textPainter = createTP(t3);
      textOffset = Offset(init_x + barWidth * 63, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
    } else if (input[2] == 'upc') {
      String t1 = input[1].substring(0, 1);
      String t2 = input[1].substring(1, 6);
      String t3 = input[1].substring(6, 11);
      String t4 = input[1].substring(11);
      textPainter = createTP(t1);
      textOffset = Offset(init_x, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
      textPainter = createTP(t2);
      textOffset = Offset(init_x + barWidth * 24, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
      textPainter = createTP(t3);
      textOffset = Offset(init_x + barWidth * 62, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
      textPainter = createTP(t4);
      textOffset = Offset(init_x + barWidth * 103, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
    } else if (input[2] != 'qrcode') {
      textPainter = createTP(input[1]);
      textOffset = Offset(
          sizePassed.width / 2 - textPainter.width / 2, sizePassed.height + 2);
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  TextPainter createTP(String text) {
    var textPainter = TextPainter(
        text: TextSpan(
            text: text, style: TextStyle(fontSize: 20, color: bgColor)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(
      minWidth: 0,
      maxWidth: sizePassed.width,
    );
    return textPainter;
  }
}
