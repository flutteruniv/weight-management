import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];
  var seriesWeightList = List<weightData>();
  var seriesFatList = List<fatData>();
  DateTime sevenDaysAgo;
  DateTime thirtyDaysAgo;
  DateTime threeMonthsAgo;
  bool weight = true;

  Future weightTrue() {
    weight = true;
    notifyListeners();
  }

  Future weightFalse() {
    weight = false;
    notifyListeners();
  }

  Future fetchData() async {
    seriesFatList.clear();
    seriesWeightList.clear();
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;

    sevenDaysAgo = muscleData[0].timestamp.toDate().add(Duration(days: 7) * -1);
    thirtyDaysAgo =
        muscleData[0].timestamp.toDate().add(Duration(days: 30) * -1);
    threeMonthsAgo =
        muscleData[0].timestamp.toDate().add(Duration(days: 90) * -1);

    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(threeMonthsAgo)) break;
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      seriesFatList.add(fatData(
          muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
    }
    notifyListeners();
  }

  Future setOneWeek() {
    seriesWeightList.clear();
    seriesFatList.clear();
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(sevenDaysAgo)) break;
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      if (muscleData[i].bodyFatPercentage != null)
        seriesFatList.add(fatData(
            muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
    }
    notifyListeners();
  }

  Future setOneMonth() {
    seriesWeightList.clear();
    seriesFatList.clear();
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(thirtyDaysAgo)) break;
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      if (muscleData[i].bodyFatPercentage != null)
        seriesFatList.add(fatData(
            muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
    }
    notifyListeners();
  }

  Future setThreeMonths() {
    seriesWeightList.clear();
    seriesFatList.clear();
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(threeMonthsAgo)) break;
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      if (muscleData[i].bodyFatPercentage != null)
        seriesFatList.add(fatData(
            muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
    }
    notifyListeners();
  }

  Future setWholePeriod() {
    seriesWeightList.clear();
    seriesFatList.clear();
    for (int i = 0; i < muscleData.length; i++) {
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
      if (muscleData[i].bodyFatPercentage != null)
        seriesFatList.add(fatData(
            muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
    }
    notifyListeners();
  }
}

class weightData {
  final DateTime date;
  final double weight;

  weightData(this.date, this.weight);
}

class fatData {
  final DateTime date;
  final double fatPercentage;

  fatData(this.date, this.fatPercentage);
}
