import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'common/component_index.dart';
import 'login_page.dart';
import 'model/board_model.dart';
import 'model/user_model.dart';
import 'topic_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const String URL_BOARD_ICON =
      "http://img4.nga.178.com/ngabbs/nga_classic/f/app/%s.png";

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
    return InkWell(
        onTap: () => _startTopicListPage(board),
        child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: _getBoardIcon(board),
                ),
                Container(
                    padding: EdgeInsets.only(top: 4), child: Text(board.name)),
              ],
            )));
  }

  void _startTopicListPage(Board board) {
    Widget nextWidget = UserModel.getInstance().isEmpty()
        ? new LoginWidget()
        : new TopicListWidget(board);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }

  Widget _getBoardIcon(Board board) {
    return CachedNetworkImage(
      width: 48,
      height: 48,
      imageUrl: sprintf(URL_BOARD_ICON, [board.fid.toString()]),
      placeholder: (context, url) => Image.asset(
        Resources.getDrawable("default_board_icon"),
        width: 48,
        height: 48,
      ),
    );
  }

  String _getImageName(Board board) {
    int fid = board.fid;
    return fid > 0 ? "p" + fid.toString() : "p_" + fid.abs().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Resources.getString(context, title)),
        bottom: _buildTabBar(),
      ),
      body: _buildTabBody(),
    );
  }
}
