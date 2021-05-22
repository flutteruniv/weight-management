import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/presentation/Top/top_page.dart';
import 'package:weight_management/presentation/authentication/authentication_page.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/mypage/mypage_model.dart';
import 'package:weight_management/services/dialog_helper.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ChangeNotifierProvider<MyPageModel>(
        create: (_) => MyPageModel()..fetch(context),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Consumer<MyPageModel>(
            builder: (context, model, child) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 20, left: 20, top: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 30,
                          child: Text(
                            '目標体重(Kg)',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextField(
                          style: TextStyle(fontSize: 18),
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
                          height: 30,
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '目標体脂肪率(%)',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextField(
                          style: TextStyle(fontSize: 18),
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SizedBox(
                            height: 230,
                            width: 200,
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
                          minWidth: 500,
                          height: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RaisedButton(
                            onPressed: () async {
                              if (currentUser != null) {
                                if (model.idealWeight != null) {
                                  await model.addDate(context);
                                  await model.fetch(context);
                                } else {
                                  showAlertDialog(context, '体重を入力するんだ！');
                                }
                              } else {
                                showAlertDialog(context, 'ログインが必要です');
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
                                              await model.sighOut();
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
