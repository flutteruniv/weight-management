import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/signup/signup_page.dart';

class SelectSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('新規登録'),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text("メールアドレスで新規登録"),
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
                title: Text("Googleアカウントで新規登録"),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
