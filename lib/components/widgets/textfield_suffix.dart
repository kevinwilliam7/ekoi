import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/text_constant.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    this.validator,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) => {},
      style: inputText,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      autofocus: true,
      obscureText: false,
      enabled: enabled,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: labelText,
        labelStyle: textField,
        hintText: hintText,
        hintStyle: textField,
        prefixIcon: Icon(
          icon,
          size: 18,
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
