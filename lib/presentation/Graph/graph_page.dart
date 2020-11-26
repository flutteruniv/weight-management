import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/Graph/graph_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GraphModel>(
      create: (_) => GraphModel()..fetchData(),
      child: Scaffold(
        body: Consumer<GraphModel>(
          builder: (context, model, child) {
            return Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 500,
                    width: double.infinity,
                    child: charts.TimeSeriesChart(
                      _createSampleData(model.seriesList),
                      domainAxis: charts.DateTimeAxisSpec(
                        /*      tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                          <charts.TickSpec<DateTime>>[
                            charts.TickSpec<DateTime>(model.dateList[0]),
                            charts.TickSpec<DateTime>(
                                model.dateList[0].add(Duration(days: 1) * -7)),
                          ],
                        ),*/
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(
                              format: 'MM/dd', transitionFormat: 'MM/dd'),
                        ),
                      ),
                      //   animate: false,
                      behaviors: [
                        charts.SlidingViewport(),
                        charts.PanAndZoomBehavior(),
                      ],
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: true, //点がtrueだと付く
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonTheme(
                            minWidth: 20,
                            height: 30,
                            child: RaisedButton(
                              onPressed: () async {},
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
                              onPressed: () async {},
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
                              onPressed: () async {},
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
                              onPressed: () async {},
                              child: Text(
                                '半年間',
                                style: TextStyle(fontSize: 15),
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<charts.Series<Data, DateTime>> _createSampleData(List<Data> data) {
    return [
      charts.Series<Data, DateTime>(
        id: 'time',
        domainFn: (Data muscles, _) => muscles.date,
        measureFn: (Data muscles, _) => muscles.weight,
        data: data,
      )
    ];
  }
}
