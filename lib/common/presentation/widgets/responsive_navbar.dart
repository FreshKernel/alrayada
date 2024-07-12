import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../admin/dashboard/admin_dashboard_screen.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../dashboard/tab_item.dart';
import '../../../settings/data/settings_data.dart';
import '../../../settings/logic/settings_cubit.dart';

/// A widget that is used in [DashboardScreen] and [AdminDashboardScreen]
///
/// it share the responsive navigation bar
/// it will use [NavigationRail] on bigger screens
/// and [NavigationBar] in smaller screens
///
/// It doesn't define the tabs or the navigation bar items (or the tabs)
class ResponsiveNavbar extends StatelessWidget {
  const ResponsiveNavbar({
    required this.tabs,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.pageStorageBucket,
    this.drawer,
    super.key,
  });

  final List<TabItem> tabs;
  final int currentIndex;
  final Widget? drawer;
  final ValueChanged<int> onDestinationSelected;
  final PageStorageBucket pageStorageBucket;

  bool _isNavRailBar(Size size, AppLayoutMode layoutMode) {
    switch (layoutMode) {
      case AppLayoutMode.auto:
        return size.width >= 480;
      case AppLayoutMode.small:
        return false;
      case AppLayoutMode.large:
        return true;
    }
  }

  List<TabItem> get _tabs => tabs;

  int get _currentIndex => currentIndex;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, AppLayoutMode>(
      selector: (state) => state.layoutMode,
      builder: (context, layoutMode) {
        return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            title: Text(_tabs[_currentIndex].label),
            actions: _tabs[_currentIndex].actionsBuilder?.call(context),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                final bodyWidget = PageStorage(
                  bucket: pageStorageBucket,
                  child: _tabs[_currentIndex].body,
                );
                if (!_isNavRailBar(MediaQuery.sizeOf(context), layoutMode)) {
                  return bodyWidget;
                }
                return Row(
                  children: [
                    NavigationRail(
                      onDestinationSelected: onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      destinations: _tabs.map((e) {
                        return e.toNavigationRailDestination();
                      }).toList(),
                      selectedIndex: _currentIndex,
                    ),
                    Expanded(
                      child: bodyWidget,
                    )
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              if (_isNavRailBar(MediaQuery.sizeOf(context), layoutMode)) {
                return const SizedBox.shrink();
              }
              return NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: _tabs.map((e) {
                  return e.toNavigationDestination();
                }).toList(),
              );
            },
          ),
          floatingActionButton:
              _tabs[_currentIndex].actionButtonBuilder?.call(context),
        );
      },
    );
  }
}
