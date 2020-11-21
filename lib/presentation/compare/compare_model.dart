import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CompareModel extends ChangeNotifier {
  MuscleData muscleData;
  String upperWeight;
  String upperFatPercentage;
  String lowerWeight;
  String lowerFatPercentage;
  String upperImageURL;
  String lowerImageURL;
  String upperDate = '日付を選ぶ';
  String lowerDate = '日付を選ぶ';
  /*
  List<String> weight = [null, null];
  List<String> fatPercentage = [];
  List<String> imageURL = [];
  List<String> date = ['日付を選ぶu', '日付を選ぶi'];

  Future clearValue(int i) {
    weight[i] = null;
    fatPercentage[i] = null;
    imageURL[i] = null;
    date[i] = '日付を選ぶ';
    notifyListeners();
  }
*/
  Future clearUpperValue() {
    upperWeight = null;
    upperFatPercentage = null;
    upperImageURL = null;
    upperDate = '日付を選ぶ';
    notifyListeners();
  }

  Future clearLowerValue() {
    lowerWeight = null;
    lowerFatPercentage = null;
    lowerImageURL = null;
    lowerDate = '日付を選ぶ';
    notifyListeners();
  }

/*
  Future changeValue(MuscleData selectMuscleData, int i) {
    weight[i] = selectMuscleData.weight.toString();
    date[i] = selectMuscleData.date;
    if (selectMuscleData.bodyFatPercentage != null) {
      fatPercentage[i] = selectMuscleData.bodyFatPercentage.toString();
      selectMuscleData.imageURL != null
          ? imageURL[i] = selectMuscleData.imageURL
          : imageURL[i] = null;
    } else {
      fatPercentage[i] = null;
      selectMuscleData.imageURL != null
          ? imageURL[i] = selectMuscleData.imageURL
          : imageURL[i] = null;
    }
    notifyListeners();
  }
*/
  Future changeUpperValue(MuscleData selectMuscleData) {
    upperWeight = selectMuscleData.weight.toString();
    upperDate = selectMuscleData.date;
    if (selectMuscleData.bodyFatPercentage != null) {
      upperFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      selectMuscleData.imageURL != null
          ? upperImageURL = selectMuscleData.imageURL
          : upperImageURL = null;
    } else {
      upperFatPercentage = null;
      selectMuscleData.imageURL != null
          ? upperImageURL = selectMuscleData.imageURL
          : upperImageURL = null;
    }
    notifyListeners();
  }

  Future changeLowerValue(MuscleData selectMuscleData) {
    lowerWeight = selectMuscleData.weight.toString();
    lowerDate = selectMuscleData.date;
    if (selectMuscleData.bodyFatPercentage != null) {
      lowerFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      selectMuscleData.imageURL != null
          ? lowerImageURL = selectMuscleData.imageURL
          : lowerImageURL = null;
    } else {
      upperFatPercentage = null;
      selectMuscleData.imageURL != null
          ? lowerImageURL = selectMuscleData.imageURL
          : lowerImageURL = null;
    }
    notifyListeners();
  }
}
