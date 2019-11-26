import 'package:flutter/material.dart';
import 'package:nga_open_source/common/component_index.dart';

class PopupMenuItemEx extends PopupMenuItem<String> {
  PopupMenuItemEx(String value, Widget child)
      : super(value: value, child: child);

  factory PopupMenuItemEx.create(String value, String text) {
    Widget child = Container(
      alignment: Alignment.center,
      child: Text(text),
    );
    return PopupMenuItemEx(value, child);
  }
}

class ActionMenuIcon extends StatelessWidget {
  final Function onClick;

  final String text;

  final String drawableRes;

  ActionMenuIcon({this.text, this.onClick, this.drawableRes});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: drawableRes != null ? _getActionIcon() : _getActionText(),
    );
  }

  Widget _getActionIcon() {
    return Image.asset(
      ResourceUtils.getDrawable(drawableRes),
      width: 24,
      height: 24,
    );
  }

  Widget _getActionText() {
    return Padding(
        padding: EdgeInsets.only(right: 16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
