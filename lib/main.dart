import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nga_open_source/redux/app_redux.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/board/board_action.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/utils/utils.dart';

import 'page/home_page.dart';
import 'res/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initialize();
  runApp(ReduxApp());
}

void _initialize() {
  setLocalizedSimpleValues(AppStrings.localizedSimpleValues);
  AppRedux.dispatch(UserInitAction());
  AppRedux.dispatch(BoardInitAction());
}

class ReduxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContextUtils.buildContext = context;
    return StoreProvider<AppState>(
      store: AppRedux.store,
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        locale: Locale('zh',""),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CustomLocalizations.delegate,
        ],
        // supportedLocales: [
        //   Locale('zh', ''), // English, no country code
        // ],
        home: HomePage(),
      ),
    );
  }
}
