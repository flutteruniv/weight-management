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
          padding: EdgeInsets.all(32.0),
          child: Consumer<CalenderSaveModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text(model.value),
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
                    child: Text('Click me'),
                  ),
                  TextField(
                      decoration:
                          InputDecoration(hintText: '62.0', labelText: 'Date')),
                  TextField(
                      decoration: InputDecoration(
                          hintText: '62.0', labelText: 'Weight')),
                  RaisedButton(
                    onPressed: () {
                      //to do
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
