import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class ListModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];

  Future fetchData() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;
    notifyListeners();
  }
}
