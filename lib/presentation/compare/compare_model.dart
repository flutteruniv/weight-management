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

  Future changeUpperValue(MuscleData selectMuscleData) {
    upperWeight = selectMuscleData.weight.toString();
    upperDate = selectMuscleData.date;
    if (selectMuscleData.bodyFatPercentage != null && //ありあり
        selectMuscleData.imageURL != null) {
      upperFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      upperImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage == null && //なしあり
        selectMuscleData.imageURL != null) {
      upperFatPercentage = null;
      upperImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage != null && //ありなし
        selectMuscleData.imageURL == null) {
      upperFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      upperImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage == null && //なしなし
        selectMuscleData.imageURL == null) {
      upperFatPercentage = null;
      upperImageURL = null;
    }
    notifyListeners();
  }

  Future changeLowerValue(MuscleData selectMuscleData) {
    lowerWeight = selectMuscleData.weight.toString();
    lowerDate = selectMuscleData.date;
    if (selectMuscleData.bodyFatPercentage != null && //ありあり
        selectMuscleData.imageURL != null) {
      lowerFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      lowerImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage == null && //なしあり
        selectMuscleData.imageURL != null) {
      lowerFatPercentage = null;
      lowerImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage != null && //ありなし
        selectMuscleData.imageURL == null) {
      lowerFatPercentage = selectMuscleData.bodyFatPercentage.toString();
      lowerImageURL = selectMuscleData.imageURL;
    } else if (selectMuscleData.bodyFatPercentage == null && //なしなし
        selectMuscleData.imageURL == null) {
      lowerFatPercentage = null;
      lowerImageURL = null;
    }
    notifyListeners();
  }
}
