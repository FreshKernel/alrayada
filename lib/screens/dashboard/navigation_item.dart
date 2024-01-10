import 'package:flutter/material.dart'
    show NavigationDestination, NavigationRailDestination;
import 'package:flutter/widgets.dart'
    show
        BottomNavigationBarItem,
        BuildContext,
        Text,
        ValueKey,
        Widget,
        immutable;

@immutable
class NavigationItem {
  const NavigationItem({
    required this.label,
    required this.body,
    required this.title,
    required this.icon,
    this.tooltip,
    this.actionsBuilder,
    this.actionButtonBuilder,
  });
  final String title;
  final String label;
  final Widget body;
  final Widget icon;
  final String? tooltip;
  final NavigationItemActionsBuilder? actionsBuilder;
  final NavigationItemActionButtonBuilder? actionButtonBuilder;

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
        key: ValueKey(tooltip),
      );

  NavigationRailDestination toNavigationRailDestination() =>
      NavigationRailDestination(
        icon: icon,
        label: Text(label),
      );
}

typedef NavigationItemActionsBuilder = List<Widget> Function(
    BuildContext context);

typedef NavigationItemActionButtonBuilder = Widget Function(
    BuildContext context);
