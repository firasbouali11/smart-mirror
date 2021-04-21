import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(45,78,45,50),
                child: Container(
                  width: size.width,
                  height: size.height/1.4,
                  decoration: BoxDecoration(
                      color: Color(0x45ffffff),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)
                      ),
                  // padding: EdgeInsets.,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.05, bottom: 10),
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 140,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                        child: Theme(
                          data: ThemeData(primaryColor: Colors.white),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box,color: Colors.white,),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              hintText: "Mirror ID",
                              hintStyle: TextStyle(color: Colors.white),

                            ),
                          ),
                        ),
                      ),  Container(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                        child: Theme(
                          data: ThemeData(primaryColor: Colors.white),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,color: Colors.white,),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                      ),  Container(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                        child: Theme(
                          data: ThemeData(primaryColor: Colors.white),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText:true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,color: Colors.white,),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Login"),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text("Because life has never been better",style: TextStyle(
                      color: Colors.white
                    ),),
                    SizedBox(height: 10,),
                    Container(
                      width: size.width/2,
                      height: 10,
                      color: Colors.white,
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
