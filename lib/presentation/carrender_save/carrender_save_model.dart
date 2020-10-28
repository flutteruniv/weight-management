import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderSaveModel extends ChangeNotifier {
  // String value = DateTime.now().toString();
  String value = (DateFormat('yyyy/MM/dd')).format(DateTime.now());
  DateTime picked;

  void selectDate() async {
    if (picked != null) value = (DateFormat('yyyy/MM/dd')).format(picked);
    notifyListeners();
  }
}
