// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PopupWidget extends StatelessWidget {
  final Widget popoutTitle;
  final Widget popoutContent;
  final VoidCallback acceptPressed;
  final Widget acceptText;
  const PopupWidget({
    Key? key,
    required this.popoutTitle,
    required this.popoutContent,
    required this.acceptPressed,
    required this.acceptText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: popoutTitle,
      content: popoutContent,
      actions: [
        TextButton(
          //FlatButton
          // textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('BATAL'),
        ),
        TextButton(
          //FlatButton
          // textColor: Color(0xFF6200EE),
          onPressed: acceptPressed,
          child: acceptText,
        ),
      ],
    );
  }
}
