import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/box_user.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/popout.dart';
import 'package:smart_aquarium/components/widgets/shimmer.dart';
import 'package:smart_aquarium/pages/add_data.dart';
import 'package:smart_aquarium/pages/add_user.dart';
import 'package:smart_aquarium/pages/change_profile.dart';
import 'package:smart_aquarium/services/firebase_service.dart';
import '../components/widgets/box_adduser.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .ref('users')
                          .child(currentUser.uid)
                          .onValue,
                      builder: (context, AsyncSnapshot snapshot) {
                        try {
                          if (snapshot.hasData) {
                            final name =
                                snapshot.data.snapshot.value['displayName'];
                            final email = snapshot.data.snapshot.value['email'];
                            final phone =
                                snapshot.data.snapshot.value['phonenumber'];
                            final role = snapshot.data.snapshot.value['role'];
                            return Column(
                              children: [
                                Container(
                                  height: size.height * 0.3,
                                  child: BoxUserWidget(
                                    startColor: 0xFF36AE7C,
                                    endColor: 0xFF2F8F9D,
                                    press: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeProfileScreen(
                                            name: name.toString(),
                                            email: email.toString(),
                                            phone: phone.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    role: role == 'admin'
                                        ? 'administrator'
                                        : 'user',
                                    logout: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PopupWidget(
                                            popoutTitle:
                                                Text('Keluar dari akun?'),
                                            popoutContent: Text(
                                                'Anda akan keluar dari sistem dan kembali ke halaman login.'),
                                            acceptPressed: () {
                                              LoadingPopup.loadingPopUp(
                                                context,
                                                'Keluar...',
                                              );
                                              new Future.delayed(
                                                  new Duration(seconds: 3), () {
                                                FirebaseService.signOut();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            },
                                            acceptText: Text('YA, KELUAR'),
                                          );
                                        },
                                      );
                                    },
                                    email: email,
                                    name: name,
                                    phone: phone,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Container(
                                  foregroundDecoration: role == "admin"
                                      ? BoxDecoration()
                                      : BoxDecoration(
                                          color: Colors.grey,
                                          backgroundBlendMode:
                                              BlendMode.saturation,
                                        ),
                                  height: size.height * 0.3,
                                  child: BoxAddUserWidget(
                                    image: 'assets/images/management_user.png',
                                    textButton: 'Tambah Sekarang',
                                    startColor: 0xFFF24C4C,
                                    endColor: 0xFF632626,
                                    press: role == "admin"
                                        ? () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddUserScreen(),
                                              ),
                                            );
                                          }
                                        : () {},
                                    title: 'Tambah \nPengguna',
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Container(
                                  foregroundDecoration: role == "admin"
                                      ? BoxDecoration()
                                      : BoxDecoration(
                                          color: Colors.grey,
                                          backgroundBlendMode:
                                              BlendMode.saturation,
                                        ),
                                  height: size.height * 0.3,
                                  child: BoxAddUserWidget(
                                    image: 'assets/images/data.png',
                                    textButton: 'Data Ikan',
                                    startColor: 0xFF1234678,
                                    endColor: 0xFF123456,
                                    press: role == "admin"
                                        ? () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddDataScreen(),
                                              ),
                                            );
                                          }
                                        : () {},
                                    title: 'Pertumbuhan \nIkan',
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                        return ProfileShimmer();
                      },
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
