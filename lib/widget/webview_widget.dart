import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart' as prefix1;
import 'package:nga_open_source/bloc/webview_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as prefix0;

class WebViewEx extends StatefulWidget {
  final String initialUrl;

  final String initialHtml;

  final bool useFlutterWebView;

  final WebViewBloc _webViewBloc = new WebViewBloc();

  final Map<String, Function> jsMap;

  WebViewEx({
    this.initialUrl,
    this.initialHtml,
    this.jsMap,
    this.useFlutterWebView = false,
  });

  @override
  State<StatefulWidget> createState() {
    return useFlutterWebView
        ? new _WebViewState()
        : new _WebViewScaffoldState();
  }

  String _getInitialUrl() {
    if (initialUrl != null) {
      return initialUrl;
    } else if (initialHtml != null) {
      return new Uri.dataFromString(initialHtml,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString();
    } else {
      return "";
    }
  }

  void loadUrl({String url, String html}) {
    String data = url;
    if (html != null) {
      data = new Uri.dataFromString(html,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
          .toString();
    }
    _webViewBloc.loadUrl(data);
  }
}

class _WebViewState extends State<WebViewEx> {
  WebViewController _webViewController;

  WebView _webView;

  Set<prefix0.JavascriptChannel> _getJavascriptMethods() {
    Set<prefix0.JavascriptChannel> jsSet = Set();
    widget.jsMap?.forEach((key, value) {
      jsSet.add(prefix0.JavascriptChannel(
          name: key,
          onMessageReceived: (prefix0.JavascriptMessage msg) {
            value(msg.message);
          }));
    });
    return jsSet;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget._webViewBloc.data,
        initialData: widget._getInitialUrl(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (_webView == null) {
            _webView = WebView(
              initialUrl: snapshot.data,
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
          } else {
            _webViewController?.loadUrl(snapshot.data);
          }
          return _webView;
        });
  }
}

class _WebViewGestureRecognizer extends OneSequenceGestureRecognizer {
  @override
  String get debugDescription => "webview";

  @override
  void didStopTrackingLastPointer(int pointer) {
  }

  @override
  void handleEvent(PointerEvent event) {
    print(event.toString());
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    print("addAllowedPointer");
    print(event.toString());
    super.addAllowedPointer(event);
  }
}

class _WebViewScaffoldState extends State<WebViewEx> {
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  FlutterWebviewPlugin _webViewPlugin;

  WebviewScaffold _webviewScaffold;

  @override
  Widget build(BuildContext context) {
    _webViewPlugin ??= new FlutterWebviewPlugin();
    _onStateChanged ??= _webViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.abortLoad) {
        canLaunch(state.url).then((value) {
          if (value) {
            launch(state.url);
          }
        });
      }
    });

    return StreamBuilder<String>(
        stream: widget._webViewBloc.data,
        initialData: widget._getInitialUrl(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (_webviewScaffold == null) {
            _webviewScaffold = WebviewScaffold(
              hidden: true,
              invalidUrlRegex: "",
              url: snapshot.data,
              withJavascript: true,
              javascriptChannels: _getJavascriptMethods(),
            );
          } else {
            _webViewPlugin ??= new FlutterWebviewPlugin();
            _webViewPlugin.reloadUrl(snapshot.data);
          }
          return _webviewScaffold;
        });
  }

  Set<prefix1.JavascriptChannel> _getJavascriptMethods() {
    Set<prefix1.JavascriptChannel> jsSet = Set();
    widget.jsMap?.forEach((key, value) {
      jsSet.add(prefix1.JavascriptChannel(
          name: key,
          onMessageReceived: (prefix1.JavascriptMessage msg) {
            value(msg.message);
          }));
    });
    return jsSet;
  }

  @override
  void dispose() {
    _onStateChanged?.cancel();
    _onStateChanged = null;
    super.dispose();
  }
}
