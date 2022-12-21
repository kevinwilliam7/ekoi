import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/text_constant.dart';

class PasswordFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final VoidCallback suffixPress;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const PasswordFieldWidget(
      {Key? key,
      required this.obscureText,
      required this.suffixPress,
      required this.labelText,
      required this.hintText,
      required this.controller,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: inputText,
      validator: validator,
      controller: controller,
      autofocus: true,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        labelText: labelText,
        labelStyle: textField,
        hintText: hintText,
        hintStyle: textField,
        prefixIcon: Icon(
          Icons.lock_outline,
          size: 18,
        ),
        suffixIcon: IconButton(
          icon: obscureText == true
              ? Icon(
                  Icons.visibility_off_outlined,
                  size: 18,
                )
              : Icon(
                  Icons.visibility_outlined,
                  size: 18,
                ),
          onPressed: suffixPress,
        ),
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}
