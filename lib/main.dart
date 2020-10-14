import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> _tabNames = [
    "保存",
    "比較",
    "グラフ",
    "一覧",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_tabNames[1]),
        ),
        body: _topPageBody(context),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.cake),
              title: Text(
                _tabNames[0],
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grade),
              title: Text(
                _tabNames[1],
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              title: Text(_tabNames[2]),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages),
              title: Text(_tabNames[3]),
            ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget _topPageBody(BuildContext context) {
    /*final model = Provider.of<TopModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabPage(currentIndex, 0, HomePage()),
        _tabPage(currentIndex, 1, VimeoPage()),
        _tabPage(currentIndex, 2, NotificationPage()),
        _tabPage(currentIndex, 3, MyPage()),
      ],
    );*/
  }

  Widget _tabPage(int currentIndex, int tabIndex, StatelessWidget page) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: page,
    );
  }
}
