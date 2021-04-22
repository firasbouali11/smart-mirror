import 'package:alexa_app/screens/User_welcome_page.dart';
import 'package:flutter/material.dart';
import "package:alexa_app/screens/Login_screen.dart";
import "package:alexa_app/screens/Admin_welcome_page.dart";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alexa App',
      initialRoute: "/user",
      routes: {
        "/": (context) => Login(),
        "/admin": (context) => Admin_welcome_page(),
        "/user": (context) => UserWelcomePage(),
      },
    );
  }
}