import 'package:aquahealthy/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:aquahealthy/login.dart';
void main() => runApp(new AquaApp());

class AquaApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SplashScreen(),
      theme: new ThemeData(
        primarySwatch: Colors.blue
      )
    );
  }

}