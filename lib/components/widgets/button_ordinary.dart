import 'package:flutter/material.dart';

class OrdinaryButton extends StatelessWidget {
  const OrdinaryButton({
    Key? key,
    required this.press,
    required this.textButton,
    required this.textColor,
    required this.outlineColor,
  }) : super(key: key);
  final VoidCallback press;
  final String textButton;
  final int textColor, outlineColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Color(outlineColor),
            ),
          ),
        ),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            right: 15,
            left: 15,
          ),
          child: Text(
            textButton,
            style: TextStyle(
              color: Color(textColor),
            ),
          ),
        ),
      ),
      onPressed: press,
    );
  }
}
