import 'package:flutter/cupertino.dart';

import '../navigation_item.dart';

class CupertinoScaffoldDashboard extends StatefulWidget {
  const CupertinoScaffoldDashboard({required this.navigationItems, super.key});
  final List<NavigationItem> navigationItems;

  @override
  State<CupertinoScaffoldDashboard> createState() =>
      CupertinoScaffoldDashboardState();
}

class CupertinoScaffoldDashboardState
    extends State<CupertinoScaffoldDashboard> {
  late final CupertinoTabController _cupertinoTabController;

  @override
  void initState() {
    super.initState();
    _cupertinoTabController = CupertinoTabController();
  }

  @override
  void dispose() {
    _cupertinoTabController.dispose();
    super.dispose();
  }

  void navigateToItem(int newIndex) {
    _cupertinoTabController.index = newIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        items: widget.navigationItems
            .map((e) => e.toBottomNavigationBarItem())
            .toList(),
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  widget.navigationItems[index].actionsBuilder?.call(context) ??
                      [],
            ),
            middle: Text(widget.navigationItems[index].label),
          ),
          child: SafeArea(
            child: widget.navigationItems[index].body,
          ),
        );
      },
    );
  }
}
