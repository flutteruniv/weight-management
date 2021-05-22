import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopModel extends ChangeNotifier {
  bool saveDone = false;
  bool deleteDone = false;

  void changeSaveDone(bool bool) {
    saveDone = bool;
    notifyListeners();
  }

  void changeDeleteDone(bool bool) {
    deleteDone = bool;
    notifyListeners();
  }

  int currentIndex = 0;

  void onTabTapped(int index) async {
    currentIndex = index;

    notifyListeners();
  }
}
