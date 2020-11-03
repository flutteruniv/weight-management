import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/list/list_model.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..fetchData(),
      child: Scaffold(
        body: Consumer<ListModel>(
          builder: (context, model, child) {
            final muscleData = model.muscleData;
            final listTiles = muscleData
                .map((muscleData) => ListTile(
                      title: Text(muscleData.weight.toString()),
                    ))
                .toList();
            return ListView(
              children: listTiles,
            );
          },
        ),
      ),
    );
  }
}
