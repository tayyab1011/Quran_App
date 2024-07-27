import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/helper/global_variables.dart';



class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {

    return  Container(
      height: 54,
      width: 286,
      decoration: BoxDecoration(

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
          Color(0xFFF7E683),
          Color(0xFFF7E683),
          Color(0xFFE8B55B),
        ],
          stops: [0.0, 0.5, 1.0],
        ),

          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
                textStyle:  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: GlobalVariables.buttonColor)),
          ),
        ],
      ),
    );
  }
}
