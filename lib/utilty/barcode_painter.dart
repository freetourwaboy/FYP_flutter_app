import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BarcodePainter extends StatelessWidget {
  final List<String> input;

  BarcodePainter(this.input);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Painter(input),
      size: Size.infinite,
    );
  }
}

class Painter extends CustomPainter {
  final List<String> input;

  Painter(this.input);
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final spacePaint = Paint()..color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), spacePaint);

    // Calculate the width and height of each bar
    final barWidth = size.width / input[0].length;
    final barHeight = size.height;

    // Iterate over the string and draw bars or spaces
    for (var i = 0; i < input[0].length; i++) {
      final xPos = i * barWidth;

      if (input[0][i] == '1') {
        canvas.drawRect(
          Rect.fromLTWH(xPos, 0, barWidth, barHeight),
          blackPaint,
        );
      }
    }

    var textPainter = TextPainter(
        text: TextSpan(
            text: input[1],
            style: const TextStyle(fontSize: 13, color: Colors.red)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    var textOffset =
        Offset(size.width / 2 - textPainter.width / 2, size.height + 5);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
