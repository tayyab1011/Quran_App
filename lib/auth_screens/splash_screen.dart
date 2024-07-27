import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/auth_screens/onboarding_screen.dart';
import 'dart:async';
import 'package:quran_app/home_screens/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    whereToGO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFFF7E683),
              Color(0xFFF7E683),
              Color(0xFFE8B55B),
            ],
            stops: [0.0, 0.5, 1.0], // Adjust the stops if necessary
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  'assets/images/Logo.svg',
                  width: 232,
                  height: 186.97,
                ),
                const SizedBox(
                  height: 70,
                ),
                SvgPicture.asset(
                  'assets/images/splash_logo.svg',
                  width: 409,
                  height: 353,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void whereToGO() async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    Timer(const Duration(seconds: 3), () {
      if (userId != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      }
    });
  }
}
