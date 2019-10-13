import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TextStyleEx extends TextStyle {
  TextStyleEx({
    double fontSize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) : super(
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        );
}
