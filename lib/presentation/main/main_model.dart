import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class TopModel extends ChangeNotifier {
  Future init() async {
    notifyListeners();
  }

  int currentIndex = 0;

  void onTabTapped(int index) async {
    currentIndex = index;
    notifyListeners();
  }
}
