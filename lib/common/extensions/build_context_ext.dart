import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  bool get isDark {
    return Theme.of(this).brightness == Brightness.dark;
  }
}
