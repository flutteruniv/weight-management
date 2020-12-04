import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/signup/signup_page.dart';

class SelectLoginUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('ログイン'),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text("メールアドレスでログイン"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("Googleアカウントでログイン"),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
