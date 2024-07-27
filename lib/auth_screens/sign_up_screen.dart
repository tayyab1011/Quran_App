import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/login_screen.dart';
import 'package:quran_app/models/signupModel.dart';
import 'package:quran_app/widgets/custom_toast.dart';

import '../helper/global_variables.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  SignUpModels signUpModels = SignUpModels();
  bool _obsecureText = true;
  bool _isLoading = false;

  signup() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/signup');

    var body = {
      "email": emailController.text,
      "password": passController.text,
      "last_name": lNameController.text,
      "first_name": fNameController.text,
      "account_type": "SignupWithApp",
      "one_signal_id": "123456"
    };
    print("Body: $body");
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      signUpModels = signUpModelsFromJson(resBody);
      print(resBody);
    } else {
      print(res.reasonPhrase);
      signUpModels = signUpModelsFromJson(resBody);
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
              Text(
                "Sign Up",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: GlobalVariables.textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 35,
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
                        "First Name",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: fNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your First Name ';
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            prefixIcon:  Icon(
                              Icons.person,
                              color: GlobalVariables.iconColor,
                            ),

                            hintText: 'First Name',
                            hintStyle:  TextStyle(
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
                        "Last Name",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: lNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last Name ';
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            prefixIcon:  Icon(
                              Icons.person,
                              color: GlobalVariables.iconColor,
                            ),

                            hintText: 'Last Name',
                            hintStyle:  TextStyle(
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
                            prefixIcon:  Icon(
                              Icons.email,
                              color: GlobalVariables.iconColor,
                            ),

                            hintText: 'Email',
                            hintStyle:  TextStyle(
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
                        controller: passController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password ';
                          } else if (value.length < 6) {
                            return 'Please enter 6-digits Password';
                          }
                          return null;
                        },
                        obscureText: _obsecureText,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            prefixIcon:  Icon(
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
                            hintStyle:  TextStyle(
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
                                    color: Colors.grey.withOpacity(0.25))),

                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              GestureDetector(
                onTap: () async {
                  if (emailController.text.isNotEmpty &&
                      passController.text.isNotEmpty &&
                      lNameController.text.isNotEmpty &&
                      fNameController.text.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    print(emailController.text);
                    print(passController.text);
                    print(lNameController.text);
                    print(fNameController.text);

                    await signup();
                    setState(() {
                      _isLoading = false;
                    });
                    if (signUpModels.status == "success") {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                      CustomToast.showToast(
                        message: 'SignUp Successfully',
                      );
                    } else {
                      CustomToast.showToast(
                        message: '${signUpModels.message}',
                        
                      );
                       setState(() {
                        _isLoading = false;
                      });
                    }
                  }else{
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
                      'SIGNUP',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: GlobalVariables.buttonColor)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
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
                            builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        'Login',
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
