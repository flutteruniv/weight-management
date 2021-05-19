import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/presentation/Top/top_page.dart';
import 'package:weight_management/presentation/authentication/authentication_page.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/ideal_muscle_data.dart';
import 'package:weight_management/presentation/main/main.dart';
import 'package:weight_management/presentation/mypage/mypage_model.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final User currentUser = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ChangeNotifierProvider<MyPageModel>(
        create: (_) => MyPageModel()..fetchData(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Consumer<MyPageModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: deviceHeight * 0.03,
                      bottom: deviceHeight * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: deviceHeight * 0.05,
                        child: Text(
                          '目標体重(Kg)',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 22),
                        controller: model.idealWeightTextController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                      Container(
                        height: deviceHeight * 0.05,
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '目標体脂肪率(%)',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 22),
                        controller: model.idealFatTextController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                      Container(
                        height: deviceHeight * 0.05,
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '理想のボディ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          height: deviceHeight * 0.33,
                          width: deviceWidth * 0.45,
                          child: InkWell(
                            onTap: () async {
                              model.showImagePicker();
                            },
                            child: model.idealImageFile != null
                                ? Image.file(model.idealImageFile)
                                : model.idealImageURL != null //DBからの写真がある
                                    ? Image.network(model.idealImageURL)
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
                                            '理想の身体\nの写真を選ぶ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 20000,
                        height: 40,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: RaisedButton(
                          onPressed: () async {
                            if (currentUser != null) {
                              if (model.hasIdealMuscle) {
                                await updateData(
                                    model, context, model.idealMuscleList[0]);
                              } else {
                                await addData(model, context);
                              }
                              await model.fetchData();
                            } else {
                              _showDialog(context);
                            }
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
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: currentUser != null
                                ? Text(
                                    'ログアウト',
                                    style: TextStyle(fontSize: 15),
                                  )
                                : Text(
                                    'ログイン',
                                    style: TextStyle(fontSize: 15),
                                  ),
                            color: Colors.white,
                            shape: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            onPressed: () async {
                              if (currentUser != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'ログアウトしますか？',
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            // ログイン画面に遷移＋チャット画面を破棄
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopPage(),
                                                ),
                                                (_) => false);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AuthenticationPage(),
                                    ));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future addData(MyPageModel model, BuildContext context) async {
    try {
      model.showProgressDialog(context);
      await model.addDataToFirebase();
      Navigator.of(context).pop();

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
      Navigator.of(context).pop();
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
      model.showProgressDialog(context);
      await model.updateData(muscleData);
      Navigator.of(context).pop();

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
      Navigator.of(context).pop();
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

  Future _showDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ログインが必要です'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthenticationPage(),
                    ));
              },
            )
          ],
        );
      },
    );
  }
}
