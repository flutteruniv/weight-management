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
                .map((muscleData) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black38, width: 1),
                        ),
                      ),
                      child: ListTile(
                          leading: Image.network(muscleData.imageURL),
                          title: Text(muscleData.weight.toString() + ' kg'),
                          subtitle: Text(muscleData.date),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                          )),
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
