import 'package:alexa_app/services/Users.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";
import 'package:localstorage/localstorage.dart';


class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

Admin admin;

class _AddUserState extends State<AddUser> {
  File image;
  String username;
  String password;
  String mirror;
  final ImagePicker picker = ImagePicker();
  final LocalStorage storage = LocalStorage("ava");

  getimages() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage.path);
    });
    print(image.uri);
  }

  create_user() async{
    await admin.create_user(username, "alaa@gmail.com", password, mirror, image, storage);
    await admin.get_users(storage);
    Navigator.pop(context);
  }



  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    admin = ModalRoute.of(context).settings.arguments;
    print(admin);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Add User"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(45, 78, 45, 50),
              child: Container(
                width: size.width,
                height: size.height / 1.4,
                decoration: BoxDecoration(
                    color: Color(0x45ffffff),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                // padding: EdgeInsets.,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.05, bottom: 10),
                        child: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 150,
                        )),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                      child: Theme(
                        data: ThemeData(primaryColor: Colors.white),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (e){
                            setState(() {
                              mirror = e.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.account_box,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Mirror ID",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                      child: Theme(
                        data: ThemeData(primaryColor: Colors.white),
                        child: TextField(
                          onChanged: (e){
                            setState(() {
                              username = e.toLowerCase();
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                      child: Theme(
                        data: ThemeData(primaryColor: Colors.white),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (e){
                            setState(() {
                              password=e.toLowerCase();
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(
                      onPressed: getimages,
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                              size: 50,
                            ),
                            Text("Upload pictures",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: create_user,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Add"),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: size.width / 2,
                    height: 10,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
