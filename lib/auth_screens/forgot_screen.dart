import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/reset_password.dart';
import 'package:quran_app/helper/global_variables.dart';
import 'package:quran_app/models/forgot_models.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import '../widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController emailController = TextEditingController();
  ForgotModels forgotModels = ForgotModels();
  bool _isLoading = false;

  forgotPassword() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/forgot_password');

    var body = {"email": emailController.text};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      forgotModels = forgotModelsFromJson(resBody);
      print(resBody);
    } else {
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
              Text(
                "Forgot Password?",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: GlobalVariables.textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 5,
              ),
              SvgPicture.asset(
                'assets/images/forgot.svg',
                width: 108,
                height: 108,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 12),
                child: Text(
                  textAlign: TextAlign.center,
                  "Please enter your register email to reset password.",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(
                        height: 5,
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
                            hintText: 'Email Id',
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
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (emailController.text.isNotEmpty) {
                     setState(() {
                        _isLoading = true;
                      });
                    print(emailController.text);
                    await forgotPassword();
                    if (forgotModels.status == 'success') {
                      CustomToast.showToast(message: 'Code sent to your Gmail');
                       setState(() {
                        _isLoading = false;
                      });
                    } else {
                      CustomToast.showToast(message: "${forgotModels.message}");
                       setState(() {
                        _isLoading = false;
                      });
                      
                    }
                  } else {
                    CustomToast.showToast(
                      message: 'All fields are required',
                    );
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SvgPicture.asset(
                                'assets/images/Logo.svg',
                                width: 108.39,
                                height: 108,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Password reset Code Sent!",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  '4-Digit reset code has been sent to your email',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ResetPassword(
                                                  code: forgotModels.data?.otp.toString(),
                                                      email: emailController.text,
                                                )));
                                  },
                                  child: const CustomButton(
                                    text: 'OK',
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        );
                      });
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
                              'NEXT',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: GlobalVariables.buttonColor)),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
