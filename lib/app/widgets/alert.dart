import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

alertDialog(context, AlertType type, String title, String text) {
  Alert(
    context: context,
    type: AlertType.none,
    title: title,
    desc: text,
    style: const AlertStyle(
      backgroundColor: Color(0xffdecee7),
      titleStyle: TextStyle(color: Color(0xff1d083b), fontWeight: FontWeight.bold),
      descStyle: TextStyle(
        color: Color(0xff1d083b),
      ),
    ),
    buttons: [
      DialogButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        width: 120,
        color: const Color(0xff1d083b),
        child: const Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
      )
    ],
  ).show();
}