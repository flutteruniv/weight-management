import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/presentation/list/list_model.dart';
import 'package:weight_management/presentation/top/top_model.dart';
import 'package:weight_management/services/dialog_helper.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topModel = Provider.of<TopModel>(context);
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..fetch(context),
      child: Scaffold(
        body: Consumer<ListModel>(
          builder: (context, model, child) {
            if (topModel.saveDone) {
              model.fetch(context);
              print('一覧画面更新');
            }
            if (model.muscleData != null) {
              final muscleData = model.muscleData;
              final listTiles = muscleData
                  .map(
                    (muscleData) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black38, width: 1),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return Center(
                                child: AlertDialog(
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        muscleData.imageURL != null
                                            ? Column(
                                                children: [
                                                  RotatedBox(
                                                    quarterTurns:
                                                        muscleData.angle == null
                                                            ? 0
                                                            : muscleData.angle,
                                                    child: Image.network(
                                                        muscleData.imageURL),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: muscleData
                                                                .bodyFatPercentage !=
                                                            null
                                                        ? Text('体重：' +
                                                            muscleData.weight
                                                                .toString() +
                                                            ' kg       ' +
                                                            '体脂肪率：' +
                                                            muscleData
                                                                .bodyFatPercentage
                                                                .toString() +
                                                            ' %')
                                                        : Text('体重：' +
                                                            muscleData.weight
                                                                .toString() +
                                                            ' kg'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16.0),
                                                    child: Text(
                                                      muscleData.date,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Column(children: [
                                                muscleData.bodyFatPercentage !=
                                                        null
                                                    ? Text('体重：' +
                                                        muscleData.weight
                                                            .toString() +
                                                        ' kg       ' +
                                                        '体脂肪率：' +
                                                        muscleData
                                                            .bodyFatPercentage
                                                            .toString() +
                                                        ' %')
                                                    : Text('体重：' +
                                                        muscleData.weight
                                                            .toString() +
                                                        ' kg'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16.0),
                                                  child: Text(
                                                    muscleData.date,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              ])
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: muscleData.imageURL != null //写真、体脂肪率あるなしで条件分岐
                            ? ListTile(
                                leading: RotatedBox(
                                    quarterTurns: muscleData.angle == null
                                        ? 0
                                        : muscleData.angle,
                                    child: Image.network(muscleData.imageURL)),
                                title: muscleData.bodyFatPercentage != null
                                    ? Text(muscleData.weight.toString() +
                                        ' kg       ' +
                                        muscleData.bodyFatPercentage
                                            .toString() +
                                        ' %')
                                    : Text(
                                        muscleData.weight.toString() + ' kg'),
                                subtitle: Text(muscleData.date),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('削除しますか？'),
                                          actions: [
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                await deleteList(
                                                    context, model, muscleData);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
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
                                        muscleData.bodyFatPercentage
                                            .toString() +
                                        ' %')
                                    : Text(
                                        muscleData.weight.toString() + ' kg'),
                                subtitle: Text(muscleData.date),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('削除しますか？'),
                                          actions: [
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                topModel.changeDeleteDone(true);
                                                await deleteList(
                                                    context, model, muscleData);
                                                topModel
                                                    .changeDeleteDone(false);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  )
                  .toList();
              return ListView(
                children: listTiles,
              );
            } else {
              return Center(
                  child: Text(
                'データなし',
                style: TextStyle(
                  fontSize: 25,
                ),
              ));
            }
          },
        ),
        floatingActionButton: Consumer<ListModel>(
          builder: (context, model, child) {
            if (model.muscleData != null) {
              return FloatingActionButton.extended(
                heroTag: 'hero2',
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

  Future deleteList(
      BuildContext context, ListModel model, MuscleData muscleData) async {
    try {
      await model.deleteMuscleData(muscleData);
      await model.fetch(context);
    } catch (e) {
      await showAlertDialog(context, e.toString());
      print(e.toString());
    }
  }
}
