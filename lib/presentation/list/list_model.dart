import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class ListModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];
  String sortName = '日付順（降順）';

  Future fetchData() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;
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
    final result = await showCupertinoBottomBar(context);
    if (result == 0) {
      sortName = '日付順（降順）';
      final docs = await FirebaseFirestore.instance
          .collection('muscleData')
          .orderBy('date', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (result == 1) {
      sortName = '日付順（昇順）';
      final docs = await FirebaseFirestore.instance
          .collection('muscleData')
          .orderBy('date', descending: false)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (result == 2) {
      sortName = '体重順（降順）';
      final docs = await FirebaseFirestore.instance
          .collection('muscleData')
          .orderBy('weight', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    } else if (result == 3) {
      sortName = '体重順（昇順）';
      final docs = await FirebaseFirestore.instance
          .collection('muscleData')
          .orderBy('weight', descending: false)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
    }
    notifyListeners();
  }
}
