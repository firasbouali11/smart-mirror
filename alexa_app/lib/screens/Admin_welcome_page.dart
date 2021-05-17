import "package:flutter/material.dart";
import "package:alexa_app/services/Users.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class Admin_welcome_page extends StatefulWidget {
  @override
  _Admin_welcome_pageState createState() => _Admin_welcome_pageState();
}

Admin admin;
LocalStorage storage = LocalStorage("ava");

class _Admin_welcome_pageState extends State<Admin_welcome_page> {

  List users=[];

  delete_user(){
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    admin = ModalRoute.of(context).settings.arguments;
    users = admin.users;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffC4C4C4),
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
        backgroundColor: Color(0xff760F83),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt,color: Colors.black,),
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.pushNamed(context, "/adduser",arguments: admin);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [

            ListView.builder(
              padding: EdgeInsets.only(top: 100),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                // User instance = users[index];
                return CardWidget(user:users[index],callback: delete_user,);
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

class CardWidget extends StatefulWidget {

  final Map<String,dynamic> user;
  void Function() callback;
  CardWidget({this.user,this.callback});


  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {


  @override
  Widget build(BuildContext context) {
    delete_user(int id) async{
      await admin.delete_user(id.toString(), storage);
      await admin.get_users(storage);
      widget.callback();
    }

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
                    backgroundImage: widget.user["image"]==null ? null: NetworkImage(widget.user["image"])   ,
                    child: widget.user["image"]==null ? Text(widget.user["username"]) : null,
                    backgroundColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(widget.user["username"]),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(Icons.delete,size: 40,),
              onTap: (){delete_user(widget.user["id"]);},
            )
          ],
        ),
      ),
    );
  }
}
