import 'package:dynamic_color/dynamic_color.dart' show DynamicColorBuilder;
import 'package:flutter/material.dart';
import '../main.dart' show MyApp;

/// A wrapper class for [DynamicColorBuilder] to be used in my [MyApp]
class MyDynamicColorBuilder extends StatelessWidget {
  const MyDynamicColorBuilder({
    required this.isEnabled,
    required this.builder,
    super.key,
  });

  final bool isEnabled;
  final Widget Function(ColorScheme? lightDynamic, ColorScheme? darkDynamic)
      builder;

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return builder(null, null);
    }
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return builder(lightDynamic, darkDynamic);
      },
    );
  }
}
