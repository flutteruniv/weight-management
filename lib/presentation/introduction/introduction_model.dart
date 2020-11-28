import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionModel extends ChangeNotifier {
  bool intro = false;

  getPrefIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「intro」がキー名。見つからなければtrueを返す
    intro = prefs.getBool('intro') ?? true;
    notifyListeners();
  }

  setIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("intro", false);
    notifyListeners();
  }

  var listPagesViewModel = [
    PageViewModel(
      title: "体重管理アプリの使い方",
      body: "アプリをインストールしてくれて\nありがとうございます！！\n見た目の変化を記録したい。\nそんなあなたにお勧めです！！",
      image: const Center(
          child: Icon(
        Icons.fitness_center,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "保存画面",
      body: '体重、体脂肪率、写真を保存してみよう！',
      image: const Center(
          child: Icon(
        Icons.edit,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "比較画面",
      body: '身体の変化を写真で楽しもう！',
      image: const Center(
          child: Icon(
        Icons.group,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "グラフ画面",
      body: 'グラフで体重、体脂肪率の遷移を\n見てみよう！',
      image: const Center(
          child: Icon(
        Icons.insights,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "一覧画面",
      body: 'これまでの記録を一覧で見てみよう！',
      image: const Center(
          child: Icon(
        Icons.list_alt,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
    PageViewModel(
      title: "マイページ",
      body:
          '目標体重、理想の身体を設定しよう！\nログイン機能もあるので\n万が一の時も安心です！\n\nそれでは快適なマッスルライフへ\nいってらっしゃい！',
      image: const Center(
          child: Icon(
        Icons.person,
        size: 200,
      )),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    ),
  ];
}
