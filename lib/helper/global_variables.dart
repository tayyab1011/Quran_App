import 'package:flutter/material.dart';

class GlobalVariables{
  
  static const appGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
    Color.fromARGB(247, 230, 131, 1),
    Color.fromARGB(247, 230, 131, 1),
    Color.fromARGB(232, 181, 91, 1)
  ],stops:[0.5,1.0]
  );
  static Color inputColors = const Color.fromRGBO(0, 0, 0, 1);
  static Color textColor = const Color(0xFF5B4214);
  static  Color pinkColor = const Color.fromRGBO(251, 132, 124, 1);
  static Color buttonColor = const Color(0xFF5B4214);
  static Color iconColor = const Color(0xFF4D4D4D);
  static Color labelColor = const Color(0xFF6C6C6C);
}
