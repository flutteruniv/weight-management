import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderSaveModel extends ChangeNotifier {
  // String value = DateTime.now().toString();
  String viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now()); //表示する日付
  DateTime picked;
  double addWeight;
  DateTime addDate = DateTime.now(); //firestoreに入れる日付

  void selectDate() async {
    //datepickerでとった値を入れる
    if (picked != null) {
      viewDate = (DateFormat('yyyy/MM/dd')).format(picked);
      addDate = picked;
    }
    notifyListeners();
  }

  Future addDataToFirebase() {
    //firebaseに値を追加
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    FirebaseFirestore.instance.collection('muscleData').add(
      {
        'weight': addWeight,
        'date': Timestamp.fromDate(addDate),
      },
    );
  }
}
