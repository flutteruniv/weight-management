import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/Graph/graph_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weight_management/presentation/main/main_model.dart';

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topModel = Provider.of<TopModel>(context);
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<GraphModel>(
      create: (_) => GraphModel()..fetchData(),
      child: Scaffold(
        body: Consumer<GraphModel>(
          builder: (context, model, child) {
            if (topModel.graphPageUpdate) {
              model.fetchData();
            }
            return Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                        minWidth: 150,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () async {
                            model.weightTrue();
                          },
                          highlightElevation: 16,
                          highlightColor: Colors.blue,
                          onHighlightChanged: (value) {},
                          child: Text(
                            '体重',
                            style: TextStyle(fontSize: 25),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () async {
                            model.weightFalse();
                          },
                          highlightElevation: 16,
                          highlightColor: Colors.deepOrange,
                          onHighlightChanged: (value) {},
                          child: Text(
                            '体脂肪率',
                            style: TextStyle(fontSize: 25),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: deviceHeight * 0.6,
                    width: double.infinity,
                    child: charts.TimeSeriesChart(
                      model.weight
                          ? _createWeightData(model.seriesWeightList)
                          : _createFatData(model.seriesFatList),
                      domainAxis: charts.DateTimeAxisSpec(
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(
                              format: 'dd', transitionFormat: 'MM/dd'),
                        ),
                      ),
                      //animate: false,
                      behaviors: [
                        charts.SlidingViewport(),
                        charts.PanAndZoomBehavior(),
                      ],
                      dateTimeFactory: charts.LocalDateTimeFactory(),
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: true, //点がtrueだと付く
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                        minWidth: 20,
                        height: 30,
                        child: RaisedButton(
                          onPressed: () async {
                            await model.setOneWeek();
                          },
                          child: Text(
                            '1週間',
                            style: TextStyle(fontSize: 15),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 20,
                        height: 30,
                        child: RaisedButton(
                          onPressed: () async {
                            await model.setOneMonth();
                          },
                          child: Text(
                            '1か月間',
                            style: TextStyle(fontSize: 15),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 20,
                        height: 30,
                        child: RaisedButton(
                          onPressed: () async {
                            await model.setThreeMonths();
                          },
                          child: Text(
                            '3か月間',
                            style: TextStyle(fontSize: 15),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 20,
                        height: 30,
                        child: RaisedButton(
                          onPressed: () async {
                            await model.setWholePeriod();
                          },
                          child: Text(
                            '全期間',
                            style: TextStyle(fontSize: 15),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<charts.Series<weightData, DateTime>> _createWeightData(
      List<weightData> data) {
    return [
      charts.Series<weightData, DateTime>(
        id: 'Muscles',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (weightData muscles, _) => muscles.date,
        measureFn: (weightData muscles, _) => muscles.weight,
        data: data,
      )
    ];
  }

  List<charts.Series<fatData, DateTime>> _createFatData(List<fatData> data) {
    return [
      charts.Series<fatData, DateTime>(
        id: 'Muscles',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (fatData muscles, _) => muscles.date,
        measureFn: (fatData muscles, _) => muscles.fatPercentage,
        data: data,
      )
    ];
  }
}
