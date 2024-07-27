import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/forgot_screen.dart';
import 'package:quran_app/auth_screens/sign_up_screen.dart';
import 'package:quran_app/helper/global_variables.dart';
import 'package:quran_app/home_screens/bottom_nav_bar.dart';
import 'package:quran_app/models/sign_in_models.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  SignInModels signInModels = SignInModels();
  bool _isLoading = false;

  signIn() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/signin');

    var body = {
      "email": emailController.text,
      "password": passController.text,
      "one_signal_id": "123456"
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      signInModels = signInModelsFromJson(resBody);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      if(signInModels.data !=null) {
        sharedPreferences.setString('userId', signInModels.data!.usersCustomersId.toString());
      }
      print(resBody);
    } else {
      signInModels = signInModelsFromJson(resBody);
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/Logo.svg',
                width: 146,
                height: 117,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                textAlign: TextAlign.center,
                "Welcome Back!",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
              ),
              Text(
                "Login",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: GlobalVariables.textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email  ';
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: GlobalVariables.iconColor,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: GlobalVariables.labelColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.25))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.25)))),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        obscureText: _obsecureText,
                        controller: passController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: GlobalVariables.iconColor,
                            ),
                            suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    _obsecureText = !_obsecureText;
                                  });
                                },
                                icon: _obsecureText
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: GlobalVariables.labelColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.25))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.25)))),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotScreen()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.titilliumWeb(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              GestureDetector(
                  onTap: () async {
                    if (emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      print(emailController.text);
                      print(passController.text);
                      await signIn();
                   
                      if (signInModels.status == 'success') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BottomNavBar()));
                        CustomToast.showToast(message: 'Login Successful');
                           setState(() {
                        _isLoading = false;
                      });
                      } else {
                        CustomToast.showToast(
                            message: '${signInModels.message}');
                              setState(() {
                        _isLoading = false;
                      });
                      }
                    } else {
                      CustomToast.showToast(
                        message: 'All fields are required',
                      );
                    }
                  },
                  child: Container(
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
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: GlobalVariables.textColor,
                            )
                          : Text(
                              'LOGIN',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: GlobalVariables.buttonColor)),
                            ),
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        textStyle: const TextStyle(
                            height: 1,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                      },
                      child: Text(
                        'SignUp',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      )),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
