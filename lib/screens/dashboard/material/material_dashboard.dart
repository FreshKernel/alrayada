import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/settings_cubit.dart';
import '../navigation_item.dart';
import 'w_material_drawer.dart';

class MaterialScaffoldDashboard extends StatefulWidget {
  const MaterialScaffoldDashboard({
    required this.navigationItems,
    super.key,
  });

  final List<NavigationItem> navigationItems;

  @override
  State<MaterialScaffoldDashboard> createState() =>
      MaterialScaffoldDashboardState();
}

class MaterialScaffoldDashboardState extends State<MaterialScaffoldDashboard> {
  var _currentIndex = 0;
  final _pageStorageBucket = PageStorageBucket();

  bool _isNavRailBar(Size size, AppLayoutMode layoutMode) {
    switch (layoutMode) {
      //  Might want needs to be updated
      case AppLayoutMode.auto:
        return size.width >= 480;
      case AppLayoutMode.small:
        return false;
      case AppLayoutMode.large:
        return true;
    }
  }

  void navigateToItem(int newIndex) => setState(() {
        _currentIndex = newIndex;
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.layoutMode != current.layoutMode,
      builder: (context, state) => Scaffold(
        drawer: const DashboardMaterialDrawer(),
        appBar: AppBar(
          title: Text(widget.navigationItems[_currentIndex].label),
          actions: widget.navigationItems[_currentIndex].actionsBuilder
              ?.call(context),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              final bodyWidget = PageStorage(
                bucket: _pageStorageBucket,
                child: widget.navigationItems[_currentIndex].body,
              );
              if (!_isNavRailBar(
                  MediaQuery.sizeOf(context), state.layoutMode)) {
                return bodyWidget;
              }
              return Row(
                children: [
                  NavigationRail(
                    onDestinationSelected: navigateToItem,
                    labelType: NavigationRailLabelType.all,
                    destinations: widget.navigationItems.map((e) {
                      return e.toNavigationRailDestination();
                    }).toList(),
                    selectedIndex: _currentIndex,
                  ),
                  Expanded(
                    child: widget,
                  )
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            if (_isNavRailBar(MediaQuery.sizeOf(context), state.layoutMode)) {
              return const SizedBox.shrink();
            }
            return NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: navigateToItem,
              destinations: widget.navigationItems.map((e) {
                return e.toNavigationDestination();
              }).toList(),
            );
          },
        ),
        floatingActionButton: widget
            .navigationItems[_currentIndex].actionButtonBuilder
            ?.call(context),
      ),
    );
  }
}
