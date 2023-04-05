import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> captureCanvas(GlobalKey paintKey) async {
  RenderRepaintBoundary boundary =
      paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(); // Adjust pixel ratio as needed
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData?.buffer;
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/barcode.png';
  await File(filePath).writeAsBytes(
      buffer!.asUint8List(byteData!.offsetInBytes, byteData.lengthInBytes));
}
