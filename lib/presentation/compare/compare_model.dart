import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CompareModel extends ChangeNotifier {
  MuscleData muscleData;
  String upperWeight = '30';
  String upperFatPercentage;
  String lowerWeight = '10';
  String lowerFatPercentage;

  Future changeUpperWeight(MuscleData selectMuscleData) {
    upperWeight = selectMuscleData.weight.toString();
    notifyListeners();
  }

  Future changeLowerWeight(MuscleData selectMuscleData) {
    lowerWeight = selectMuscleData.weight.toString();
    notifyListeners();
  }
}
