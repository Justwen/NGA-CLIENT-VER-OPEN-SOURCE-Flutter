import 'dart:convert';

import 'package:nga_open_source/bloc/base_bloc.dart';

class WebViewBloc extends BaseBloc<String> {
  void loadUrl(String url) {
    if (bean != url) {
      bean = url;
      print("loadUrl");
      notifyDataChanged();
    }
  }
}
