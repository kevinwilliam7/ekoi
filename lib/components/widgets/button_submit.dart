import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/color_constant.dart';
import 'package:smart_aquarium/constants/text_constant.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  const SubmitButton({Key? key, required this.text, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(text, style: textButton),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return kBlueColor;
            }
            return kBlueColor1;
          },
        ),
      ),
    );
  }
}
