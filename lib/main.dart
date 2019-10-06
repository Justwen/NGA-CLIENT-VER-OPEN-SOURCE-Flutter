import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nga_open_source/redux/app_state.dart';
import 'package:nga_open_source/redux/user/user_action.dart';
import 'package:nga_open_source/redux/user/user_middleware.dart';
import 'package:nga_open_source/utils/sp_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'home_page.dart';
import 'model/user_model.dart';
import 'redux/app_reducer.dart';
import 'res/app_strings.dart';

void main() {
  final store = Store<AppState>(reducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware,UserMiddleware()]);
  PreferenceUtils.init().then((sp) {
    runApp(new ReduxApp(store));
  });

}

class ReduxApp extends StatelessWidget {
  static Store<AppState> store;

  ReduxApp(Store store) {
    print(1);
    ReduxApp.store = store;
    setLocalizedSimpleValues(AppStrings.localizedSimpleValues);
    _initCommonComponent();
    print(4);
    UserModel.getInstance();
  //  ReduxApp.store.dispatch(UserInitAction.action);
  }

  void _initCommonComponent()  {
//    PreferenceUtils.init().then((sp) {
//      print(123);
      ReduxApp.store.dispatch(UserInitAction());
//    });
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
