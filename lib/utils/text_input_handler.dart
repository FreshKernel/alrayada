import 'package:flutter/widgets.dart';

/// A class that hold both the [TextEditingController] and [FocusNode] to
/// make things more readable and easier to maintain
@immutable
class TextInputHandler {
  const TextInputHandler(
    this.controller,
    this.focusNode,
  );

  final TextEditingController controller;
  final FocusNode focusNode;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
