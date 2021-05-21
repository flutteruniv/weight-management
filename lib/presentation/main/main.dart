import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/presentation/Graph/graph_page.dart';
import 'package:weight_management/presentation/Top/top_page.dart';
import 'package:weight_management/presentation/authentication/authentication_page.dart';
import 'package:weight_management/presentation/carrender_save/save_page.dart';
import 'package:weight_management/presentation/compare/compare_page.dart';
import 'package:weight_management/presentation/introduction/introduction_model.dart';
import 'package:weight_management/presentation/introduction/introduction_page.dart';
import 'package:weight_management/presentation/list/list_page.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/mypage/mypage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<IntroductionModel>(
        create: (_) => IntroductionModel()..getPrefIntro(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer<IntroductionModel>(
            builder: (context, model, child) {
              return model.intro == true ? IntroductionPage() : TopPage();
            },
          ),
        ),
      ),
    );
  }
}
