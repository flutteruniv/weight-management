import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/compare/compare_page.dart';
import 'package:weight_management/presentation/compare/select_model.dart';
import 'package:weight_management/presentation/main/main_model.dart';

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectModel>(
      create: (_) => SelectModel()..fetchData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('選択する'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.blue,
        ),
        body: Consumer<SelectModel>(
          builder: (context, model, child) {
            if (model.hasData) {
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
                              onTap: () {
                                Navigator.pop(context, muscleData);
                              },
                              leading: Image.network(muscleData.imageURL),
                              title: muscleData.bodyFatPercentage != null
                                  ? Text(muscleData.weight.toString() +
                                      ' kg       ' +
                                      muscleData.bodyFatPercentage.toString() +
                                      ' %')
                                  : Text(muscleData.weight.toString() + ' kg'),
                              subtitle: Text(muscleData.date),
                            )
                          : ListTile(
                              onTap: () {
                                Navigator.pop(context, muscleData);
                              },
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
                            ),
                    ),
                  )
                  .toList();
              return ListView(
                children: listTiles,
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
        floatingActionButton: Consumer<SelectModel>(
          builder: (context, model, child) {
            if (model.hasData) {
              return FloatingActionButton.extended(
                label: Text(model.sortName),
                onPressed: () async {
                  model.showBottomSheet(context);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
