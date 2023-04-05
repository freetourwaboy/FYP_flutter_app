import 'package:flutter/material.dart';

class BarcodePainter extends StatelessWidget {
  final List<String> input;
  final Size size;
  final Color barColor;
  final Color backColor;

  const BarcodePainter(this.input, this.size, this.barColor, this.backColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: Painter(input, size, barColor, backColor));
  }
}

class Painter extends CustomPainter {
  final List<String> input;
  final Size sizePassed;
  final Color barColor;
  final Color backColor;

  Painter(this.input, this.sizePassed, this.barColor, this.backColor);

  @override
  void paint(Canvas canvas, Size size) {
    print(barColor);
    print(backColor);
    final blackPaint = Paint()..color = barColor;
    final spacePaint = Paint()..color = backColor;
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

    canvas.drawRect(
        Rect.fromLTWH(0, 0, sizePassed.width, sizePassed.height), spacePaint);

    // Calculate the width and height of each bar
    final barWidth = sizePassed.width / input[0].length;

    final barHeight = sizePassed.height;
    final longBarHeight = sizePassed.height + 13;
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

    var textPainter = TextPainter(
        text: TextSpan(
            text: input[1],
            style: const TextStyle(fontSize: 13, color: Colors.red)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    textPainter.layout(
      minWidth: 0,
      maxWidth: sizePassed.width,
    );

    var textOffset = Offset(
        sizePassed.width / 2 - textPainter.width / 2, sizePassed.height + 12);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
