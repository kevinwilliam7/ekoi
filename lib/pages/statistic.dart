// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:intl/intl.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:convert';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final List<Color> color = <Color>[
    Color.fromARGB(255, 152, 201, 235),
    Color.fromARGB(255, 63, 132, 189),
    Colors.blue
  ];
  final List<double> stops = <double>[0.0, 0.5, 1.0];
  List<SensorData> listSensors = [];
  List<ChartData> chartSensors = [];
  late SensorDataSource _sensorDataSource;
  late ZoomPanBehavior zoomPanBehavior;
  late TrackballBehavior trackballBehavior;
  late CrosshairBehavior crosshairBehavior;
  late String selectedItem;
  late int selectedIndex;
  List<String> _items = [
    "Suhu Air",
    "Kekeruhan Air",
    "Keasaman Air",
    "Amonia",
    "Ketinggian Air",
    "Sisa Pakan",
  ];

  @override
  void initState() {
    super.initState();
    selectedItem = _items[0];
    selectedIndex = 0;
    zoomPanBehavior = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableMouseWheelZooming: true,
    );
    trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
    );
    crosshairBehavior = CrosshairBehavior(
      enable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: AppbarBackgroundWidget(),
            bottom: PreferredSize(
              child: TabBar(
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 30), // Space between tabs
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ), // Indicator height
                ),
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    selectedItem = _items[index];
                  });
                },
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                tabs: [
                  for (int i = 0; i < _items.length; i++)
                    Tab(child: Text(_items[i])),
                ],
              ),
              preferredSize: Size.fromHeight(0),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(0),
                topRight: const Radius.circular(0),
                bottomLeft: const Radius.circular(0),
                bottomRight: const Radius.circular(0),
              ),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  ClipPath(
                    clipper: ClipParabolaWidget(),
                    child: BodyBackgroundWidget(
                      height: size.height * 0.3,
                    ),
                  ),
                  FutureBuilder(
                    future: FirebaseService.getDataSensor(),
                    builder: (context, AsyncSnapshot snapshot) {
                      try {
                        if (snapshot.hasData) {
                          final data =
                              json.decode(json.encode(snapshot.data.value))
                                  as Map<String, dynamic>;
                          listSensors.clear();
                          chartSensors.clear();
                          var listDate = [];
                          var listTime = [];
                          var listValue = [];
                          var indexvalue = selectedItem == 'Keasaman Air'
                              ? 'ph'
                              : selectedItem == 'Ketinggian Air'
                                  ? 'tinggi_air'
                                  : selectedItem == 'Sisa Pakan'
                                      ? 'tinggi_pakan'
                                      : selectedItem == 'Kekeruhan Air'
                                          ? 'kekeruhan'
                                          : selectedItem == 'Amonia'
                                              ? 'amonia'
                                              : selectedItem == 'Suhu Air'
                                                  ? 'suhu'
                                                  : 'ph';
                          for (int i = 0; i < data.length; i++) {
                            listDate.add(data.values.elementAt(i)['date']);
                            listTime.add(data.values.elementAt(i)['time']);
                            listValue.add(data.values.elementAt(i)[indexvalue]);
                          }
                          for (int i = 0; i < data.length; i++) {
                            chartSensors.add(
                              ChartData(
                                DateTime.parse(
                                  listDate[i].toString() +
                                      " " +
                                      listTime[i].toString(),
                                ), //index 0 untuk tanggal dan waktu
                                double.parse(
                                  listValue[i].toString(),
                                ), //index 1 untuk nilai sensor
                              ),
                            );
                            listSensors.add(
                              SensorData(
                                DateTime.parse(
                                  listDate[i].toString() +
                                      " " +
                                      listTime[i].toString(),
                                ), //index 0 untuk tanggal dan waktu
                                DateTime.parse(
                                  listDate[i].toString() +
                                      " " +
                                      listTime[i].toString(),
                                ),
                                double.parse(
                                  listValue[i].toString(),
                                ), //index 1 untuk nilai sensor
                              ),
                            );
                          }
                          _sensorDataSource = SensorDataSource(listSensors);
                          return Container(
                            child: Column(
                              children: [
                                //tab grafik
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(15),
                                            topRight: const Radius.circular(15),
                                            bottomLeft:
                                                const Radius.circular(0),
                                            bottomRight:
                                                const Radius.circular(0),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 0, top: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Grafik ' +
                                                      _items[selectedIndex],
                                                  style: tabLabel),
                                              MaterialButton(
                                                padding: EdgeInsets.all(0),
                                                minWidth: 0,
                                                onPressed: () {},
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // margin:
                                        //     EdgeInsets.symmetric(horizontal: 15),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(0),
                                            topRight: const Radius.circular(0),
                                            bottomLeft:
                                                const Radius.circular(0),
                                            bottomRight:
                                                const Radius.circular(0),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 0,
                                            top: 15,
                                            bottom: 5,
                                          ),
                                          child: SfCartesianChart(
                                            crosshairBehavior:
                                                crosshairBehavior,
                                            trackballBehavior:
                                                trackballBehavior,
                                            zoomPanBehavior: zoomPanBehavior,
                                            primaryXAxis: DateTimeAxis(
                                              isInversed: true,
                                              intervalType:
                                                  DateTimeIntervalType.hours,
                                            ),
                                            primaryYAxis:
                                                NumericAxis(isInversed: false),
                                            series: <
                                                ChartSeries<ChartData,
                                                    DateTime>>[
                                              AreaSeries<ChartData, DateTime>(
                                                sortingOrder:
                                                    SortingOrder.ascending,
                                                sortFieldValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                name: selectedItem,
                                                dataSource: chartSensors,
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                xAxisName: 'Waktu',
                                                yAxisName: selectedItem,
                                                gradient: LinearGradient(
                                                  colors: color,
                                                  stops: stops,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //tab datatable
                                Column(
                                  children: [
                                    Container(
                                      child: SfDataGridTheme(
                                        data: SfDataGridThemeData(
                                            headerColor: Color.fromARGB(
                                                255, 248, 248, 248)),
                                        child: SfDataGrid(
                                          // horizontalScrollPhysics:
                                          //     NeverScrollableScrollPhysics(),
                                          // verticalScrollPhysics:
                                          //     NeverScrollableScrollPhysics(),
                                          columnWidthMode: ColumnWidthMode.fill,
                                          allowSorting: true,
                                          selectionMode: SelectionMode.multiple,
                                          source: _sensorDataSource,
                                          gridLinesVisibility:
                                              GridLinesVisibility.both,
                                          headerGridLinesVisibility:
                                              GridLinesVisibility.both,
                                          columns: [
                                            GridTextColumn(
                                              minimumWidth: size.width / 2.3,
                                              columnName: 'date',
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Tanggal',
                                                  // overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ),
                                            GridTextColumn(
                                              maximumWidth: size.width * 0.2,
                                              columnName: 'time',
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Waktu',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            GridTextColumn(
                                              minimumWidth: size.width / 2.9,
                                              columnName: 'value',
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  selectedItem,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                      return StatisticShimmer();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget getloadMoreIndicatorBuilder(
  //     BuildContext context, ChartSwipeDirection direction) {
  //   if (direction == ChartSwipeDirection.end) {
  //     isNeedToUpdateView = true;
  //     globalKey = GlobalKey<State>();
  //     return StatefulBuilder(
  //         key: globalKey,
  //         builder: (BuildContext context, StateSetter stateSetter) {
  //           Widget widget;
  //           if (isNeedToUpdateView) {
  //             widget = getProgressIndicator();
  //             _updateView();
  //             isDataUpdated = true;
  //           } else {
  //             widget = Container();
  //           }
  //           return widget;
  //         });
  //   } else {
  //     return SizedBox.fromSize(size: Size.zero);
  //   }
  // }
}

class SensorDataSource extends DataGridSource {
  SensorDataSource(List<SensorData> listSensors) {
    dataGridRows = listSensors
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<DateTime>(
                  columnName: 'date', value: dataGridRow.date),
              DataGridCell<DateTime>(
                  columnName: 'time', value: dataGridRow.time),
              DataGridCell<double>(
                  columnName: 'value', value: dataGridRow.value),
            ],
          ),
        )
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: (dataGridCell.columnName == 'date' ||
                  dataGridCell.columnName == 'time')
              ? Alignment.centerLeft
              : Alignment.center,
          child: Text(
            dataGridCell.columnName == 'date'
                ? DateFormat('EEEE, d/M/y', "id_ID").format(dataGridCell.value)
                : dataGridCell.columnName == 'time'
                    ? DateFormat('HH:mm').format(dataGridCell.value)
                    : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  void updateDataGriDataSource() {
    notifyListeners();
  }
}

class SensorData {
  SensorData(this.date, this.time, this.value);
  final DateTime date;
  final DateTime time;
  final double value;
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
