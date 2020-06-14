import 'package:flutter/material.dart';
import 'package:s_app/create.dart';
import 'package:s_app/home.dart';
import 'package:s_app/reset.dart';
import 'package:s_app/signin.dart';
import 'package:s_app/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S-App v1.0-Alpha',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/signin': (_) => new SigninPage(),
        '/create': (_) => new CreatePage(),
        '/home': (_) => new HomePage(),
        '/reset': (_) => new ResetPage(),
      },
      debugShowCheckedModeBanner: true,
    );
  }
}