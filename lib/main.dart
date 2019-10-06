import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/redux/user/user_middleware.dart';
import 'package:redux/redux.dart';

import 'home_page.dart';
import 'redux/app_reducer.dart';
import 'res/app_strings.dart';

void main() {
  final store = Store<AppState>(reducer,
      initialState: AppState.initial(), middleware: [UserMiddleware()]);

  runApp(new ReduxApp(store));
}

class ReduxApp extends StatelessWidget {
  static Store<AppState> store;

  ReduxApp(Store store) {
    ReduxApp.store = store;
    setLocalizedSimpleValues(AppStrings.localizedSimpleValues);
    //UserModel.getInstance();
    ReduxApp.store.dispatch(UserInitAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        locale: Locale('zh'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CustomLocalizations.delegate,
        ],
        supportedLocales: CustomLocalizations.supportedLocales,
        home: HomePage(),
      ),
    );
  }
}
