import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/presentation/authentication/authentication_page.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/ideal_muscle_data.dart';
import 'package:weight_management/presentation/mypage/mypage_model.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<MyPageModel>(
      create: (_) => MyPageModel()..fetchData(),
      child: Scaffold(
        body: Consumer<MyPageModel>(
          builder: (context, model, child) {
            return Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.0, top: deviceHeight * 0.03, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        '目標体重(Kg)',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 25),
                        controller: model.idealWeightTextController,
                        keyboardType: TextInputType.number,
                        onChanged: (number) {
                          model.idealWeight = double.parse(number);
                        },
                        decoration: InputDecoration(
                          //Focusしていないとき
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          //Focusしているとき
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 3.0,
                            ),
                          ),
                          hintText: '目標体重(Kg)を入力',
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      Text(
                        '目標体脂肪率(%)',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 25),
                        controller: model.idealFatTextController,
                        keyboardType: TextInputType.number,
                        onChanged: (number) {
                          model.idealFat = double.parse(number);
                        },
                        decoration: InputDecoration(
                          //Focusしていないとき
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          //Focusしているとき
                          focusedBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 3.0,
                            ),
                          ),
                          hintText: '目標体脂肪率(%)を入力',
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      Text(
                        '理想のボディ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.33,
                        width: deviceWidth * 0.45,
                        child: InkWell(
                          onTap: () async {
                            model.showImagePicker();
                          },
                          child: model.idealImageFile != null
                              ? Image.file(model.idealImageFile)
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '理想の身体\nの写真を選ぶ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      ButtonTheme(
                        minWidth: 20000,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () async {
                            if (model.hasIdealMuscle) {
                              await updateData(
                                  model, context, model.idealMuscleList[0]);
                            } else {
                              await addData(model, context);
                            }
                            await model.fetchData();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: model.hasIdealMuscle
                                ? Text(
                                    //true
                                    '変更',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )
                                : Text(
                                    //false
                                    '登録',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      RaisedButton(
                        child: Text('ログアウト'),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          // ログイン画面に遷移＋チャット画面を破棄
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthenticationPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future addData(MyPageModel model, BuildContext context) async {
    try {
      await model.addDataToFirebase();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登録しました'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
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

  Future updateData(MyPageModel model, BuildContext context,
      IdealMuscleData muscleData) async {
    try {
      await model.updateData(muscleData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('変更しました'),
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
