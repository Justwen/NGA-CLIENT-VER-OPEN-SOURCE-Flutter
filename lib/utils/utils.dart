

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class StringUtils {

  static bool isEmpty(String data) => data == null || data == "";

}

class ContextUtils {

  static BuildContext buildContext;

}

class ToastUtils {

  static void showToast(String msg) {
    Toast.show(msg, ContextUtils.buildContext);
  }
}

