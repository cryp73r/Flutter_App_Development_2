import 'package:flutter/material.dart';
import 'package:online_class_schedule/src/ui/detailScreen.dart';
import 'package:online_class_schedule/src/ui/startScreen.dart';

class UI extends StatelessWidget {
  const UI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OCS",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: Colors.black,
        backgroundColor: Colors.black,
        indicatorColor: Color(0xff0e1d36),
        buttonColor: Color(0xff3B3B3B),
        hintColor: Color(0xff280C0B),
        highlightColor: Color(0xff372901),
        hoverColor: Color(0xff3a3a3b),
        focusColor: Color(0xff0b2512),
        disabledColor: Colors.grey,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.white,
        ),
        cardColor: Color(0xFF151515),
        canvasColor: Colors.black,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: ColorScheme.dark(),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StartScreen(),
    );
  }
}

