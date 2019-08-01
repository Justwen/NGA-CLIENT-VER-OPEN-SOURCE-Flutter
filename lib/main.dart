import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'repository/board_repository.dart';
import 'home_page.dart';

import 'res/app_strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      locale: Locale('zh'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate,
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
      home: HomePage(),
    );
  }

  @override
  void initState() {
    setLocalizedSimpleValues(AppStrings.localizedSimpleValues);
    super.initState();
    BoardManager.getInstance();
  }


  ThemeData getThemeData() {
    return ThemeData(primarySwatch: Colors.green);
  }

}
