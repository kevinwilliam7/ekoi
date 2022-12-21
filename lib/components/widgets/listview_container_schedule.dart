import 'package:flutter/material.dart';

class ContainerListSchedule extends StatelessWidget {
  const ContainerListSchedule(
      {Key? key,
      required this.startColor,
      required this.endColor,
      required this.icon,
      required this.textColor,
      required this.textTime,
      required this.textTitle,
      required this.width,
      required this.asset})
      : super(key: key);

  final Widget icon;
  final double width;
  final int startColor, endColor;

  final Color textColor;
  final String textTime;
  final String textTitle;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
        //     blurRadius: 5,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              child: Image.asset(asset, fit: BoxFit.contain, scale: 5),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: icon,
          ),
          Positioned(
            bottom: 25,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textTitle,
                  style: TextStyle(color: textColor, fontFamily: 'Lato'),
                ),
                Text(
                  textTime,
                  style: TextStyle(color: textColor, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
