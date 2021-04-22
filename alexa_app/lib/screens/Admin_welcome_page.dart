import "package:flutter/material.dart";
import "package:alexa_app/services/Users.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Admin_welcome_page extends StatefulWidget {
  @override
  _Admin_welcome_pageState createState() => _Admin_welcome_pageState();
}

class _Admin_welcome_pageState extends State<Admin_welcome_page> {

  List<User> users = [
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
    User(name: "firas", password: "ezjfhkjzefhze", image: "lfjzklfjezkl"),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffC4C4C4),
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
        backgroundColor: Color(0xff760F83),
      ),
      body: SafeArea(
        child: Stack(
          children: [

            ListView.builder(
              padding: EdgeInsets.only(top: 100),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                User instance = users[index];
                return CardWidget(user:instance);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 20, horizontal: size.width * 0.2),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 2),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "    search user...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {

  final User user;
  CardWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical:10,horizontal: 30),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(user.name.substring(0,1)),
                    backgroundColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(user.name),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(Icons.delete,size: 40,),
              onTap: (){print("deleted");},
            )
          ],
        ),
      ),
    );
  }
}
