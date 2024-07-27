import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/helper/global_variables.dart';

class PinkButton extends StatelessWidget {
  final String text;
  const PinkButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 286,
      decoration: BoxDecoration(
        color: GlobalVariables.pinkColor,

          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          )
        ],
      ),
    );
  }
}
