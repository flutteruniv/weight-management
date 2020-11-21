import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/muscle_data.dart';

class TopModel extends ChangeNotifier {
  bool savePageUpdate = false;
  bool listPageUpdate = false;

  Future updateListPageTrue() {
    listPageUpdate = true;
    notifyListeners();
  }

  Future updateListPageFalse() {
    listPageUpdate = false;
    notifyListeners();
  }

  Future updatePageTrue() {
    savePageUpdate = true;
    notifyListeners();
  }

  Future updatePageFalse() {
    savePageUpdate = false;
    notifyListeners();
  }

  Future init() async {
    notifyListeners();
  }

  int currentIndex = 0;

  void onTabTapped(int index) async {
    currentIndex = index;
    updateListPageFalse();
    notifyListeners();
  }
}
