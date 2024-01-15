import 'package:flutter/material.dart'
    show ScaffoldMessengerState, SnackBar, Text;

extension ScaffoldMessengerStateExt on ScaffoldMessengerState {
  void showSnackBarText(String text) {
    clearSnackBars();
    showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
