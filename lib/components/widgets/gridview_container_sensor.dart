import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BoxGridViewSensor extends StatelessWidget {
  const BoxGridViewSensor({
    Key? key,
    required this.startColor,
    required this.endColor,
    required this.centerIndicator,
    required this.textColor,
    required this.textTitle,
    required this.valueIndicator,
    required this.colorIndicator,
    required this.textValue,
    required this.textUnit,
    required this.iconColor,
    required this.imageAsset,
    required this.midColor,
  }) : super(key: key);

  final IconData centerIndicator;
  final int startColor, endColor, midColor, iconColor;
  final double valueIndicator;
  final Color textColor, colorIndicator;
  final String textTitle, textValue, textUnit, imageAsset;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0, 20),
              blurRadius: 30,
              spreadRadius: -5,
            ),
          ],
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
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 25,
              left: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textTitle,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textValue,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ' ' + textUnit,
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              child: Image.asset(
                imageAsset,
                width: 45,
                height: 45,
              ),
              top: 15,
              left: 15,
            ),
            // Positioned(
            //   top: 15,
            //   left: 15,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       CircularPercentIndicator(
            //         radius: 45,
            //         lineWidth: 2,
            //         percent: valueIndicator < 0
            //             ? 0
            //             : valueIndicator > 1
            //                 ? 1
            //                 : valueIndicator,
            //         progressColor: colorIndicator,
            //         backgroundColor: Color.fromARGB(255, 207, 207, 207),
            //         circularStrokeCap: CircularStrokeCap.round,
            //         center: FaIcon(
            //           centerIndicator,
            //           color: Color(iconColor),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
