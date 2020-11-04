import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/presentation/Graph/graph_page.dart';
import 'package:weight_management/presentation/carrender_save/carrender_save_page.dart';
import 'package:weight_management/presentation/list/list_page.dart';
import 'package:weight_management/presentation/main/main_model.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/seni.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TopPage(),
    );
  }
}

class TopPage extends StatelessWidget {
  final List<String> _tabNames = [
    "保存",
    "比較",
    "グラフ",
    "一覧",
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      create: (_) => TopModel()..init(),
      child: Consumer<TopModel>(
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(_tabNames[model.currentIndex]),
                backgroundColor: Colors.blue,
              ),
              body: _topPageBody(context),
              bottomNavigationBar: BottomNavigationBar(
                onTap: model.onTabTapped,
                currentIndex: model.currentIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text(_tabNames[0]),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.movie),
                    title: Text(_tabNames[1]),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.speaker_notes),
                    title: Text(_tabNames[2]),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text(_tabNames[3]),
                  ),
                ],
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
        _tabPage(currentIndex, 1, seni()),
        _tabPage(currentIndex, 2, GraphPage()),
        _tabPage(currentIndex, 3, ListPage()),
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
