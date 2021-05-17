import 'package:alexa_app/services/Users.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}



class _LoadingState extends State<Loading> {
  String token;
  final LocalStorage storage = LocalStorage("ava");
  void setupUser() async{
    CurrentUser user = CurrentUser();
    await user.get_user_data(storage);
    await user.get_playlist(storage);
    await user.get_tasks(storage);
    await user.get_mails(storage);
    Navigator.pushReplacementNamed(context, "/user",arguments:user);
  }


  @override
  void initState() {
    super.initState();
    setupUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Loading")),
    );
  }
}
