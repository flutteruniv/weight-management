import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_management/presentation/save/save_model.dart';
import 'package:weight_management/presentation/top/top_model.dart';
import 'package:weight_management/services/dialog_helper.dart';

class SavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser;
    final topModel = Provider.of<TopModel>(context);
    return ChangeNotifierProvider<SaveModel>(
      create: (_) => SaveModel()..initState(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Consumer<SaveModel>(builder: (context, model, child) {
            if (topModel.deleteDone) {
              model.initState();
              model.imageFile = null;
              print('保存画面更新');
            }
            if (model.loadingData) {
              //データローディングが終わればこっちを表示
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 250,
                          height: 40,
                          child: RaisedButton.icon(
                            // 日付を取得
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate:
                                    DateTime.now().add(Duration(days: -1095)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 1095)),
                              );
                              model.changeDate(pickedDate);
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
                        Container(
                          height: 70,
                          child: TextField(
                            controller: model.weightTextController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                hintText: '体重を入力（Kg）', labelText: '体重(Kg)'),
                            onChanged: (number) {
                              //テキストに体重入力
                              model.addWeight = double.parse(number);
                            },
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 70,
                          child: TextField(
                            controller: model.fatTextController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: '体脂肪率を入力（％）',
                              labelText: '体脂肪率(%)',
                            ),
                            onChanged: (number) {
                              //テキストに体重入力
                              model.addFatPercentage = double.parse(number);
                            },
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          alignment: AlignmentDirectional(1.3, 1.3),
                          children: [
                            SizedBox(
                              height: 230,
                              width: 200,
                              child: InkWell(
                                onTap: () async {
                                  model.showBottomSheet(context);
                                },
                                child: model.sameDateMuscleData != null
                                    ? model.imageFile != null
                                        ? RotatedBox(
                                            quarterTurns: model.angle,
                                            child: Image.file(model.imageFile))
                                        : model.imageURL != null
                                            ? RotatedBox(
                                                quarterTurns: model.angle,
                                                child: Image.network(
                                                    model.imageURL))
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '写真を選ぶ',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              )
                                    : model.imageFile != null
                                        ? RotatedBox(
                                            quarterTurns: model.angle,
                                            child: Image.file(model.imageFile))
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              border: Border.all(
                                                  color: Colors.grey),
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
                                          ),
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: 'hero1',
                              onPressed: () {
                                model.changeAngle();
                              },
                              child: Icon(Icons.rotate_right_outlined),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                        ),
                        ButtonTheme(
                          minWidth: 20000,
                          height: 40,
                          child: RaisedButton(
                            onPressed: () async {
                              if (currentUser != null) {
                                if (model.addWeight != null) {
                                  await model.addDate(context);
                                  topModel.changeSaveDone(true);
                                  await model.initState();
                                  topModel.changeSaveDone(false);
                                } else {
                                  showAlertDialog(context, '体重を入力するんだ！');
                                }
                              } else {
                                showAlertDialog(context, 'ログインが必要です');
                              }
                            },
                            child: model.sameDateMuscleData == null
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
}
