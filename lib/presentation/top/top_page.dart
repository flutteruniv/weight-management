import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/presentation/Graph/graph_page.dart';
import 'package:weight_management/presentation/Top/top_model.dart';
import 'package:weight_management/presentation/carrender_save/save_page.dart';
import 'package:weight_management/presentation/compare/compare_page.dart';
import 'package:weight_management/presentation/list/list_page.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/mypage/mypage.dart';

class TopPage extends StatelessWidget {
  final List<String> _tabNames = [
    "保存",
    "比較",
    "グラフ",
    "一覧",
    "マイページ",
  ];

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<TopModel>(
      create: (_) => TopModel()..init(),
      child: Consumer<TopModel>(
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: deviceHeight * 0.06,
                centerTitle: true,
                title: Text(
                  _tabNames[model.currentIndex],
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.blue,
              ),
              body: _topPageBody(context),
              bottomNavigationBar: SizedBox(
                height: deviceHeight * 0.1,
                child: BottomNavigationBar(
                  onTap: model.onTabTapped,
                  currentIndex: model.currentIndex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit),
                      title: Text(_tabNames[0]),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      title: Text(_tabNames[1]),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.insights),
                      title: Text(_tabNames[2]),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt),
                      title: Text(_tabNames[3]),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text(_tabNames[4]),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget _topPageBody(BuildContext context) {
    Firebase.initializeApp();
    final model = Provider.of<TopModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabPage(currentIndex, 0, CarenderSavePage()),
        _tabPage(currentIndex, 1, ComparePage()),
        _tabPage(currentIndex, 2, GraphPage()),
        _tabPage(currentIndex, 3, ListPage()),
        _tabPage(currentIndex, 4, MyPage()),
      ],
    );
  }

  Widget _tabPage(int currentIndex, int tabIndex, StatelessWidget page) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: page,
    );
  }
}
