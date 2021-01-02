import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/user.dart';

class SelectModel extends ChangeNotifier {
  List<Users> userData = [];
  String userDocID;
  List<MuscleData> muscleData = [];
  String sortName = '日付順（降順）';
  bool hasData = false;
  final User currentUser = FirebaseAuth.instance.currentUser;

  Future fetchData() async {
    if (currentUser != null) {
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
    }
    notifyListeners();
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
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('date', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (sortingType == 1) {
      sortName = '日付順（昇順）';
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('date', descending: false)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (sortingType == 2) {
      sortName = '体重順（降順）';
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('weight', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (sortingType == 3) {
      sortName = '体重順（昇順）';
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('weight', descending: false)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    }
    notifyListeners();
  }
}
