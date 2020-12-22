import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/carrender_save/carrender_save_model.dart';
import 'package:weight_management/presentation/main/main_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarenderSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final topModel = Provider.of<TopModel>(context);
    return ChangeNotifierProvider<CalenderSaveModel>(
      create: (_) => CalenderSaveModel()..initData(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Consumer<CalenderSaveModel>(builder: (context, model, child) {
            if (topModel.listPageUpdate) {
              model.initData();
              model.imageFile = null;
            }
            if (model.loadingData) {
              //データローディングが終わればこっちを表示
              return Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: deviceHeight * 0.02,
                  bottom: deviceHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
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
                            lastDate: DateTime.now().add(Duration(days: 1095)),
                          );
                          model.selectDate();
                          await model.judgeDate(); //日付を取得した時に同じ日付があるか判断
                          await model.setText();
                          // if (model.sameDate != true) model.imageFile = null;
                        },
                        label: Text(
                          model.viewDate,
                          style: TextStyle(fontSize: 22),
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
                      },
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    SizedBox(
                      height: deviceHeight * 0.33,
                      width: deviceWidth * 0.45,
                      child: InkWell(
                        onTap: () async {
                          model.showBottomSheet(context);
                        },
                        child: model.sameDate == true
                            ? model.imageFile != null
                                ? Image.file(model.imageFile)
                                : model.imageURL != null
                                    ? Image.network(model.imageURL)
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '写真を選ぶ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      )
                            : model.imageFile != null
                                ? Image.file(model.imageFile)
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '写真を選ぶ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    ButtonTheme(
                      minWidth: 20000,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () async {
                          //to do
                          if (model.sameDate) {
                            //同じ日付あるなら更新
                            await updateData(model, context,
                                model.sameDateMuscleData, topModel);
                          } else {
                            //同じ日付がないなら保存
                            await addData(model, context, topModel);
                          }
                          /*  await model.fetchData();
                      await model.judgeDate();
                      await model.setText();*/
                          await model.initData();
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
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
      topModel.updateGraphPageTrue();

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
                  topModel.updateGraphPageFalse();
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
      topModel.updateGraphPageTrue();

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
                    topModel.updateGraphPageFalse();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }
}
