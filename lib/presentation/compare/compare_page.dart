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
    return ChangeNotifierProvider<CompareModel>(
      create: (_) => CompareModel(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 30.0),
          child: Consumer<CompareModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          ButtonTheme(
                            minWidth: 20,
                            height: 40,
                            child: RaisedButton.icon(
                              // 日付を取得
                              icon: Icon(Icons.date_range),
                              onPressed: () async {
                                MuscleData muscleData = await Navigator.push(
                                  context,
                                  MaterialPageRoute<MuscleData>(
                                    builder: (context) => SelectPage(),
                                  ),
                                );
                                model.changeUpperValue(muscleData);
                              },
                              label: Text(
                                model.upperDate,
                                style: TextStyle(fontSize: 15),
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    '体重',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Center(
                                  child: model.upperWeight != null
                                      ? Text(
                                          model.upperWeight.toString() + ' kg',
                                          style: TextStyle(fontSize: 25),
                                        )
                                      : Text(
                                          'なし',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 150,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    '体脂肪率',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Center(
                                    child: model.upperFatPercentage != null
                                        ? Text(
                                            model.upperFatPercentage
                                                    .toString() +
                                                ' %',
                                            style: TextStyle(fontSize: 25),
                                          )
                                        : Text(
                                            'なし',
                                            style: TextStyle(fontSize: 25),
                                          )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ButtonTheme(
                            minWidth: 20,
                            height: 30,
                            child: RaisedButton.icon(
                              // クリアする
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await model.clearUpperValue();
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
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 300,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: model.upperImageURL != null
                            ? Image.network(model.upperImageURL)
                            : Center(
                                child: Text(
                                '写真なし',
                                style: TextStyle(fontSize: 30),
                              )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          ButtonTheme(
                            minWidth: 20,
                            height: 40,
                            child: RaisedButton.icon(
                              // 日付を取得
                              icon: Icon(Icons.date_range),
                              onPressed: () async {
                                MuscleData muscleData = await Navigator.push(
                                  context,
                                  MaterialPageRoute<MuscleData>(
                                    builder: (context) => SelectPage(),
                                  ),
                                );
                                model.changeLowerValue(muscleData);
                              },
                              label: Text(
                                model.lowerDate,
                                style: TextStyle(fontSize: 15),
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    '体重',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Center(
                                  child: model.lowerWeight != null
                                      ? Text(
                                          model.lowerWeight.toString() + ' kg',
                                          style: TextStyle(fontSize: 25),
                                        )
                                      : Text(
                                          'なし',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 150,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    '体脂肪率',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Center(
                                  child: model.lowerFatPercentage != null
                                      ? Text(
                                          model.lowerFatPercentage.toString() +
                                              ' %',
                                          style: TextStyle(fontSize: 25),
                                        )
                                      : Text(
                                          'なし',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ButtonTheme(
                            minWidth: 20,
                            height: 30,
                            child: RaisedButton.icon(
                              // クリアする
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await model.clearLowerValue();
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
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 300,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: model.lowerImageURL != null
                            ? Image.network(model.lowerImageURL)
                            : Center(
                                child: Text(
                                '写真なし',
                                style: TextStyle(fontSize: 30),
                              )),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
