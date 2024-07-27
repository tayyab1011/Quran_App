import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFF7E683),
                Color(0xFFF7E683),
                Color(0xFFE8B55B),
              ],
            stops: [0.0, 0.5, 1.0],
          )
        ) ,
        child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  SvgPicture.asset(
                    'assets/images/board.svg',
                    width: 343,
                    height: 270,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Search from our enormous collection of Islamic books, authors and read them.',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 23 )
                      ),),
                  ),


                  const Spacer(),
                  GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen())),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 38),
                        child: SvgPicture.asset(
                          'assets/images/call_back.svg', height: 90, width: 90,),
                      )
                  )
                ],
              ),
            )),
      ),
    );
  }

}
