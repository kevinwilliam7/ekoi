// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/box_configure.dart';
import 'package:smart_aquarium/components/widgets/gridview_container_control.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/popout.dart';
import 'package:smart_aquarium/main.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/material.dart';
import 'package:smart_aquarium/pages/configuration.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool modeSwitched = false;
  late final _ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                child: StreamBuilder(
                  stream: _ref.child('control').onValue,
                  builder: (context, AsyncSnapshot sp) {
                    if (sp.hasData) {
                      Map<dynamic, dynamic> data =
                          sp.data.snapshot.value as Map<dynamic, dynamic>;
                      modeSwitched = data.values.elementAt(0)['mode'];
                      return Column(
                        children: [
                          Container(
                            height: size.height * 0.3,
                            child: BoxConfigureWidget(
                              startColor: 0xFF9288E4,
                              endColor: 0xFF534EA7,
                              title: 'Konfigurasi \nKendali',
                              press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ConfigurationScreen(),
                                  ),
                                );
                              },
                              widget: FlutterSwitch(
                                activeIcon: Icon(FontAwesomeIcons.robot,
                                    color: Colors.green),
                                inactiveIcon: Icon(FontAwesomeIcons.handFist,
                                    color: Color(0xFF73777B)),
                                activeText: 'Otomatis',
                                inactiveText: 'Manual',
                                width: 95,
                                height: 40,
                                valueFontSize: 8,
                                toggleSize: 45,
                                borderRadius: 36.0,
                                activeColor: Colors.green,
                                inactiveColor: Color(0xFF73777B),
                                padding: 8.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PopupWidget(
                                        acceptText: Text('TERIMA'),
                                        popoutTitle: Text('Apakan anda yakin?'),
                                        popoutContent: modeSwitched == false
                                            ? Text(
                                                'Anda akan beralih ke mode otomatis, proses kendali ditentukan oleh sistem')
                                            : Text(
                                                'Anda akan beralih ke mode manual, proses kendali tidak ditentukan oleh sistem'),
                                        acceptPressed: () {
                                          setState(() {
                                            modeSwitched = val;
                                            FirebaseService.updateModeControl(
                                                modeSwitched);
                                          });
                                          Navigator.pop(context, false);
                                        },
                                      );
                                    },
                                  );
                                },
                                value: modeSwitched,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 3),
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                String key =
                                    data.keys.elementAt(index).toString();
                                String value = data.values
                                    .elementAt(index)['value']
                                    .toString();
                                bool isSwitched = data.values
                                    .elementAt(index)['value'] as bool;
                                return BoxGridviewControl(
                                  startColor: isSwitched == true
                                      ? 0xFFB5FF7D
                                      : 0xFFFFA1C9,
                                  midColor: isSwitched == true
                                      ? 0xFF52D681
                                      : 0xFFF94892,
                                  endColor: isSwitched == true
                                      ? 0xFF00AD7C
                                      : 0xFFE60965,
                                  foregroundDecoration: modeSwitched == true
                                      ? BoxDecoration(
                                          color: Colors.grey,
                                          backgroundBlendMode:
                                              BlendMode.saturation,
                                        )
                                      : BoxDecoration(),
                                  icon: Icon(
                                      key == "servo"
                                          ? FontAwesomeIcons.fish
                                          : key == "heater"
                                              ? FontAwesomeIcons.thermometer3
                                              : key == "cooler"
                                                  ? FontAwesomeIcons
                                                      .thermometer1
                                                  : key == "drain"
                                                      ? FontAwesomeIcons
                                                          .glassWaterDroplet
                                                      : FontAwesomeIcons.water,
                                      color: Colors.white),
                                  title: mapTitle[key].toString(),
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
                                    onToggle: (val) {
                                      modeSwitched == true
                                          ? setState(() {})
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopupWidget(
                                                  acceptText: Text('TERIMA'),
                                                  popoutTitle: Text(
                                                      'Apakan anda yakin?'),
                                                  popoutContent: Text(
                                                    value.toString() == "true"
                                                        ? 'Perangkat kontrol ' +
                                                            mapTitle[key]
                                                                .toString() +
                                                            ' anda akan dimatikan secara manual.'
                                                        : 'Perangkat kontrol ' +
                                                            mapTitle[key]
                                                                .toString() +
                                                            ' anda akan dihidupkan secara manual.',
                                                  ),
                                                  acceptPressed: () {
                                                    setState(() {
                                                      isSwitched = val;
                                                      FirebaseService
                                                          .updateSwitchControl(
                                                              isSwitched, key);
                                                    });
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                );
                                              },
                                            );
                                    },
                                    value: isSwitched,
                                  ),
                                  textColor: Colors.white,
                                  imageAsset: key == 'servo'
                                      ? 'assets/images/servo.png'
                                      : key == 'cooler'
                                          ? 'assets/images/cooler.png'
                                          : key == 'heater'
                                              ? 'assets/images/heater.png'
                                              : key == 'pump'
                                                  ? 'assets/images/pump.png'
                                                  : key == 'drain'
                                                      ? 'assets/images/pump.png'
                                                      : 'assets/images/pump.png',
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 5)
                        ],
                      );
                    } else {
                      return ControlShimmer();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//tinggi oppo A31 : 756
//lebar oppo A31 : 360