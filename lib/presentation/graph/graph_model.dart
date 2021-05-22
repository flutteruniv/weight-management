import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/users_repository.dart';
import 'package:weight_management/services/dialog_helper.dart';

class GraphModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];
  var seriesWeightList = List<weightData>();
  var seriesFatList = List<fatData>();
  DateTime weightSevenDaysAgo;
  DateTime weightThirtyDaysAgo;
  DateTime weightThreeMonthsAgo;
  DateTime fatSevenDaysAgo;
  DateTime fatThirtyDaysAgo;
  DateTime fatThreeMonthsAgo;
  bool isSelectedWeight = true;
  bool hasData = false;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final _userRepository = UsersRepository.instance;
  Users myUser;

  Future weightTrue() {
    isSelectedWeight = true;
    notifyListeners();
  }

  Future weightFalse() {
    isSelectedWeight = false;
    notifyListeners();
  }

  Future fetch(BuildContext context) async {
    if (currentUser != null) {
      try {
        seriesWeightList.clear();
        seriesFatList.clear();
        myUser = await _userRepository.fetch();
        muscleData = await _userRepository.getMuscleData(
            docID: myUser.documentID, orderByState: 'date', bool: true);
        hasData = true;
        await getWeightDays();
        getWeightList(weightThirtyDaysAgo);
        await getFatDays();
        if (fatThirtyDaysAgo != null) {
          getFatList(fatThirtyDaysAgo);
        }
      } catch (e) {
        hasData = false;
        print("${e.toString()}グラフ");
      }
    }
    notifyListeners();
  }

  Future getWeightDays() {
    weightSevenDaysAgo =
        muscleData.first.timestamp.toDate().add(Duration(days: 7) * -1);
    weightThirtyDaysAgo =
        muscleData.first.timestamp.toDate().add(Duration(days: 30) * -1);
    weightThreeMonthsAgo =
        muscleData.first.timestamp.toDate().add(Duration(days: 90) * -1);
    notifyListeners();
  }

  //dateTime以内の体重をリストに格納
  Future getWeightList(DateTime dateTime) {
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(dateTime)) break;
      seriesWeightList.add(
          weightData(muscleData[i].timestamp.toDate(), muscleData[i].weight));
    }
    notifyListeners();
  }

  Future getFatDays() {
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].bodyFatPercentage != null) {
        fatSevenDaysAgo =
            muscleData[i].timestamp.toDate().add(Duration(days: 7) * -1);
        fatThirtyDaysAgo =
            muscleData[i].timestamp.toDate().add(Duration(days: 30) * -1);
        fatThreeMonthsAgo =
            muscleData[i].timestamp.toDate().add(Duration(days: 90) * -1);
        break;
      }
    }
    print(fatThirtyDaysAgo);
    notifyListeners();
  }

  Future getFatList(DateTime dateTime) {
    for (int i = 0; i < muscleData.length; i++) {
      if (muscleData[i].timestamp.toDate().isBefore(dateTime)) break;
      if (muscleData[i].bodyFatPercentage != null) {
        seriesFatList.add(fatData(
            muscleData[i].timestamp.toDate(), muscleData[i].bodyFatPercentage));
      }
    }
    notifyListeners();
  }

  Future changeWeight(DateTime dateTime) async {
    seriesWeightList.clear();
    await getWeightDays();
    getWeightList(dateTime);
    notifyListeners();
  }

  Future changeFat(DateTime dateTime) async {
    seriesFatList.clear();
    await getFatDays();
    getFatList(dateTime);
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
