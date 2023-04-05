import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class BarCode {
  static Future<List<String>> encode(
      JavascriptRuntime javascriptRuntime, String codeType, String raw) async {
    bool isNumeric =
        raw.split('').every((char) => char.contains(RegExp(r'[0-9]')));
    if (codeType == 'EAN13' && (raw.length != 12 || isNumeric == false)) {
      return ["Error: The input must be digits and 12 digits long", raw];
    }
    if (codeType == 'UPC' && (raw.length != 11 || isNumeric == false)) {
      return ["Error: The input must be digits and 11 digits long", raw];
    }
    switch (codeType) {
      case 'QR Code':
        codeType = 'qrcode';
        break;
      case 'Code128':
        codeType = 'code128';
        break;
      case 'Code39':
        codeType = 'code39';
        break;
      case 'EAN13':
        codeType = 'ean13';
        break;
      case 'UPC':
        codeType = 'upc';
        break;
    }
    final String uri = 'lib/assets/$codeType.js';
    final String funtionString = await rootBundle.loadString(uri);
    final jsResult =
        javascriptRuntime.evaluate("$funtionString      encode('$raw');");
    return [jsResult.stringResult, raw, codeType];
  }
}
