import 'package:flutter/material.dart';
import 'package:rohit_chat_app/Screens/Welcome/welcome_screen.dart';
import 'package:rohit_chat_app/Utils/colorConstant.dart' as ColorConstant;
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: ColorConstant.BACK_GROUND_COLOR,
      accentColor: Colors.cyan[600],
      // Define the default font family.
      fontFamily: 'Georgia',
      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
    ),
    home: WelcomeScreen(),
  ));
}
