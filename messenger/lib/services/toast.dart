import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

void toast(String msg) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
      backgroundColor: Colors.indigo,
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))));
}
