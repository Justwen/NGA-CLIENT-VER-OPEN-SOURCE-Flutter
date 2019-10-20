import 'package:flutter/material.dart';

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
