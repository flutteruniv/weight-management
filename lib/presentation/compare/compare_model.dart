import 'dart:html';

import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CompareModel extends ChangeNotifier {
  MuscleData muscleData;
  List<String> weight = List(2);
  List<String> fatPercentage = List(2);
  List<String> imageURL = List(2);
  List<String> date = ['日付を選ぶ', '日付を選ぶ'];

  Future clearValue(int i) {
    weight[i] = null;
    fatPercentage[i] = null;
    imageURL[i] = null;
    date[i] = '日付を選ぶ';
    notifyListeners();
  }

  Future changeValue(MuscleData selectMuscleData, int i) {
    weight[i] = selectMuscleData.weight.toString();
    date[i] = selectMuscleData.date;

    fatPercentage[i] = selectMuscleData.bodyFatPercentage != null
        ? selectMuscleData.bodyFatPercentage.toString()
        : null;
    imageURL[i] =
        selectMuscleData.imageURL != null ? selectMuscleData.imageURL : null;
    notifyListeners();
  }
}
