import 'package:flutter/material.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

String to24hours(hourS, minuteS) {
  final hour = hourS.toString().padLeft(2, "0");
  final min = minuteS.toString().padLeft(2, "0");
  return "$hour:$min";
}
