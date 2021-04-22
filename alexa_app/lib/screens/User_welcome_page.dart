import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class UserWelcomePage extends StatefulWidget {
  @override
  _UserWelcomePageState createState() => _UserWelcomePageState();
}

class _UserWelcomePageState extends State<UserWelcomePage> {
  bool ledoff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/woman.jpg"),
                radius: 80,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Firas Bouali",
                style: TextStyle(
                    fontSize: 45, letterSpacing: 1.2, color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                    color: Color(0x45ffffff),
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0, 2),
                                      blurRadius: 1.8)
                                ],
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  size: 90,
                                ),
                                Text(
                                  "Music",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0, 2),
                                    blurRadius: 1.8)
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Icon(
                                Icons.menu_open,
                                size: 90,
                              ),
                              Text(
                                "Tasks",
                                style: TextStyle(fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              ledoff = !ledoff;
                            });
                          } ,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0, 2),
                                        blurRadius: 1.8)
                                  ],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Icon(
                                    !ledoff
                                        ? Icons.wb_sunny_outlined
                                        : Icons.wb_sunny,
                                    size: 90,
                                  ),
                                  Text(
                                    "Led",
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0, 2),
                                    blurRadius: 1.8)
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Icon(
                                Icons.mail,
                                size: 90,
                              ),
                              Text(
                                "Mail",
                                style: TextStyle(fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
