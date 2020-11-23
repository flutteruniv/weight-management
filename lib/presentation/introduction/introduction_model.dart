import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionModel extends ChangeNotifier {
  bool intro;

  getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「intro」がキー名。見つからなければtrueを返す
    intro = prefs.getBool('intro') ?? true;
    notifyListeners();
  }

  setStringListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("intro", false);
    notifyListeners();
  }

  var listPagesViewModel = [
    PageViewModel(
      title: "体重管理アプリの使い方",
      body: "見た目の変化を記録したい。そんなあなたにお勧めです",
      image: const Center(
          child: Icon(
        Icons.analytics,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange, fontSize: 30),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "保存画面",
      body: '体重、体脂肪率、写真を保存しよう',
      image: const Center(
          child: Icon(
        Icons.analytics,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange, fontSize: 30),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "比較画面",
      body: '身体の変化を写真で楽しもう',
      image: const Center(
          child: Icon(
        Icons.analytics,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange, fontSize: 30),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "グラフ画面",
      body: 'グラフで体重、体脂肪率の遷移を見てみよう',
      image: const Center(
          child: Icon(
        Icons.analytics,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange, fontSize: 30),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "一覧画面",
      body: 'これまでの記録を一覧で見てみよう',
      image: const Center(
          child: Icon(
        Icons.analytics,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange, fontSize: 30),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
  ];
}
