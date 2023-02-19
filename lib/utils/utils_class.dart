import 'package:flutter/material.dart';
import 'package:video_conferencing/main.dart';

class Utils {
  static showSnackbar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      elevation: 1.0,
      content: Text(
        text,
        style: const TextStyle(color: Colors.blue),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "Ok",
        onPressed: () => {},
      ),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
