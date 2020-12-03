import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/login/login_page.dart';
import 'package:weight_management/presentation/signup/signup_page.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text('認証ページ'),
        ),
        body: Center(
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
            ],
          ),
        ),
      ),
    );
  }
}
