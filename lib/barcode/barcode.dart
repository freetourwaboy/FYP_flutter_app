import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:fyp/model/button_model.dart';
import 'package:provider/provider.dart';

class BarCode {
  static Future<List<String>> encode(BuildContext context,
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

    final jsResult = codeType == 'qrcode'
        ? javascriptRuntime.evaluate("$funtionString   QRCode.generate('$raw')")
        : javascriptRuntime.evaluate("$funtionString      encode('$raw');");

    if (jsResult.stringResult != '' &&
        !jsResult.stringResult.startsWith('Error')) {
      toggle(context);
    }
    if (jsResult.stringResult.startsWith('Error')) {
      return [jsResult.stringResult, raw, codeType];
    }
    if (codeType == 'qrcode') {
      return [jsResult.stringResult, raw, codeType];
    }
    Map<String, dynamic> decode = jsonDecode(jsResult.stringResult);
    return [decode['barcode'], decode['fullcode'], codeType];
  }

  static void toggle(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    buttonModel.toggle();
  }
}
