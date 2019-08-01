import 'package:fluintl/fluintl.dart';
import 'package:fluintl/src/intl_util.dart';
import 'package:flutter/material.dart';

class AppStrings {
  static const String appName = "app_name";

  static getString(BuildContext context, String id) {
    return IntlUtil.getString(context, id);
  }

  static Map<String, Map<String, String>> localizedSimpleValues = {
    'zh': {
      appName: "NGA客户端开源版",
    },
    'en': {
      appName: "NGA OPEN SOURCE CLIENT",
    },
  };

  static Map<String, Map<String, Map<String, String>>> localizedValues = {
    'zh': {
      'CN': {
        appName: "NGA客户端开源版",
      }
    },
    'en': {
      'US': {
        appName: "NGA OPEN SOURCE CLIENT",
      }
    },
  };
}
