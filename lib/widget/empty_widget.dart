import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final Function _refresh;

  final bool pullRefresh;

  EmptyWidget(this._refresh, {this.pullRefresh = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _buildEmptyWidget(),
      onTap: _refresh,
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      color: Colors.transparent,
      child: Text("加载失败，请重试"),
      alignment: Alignment.center,
    );
  }
}
