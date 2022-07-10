// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildDarkTheme1(),
        home: HomePage());
  }
}

ThemeData buildDarkTheme1() => ThemeData(
    primaryColorDark: Colors.black,
    //cardColor: Color.fromRGBO(12, 21, 56, 1),
    cardColor: Color.fromRGBO(12, 25, 69, 1),
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue, foregroundColor: Colors.white),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blue),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        headline1: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        headline2: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue),
        button: TextStyle(color: Colors.white, fontSize: 16)));
