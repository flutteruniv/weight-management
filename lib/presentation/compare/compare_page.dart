import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/compare/compare_model.dart';

class ComparePage extends StatelessWidget {
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
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () async {},
                              label: Text(
                                '日付を選ぶ',
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
                                  child: Text(
                                    '50kg',
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
                                  child: Text(
                                    '10.5%',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
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
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () async {},
                              label: Text(
                                '日付を選ぶ',
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
                                  child: Text(
                                    '50kg',
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
                                  child: Text(
                                    '10.5%',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
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
