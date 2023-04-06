import 'package:flutter/material.dart';

class ButtonModel extends ChangeNotifier {
  bool _haveCode = false;

  bool get haveCode => _haveCode;

  void toggle() {
    _haveCode = true;
    notifyListeners();
  }
}
