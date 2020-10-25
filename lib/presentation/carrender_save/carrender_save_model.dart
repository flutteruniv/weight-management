import 'package:flutter/material.dart';

class CalenderSaveModel extends ChangeNotifier {
  String value = DateTime.now().toString();
  DateTime picked;

  void selectDate() async {
    if (picked != null) value = picked.toString();
    notifyListeners();
  }
}
