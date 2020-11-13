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
      create: (_) => CalenderSaveModel()..fetchDataJudgeDate(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(50.0),
          child: Consumer<CalenderSaveModel>(builder: (context, model, child) {
            if (model.loadingData == true) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('日付を選択'),
                      RaisedButton(
                        // 日付を取得
                        onPressed: () async {
                          model.pickedDate = await showDatePicker(
                            context: context,
                            initialDate: new DateTime.now(),
                            firstDate:
                                DateTime.now().add(Duration(days: -1095)),
                            lastDate: DateTime.now().add(Duration(days: 1095)),
                          );
                          model.selectDate();
                          model.judgeDate();
                        },
                        child: Text(model.viewDate),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: '体重を入力（Kg）', labelText: '体重'),
                        onChanged: (number) {
                          //テキストに体重入力
                          model.additionalWeight = double.parse(number);
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: '体脂肪率を入力（％）', labelText: '体脂肪率'),
                        onChanged: (number) {
                          //テキストに体重入力
                          model.additionalBodyFatPercentage =
                              double.parse(number);
                        },
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 200,
                        width: 150,
                        child: InkWell(
                          onTap: () async {
                            //await model.showImagePicker();
                            model.showBottomSheet(context);
                          },
                          child: model.imageFile != null
                              ? Image.file(model.imageFile)
                              : Container(
                                  color: Colors.green,
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
                      SizedBox(height: 30),
                      RaisedButton(
                        onPressed: () async {
                          //to do
                          if (model.sameDate == true) {
                            //同じ日付あるなら更新
                            await updateData(model, context,
                                model.sameDateMuscleData, topModel);
                          } else if (model.sameDate != true) {
                            //同じ日付なら保存
                            await addData(model, context, topModel);
                          }
                          await model.fetchData();
                          await model.judgeDate();
                        },
                        child: model.sameDate != true ? Text('保存') : Text('更新'),
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
