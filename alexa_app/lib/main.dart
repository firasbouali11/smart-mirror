import 'package:flutter/material.dart';
import "package:alexa_app/screens/Login_screen.dart";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alexa App',
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
      },
    );
  }
}