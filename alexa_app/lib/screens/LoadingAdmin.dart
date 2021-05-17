import 'package:alexa_app/services/Users.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class LoadingAdmin extends StatefulWidget {
  const LoadingAdmin({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}



class _LoadingState extends State<LoadingAdmin> {
  String token;
  final LocalStorage storage = LocalStorage("ava");
  void setupUser() async{
    Admin admin = Admin();
    await admin.get_users(storage);
    Navigator.pushReplacementNamed(context, "/admin",arguments:admin);
  }


  @override
  void initState() {
    super.initState();
    setupUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("LoadingAdmin")),
    );
  }
}
