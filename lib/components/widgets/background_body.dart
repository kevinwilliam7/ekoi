import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/color_constant.dart';

class BodyBackgroundWidget extends StatelessWidget {
  final double height;
  const BodyBackgroundWidget({Key? key, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kBlueColor1,
            kBlueColor2,
          ],
        ),
      ),
    );
  }
}
