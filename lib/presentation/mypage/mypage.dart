import 'package:flutter/material.dart';
import 'package:weight_management/presentation/login/login_page.dart';
import 'package:weight_management/presentation/signup/signup_page.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          RaisedButton(
            child: Text('新規登録'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
          ),
          RaisedButton(
            child: Text('ログイン'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          RaisedButton(
            child: Text('ログアウト'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
