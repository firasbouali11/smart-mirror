import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class UserWelcomePage extends StatefulWidget {
  @override
  _UserWelcomePageState createState() => _UserWelcomePageState();
}

class _UserWelcomePageState extends State<UserWelcomePage> {
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
              Text("Firas Bouali",style: TextStyle(
                fontSize: 45,
                letterSpacing: 1.2
              ),),
              Container(
                padding: EdgeInsets.symmetric(vertical: 55,horizontal: 11),
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  color: Color(0x55ffffff),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                              onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                              icon: Icon(Icons.music_note,size: 90,color: Colors.black,),
                              label: Text(""),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          icon: Icon(Icons.menu_open,size: 90,color: Colors.black,),
                          label: Text(""),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            icon: Icon(Icons.wb_sunny_outlined,size: 90,color: Colors.black,),
                            label: Text(""),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          icon: Icon(Icons.mail_outline,size: 90,color: Colors.black,),
                          label: Text(""),
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
