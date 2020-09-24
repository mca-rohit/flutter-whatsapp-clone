import 'package:flutter/material.dart';
import 'package:rohit_chat_app/Screens/Login/login_signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.greenAccent,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/welcome.png"),
              SizedBox(
                height: 100,
              ),
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Accept Terms & Conditions",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => LoginSingUpScreen()), (
                      route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
