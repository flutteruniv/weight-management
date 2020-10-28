import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderSaveModel extends ChangeNotifier {
  // String value = DateTime.now().toString();
  String date = (DateFormat('yyyy/MM/dd')).format(DateTime.now());
  DateTime picked;
  double addWeight;

  void selectDate() async {
    if (picked != null) date = (DateFormat('yyyy/MM/dd')).format(picked);
    notifyListeners();
  }

  Future addDataToFirebase() {
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    FirebaseFirestore.instance.collection('muscleData').add(
      {
        'weight': addWeight,
        'date': date,
      },
    );
  }
}
