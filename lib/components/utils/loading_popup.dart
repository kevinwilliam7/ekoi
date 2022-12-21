import 'package:flutter/material.dart';

class LoadingPopup {
  static loadingPopUp(context, String text) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        'Memuat...',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}
