import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/carrender_save/carrender_save_model.dart';

class CarenderSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    child: Text(model.date),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(hintText: '60.0', labelText: 'Weight'),
                    onChanged: (number) {
                      model.addWeight = double.parse(number);
                    },
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    onPressed: () async {
                      //to do
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
                    },
                    child: Text('保存する'),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
