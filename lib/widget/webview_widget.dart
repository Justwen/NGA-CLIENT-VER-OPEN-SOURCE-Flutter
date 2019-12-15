import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewEx extends StatelessWidget {
  final String initialHtml;

  final Map<String, Function> jsMap;

  WebViewController _webViewController;

  String _url;

  WebViewEx({
    this.initialHtml,
    this.jsMap,
  }) {
    _url = _getInitialUrl();
  }

  String _getInitialUrl() {
    if (initialHtml != null) {
      return new Uri.dataFromString(initialHtml,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString();
    } else {
      return "";
    }
  }

  void loadHtml(String html) {
    String url = "";
    if (html != null) {
      url = new Uri.dataFromString(html,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString();
    }
    if (url != _url) {
      _url = url;
      _webViewController?.loadUrl(_url);
    }
  }

  Set<JavascriptChannel> _getJavascriptMethods() {
    Set<JavascriptChannel> jsSet = Set();
    jsMap?.forEach((key, value) {
      jsSet.add(JavascriptChannel(
          name: key,
          onMessageReceived: (JavascriptMessage msg) {
            value(msg.message);
          }));
    });
    return jsSet;
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: _url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) => _webViewController = controller,
      navigationDelegate: (navigation) {
        canLaunch(navigation.url).then((value) {
          if (value) {
            launch(navigation.url);
          }
        });
        return NavigationDecision.prevent;
      },
      javascriptChannels: _getJavascriptMethods(),
      gestureRecognizers: [
        Factory(() {
          return _WebViewGestureRecognizer();
        }),
      ].toSet(), //GestureDetector,
    );
  }
}

class _WebViewGestureRecognizer extends OneSequenceGestureRecognizer {
  @override
  String get debugDescription => "webview";

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {}

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
  }
}
