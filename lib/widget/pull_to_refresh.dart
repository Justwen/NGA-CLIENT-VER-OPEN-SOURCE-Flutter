import 'package:flutter/material.dart';

class PullToRefreshWidget<T> extends StatefulWidget {
  final Function loadMore;

  final Function refresh;

  final Function listBuilder;

  final List<T> datList;

  bool _showLoading = false;

  PullToRefreshWidget(this.datList, this.listBuilder,
      {this.loadMore, this.refresh});

  @override
  State<StatefulWidget> createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefreshWidget> {
  static const double DISPLACEMENT = 40.0;

  ScrollController _scrollController = ScrollController();

  Function _updateScrollPosition;

  bool get showLoading => widget._showLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _refresh(),
        displacement: DISPLACEMENT,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.datList.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.datList.length) {
              return widget._showLoading
                  ? _buildLoadingWidget()
                  : _buildNoMoreWidget();
            } else {
              return widget.listBuilder(context, index);
            }
          },
          controller: _scrollController,
        ));
  }

  Widget _buildLoadingWidget() {
    return Offstage(
        offstage: false,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Center(
            child: new CircularProgressIndicator(),
          ),
        ));
  }

  Widget _buildNoMoreWidget() {
    return Offstage(
        offstage: false,
        child: Center(
            child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text("没有更多啦~"))));
  }

  @override
  void initState() {
    _updateScrollPosition = () {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!widget._showLoading) {
          _loadMore();
        }
      }
    };
    _scrollController.addListener(_updateScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollPosition);
    super.dispose();
  }

  void _loadMore() {
    if (widget.loadMore != null && widget.loadMore()) {
      setState(() {
        widget._showLoading = true;
      });
    }
  }

  Future<Null> _refresh() async {
    if (widget.refresh != null) {
      widget.refresh();
    }
  }
}
