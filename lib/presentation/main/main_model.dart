import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopModel extends ChangeNotifier {
  bool savePageUpdate = false;
  bool listPageUpdate = false;
  //bool introduction = true;

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
