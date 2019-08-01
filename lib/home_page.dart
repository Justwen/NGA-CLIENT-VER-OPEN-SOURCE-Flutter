import 'package:flutter/material.dart';

import 'common/component_index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String title;

  TabController tabController;

  List<Category> categoryList;

  @override
  void initState() {
    super.initState();
    title = AppStrings.appName;
    categoryList = BoardManager.getInstance().initData(() {
      setState(() {
        categoryList = BoardManager.getInstance().getBoardCategory();
      });
    });
  }

  Widget _buildTabBar() {
    tabController = TabController(length: categoryList.length, vsync: this);
    Widget tabBar = TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: categoryList.map((e) {
        return Container(
          height: 48.0,
          alignment: Alignment.center,
          child: Text(e.name),
        );
      }).toList(),
    );
    return tabBar;
  }

  Widget _buildTabBody() {
    Widget tabBarBody = TabBarView(
      children: categoryList.map((e) {
        return _buildBoardListView(e);
      }).toList(),
      controller: tabController,
    );
    return tabBarBody;
  }

  Widget _buildBoardListView(Category category) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: category.boards.length,
        itemBuilder: (context, i) {
          return _buildBoardItem(category.boards[i]);
        });
  }

  Widget _buildBoardItem(Board board) {
    return Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          children: [
            _getBoardIcon(board),
            Container(
                padding: EdgeInsets.only(top: 4), child: Text(board.name)),
          ],
        ));
  }

  Image _getBoardIcon(Board board) {

    Image image = Image.asset(Resources.getDrawable(_getImageName(board)),
        width: 48, height: 48);
    if (image == null) {
      image = Image.asset(Resources.getDrawable("default_board_icon"),
          width: 48, height: 48);
    }
    return image;
  }

  String _getImageName(Board board) {
    int fid = board.fid;
    return fid > 0 ? "p" + fid.toString() : "p_" + fid.abs().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, title)),
        bottom: _buildTabBar(),
      ),
      body: _buildTabBody(),
    );
  }
}
