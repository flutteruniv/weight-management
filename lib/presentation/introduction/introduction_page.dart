import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/introduction/introduction_model.dart';
import 'package:weight_management/presentation/main/main.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IntroductionModel>(
      create: (_) => IntroductionModel(),
      child: Scaffold(
        body: Consumer<IntroductionModel>(
          builder: (context, model, child) {
            return IntroductionScreen(
              pages: model.listPagesViewModel,
              onDone: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => TopPage()), (_) => false);
                model.setIntro();
              },
              showSkipButton: true,
              skip: const Text("スキップ"),
              next: const Text('次へ'),
              done: const Text("アプリへ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            );
          },
        ),
      ),
    );
  }
}
