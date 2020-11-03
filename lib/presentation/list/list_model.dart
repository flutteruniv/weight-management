import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class ListModel extends ChangeNotifier {
  List<MuscleData> muscleData = [];

  Future fetchData() async {
    Firebase.initializeApp();
    final docs =
        await FirebaseFirestore.instance.collection('muscleData').get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;
    notifyListeners();
  }
}
