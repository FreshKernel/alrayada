import 'package:flutter/material.dart'
    show ScaffoldMessengerState, SnackBar, Text;

extension ScaffoldMessengerStateExtensions on ScaffoldMessengerState {
  void showSnackBarText(String text) {
    clearSnackBars();
    showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
