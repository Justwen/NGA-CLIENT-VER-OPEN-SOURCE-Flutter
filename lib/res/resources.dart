import 'package:fluintl/fluintl.dart';
import 'package:fluintl/src/intl_util.dart';
import 'package:flutter/material.dart';
import 'package:nga_open_source/res/app_colors.dart';

class ResourceUtils {
  static String getDrawable(String resName, {String format = "png"}) {
    return 'assets/images/$resName.$format';
  }

  static getString(BuildContext context, String id) {
    return IntlUtil.getString(context, id);
  }

}
