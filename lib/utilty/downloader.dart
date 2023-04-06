import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<void> captureCanvas(GlobalKey paintKey) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  RenderRepaintBoundary boundary =
      paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(); // Adjust pixel ratio as needed
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData?.buffer;
  var directory = "/storage/emulated/0/Download/";
  bool dirDownloadExists = true;
  dirDownloadExists = await Directory(directory).exists();
  if (dirDownloadExists) {
    directory = "/storage/emulated/0/Download/";
  } else {
    directory = "/storage/emulated/0/Downloads/";
  }

  final filePath = '$directory/barcode.png';
  await File(filePath).writeAsBytes(
      buffer!.asUint8List(byteData!.offsetInBytes, byteData.lengthInBytes));
}
