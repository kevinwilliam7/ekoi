import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/popout.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/pages/control.dart';
import 'package:smart_aquarium/pages/home.dart';
import 'package:smart_aquarium/pages/login.dart';
import 'package:smart_aquarium/pages/onboard.dart';
import 'package:smart_aquarium/pages/statistic.dart';
import 'package:smart_aquarium/pages/user.dart';
import 'package:smart_aquarium/services/onesignal_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const MyApp());
}

final loading = false;
Map<String, String> sensorTitle = {
  "tinggi_air": "Tinggi Air",
  "tinggi_pakan": "Sisa Pakan",
  "amonia": "Amonia",
  "suhu": "Suhu",
  "kekeruhan": "Kekeruhan",
  "ph": "Keasaman",
};

Map<String, String> mapTitle = {
  "servo": "Pakan Ikan",
  "drain": "Pompa Pengurasan",
  "cooler": "Pendingin Air",
  "heater": "Penghangat Air",
  "pump": "Pompa Pengisian",
  "uv": "Filter UV"
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      routes: {
        "onboard_screen": (context) => OnboardScreen(),
        "login_screen": (context) => LoginScreen(),
        "main_screen": (context) => MyStatefulWidget()
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(true);
            return MyStatefulWidget();
          } else {
            print(false);
            return OnboardScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    StatisticScreen(),
    ControlScreen(),
    UserScreen(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void disablePushNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? disableNotif = prefs.getBool('_disableNotif');
    print(disableNotif);
    if (disableNotif == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupWidget(
            popoutTitle: Text('Izin Notifikasi'),
            popoutContent: Text('Notifikasi aplikasi akan diaktifkan'),
            acceptText: Text('AKTIFKAN'),
            acceptPressed: () {
              OneSignal.shared.disablePush(false);
              prefs.remove('_disableNotif');
              prefs.setBool('_disableNotif', false);
              Navigator.pop(context, false);
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupWidget(
            popoutTitle: Text('Izin Notifikasi'),
            popoutContent: Text('Notifikasi aplikasi akan dimatikan'),
            acceptText: Text('MATIKAN'),
            acceptPressed: () {
              OneSignal.shared.disablePush(true);
              prefs.remove('_disableNotif');
              prefs.setBool('_disableNotif', true);
              Navigator.pop(context, false);
            },
          );
        },
      );
    }
    print(disableNotif);
  }

  @override
  void initState() {
    super.initState();
    OneSignalService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: Container(
          width: size.width / 2,
          child: Text(
            _selectedIndex == 0
                ? 'Beranda'
                : _selectedIndex == 1
                    ? 'Statistik'
                    : _selectedIndex == 2
                        ? 'Kendali'
                        : 'Pengguna',
            style: appBarText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              disablePushNotification();
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.00), //(x,y)
                blurRadius: 4.00,
                color: Colors.blue,
                spreadRadius: 1.00),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: 'Beranda',
              tooltip: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.pie_chart_outline),
              label: 'Statistik',
              tooltip: 'Statistik',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.control_point_outlined),
              label: 'Kendali',
              tooltip: 'Kendali',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              label: 'Pengguna',
              tooltip: 'Pengguna',
            ),
          ],
          currentIndex: _selectedIndex,
          iconSize: 20,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
