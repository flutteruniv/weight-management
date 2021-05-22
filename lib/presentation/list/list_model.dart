import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/auth_repository.dart';
import 'package:weight_management/repository/users_repository.dart';

class ListModel extends ChangeNotifier {
  String userDocID;
  List<MuscleData> muscleData = [];
  String sortName = '日付順（降順）';

  final _userRepository = UsersRepository.instance;
  final _authRepository = AuthRepository.instance;
  Users myUser;

  Future fetch(BuildContext context) async {
    if (_authRepository.isLogin) {
      try {
        myUser = await _userRepository.fetch();
        muscleData = await _userRepository.getMuscleData(
            docID: myUser.documentID, orderByState: 'date', bool: true);
      } catch (e) {
        print("${e.toString()}一覧");
      }
    }
    notifyListeners();
  }

  Future deleteMuscleData(MuscleData muscleData) async {
    _userRepository.deleteMuscleData(myUser, muscleData);
  }

  Future<int> showCupertinoBottomBar(BuildContext context) {
    //選択するためのボトムシートを表示
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('表示順を選ぶ'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  '日付（降順）',
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  '日付（昇順）',
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  '体重順（降順）',
                ),
                onPressed: () {
                  Navigator.pop(context, 2);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  '体重順（昇順）',
                ),
                onPressed: () {
                  Navigator.pop(context, 3);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, 4);
              },
              isDefaultAction: true,
            ),
          );
        });
  }

  void showBottomSheet(BuildContext context) async {
    //ボトムシートから受け取った値によって操作を変える
    final sortingType = await showCupertinoBottomBar(context);
    if (sortingType == 0) {
      sortName = '日付順（降順）';
      muscleData = await _userRepository.getMuscleData(
          docID: myUser.documentID, orderByState: 'date', bool: true);
    } else if (sortingType == 1) {
      sortName = '日付順（昇順）';
      muscleData = await _userRepository.getMuscleData(
          docID: myUser.documentID, orderByState: 'date', bool: false);
    } else if (sortingType == 2) {
      sortName = '体重順（降順）';
      muscleData = await _userRepository.getMuscleData(
          docID: myUser.documentID, orderByState: 'weight', bool: true);
    } else if (sortingType == 3) {
      sortName = '体重順（昇順）';
      muscleData = await _userRepository.getMuscleData(
          docID: myUser.documentID, orderByState: 'weight', bool: false);
    }
    notifyListeners();
  }
}
