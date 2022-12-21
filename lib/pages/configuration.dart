import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/utils/time_extension.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/components/widgets/textfield_ordinary.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late TimeOfDay _time1, _time2;
  late TextEditingController _time1Controller, _time2Controller;
  late TextEditingController _suhuMaksController,
      _suhuMinController,
      _phMinController,
      _phMaksController,
      _turbMaksController,
      _nhMaksController,
      _maksAirController,
      _minAirController,
      _pakanMinController,
      _tinggiAkuariumController;
  @override
  void initState() {
    super.initState();
    FirebaseService.jadwalpakan().then((value) {
      setState(() {
        _time1 = new TimeOfDay(hour: value[0], minute: value[1]);
        _time2 = new TimeOfDay(hour: value[2], minute: value[3]);
        _time1Controller = new TextEditingController(text: _time1.to24hours());
        _time2Controller = new TextEditingController(text: _time2.to24hours());
      });
    });
    FirebaseService.configurecontrol().then((value) {
      setState(() {
        _phMaksController =
            new TextEditingController(text: value[0].toString());
        _phMinController = new TextEditingController(text: value[1].toString());
        _suhuMaksController =
            new TextEditingController(text: value[2].toString());
        _suhuMinController =
            new TextEditingController(text: value[3].toString());
        _turbMaksController =
            new TextEditingController(text: value[4].toString());
        _nhMaksController =
            new TextEditingController(text: value[5].toString());
        _minAirController =
            new TextEditingController(text: value[6].toString());
        _maksAirController =
            new TextEditingController(text: value[7].toString());
        _pakanMinController =
            new TextEditingController(text: value[8].toString());
        _tinggiAkuariumController =
            new TextEditingController(text: value[9].toString());
      });
    });
  }

  @override
  void dispose() {
    _suhuMaksController.dispose();
    _suhuMinController.dispose();
    _phMaksController.dispose();
    _phMinController.dispose();
    _turbMaksController.dispose();
    _nhMaksController.dispose();
    _time1Controller.dispose();
    _time2Controller.dispose();
    super.dispose();
  }

  void _selectTime() async {
    final TimeOfDay? newTime1 = await showTimePicker(
      context: context,
      initialTime: _time1,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
    );
    if (newTime1 != null) {
      setState(() {
        _time1 = newTime1;
        print(_time1);
      });
    }
  }

  void _selectTime2() async {
    final TimeOfDay? newTime2 = await showTimePicker(
      context: context,
      initialTime: _time2,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
    );
    if (newTime2 != null) {
      setState(() {
        _time2 = newTime2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: RichText(
            text: TextSpan(
          text: 'Konfigurasi Kendali',
          style: appBarHai,
        )),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipParabolaWidget(),
                child: BodyBackgroundWidget(
                  height: size.height * 0.3,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    //penjadwalan pakan
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(15.0),
                          topRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                          bottomRight: const Radius.circular(15.0),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 25,
                                left: 25,
                                top: 10,
                              ),
                              child: Text(
                                'Penjadwalan Pakan',
                                style: tabLabel,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .ref('jadwal_pakan')
                                  .onValue,
                              builder: (context, AsyncSnapshot snapshot) {
                                try {
                                  _time1Controller.text = _time1.to24hours();
                                  _time2Controller.text = _time2.to24hours();
                                  if (snapshot.hasData) {
                                    return Form(
                                      key: _formKey1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 25,
                                          left: 25,
                                          top: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                                height: size.height * 0.01),
                                            InkWell(
                                              onTap: _selectTime,
                                              child: TextFieldWidget(
                                                controller: _time1Controller,
                                                enabled: false,
                                                labelText: 'Pakan pertama',
                                                hintText: 'Pakan pertama',
                                                icon: Icons.timer,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            InkWell(
                                              onTap: _selectTime2,
                                              child: TextFieldWidget(
                                                controller: _time2Controller,
                                                enabled: false,
                                                labelText: 'Pakan kedua',
                                                hintText: 'Pakan kedua',
                                                icon: Icons.timer,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                              ),
                                              onPressed: () {
                                                LoadingPopup.loadingPopUp(
                                                  context,
                                                  'Simpan Data Konfigurasi...',
                                                );
                                                new Future.delayed(
                                                    new Duration(seconds: 3),
                                                    () {
                                                  FirebaseService
                                                      .saveJadwalPakan(
                                                    _time1.hour.toInt(),
                                                    _time1.minute.toInt(),
                                                    _time2.hour.toInt(),
                                                    _time2.minute.toInt(),
                                                  );
                                                  Navigator.pop(
                                                      context); //pop dialog
                                                });
                                              },
                                              child: Text(
                                                'Save',
                                                style: textButton,
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.02),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 25),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: ShimmerWidget(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.26,
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //atur kontrol suhu
                    SizedBox(height: size.height * 0.01),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(15.0),
                          topRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                          bottomRight: const Radius.circular(15.0),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 25,
                                left: 25,
                                top: 10,
                              ),
                              child: Text(
                                'Atur Pengukuran dan Kendali',
                                style: tabLabel,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .ref('konfigurasiKontrol')
                                  .onValue,
                              builder: (context, AsyncSnapshot snapshot) {
                                try {
                                  if (snapshot.hasData) {
                                    return Form(
                                      key: _formKey2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 25,
                                          left: 25,
                                          top: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                                height: size.height * 0.01),
                                            TextFieldWidget(
                                              labelText: 'Suhu Minimum',
                                              hintText: 'Suhu Minimum',
                                              icon: Icons.thermostat,
                                              controller: _suhuMinController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Suhu Maksimum',
                                              hintText: 'Suhu Maksimum',
                                              icon: Icons.thermostat,
                                              controller: _suhuMaksController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'pH Minimum',
                                              hintText: 'pH Minimum',
                                              icon: Icons.sanitizer,
                                              controller: _phMinController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'pH Maksimum',
                                              hintText: 'pH Maksimum',
                                              icon: Icons.sanitizer,
                                              controller: _phMaksController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Kekeruhan Maksimum',
                                              hintText: 'Kekeruhan Maksimum',
                                              icon: Icons.water_drop,
                                              controller: _turbMaksController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText:
                                                  'Kadar Amonia Maksimum',
                                              hintText: 'Kadar Amonia Maksimum',
                                              icon: Icons.raw_off_rounded,
                                              controller: _nhMaksController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Pakan Minimum',
                                              hintText: 'Pakan Minimum',
                                              icon: Icons.raw_off_rounded,
                                              controller: _pakanMinController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Tinggi Air Min',
                                              hintText: 'Tinggi Air Min',
                                              icon:
                                                  Icons.indeterminate_check_box,
                                              controller: _minAirController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Tinggi Air Maks',
                                              hintText: 'Tinggi Air Maks',
                                              icon:
                                                  Icons.indeterminate_check_box,
                                              controller: _maksAirController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.03),
                                            TextFieldWidget(
                                              labelText: 'Tinggi Akuarium',
                                              hintText: 'Tinggi Akuarium',
                                              icon:
                                                  Icons.indeterminate_check_box,
                                              controller:
                                                  _tinggiAkuariumController,
                                              keyboardType: TextInputType.phone,
                                              enabled: true,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                              ),
                                              onPressed: () {
                                                LoadingPopup.loadingPopUp(
                                                  context,
                                                  'Simpan Data Konfigurasi...',
                                                );
                                                new Future.delayed(
                                                    new Duration(seconds: 3),
                                                    () {
                                                  FirebaseService
                                                      .saveKonfigurasi(
                                                    double.parse(
                                                        _suhuMaksController
                                                            .text),
                                                    double.parse(
                                                        _suhuMinController
                                                            .text),
                                                    double.parse(
                                                        _phMaksController.text),
                                                    double.parse(
                                                        _phMinController.text),
                                                    double.parse(
                                                        _turbMaksController
                                                            .text),
                                                    double.parse(
                                                        _nhMaksController.text),
                                                    double.parse(
                                                        _maksAirController
                                                            .text),
                                                    double.parse(
                                                        _minAirController.text),
                                                    double.parse(
                                                        _pakanMinController
                                                            .text),
                                                    double.parse(
                                                        _tinggiAkuariumController
                                                            .text),
                                                  );
                                                  Navigator.pop(
                                                      context); //pop dialog
                                                });
                                              },
                                              child: Text(
                                                'Save',
                                                style: textButton,
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.02),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 25),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: ShimmerWidget(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
