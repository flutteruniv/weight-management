import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/login/login_page.dart';
import 'package:weight_management/presentation/login/select_login_page.dart';
import 'package:weight_management/presentation/signup/select_signup_page.dart';
import 'package:weight_management/presentation/signup/signup_page.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('理想のボディを目指そうぜ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    '新規登録',
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.white,
                  shape: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    'ログイン',
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.white,
                  shape: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
