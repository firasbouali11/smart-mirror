import "package:flutter/material.dart";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ("Alexa App"),
              style: TextStyle(fontSize: 45, color: Colors.red[300]),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
