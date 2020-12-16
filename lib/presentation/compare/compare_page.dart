import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/compare/compare_model.dart';
import 'package:weight_management/presentation/compare/select_page.dart';

class ComparePage extends StatelessWidget {
  ComparePage({this.muscleData});
  MuscleData muscleData;
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<CompareModel>(
      create: (_) => CompareModel(),
      child: Center(
        child: Scaffold(
          body: Container(
            padding:
                EdgeInsets.only(right: 20, left: 20, top: deviceHeight * 0.02),
            child: Consumer<CompareModel>(
              builder: (context, model, child) {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonTheme(
                                  minWidth: deviceWidth * 0.1,
                                  height: 40,
                                  child: RaisedButton.icon(
                                    // 日付を取得
                                    icon: Icon(Icons.date_range),
                                    onPressed: () async {
                                      MuscleData muscleData =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute<MuscleData>(
                                          builder: (context) => SelectPage(),
                                        ),
                                      );
                                      await model.changeValue(muscleData, 0);
                                    },
                                    label: Text(
                                      model.date[0],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.3,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          '体重',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                        child: model.weight[0] != null
                                            ? Text(
                                                model.weight[0].toString() +
                                                    ' kg',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            : Text(
                                                'なし',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.3,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          '体脂肪率',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                          child: model.fatPercentage[0] != null
                                              ? Text(
                                                  model.fatPercentage[0]
                                                          .toString() +
                                                      ' %',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )
                                              : Text(
                                                  'なし',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                    ],
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 120,
                                  height: 30,
                                  child: RaisedButton.icon(
                                    // クリアする
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await model.clearValue(0);
                                    },
                                    label: Text(
                                      'クリア',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 120,
                                  height: 30,
                                  child: RaisedButton.icon(
                                    // クリアする
                                    icon: Icon(Icons.fitness_center_rounded),
                                    onPressed: () async {
                                      await setIdealData(model, context, 0);
                                    },
                                    label: Text(
                                      '理想',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: deviceWidth * 0.05,
                            ),
                            Container(
                              height: deviceHeight * 0.35,
                              width: deviceWidth * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: model.imageURL[0] != null
                                  ? Image.network(model.imageURL[0])
                                  : Center(
                                      child: Text(
                                      '写真なし',
                                      style: TextStyle(fontSize: 30),
                                    )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonTheme(
                                  minWidth: 20,
                                  height: 40,
                                  child: RaisedButton.icon(
                                    // 日付を取得
                                    icon: Icon(Icons.date_range),
                                    onPressed: () async {
                                      MuscleData muscleData =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute<MuscleData>(
                                          builder: (context) => SelectPage(),
                                        ),
                                      );
                                      model.changeValue(muscleData, 1);
                                    },
                                    label: Text(
                                      model.date[1],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.3,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          '体重',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                        child: model.weight[1] != null
                                            ? Text(
                                                model.weight[1].toString() +
                                                    ' kg',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            : Text(
                                                'なし',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.3,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          '体脂肪率',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                        child: model.fatPercentage[1] != null
                                            ? Text(
                                                model.fatPercentage[1]
                                                        .toString() +
                                                    ' %',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            : Text(
                                                'なし',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 120,
                                  height: 30,
                                  child: RaisedButton.icon(
                                    // クリアする
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await model.clearValue(1);
                                    },
                                    label: Text(
                                      'クリア',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 120,
                                  height: 30,
                                  child: RaisedButton.icon(
                                    // クリアする
                                    icon: Icon(Icons.fitness_center_rounded),
                                    onPressed: () async {
                                      await setIdealData(model, context, 1);
                                    },
                                    label: Text(
                                      '理想',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: deviceWidth * 0.03,
                            ),
                            Container(
                              height: deviceHeight * 0.35,
                              width: deviceWidth * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: model.imageURL[1] != null
                                  ? Image.network(model.imageURL[1])
                                  : Center(
                                      child: Text(
                                        '写真なし',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future setIdealData(CompareModel model, BuildContext context, int i) async {
    try {
      await model.setIdealBody(i);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('理想の身体を設定しよう！'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }
}
