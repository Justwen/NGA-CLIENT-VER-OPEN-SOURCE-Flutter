import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'model/user_model.dart';

class LoginWidget extends StatelessWidget {
  static const String LOGIN_WEB_PAGE_URL =
      "https://bbs.nga.cn/nuke.php?__lib=login&__act=account&login";

  static const String COOKIE_KEY_UID = "ngaPassportUid";

  static const String COOKIE_KEY_UNAME = "ngaPassportUrlencodedUname";

  @override
  Widget build(BuildContext context) {
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
            child: Text('Wiating...'),
          ),
        ), //设置初始化界面
      ),
      onWillPop: () => _parseCookie(),
    );
  }

  Future<bool> _parseCookie() {
    FlutterWebviewPlugin plugin = new FlutterWebviewPlugin();
    plugin.getCookies().then((cookies) {
      print("parse cookies");
      String uid = cookies[COOKIE_KEY_UID];
      String uName = cookies[COOKIE_KEY_UNAME];
      if (uid != null && uName != null) {
        UserModel.getInstance().addUser(uName, uid);
      }
    });
    return new Future.value(true);
  }
}
