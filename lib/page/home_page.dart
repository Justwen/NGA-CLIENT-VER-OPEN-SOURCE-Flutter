import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_state.dart';
import 'package:nga_open_source/res/app_colors.dart';
import 'package:sprintf/sprintf.dart';

import '../common/component_index.dart';
import 'login_page.dart';
import '../model/entity/board_info.dart';
import 'topic_title_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const String URL_BOARD_ICON =
      "http://img4.nga.178.com/ngabbs/nga_classic/f/app/%s.png";

  String title;

  TabController tabController;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    title = AppStrings.appName;
  }

  Widget _buildTabBar() {
    tabController = TabController(
      initialIndex: currentTabIndex,
      length: AppRedux.boardState.categoryList.length,
      vsync: this,
    );
    tabController.addListener(() {
      currentTabIndex = tabController.index;
    });
    Widget tabBar = TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: AppRedux.boardState.categoryList.map((e) {
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
      children: AppRedux.boardState.categoryList.map((e) {
        return _buildBoardListView(e);
      }).toList(),
      controller: tabController,
    );
    return tabBarBody;
  }

  Widget _buildBoardListView(Category category) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.25),
        itemCount: category.boards.length,
        itemBuilder: (context, i) {
          return _buildBoardItem(category.boards[i]);
        });
  }

  Widget _buildBoardItem(Board board) {
    return InkWell(
        onTap: () => _startTopicListPage(board),
        child: Container(
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

  void _startTopicListPage(Board board) async {
    bool empty = AppRedux.userState.isEmpty();

    Widget nextWidget = empty
        ? new LoginWidget()
        : new TopicTitleWidget(board);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => nextWidget));
  }

  Widget _getBoardIcon(Board board) {
    return CachedNetworkImage(
      width: 48,
      height: 48,
      imageUrl: sprintf(URL_BOARD_ICON, [board.fid.toString()]),
      placeholder: (context, url) => Image.asset(
        ResourceUtils.getDrawable("default_board_icon"),
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
    return StoreConnector<AppState, BoardState>(
        converter: (store) => store.state.boardState,
        builder: (context, boardState) {
          print("length = " + boardState.categoryList.length.toString());
          return Scaffold(
            backgroundColor: AppColors.BACKGROUND_COLOR,
            appBar: AppBar(
              title: Text(ResourceUtils.getString(context, title)),
              bottom: _buildTabBar(),
            ),
            body: _buildTabBody(),
          );
        });
  }
}
