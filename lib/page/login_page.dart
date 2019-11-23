import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/utils/utils.dart';

import '../model/entity/user_info.dart';

class LoginWidget extends StatelessWidget {
  static const String LOGIN_WEB_PAGE_URL =
      "https://bbs.nga.cn/nuke.php?__lib=login&__act=account&login";

  static const String COOKIE_KEY_UID = "ngaPassportUid";

  static const String COOKIE_KEY_UNAME = "ngaPassportUrlencodedUname";

  static const String COOKIE_KEY_CID = "ngaPassportCid";

  String url;

  @override
  Widget build(BuildContext context) {
    WebViewUtils.startUrlListener((url) {
      this.url = url;
      _parseCookie(url);
    });
    return WillPopScope(
      child: WebviewScaffold(
        //加载的URL
        url: LOGIN_WEB_PAGE_URL,
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text("登录"),
        ),
        initialChild: Container(
          color: Colors.white,
          child: Center(
            child: Text('Waiting...'),
          ),
        ), //设置初始化界面
      ),
      onWillPop: () {
        WebViewUtils.stopUrlListener();
        return _parseCookie(url);

      },
    );
  }

  Future<bool> _parseCookie(String url) async {
    String cookiesString = await WebViewUtils.getAllCookies(url);
    String uid;
    String uName;
    String cid;
    cookiesString?.split(';')?.forEach((String cookie) {
      final split = cookie.split('=');
      if (split[0].trim() == COOKIE_KEY_UID) {
        uid = split[1].trim();
      } else if (split[0].trim() == COOKIE_KEY_UNAME) {
        uName = split[1].trim();
      } else if (split[0].trim() == COOKIE_KEY_CID) {
        cid = split[1].trim();
      }
    });
    print("uid=$uid, uName=$uName, cid=$cid");
    if (uid != null && uName != null && cid != null) {
      AppRedux.dispatch(UserAddAction(UserInfo(uName, uid, cid)));
    }
    return new Future.value(true);
  }
}
