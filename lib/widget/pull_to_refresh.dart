import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nga_open_source/bloc/list_view_bloc.dart';

class PullToRefreshWidget<T> extends StatefulWidget {
  final Function loadMore;

  final Function refresh;

  final Function listBuilder;

  final List<T> datList;

  final ListViewBloc bloc;

  bool _showLoading = false;

  final ScrollController scrollController;

  PullToRefreshWidget(this.datList, this.listBuilder,
      {this.loadMore, this.refresh, this.bloc, this.scrollController});

  @override
  State<StatefulWidget> createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefreshWidget> {
  static const double DISPLACEMENT = 40.0;

  static const double MIN_MOVE_DISTANCE = 5;

  ScrollController _scrollController;

  Function _updateScrollPosition;

  bool get showLoading => widget._showLoading;

  int lastDirection;

  double lastDownY = 0;

  @override
  Widget build(BuildContext context) {
    _scrollController ??= widget.scrollController ?? new ScrollController();
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      displacement: DISPLACEMENT,
      child: Listener(
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
        ),
        onPointerMove: (event) {
          var dy = event.position.distance;
          var diff = dy - lastDownY;
          lastDownY = dy;
          if (diff.abs() > MIN_MOVE_DISTANCE) {
            if (diff < 0 && lastDirection >= 0) {
              lastDirection = 1;
              widget.bloc?.scrollDown();
            } else if (diff > 0 && lastDirection <= 0) {
              lastDirection = -1;
              widget.bloc?.scrollUp();
            }
          }
        },
        onPointerDown: (event) {
          lastDownY = event.position.distance;
          lastDirection = 0;
        },
      ),
    );
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
