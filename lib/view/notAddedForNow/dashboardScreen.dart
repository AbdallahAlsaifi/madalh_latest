import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(

          children: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropShadow(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: constants.screenWidth * 0.9,

                      child: Card(
                        child: Column(
                          children: [
                            constants.smallText('التطابقات اليومية', context, color: Colors.redAccent),
                            Container(
                              height: constants.screenWidth*0.5,
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  series: <LineSeries<SalesData, String>>[
                                    LineSeries<SalesData, String>(
                                        // Bind data source
                                        dataSource: <SalesData>[
                                          SalesData('Jan', 35),
                                          SalesData('Feb', 28),
                                          SalesData('Mar', 34),
                                          SalesData('Apr', 32),
                                          SalesData('May', 40)
                                        ],
                                        xValueMapper: (SalesData sales, _) => sales.year,
                                        yValueMapper: (SalesData sales, _) => sales.sales)
                                  ]),
                            ),
                          ],
                        ),


                      ),
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropShadow(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: constants.screenWidth * 0.9,

                      child: Card(
                        child: Column(
                          children: [
                            constants.smallText('مشاهدات ملفي', context, color: Colors.redAccent),
                            Container(
                              height: constants.screenWidth*0.5,
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                                  tooltipBehavior: _tooltip,
                                  series: <ChartSeries<_ChartData, String>>[
                                    BarSeries<_ChartData, String>(
                                        dataSource: data,
                                        xValueMapper: (_ChartData data, _) => data.x,
                                        yValueMapper: (_ChartData data, _) => data.y,
                                        name: 'Gold',
                                        color: Color.fromRGBO(8, 142, 255, 1))
                                  ])
                            ),
                          ],
                        ),


                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}