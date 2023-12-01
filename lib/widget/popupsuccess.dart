import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniproject/style.dart';

class PopupSuccess {
  static void alertDialog(context,
      {required String message,
      required String submessage,
      required VoidCallback onPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 50,
                color: Styles.blue,
              ),
              SizedBox(
                height: 30,
              ),
              Text(message, style: Styles.HeaderText),
              SizedBox(
                height: 15,
              ),
              Text(
                submessage,
                style: Styles.detailTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.buttonDefaultBackgroundColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text("OK", style: TextStyle(color: Colors.white)),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }
}
