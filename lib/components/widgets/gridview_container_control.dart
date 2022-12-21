import 'package:flutter/material.dart';

class BoxGridviewControl extends StatelessWidget {
  const BoxGridviewControl(
      {Key? key,
      required this.switchButton,
      required this.startColor,
      required this.endColor,
      required this.icon,
      required this.title,
      required this.foregroundDecoration,
      required this.midColor,
      required this.imageAsset,
      required this.textColor})
      : super(key: key);
  final Widget switchButton;
  final Widget icon;
  final Decoration foregroundDecoration;
  final int startColor, endColor, midColor;
  final String title, imageAsset;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: foregroundDecoration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(startColor),
            Color(midColor),
            Color(endColor),
            Color(endColor),
          ],
          stops: const [0.1, 0.3, 0.9, 1.0],
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.blue.withOpacity(0.5),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 15,
            child: switchButton,
          ),
          // Positioned(
          //   top: 15,
          //   left: 15,
          //   child: icon,
          // ),
          Positioned(
            top: 15,
            left: 15,
            child: Image.asset(
              imageAsset,
              width: 35,
              height: 35,
            ),
          ),
          Positioned(
            top: 65,
            left: 15,
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
