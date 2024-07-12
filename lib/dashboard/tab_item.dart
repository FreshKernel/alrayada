import 'package:flutter/material.dart'
    show NavigationDestination, NavigationRailDestination, FloatingActionButton;
import 'package:flutter/widgets.dart'
    show
        BottomNavigationBarItem,
        BuildContext,
        Text,
        ValueKey,
        Widget,
        immutable;

@immutable
class TabItem {
  const TabItem({
    required this.id,
    required this.label,
    required this.body,
    required this.title,
    required this.icon,
    this.tooltip,
    this.actionsBuilder,
    this.actionButtonBuilder,
  });
  final String id;
  final String title;
  final String label;
  final Widget body;
  final Widget icon;
  final String? tooltip;
  final TabItemActionsBuilder? actionsBuilder;

  /// It's usually the [FloatingActionButton]
  final TabItemActionButtonBuilder? actionButtonBuilder;

  BottomNavigationBarItem toBottomNavigationBarItem() =>
      BottomNavigationBarItem(
        icon: icon,
        tooltip: tooltip,
        label: label,
      );

  NavigationDestination toNavigationDestination() => NavigationDestination(
        icon: icon,
        label: label,
        tooltip: tooltip,
        key: ValueKey(id),
      );

  NavigationRailDestination toNavigationRailDestination() =>
      NavigationRailDestination(
        icon: icon,
        label: Text(label),
      );
}

typedef TabItemActionsBuilder = List<Widget> Function(
  BuildContext context,
);

typedef TabItemActionButtonBuilder = Widget Function(
  BuildContext context,
);

typedef TabItemOnNavigateToTabCallback = void Function(String newTabId);
