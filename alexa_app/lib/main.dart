import 'package:alexa_app/screens/Add_user.dart';
import 'package:alexa_app/screens/Loading.dart';
import 'package:alexa_app/screens/LoadingAdmin.dart';
import 'package:alexa_app/screens/User_welcome_page.dart';
import 'package:flutter/material.dart';
import "package:alexa_app/screens/Login_screen.dart";
import "package:alexa_app/screens/Admin_welcome_page.dart";
import "package:alexa_app/screens/Schedule.dart";
import "package:alexa_app/screens/Playlist.dart";
import "package:alexa_app/screens/Mail.dart";

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
        "/admin": (context) => Admin_welcome_page(),
        "/user": (context) => UserWelcomePage(),
        "/adduser": (context) => AddUser(),
        "/schedule": (context) => Schedule(),
        "/playlist" : (context) => Playlist(),
        "/mails": (context) => Mailing(),
        "/loading": (context) => Loading(),
        "/loading_admin": (context) => LoadingAdmin(),
      },
    );
  }
}