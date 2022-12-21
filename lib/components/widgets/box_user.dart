import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/widgets/button_ordinary.dart';

class BoxUserWidget extends StatelessWidget {
  const BoxUserWidget({
    Key? key,
    required this.press,
    required this.startColor,
    required this.endColor,
    required this.role,
    required this.logout,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  final String name, email, phone, role;
  final int startColor, endColor;
  final VoidCallback press, logout;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: const Alignment(1, 0.0),
          colors: <Color>[
            Color(startColor),
            Color(endColor),
          ],
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.blue.withOpacity(0.5),
        //     spreadRadius: 1,
        //     blurRadius: 10,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -85,
            bottom: -100,
            child: Image.asset(
              'assets/images/profile.png',
              scale: 7,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: EdgeInsets.all(12),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '#role/' + role,
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 70,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.9,
              child: Text(
                name,
                style: TextStyle(fontSize: 26, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 100,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.9,
              child: Text(
                email,
                style: TextStyle(fontSize: 13, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 25,
            child: Row(
              children: [
                OrdinaryButton(
                  outlineColor: 0xFFF9F9F9,
                  press: press,
                  textButton: 'Ubah Informasi',
                  textColor: 0xFFF9F9F9,
                ),
                SizedBox(width: 5),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      right: 15,
                      left: 15,
                    ),
                    child: Text(
                      'Keluar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
