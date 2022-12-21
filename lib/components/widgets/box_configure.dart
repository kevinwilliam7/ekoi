import 'package:flutter/material.dart';

import 'button_ordinary.dart';

class BoxConfigureWidget extends StatelessWidget {
  const BoxConfigureWidget({
    Key? key,
    required this.startColor,
    required this.endColor,
    required this.title,
    required this.press,
    required this.widget,
  }) : super(key: key);
  final VoidCallback press;
  final int startColor, endColor;
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
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
              'assets/images/configuration.png',
              scale: 7,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: widget,
          ),
          Positioned(
            left: 15,
            top: 70,
            child: Text(
              title,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 25,
            child: OrdinaryButton(
              outlineColor: 0xFFF9F9F9,
              press: press,
              textButton: 'Atur Sekarang',
              textColor: 0xFFF9F9F9,
            ),
          ),
        ],
      ),
    );
  }
}
