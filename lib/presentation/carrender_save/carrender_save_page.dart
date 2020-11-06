import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/carrender_save/carrender_save_model.dart';

class CarenderSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return ChangeNotifierProvider<CalenderSaveModel>(
      create: (_) => CalenderSaveModel(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(50.0),
          child: Consumer<CalenderSaveModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('日付を選択'),
                  RaisedButton(
                    // 日付を取得
                    onPressed: () async {
                      model.picked = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -1095)),
                        lastDate: DateTime.now().add(Duration(days: 1095)),
                      );
                      model.selectDate();
                    },
                    child: Text(model.viewDate),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: '体重を入力（Kg）', labelText: 'Weight'),
                    onChanged: (number) {
                      //テキストに体重入力
                      model.addWeight = double.parse(number);
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    width: 150,
                    child: InkWell(
                      onTap: () async {
                        await model.showImagePicker();
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
                      await addData(model, context); //入力した体重、日付をfirestoreに入れ
                    },
                    child: Text('保存する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future addData(CalenderSaveModel model, BuildContext context) async {
    try {
      await model.addDataToFirebase();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました'),
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
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }

  Future updateData(CalenderSaveModel model, BuildContext context,
      MuscleData muscleData) async {
    try {
      await model.upDateData(muscleData);

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
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }
}
