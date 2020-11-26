import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];
  var seriesList = List<Data>();
  var dateList = List<DateTime>();
  var stringDateList = List<String>();
  String date;
  DateTime useDate;

  Future fetchData() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;

    for (int i = 0; i < muscleData.length; i++) {
      seriesList
          .add(Data(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      //  dateList.add(muscleData[i].timestamp.toDate());
      stringDateList.add(muscleData[i].date);
      useDate = parseDateString(muscleData[i].date);
      dateList.add(useDate);
    }
    date = muscleData[0].date;
    notifyListeners();
  }

  DateTime parseDateString(String str) {
    final splitted = str.split("/").map(int.parse).toList();
    return DateTime(splitted[0], splitted[1], splitted[2]);
  }
}

class Data {
  final DateTime date;
  final double weight;

  Data(this.date, this.weight);
}
