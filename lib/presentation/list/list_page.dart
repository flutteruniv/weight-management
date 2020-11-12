import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/list/list_model.dart';
import 'package:weight_management/presentation/main/main_model.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topModel = Provider.of<TopModel>(context);
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..fetchData(),
      child: Scaffold(
        body: Consumer<ListModel>(
          builder: (context, model, child) {
            if (topModel.savePageUpdate == true) {
              model.fetchData();
            }

            final muscleData = model.muscleData;
            final listTiles = muscleData
                .map(
                  (muscleData) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black38, width: 1),
                      ),
                    ),
                    child: muscleData.imageURL != null //写真、体脂肪率あるなしで条件分岐
                        ? ListTile(
                            leading: Image.network(muscleData.imageURL),
                            title: muscleData.bodyFatPercentage != null
                                ? Text(muscleData.weight.toString() +
                                    ' kg       ' +
                                    muscleData.bodyFatPercentage.toString() +
                                    ' %')
                                : Text(muscleData.weight.toString() + ' kg'),
                            subtitle: Text(muscleData.date),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                            ),
                          )
                        : ListTile(
                            leading: Container(
                              height: 100,
                              width: 40,
                              color: Colors.grey,
                            ),
                            title: muscleData.bodyFatPercentage != null
                                ? Text(muscleData.weight.toString() +
                                    ' kg       ' +
                                    muscleData.bodyFatPercentage.toString() +
                                    ' %')
                                : Text(muscleData.weight.toString() + ' kg'),
                            subtitle: Text(muscleData.date),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ),
                  ),
                )
                .toList();
            return ListView(
              children: listTiles,
            );
          },
        ),
        floatingActionButton: Consumer<ListModel>(
          builder: (context, model, child) {
            return FloatingActionButton.extended(
              label: Text(model.sortName),
              onPressed: () async {
                model.showBottomSheet(context);
              },
            );
          },
        ),
      ),
    );
  }
}
