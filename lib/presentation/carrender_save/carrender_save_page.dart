import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/carrender_save/carrender_save_model.dart';
import 'package:weight_management/presentation/main/main_model.dart';

class CarenderSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topModel = Provider.of<TopModel>(context);
    return ChangeNotifierProvider<CalenderSaveModel>(
      create: (_) => CalenderSaveModel()..initData(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: Consumer<CalenderSaveModel>(builder: (context, model, child) {
            if (topModel.savePageUpdate == true) {
              model.fetchData();
            }
            if (model.loadingData == true) {
              //データローディングが終わればこっちを表示
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 250,
                        height: 50,
                        child: RaisedButton.icon(
                          // 日付を取得
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () async {
                            model.pickedDate = await showDatePicker(
                              context: context,
                              initialDate: new DateTime.now(),
                              firstDate:
                                  DateTime.now().add(Duration(days: -1095)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 1095)),
                            );
                            model.selectDate();
                            await model.judgeDate(); //日付を取得した時に同じ日付があるか判断
                            await model.setText();
                            if (model.sameDate != true) model.imageFile = null;
                          },
                          label: Text(
                            model.viewDate,
                            style: TextStyle(fontSize: 25),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      TextField(
                        controller: model.weightTextController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: '体重を入力（Kg）', labelText: '体重(Kg)'),
                        onChanged: (number) {
                          //テキストに体重入力
                          model.additionalWeight = double.parse(number);
                          model.weightTextController = TextEditingController(
                              text: double.parse(number).toString());
                        },
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        controller: model.fatTextController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '体脂肪率を入力（％）',
                          labelText: '体脂肪率(%)',
                        ),
                        onChanged: (number) {
                          //テキストに体重入力
                          model.additionalBodyFatPercentage =
                              double.parse(number);
                          model.fatTextController = TextEditingController(
                              text: double.parse(number).toString());
                        },
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        height: 230,
                        width: 180,
                        child: InkWell(
                          onTap: () async {
                            model.showBottomSheet(context);
                          },
                          child: model.sameDate == true //同じ日付がある
                              ? model.imageFile != null //写真のパスがある
                                  ? Image.file(model.imageFile) //写真を表示
                                  : Container(
                                      color: Colors.blue,
                                      child: Center(
                                        child: Text(
                                          '写真を選ぶ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                      ),
                                    )
                              //同じ日付がないとき
                              : model.imageFile != null //写真があるとき
                                  ? Image.file(model.imageFile)
                                  : Container(
                                      color: Colors.blue,
                                      child: Center(
                                        child: Text(
                                          '写真を選ぶ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      SizedBox(height: 80),
                      ButtonTheme(
                        minWidth: 20000,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            //to do
                            if (model.sameDate == true) {
                              //同じ日付あるなら更新
                              await updateData(model, context,
                                  model.sameDateMuscleData, topModel);
                            } else if (model.sameDate != true) {
                              //同じ日付がないなら保存
                              await addData(model, context, topModel);
                            }
                            await model.fetchData();
                            await model.judgeDate();
                            await model.setText();
                          },
                          child: model.sameDate != true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '保存',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '更新',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }

  Future addData(
      CalenderSaveModel model, BuildContext context, TopModel topModel) async {
    try {
      await model.addDataToFirebase();
      topModel.updatePageTrue();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  topModel.updatePageFalse();
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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

  Future updateData(CalenderSaveModel model, BuildContext context,
      MuscleData muscleData, TopModel topModel) async {
    try {
      await model.updateData(muscleData);
      topModel.updatePageTrue();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    topModel.updatePageFalse();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }
}
