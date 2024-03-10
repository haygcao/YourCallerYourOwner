import 'package:flutter/material.dart';

class SnackbarService {
  static void showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green, // Customize the color as needed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red, // Customize the color as needed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

