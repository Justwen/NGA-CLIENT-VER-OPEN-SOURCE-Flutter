import 'package:flutter/material.dart';

class TabWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool isScrollable;

  final Function(int) onTap;

  final int tabCount;

  final Function(BuildContext, int) tabBuilder;

  final double tabHeight;

  final double indicatorWeight;

  final int initialIndex;

  final Function(TabController) onTabBuild;

  TabWidget(
      {this.isScrollable = true,
      this.onTap,
      this.tabCount,
      this.tabBuilder,
      this.tabHeight = 46,
      this.initialIndex = 0,
      this.onTabBuild,
      this.indicatorWeight = 2.0});

  @override
  State<StatefulWidget> createState() {
    return new _TabState();
  }

  @override
  Size get preferredSize => Size.fromHeight(tabHeight + indicatorWeight);
}

class _TabState extends State<TabWidget> with TickerProviderStateMixin {
  bool get isScrollable => widget.isScrollable;

  Function get onTap => widget.onTap;

  int get tabCount => widget.tabCount;

  Function get tabBuilder => widget.tabBuilder;

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs;
    for (int i = 0; i < tabCount; i++) {
      tabs ??= new List();
      tabs.add(tabBuilder(context, i));
    }
    _tabController = new TabController(
        initialIndex: widget.initialIndex, length: tabCount, vsync: this);
    widget.onTabBuild?.call(_tabController);
    return TabBar(
        isScrollable: isScrollable,
        onTap: onTap,
        controller: _tabController,
        tabs: tabs);
  }
}
