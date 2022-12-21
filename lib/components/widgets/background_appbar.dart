import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/color_constant.dart';

class AppbarBackgroundWidget extends StatelessWidget {
  const AppbarBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // const Color(0xFF3366FF),
            // const Color(0xFF00CCFF),
            kBlueColor1,
            kBlueColor2,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }
}
