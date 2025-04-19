import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 1),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        // Optional action
      },
    ),
  );

  ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(snackBar);
}