import 'package:flutter/material.dart';
import 'package:weight_management/domain/ideal_muscle_data.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/users_repository.dart';

class CompareModel extends ChangeNotifier {
  MuscleData muscleData;
  List<String> weight = List(2);
  List<String> fatPercentage = List(2);
  List<String> imageURL = List(2);
  List<String> date = ['日付を選ぶ', '日付を選ぶ'];
  List<IdealMuscleData> idealMuscleList = [];
  IdealMuscleData idealMuscle;
  List<int> angle = [0, 0];

  List<Users> userData = [];
  Users myUser;
  String userDocID;
  final _usersRepository = UsersRepository.instance;

  Future setIdeal(int i) async {
    myUser = await _usersRepository.fetch();
    idealMuscle =
        await _usersRepository.getIdealMuscleData(docID: myUser.documentID);

    weight[i] = idealMuscle.weight.toString();
    if (idealMuscle.bodyFatPercentage != null)
      fatPercentage[i] = idealMuscle.bodyFatPercentage.toString();
    imageURL[i] = idealMuscle.imageURL;
    angle[i] = 0;
    date[i] = '理想の身体';

    notifyListeners();
  }

  Future clearValue(int i) {
    weight[i] = null;
    fatPercentage[i] = null;
    imageURL[i] = null;
    date[i] = '日付を選ぶ';
    angle[i] = 0;
    notifyListeners();
  }

  Future changeValue(MuscleData selectMuscleData, int i) {
    try {
      weight[i] = selectMuscleData.weight.toString();
      date[i] = selectMuscleData.date;

      fatPercentage[i] = selectMuscleData.bodyFatPercentage != null
          ? selectMuscleData.bodyFatPercentage.toString()
          : null;
      imageURL[i] =
          selectMuscleData.imageURL != null ? selectMuscleData.imageURL : null;
      angle[i] = selectMuscleData.angle != null ? selectMuscleData.angle : 0;
    } catch (e) {}
    notifyListeners();
  }
}
