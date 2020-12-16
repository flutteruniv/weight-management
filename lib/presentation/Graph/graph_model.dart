import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weight_management/domain/user.dart';

class GraphModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];
  var seriesWeightList = List<weightData>();
  var seriesFatList = List<fatData>();
  DateTime sevenDaysAgo;
  DateTime thirtyDaysAgo;
  DateTime threeMonthsAgo;
  bool isSelectedWeight = true;
  bool hasData = false;

  List<Users> userData = [];
  String userDocID;

  Future weightTrue() {
    isSelectedWeight = true;
    notifyListeners();
  }

  Future weightFalse() {
    isSelectedWeight = false;
    notifyListeners();
  }

  Future fetchData() async {
    seriesFatList.clear();
    seriesWeightList.clear();
    final docss = await FirebaseFirestore.instance.collection('users').get();
    final userData = docss.docs.map((doc) => Users(doc)).toList();
    this.userData = userData;
    for (int i = 0; i < userData.length; i++) {
      if (userData[i].userID == FirebaseAuth.instance.currentUser.uid) {
        userDocID = userData[i].documentID;
        break;
      }
    }
    try {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('date', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
      if (muscleData[0] != null) hasData = true;
    } catch (e) {
      hasData = false;
    }

    if (hasData) {
      sevenDaysAgo =
          muscleData[0].timestamp.toDate().add(Duration(days: 7) * -1);
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
    }
    notifyListeners();
  }

  Future chagePeriod(DateTime time) {
    seriesWeightList.clear();
    seriesFatList.clear();
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(time)) break;
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
