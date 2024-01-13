import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class OptionCheckbox extends StatelessWidget {
  const OptionCheckbox({
    required this.title,
    required this.description,
    required this.onChanged,
    required this.value,
    super.key,
    this.leading,
  });
  final String title;
  final Widget? leading;
  final String description;
  final VoidCallback onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: (v) => onChanged(),
      title: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              title,
            ),
          ),
        ],
      ),
      subtitle: Text(
        description,
        maxLines: 5,
      ),
    );
  }
}
