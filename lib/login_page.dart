import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'model/user_model.dart';

class LoginWidget extends StatelessWidget {
  static const String LOGIN_WEB_PAGE_URL =
      "https://bbs.nga.cn/nuke.php?__lib=login&__act=account&login";

  static const String COOKIE_KEY_UID = "ngaPassportUid";

  static const String COOKIE_KEY_UNAME = "ngaPassportUrlencodedUname";

  static const String COOKIE_KEY_CID = "ngaPassportCid";

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
            child: Text('Waiting...'),
          ),
        ), //设置初始化界面
      ),
      onWillPop: () => _parseCookie(),
    );
  }

  Future<bool> _parseCookie() {
    FlutterWebviewPlugin plugin = new FlutterWebviewPlugin();
    plugin.getCookies().then((Map<String, String> cookies) {
      // key 会莫名其妙首尾带空格
      String uid;
      String uName;
      String cid;
      for (String key in cookies.keys) {
        print("$key : ${cookies[key]}");
        if (key.trim() == COOKIE_KEY_UID) {
          uid = cookies[key];
        } else if (key.trim() == COOKIE_KEY_UNAME) {
          uName = cookies[key];
        } else if (key.trim() == COOKIE_KEY_CID) {
          cid = cookies[key];
        }
      }
      if (uid != null && uName != null && cid != null) {
        UserModel.getInstance().addUser(uName, uid, cid);
      }
    });
    return new Future.value(true);
  }
}
