import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/widgets/button_ordinary.dart';

class BoxAddUserWidget extends StatelessWidget {
  const BoxAddUserWidget(
      {Key? key,
      required this.startColor,
      required this.endColor,
      required this.title,
      required this.press,
      required this.textButton,
      required this.image})
      : super(key: key);

  final VoidCallback press;
  final int startColor, endColor;
  final String title, textButton, image;

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
              image,
              scale: 7,
            ),
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
              textButton: textButton,
              textColor: 0xFFF9F9F9,
            ),
          ),
        ],
      ),
    );
  }
}
