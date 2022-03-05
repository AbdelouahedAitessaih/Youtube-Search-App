import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_search_app/injection_container.dart';
import 'package:youtube_search_app/ui/search/search_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  initKiwi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
      ),
      home: SearchPage(),
    );
  }
}