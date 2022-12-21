// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/popout.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key}) : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  DateTime _date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  DataGridController _dataGridController = DataGridController();
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _editDateController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  TextEditingController editSubjectController = new TextEditingController();
  TextEditingController panjangIkanController = new TextEditingController();
  TextEditingController editPanjangIkanController = new TextEditingController();
  final List<Color> color = <Color>[
    Color.fromARGB(255, 152, 201, 235),
    Color.fromARGB(255, 63, 132, 189),
    Colors.blue
  ];
  final List<double> stops = <double>[0.0, 0.5, 1.0];
  late TooltipBehavior tooltipBehavior;
  late PertumbuhanDataSource _pertumbuhanDataSource;
  List<PertumbuhanData> listPertumbuhan = [];
  String dropdownvalue = 'Konvensional';

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
  }

  void _selectTime() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      'Konvensional',
      'Internet of Things',
    ];
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    _dateController.text = DateFormat('y-MM-dd').format(_date);
                    return Form(
                      key: _formKey,
                      child: AlertDialog(
                        title: Text('Tambah Data Ikan'),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Divider(height: 1),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: InkWell(
                                  onTap: _selectTime,
                                  child: TextFieldWidget(
                                    controller: _dateController,
                                    enabled: false,
                                    labelText: 'Tanggal',
                                    hintText: 'Masukan Tanggal',
                                    icon: Icons.date_range,
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextFieldWidget(
                                  controller: subjectController,
                                  enabled: true,
                                  hintText: 'Masukan Nama Ikan',
                                  icon: Icons.abc,
                                  keyboardType: TextInputType.text,
                                  labelText: 'Nama Ikan',
                                  validator: (String? text) {
                                    if (text == null ||
                                        text.trim().length == 0) {
                                      return "Nama ikan tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextFieldWidget(
                                  controller: panjangIkanController,
                                  enabled: true,
                                  hintText: 'Masukan Panjang Ikan (cm)',
                                  icon: Icons.ten_mp_rounded,
                                  keyboardType: TextInputType.number,
                                  labelText: 'Panjang Ikan',
                                  validator: (String? text) {
                                    if (text == null ||
                                        text.trim().length == 0) {
                                      return "Panjang ikan tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.select_all),
                                      contentPadding: EdgeInsets.all(10.0),
                                      hintStyle: textField,
                                      labelStyle: textField,
                                      hintText: 'Pilih',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        value: dropdownvalue,
                                        isDense: true,
                                        onChanged: (String? newdropdownvalue) {
                                          setState(
                                            () {
                                              dropdownvalue = newdropdownvalue!;
                                              // newdropdownvalue = dropdownvalue;
                                            },
                                          );
                                        },
                                        items: items.map(
                                          (String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                        actions: [
                          TextButton(
                            //FlatButton
                            // textColor: Color(0xFF6200EE),
                            onPressed: () {
                              LoadingPopup.loadingPopUp(
                                context,
                                'Simpan Data Pertumbuhan...',
                              );
                              new Future.delayed(new Duration(seconds: 3), () {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  FirebaseService.savePertumbuhanIkan(
                                    _dateController.text,
                                    subjectController.text,
                                    double.parse(panjangIkanController.text),
                                    dropdownvalue,
                                  );
                                  subjectController.clear();
                                  panjangIkanController.clear();
                                  Navigator.pop(context);
                                }
                                Navigator.pop(context);
                              });
                            },
                            child: Text('SIMPAN'),
                          ),
                          TextButton(
                            //FlatButton
                            // textColor: Color(0xFF6200EE),
                            onPressed: () {
                              subjectController.clear();
                              panjangIkanController.clear();

                              Navigator.pop(context, false);
                            },
                            child: Text('BATAL'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.add_circle),
            ),
          ],
          flexibleSpace: AppbarBackgroundWidget(),
          elevation: 0,
          title: Text(
            'Data Pertumbuhan Ikan',
            style: appBarHai,
          ),
        ),
        body: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  FutureBuilder(
                    future: FirebaseService.getPertumbuhanIkan(
                        _searchController.text),
                    builder: (context, AsyncSnapshot snapshot) {
                      try {
                        if (snapshot.hasData) {
                          listPertumbuhan.clear();
                          var listDate = [];
                          var listName = [];
                          var listSystem = [];
                          var listLong = [];
                          var listKey = [];
                          final data =
                              json.decode(json.encode(snapshot.data.value))
                                  as Map<String, dynamic>;
                          for (int i = 0; i < data.length; i++) {
                            listDate.add(data.values.elementAt(i)['date']);
                            listName.add(data.values.elementAt(i)['name']);
                            listSystem.add(data.values.elementAt(i)['system']);
                            listLong.add(data.values.elementAt(i)['long']);
                            listKey.add(data.keys.elementAt(i));
                          }

                          for (int i = 0; i < data.length; i++) {
                            listPertumbuhan.add(
                              PertumbuhanData(
                                DateTime.parse(listDate[i].toString()),
                                double.parse(listLong[i].toString()),
                                listName[i].toString(),
                                listSystem[i].toString(),
                                listKey[i].toString(),
                              ),
                            );
                          }
                          _pertumbuhanDataSource =
                              PertumbuhanDataSource(listPertumbuhan);
                          return Column(
                            children: [
                              Container(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: size.height -
                                            (AppBar().preferredSize.height),
                                        child: SfDataGridTheme(
                                          data: SfDataGridThemeData(
                                              headerColor: Color.fromARGB(
                                                  255, 248, 248, 248)),
                                          child: SfDataGrid(
                                            allowSwiping: true,
                                            startSwipeActionsBuilder:
                                                (BuildContext context,
                                                    DataGridRow row,
                                                    int rowIndex) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PopupWidget(
                                                              popoutTitle: Text(
                                                                  'Apakah anda yakin?'),
                                                              popoutContent: Text(
                                                                  'Data pertumbuhan ikan yang anda pilih akan terhapus'),
                                                              acceptPressed:
                                                                  () async {
                                                                FirebaseService
                                                                    .deletePertumbuhanIkan(row
                                                                        .getCells()[
                                                                            0]
                                                                        .value
                                                                        .toString());
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              acceptText: Text(
                                                                  'TERIMA'),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        color: Colors.red,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _editDateController =
                                                              new TextEditingController(
                                                                  text: row
                                                                      .getCells()[
                                                                          1]
                                                                      .value
                                                                      .toString());
                                                          editPanjangIkanController =
                                                              new TextEditingController(
                                                                  text: row
                                                                      .getCells()[
                                                                          3]
                                                                      .value
                                                                      .toString());
                                                          editSubjectController =
                                                              new TextEditingController(
                                                                  text: row
                                                                      .getCells()[
                                                                          2]
                                                                      .value
                                                                      .toString());
                                                        });
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            _editDateController
                                                                    .text =
                                                                DateFormat(
                                                                        'y-MM-dd')
                                                                    .format(
                                                                        _date);
                                                            return Form(
                                                              key: _formKey2,
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    'Edit Data Ikan'),
                                                                content:
                                                                    StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Divider(
                                                                            height:
                                                                                1),
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                _selectTime,
                                                                            child:
                                                                                TextFieldWidget(
                                                                              controller: _editDateController,
                                                                              enabled: false,
                                                                              labelText: 'Tanggal',
                                                                              hintText: 'Masukan Tanggal',
                                                                              icon: Icons.date_range,
                                                                              keyboardType: TextInputType.text,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                15),
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              TextFieldWidget(
                                                                            controller:
                                                                                editSubjectController,
                                                                            enabled:
                                                                                true,
                                                                            hintText:
                                                                                'Masukan Nama Ikan',
                                                                            icon:
                                                                                Icons.abc,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            labelText:
                                                                                'Nama Ikan',
                                                                            validator:
                                                                                (String? text) {
                                                                              if (text == null || text.trim().length == 0) {
                                                                                return "Nama ikan tidak boleh kosong";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                15),
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              TextFieldWidget(
                                                                            controller:
                                                                                editPanjangIkanController,
                                                                            enabled:
                                                                                true,
                                                                            hintText:
                                                                                'Masukan Panjang Ikan (cm)',
                                                                            icon:
                                                                                Icons.ten_mp_rounded,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            labelText:
                                                                                'Panjang Ikan',
                                                                            validator:
                                                                                (String? text) {
                                                                              if (text == null || text.trim().length == 0) {
                                                                                return "Panjang ikan tidak boleh kosong";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                15),
                                                                        FormField<
                                                                            String>(
                                                                          builder:
                                                                              (FormFieldState<String> state) {
                                                                            return InputDecorator(
                                                                              decoration: InputDecoration(
                                                                                prefixIcon: Icon(Icons.select_all),
                                                                                contentPadding: EdgeInsets.all(10.0),
                                                                                hintStyle: textField,
                                                                                labelStyle: textField,
                                                                                hintText: 'Pilih',
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(7.0),
                                                                                ),
                                                                              ),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton<String>(
                                                                                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold),
                                                                                  value: dropdownvalue,
                                                                                  isDense: true,
                                                                                  onChanged: (String? newdropdownvalue) {
                                                                                    setState(
                                                                                      () {
                                                                                        dropdownvalue = newdropdownvalue!;
                                                                                        // newdropdownvalue = dropdownvalue;
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  items: items.map(
                                                                                    (String items) {
                                                                                      return DropdownMenuItem(
                                                                                        value: items,
                                                                                        child: Text(items),
                                                                                      );
                                                                                    },
                                                                                  ).toList(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    //FlatButton
                                                                    // textColor:
                                                                    //     Color(
                                                                    //         0xFF6200EE),
                                                                    onPressed:
                                                                        () {
                                                                      LoadingPopup
                                                                          .loadingPopUp(
                                                                        context,
                                                                        'Ubah Data Pertumbuhan...',
                                                                      );
                                                                      new Future
                                                                              .delayed(
                                                                          new Duration(
                                                                              seconds: 3),
                                                                          () {
                                                                        if (_formKey2.currentState !=
                                                                                null &&
                                                                            _formKey2.currentState!.validate()) {
                                                                          FirebaseService
                                                                              .editPertumbuhanIkan(
                                                                            _editDateController.text,
                                                                            editSubjectController.text,
                                                                            double.parse(editPanjangIkanController.text),
                                                                            dropdownvalue,
                                                                            row.getCells()[0].value.toString(),
                                                                          );
                                                                          editSubjectController
                                                                              .clear();
                                                                          editPanjangIkanController
                                                                              .clear();
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                        }
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                        'SIMPAN'),
                                                                  ),
                                                                  TextButton(
                                                                    //FlatButton
                                                                    // textColor:
                                                                    //     Color(
                                                                    //         0xFF6200EE),
                                                                    onPressed:
                                                                        () {
                                                                      _editDateController
                                                                          .clear();
                                                                      editSubjectController
                                                                          .clear();
                                                                      editPanjangIkanController
                                                                          .clear();

                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                    child: Text(
                                                                        'BATAL'),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        color: Colors.orange,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            controller: _dataGridController,
                                            allowSorting: true,
                                            source: _pertumbuhanDataSource,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            columns: [
                                              GridTextColumn(
                                                width: 0,
                                                columnName: 'key',
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'ID',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GridTextColumn(
                                                width: size.width * 0.23,
                                                columnName: 'date',
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Tanggal',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GridTextColumn(
                                                width: size.width * 0.23,
                                                columnName: 'name',
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Nama Ikan',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GridTextColumn(
                                                width: size.width * 0.23,
                                                columnName: 'long',
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Panjang Ikan',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GridTextColumn(
                                                width: size.width * 0.35,
                                                columnName: 'system',
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Pemeliharaan',
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
                                ),
                              ),
                            ],
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: [
                            ShimmerWidget(
                              height: size.height * 0.05,
                              shape: BoxShape.rectangle,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: ShimmerWidget(
                                height: size.height * 0.6,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            ShimmerWidget(
                              height: size.height * 0.05,
                              shape: BoxShape.rectangle,
                            ),
                          ],
                        ),
                      );
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
}

class PertumbuhanDataSource extends DataGridSource {
  PertumbuhanDataSource(List<PertumbuhanData> listPertumbuhan) {
    dataGridRows = listPertumbuhan
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'key', value: dataGridRow.key),
              DataGridCell<DateTime>(
                  columnName: 'date', value: dataGridRow.date),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<double>(columnName: 'long', value: dataGridRow.long),
              DataGridCell<String>(
                  columnName: 'system', value: dataGridRow.system),
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
                dataGridCell.columnName == 'name')
            ? Alignment.centerLeft
            : Alignment.center,
        child: dataGridCell.columnName == 'date'
            ? Text(
                DateFormat('EEEE, d/M/y', "id_ID").format(dataGridCell.value))
            : dataGridCell.columnName == 'time'
                ? Text(DateFormat('HH:mm').format(dataGridCell.value))
                : Text(
                    dataGridCell.value.toString(),
                  ),
      );
    }).toList());
  }

  void updateDataGriDataSource() {
    notifyListeners();
  }
}

class PertumbuhanData {
  PertumbuhanData(this.date, this.long, this.name, this.system, this.key);
  final String name;
  final DateTime date;
  final double long;
  final String system;
  final String key;
}
