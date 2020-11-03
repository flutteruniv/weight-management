import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CalenderSaveModel extends ChangeNotifier {
  String viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now()); //表示する日付
  DateTime picked; //datepickerで取得する日付
  double addWeight; //textfieldで入力する値
  DateTime addDate = DateTime.now(); //firestoreに入れる日付

  List<MuscleData> muscledatas = [];

  Future fetchData() async {
    final docs =
        await FirebaseFirestore.instance.collection('muscleData').get();
    final muscledatas = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscledatas = muscledatas;
    notifyListeners();
  }

  void selectDate() async {
    //datepickerでとった値を入れる
    if (picked != null) {
      viewDate = (DateFormat('yyyy/MM/dd')).format(picked);
      addDate = picked;
    }
    notifyListeners();
  }

  Future addDataToFirebase() async {
    //firebaseに値を追加
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    await FirebaseFirestore.instance.collection('muscleData').add(
      {
        'weight': addWeight,
        'date': Timestamp.fromDate(addDate),
        'StringDate': viewDate,
      },
    );
  }

  Future upDateData(MuscleData muscleData) async {
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    final document = FirebaseFirestore.instance
        .collection('muscleData')
        .doc(muscleData.documentID);
    await document.update({'weight': addWeight});
  }
}
