import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quran_app/models/forgot_models.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_button.dart';
import '../helper/global_variables.dart';
import 'change_password.dart';

class ResetPassword extends StatefulWidget {
  final String? code;
  final String? email;
  const ResetPassword({super.key, this.code,  this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ForgotModels forgotModels = ForgotModels();
  late Timer _timer;
  int _start = 120;
TextEditingController  otp = TextEditingController();

forgotPassword() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/forgot_password');

    var body = {"email": widget.email};

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
  void initState() {
    super.initState();
    startTimer();
  }

  void resetTimer() {
    setState(() {
      forgotPassword();
      _start = 120;
      _timer.cancel(); // Cancel the current timer
      startTimer();
      CustomToast.showToast(message: 'OTP sent to your Gmail');
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_start ~/ 60).toString().padLeft(2, '0');
    String seconds = (_start % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot Password?",
                  style: GoogleFonts.poppins(
                    textStyle:  TextStyle(
                        color: GlobalVariables.textColor,
                        fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 12),
                  child: Text(
                    "We have sent a 4-digit verification code to your email address. Please enter it below.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$minutes:$seconds',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 60,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: PinCodeTextField(
                    controller: otp,
                    pastedTextStyle: const TextStyle(color: Colors.black),
                    pinTheme: PinTheme(
                      
                      shape: PinCodeFieldShape.underline,
                      selectedColor: Colors.grey,
                      selectedFillColor: GlobalVariables.inputColors,
                      inactiveColor: Colors.grey,
                      activeColor: Colors.grey,
                      fieldHeight: 60,
                      fieldWidth: 10,
                    ),
                    keyboardType: TextInputType.phone,
                    appContext: context,
                    length: 4,
                  ),
                ),
                const SizedBox(height: 25),
              
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    textStyle:
                        const TextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: resetTimer,
                  child: Text(
                    'Resend Verification Code',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    print("Otp from Forget: ${widget.code}");
                    print("Otp from Text field: ${otp.text}");
                    if(widget.code  == otp.text){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePassword(
                      email: widget.email,
                      code: widget.code,
                    )));
                    }else{
                      CustomToast.showToast(message: "Invalid OTP");

                    }
                  },
                  child: const CustomButton(
                    text: "NEXT",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
