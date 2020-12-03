import 'package:flutter/material.dart';
import 'package:weight_management/presentation/authentication/authentication_page.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          RaisedButton(
            child: Text('ログアウト'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthenticationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
