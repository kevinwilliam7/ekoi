import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/color_constant.dart';

class RouteBackgroundWidget extends StatelessWidget {
  final double height;
  final String image;
  const RouteBackgroundWidget(
      {Key? key, required this.height, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      child: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(
              image,
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }
}
