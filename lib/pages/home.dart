// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_aquarium/components/utils/time_extension.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/gridview_container_sensor.dart';
import 'package:smart_aquarium/components/widgets/listview_container_control.dart';
import 'package:smart_aquarium/components/widgets/listview_container_schedule.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/constants/color_constant.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/main.dart';
import 'package:smart_aquarium/pages/configuration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _ref = FirebaseDatabase.instance.ref();
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(currentUser.uid)
              .onValue,
          builder: (context, AsyncSnapshot sp) {
            try {
              return Container(
                width: size.width / 2,
                child: Text(
                  'Hai, ' + sp.data.snapshot.value['displayName'],
                  style: appBarHai,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } catch (e) {
              return ShimmerWidget(
                shape: BoxShape.rectangle,
                height: 10,
                width: 130,
              );
            }
          },
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
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipParabolaWidget(),
                child: BodyBackgroundWidget(
                  height: size.height * 0.3,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
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
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12, right: 0, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status', style: tabLabel),
                              MaterialButton(
                                padding: EdgeInsets.all(0),
                                minWidth: 0,
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: StreamBuilder(
                            stream: _ref.child('sensor').onValue,
                            builder: (context, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      right: 5,
                                      left: 0,
                                      bottom: 0,
                                    ),
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width <=
                                                    360
                                                ? 0.67
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        1.5),
                                      ),
                                      itemCount: 6,
                                      itemBuilder: (context, index) {
                                        Map<dynamic, dynamic> data = snap
                                            .data
                                            .snapshot
                                            .value as Map<dynamic, dynamic>;
                                        String keys = data.keys
                                            .elementAt(index)
                                            .toString();
                                        var value = data.values
                                            .elementAt(index)
                                            .toDouble();
                                        return BoxGridViewSensor(
                                          imageAsset: keys == 'suhu'
                                              ? 'assets/images/temperature.png'
                                              : keys == 'ph'
                                                  ? 'assets/images/pH.png'
                                                  : keys == 'amonia'
                                                      ? 'assets/images/amonia.png'
                                                      : keys == 'kekeruhan'
                                                          ? 'assets/images/kekeruhan.png'
                                                          : keys == 'tinggi_air'
                                                              ? 'assets/images/air.png'
                                                              : 'assets/images/pakan.png',
                                          textTitle:
                                              sensorTitle[keys].toString(),
                                          textValue: value.toString(),
                                          textUnit: keys == 'suhu'
                                              ? '°C'
                                              : keys == 'amonia'
                                                  ? 'PPM'
                                                  : keys == 'kekeruhan'
                                                      ? 'NTU'
                                                      : keys == 'tinggi_air'
                                                          ? 'cm'
                                                          : keys ==
                                                                  'tinggi_pakan'
                                                              ? 'cm'
                                                              : '',
                                          colorIndicator: Color(0xFFFFFFFF),
                                          valueIndicator: keys == 'ph'
                                              ? value / 14
                                              : keys == 'suhu'
                                                  ? value / 127
                                                  : keys == 'amonia'
                                                      ? value / 1
                                                      : value,
                                          startColor: keys == "amonia"
                                              ? 0xFF00B7A8
                                              : keys == "suhu"
                                                  ? 0xFFFF94C7
                                                  : keys == 'tinggi_air'
                                                      ? 0xFFBBE1FA
                                                      : keys == 'tinggi_pakan'
                                                          ? 0xFFFFD692
                                                          : keys == 'ph'
                                                              ? 0xFF84A9AC
                                                              : 0xFFE3D18A,
                                          midColor: keys == "amonia"
                                              ? 0xFF096386
                                              : keys == "suhu"
                                                  ? 0xffE760BF
                                                  : keys == 'tinggi_air'
                                                      ? 0xFF3282B8
                                                      : keys == 'tinggi_pakan'
                                                          ? 0xFFFF935C
                                                          : keys == 'ph'
                                                              ? 0xFF3B6978
                                                              : 0xFFBD9354,
                                          endColor: keys == "amonia"
                                              ? 0xFF0C084C
                                              : keys == "suhu"
                                                  ? 0xff7E49AC
                                                  : keys == 'tinggi_air'
                                                      ? 0xFF0F4C75
                                                      : keys == 'tinggi_pakan'
                                                          ? 0xFFDC5353
                                                          : keys == 'ph'
                                                              ? 0xFF204051
                                                              : 0xFF85603F,
                                          textColor: Colors.white,
                                          centerIndicator: keys == 'suhu'
                                              ? FontAwesomeIcons.thermometer
                                              : keys == 'amonia'
                                                  ? FontAwesomeIcons.biohazard
                                                  : keys == 'tinggi_air'
                                                      ? FontAwesomeIcons.levelUp
                                                      : keys == 'tinggi_pakan'
                                                          ? FontAwesomeIcons
                                                              .fish
                                                          : keys == 'ph'
                                                              ? FontAwesomeIcons
                                                                  .atom
                                                              : FontAwesomeIcons
                                                                  .cloud,
                                          iconColor: 0xFFFFFFFF,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return OverviewShimmer();
                            },
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kendali', style: tabLabel),
                              MaterialButton(
                                padding: EdgeInsets.all(0),
                                minWidth: 0,
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: StreamBuilder(
                              stream: _ref.child('control').onValue,
                              builder: (context, AsyncSnapshot sp) {
                                if (sp.hasData) {
                                  Map<dynamic, dynamic> data = sp.data.snapshot
                                      .value as Map<dynamic, dynamic>;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      String key =
                                          data.keys.elementAt(index).toString();
                                      String mode = data.values
                                          .elementAt(index)['mode']
                                          .toString();
                                      String value = data.values
                                          .elementAt(index)['value']
                                          .toString();
                                      DateTime dateTime = DateTime.parse(data
                                              .values
                                              .elementAt(index)['date'] +
                                          ' ' +
                                          data.values.elementAt(index)['time']);
                                      return Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: ContainerListControl(
                                            switchButton: FlutterSwitch(
                                              activeText: 'ON',
                                              inactiveText: 'OFF',
                                              width: 45,
                                              height: 25,
                                              valueFontSize: 8,
                                              toggleSize: 20,
                                              borderRadius: 30.0,
                                              activeColor: Color(0xFF306844),
                                              inactiveColor: Color(0xFF7a0404),
                                              padding: 2,
                                              showOnOff: true,
                                              value: value == 'true'
                                                  ? true
                                                  : false,
                                              onToggle: (bool value) {},
                                            ),
                                            textDateTime: DateFormat(
                                                    'd/M/y HH:MM', "id_ID")
                                                .format(dateTime),
                                            textMode: mode == 'true'
                                                ? 'Otomatis'
                                                : 'Manual',
                                            width: size.width / 3,
                                            icon: key == "servo"
                                                ? FontAwesomeIcons.fish
                                                : key == "heater"
                                                    ? FontAwesomeIcons
                                                        .thermometer3
                                                    : key == "cooler"
                                                        ? FontAwesomeIcons
                                                            .thermometer1
                                                        : key == "drain"
                                                            ? FontAwesomeIcons
                                                                .glassWaterDroplet
                                                            : FontAwesomeIcons
                                                                .water,
                                            startColor: value == 'true'
                                                ? 0xFFB5FF7D
                                                : 0xFFFFA1C9,
                                            midColor: value == 'true'
                                                ? 0xFF52D681
                                                : 0xFFF94892,
                                            endColor: value == 'true'
                                                ? 0xFF00AD7C
                                                : 0xFFE60965,
                                            textColor: Colors.white,
                                            textStatus:
                                                value == 'false' ? 'OFF' : 'ON',
                                            textTitle: mapTitle[key].toString(),
                                            statusColor: Color(0xFFFFFFFF),
                                            iconColor: Color(0xFFFFFFFF)),
                                      );
                                    },
                                  );
                                } else {
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (int i = 0; i < 6; i++)
                                        ControlTabShimmer()
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Penjadwalan', style: tabLabel),
                              MaterialButton(
                                padding: EdgeInsets.all(0),
                                minWidth: 0,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfigurationScreen(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: kBlackColor,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: StreamBuilder(
                              stream: _ref.child('jadwal_pakan').onValue,
                              builder: (context, AsyncSnapshot sp) {
                                if (sp.hasData) {
                                  Map<dynamic, dynamic> data = sp.data.snapshot
                                      .value as Map<dynamic, dynamic>;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final jam =
                                          data.values.elementAt(index)['jam'];
                                      final menit =
                                          data.values.elementAt(index)['menit'];
                                      final waktu = to24hours(jam, menit);
                                      bool status = data.values
                                          .elementAt(index)['status'];
                                      return Container(
                                        padding: EdgeInsets.only(right: 15),
                                        child: ContainerListSchedule(
                                          width: size.width * 0.5,
                                          endColor: jam >= 6 && jam < 15
                                              ? 0xFF34B3F1
                                              : jam >= 15 && jam < 17
                                                  ? 0xFFF66B0E
                                                  : 0xFF2C3333,
                                          startColor: jam >= 6 && jam < 15
                                              ? 0xFF1363DF
                                              : jam >= 15 && jam < 17
                                                  ? 0xFFFC9918
                                                  : 0xFF3A3845,
                                          icon: status == true
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        kGreenColor1,
                                                        kGreenColor2,
                                                      ],
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.red,
                                                        Color.fromARGB(
                                                            255, 204, 38, 27),
                                                      ],
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Icon(
                                                      FontAwesomeIcons.close,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                          textColor: Colors.white,
                                          textTime: 'Pukul $waktu WIB',
                                          textTitle: 'Pakan Ikan',
                                          asset: jam >= 6 && jam < 15
                                              ? 'assets/images/sun.png'
                                              : jam >= 15 && jam < 17
                                                  ? 'assets/images/sun.png'
                                                  : 'assets/images/moon.png',
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (int i = 0; i < 2; i++)
                                        ScheduleTabShimmer()
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5)
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
