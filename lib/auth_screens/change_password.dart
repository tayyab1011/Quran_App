import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/login_screen.dart';
import 'package:quran_app/models/reset_models.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import '../helper/global_variables.dart';
import 'package:http/http.dart' as http;


class ChangePassword extends StatefulWidget {
  final String? email;
  final String? code;
  const ChangePassword({super.key, this.email, this.code});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  ResetModels resetModels = ResetModels();
  bool _isLoading = false;
  bool _obsecureText = true;
  bool _obsecureText2 = true;

 resetPassword() async{
  var headersList = {
 
 'Accept': 'application/json',
 'Content-Type': 'application/json' 
};
var url = Uri.parse('https://mecca.eigix.net/api/modify_password');

var body = {
    "email":widget.email,
    "otp":widget.code,
    "password":passController.text,
    "confirm_password":confirmController.text
};

var req = http.Request('POST', url);
req.headers.addAll(headersList);
req.body = json.encode(body);


var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode == 200 ) {
   resetModels = resetModelsFromJson(resBody);
  print(resBody);
}
else {
  resetModels = resetModelsFromJson(resBody);
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
                    "Change Password",
                    style: GoogleFonts.poppins(
                        textStyle:  TextStyle(
                            color: GlobalVariables.textColor,
                            fontSize: 28, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please create a new password",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.grey,
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          height: 4,
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
,
                        const SizedBox(
                          height: 28,
                        ),
                        Text(
                          "Confirm Password",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                         TextFormField(
                        obscureText: _obsecureText2,
                        controller: confirmController,
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
                                    _obsecureText2 = !_obsecureText2;
                                  });
                                },
                                icon: _obsecureText2
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            hintText: 'Confirm Password',
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

                  const SizedBox(
                    height: 43,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(passController.text.isNotEmpty&& confirmController.text.isNotEmpty){
                        if(passController.text == confirmController.text){
                        setState(() {
                          _isLoading = true;
                        });
                        print(passController.text);
                        print(confirmController.text);
                      
                      await resetPassword();
                      if(resetModels.status=='success'){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                         CustomToast.showToast(message: 'Password changed Successfuly');
                          setState(() {
                        _isLoading = false;
                      });
                      }
                      else{
                        CustomToast.showToast(message:"${ resetModels.message}");
                        setState(() {
                        _isLoading = false;
                      });
                      }
                      }
                      else{
                        CustomToast.showToast(message: 'Password do not match');

                      }
                      }
                      else {
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
                              'RESET PASSWORD',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: GlobalVariables.buttonColor)),
                            ),
                    ),
                  ),
                  ),


                ],
              ),
            ),
          )),
    );
  }
}
