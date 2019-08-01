import 'package:fluintl/fluintl.dart';
import 'package:fluintl/src/intl_util.dart';
import 'package:flutter/material.dart';

class Resources {
  static String getDrawable(String resName, {String format = "png"}) {
    return 'assets/images/$resName.$format';
  }

  static getString(BuildContext context, String id) {
    return IntlUtil.getString(context, id);
  }
}
