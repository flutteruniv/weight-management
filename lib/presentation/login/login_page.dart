import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/Top/top_page.dart';
import 'package:weight_management/presentation/login/login_model.dart';
import 'package:weight_management/services/dialog_helper.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'example@gmail.com',
                      labelText: "メールアドレス",
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                    ),
                    controller: mailController,
                    onChanged: (text) {
                      model.mail = text;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '6文字以上',
                      labelText: "パスワード",
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                    ),
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                      child: Text(
                        "パスワードを忘れたマッスルへ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'ログインできない場合',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        'パスワードリセットメールを送ります\nメールアドレスを入力してください。',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        onChanged: (text) {
                                          model.email = text;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'メールアドレスを入力してください',
                                          labelText: "メールアドレス",
                                          enabledBorder: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(4.0),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(4.0),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'キャンセル',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    '送信',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await model.sendPasswordResetEmail(
                                        model.email, context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      child: Text(
                        'ログインする',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        try {
                          await model.login();
                          await showAlertDialog(context, 'ログインしました');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopPage()),
                              (_) => false);
                        } catch (e) {
                          showAlertDialog(context, e.toString());
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
