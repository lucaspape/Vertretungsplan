import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Home.dart';
import 'constants/Strings.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: White,
        primarySwatch: primaryBlack,
        textTheme: TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
            .apply(bodyColor: Colors.black),
        appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white, titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Black,
        primarySwatch: primaryWhite,
        textTheme: TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
            .apply(bodyColor: Colors.white),
        appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.white),backgroundColor: Colors.black, titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

const White = const Color(0xFFFFFFFF);
const Black = const Color(0xFF000000);

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const int _whitePrimaryValue = 0xFFFFFFFF;
