import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/auth_screens/sign_up_screen.dart';
import 'package:quran_app/models/profile_model.dart';
import 'package:quran_app/widgets/custom_toast.dart';
import 'package:quran_app/widgets/pink_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/global_variables.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confrimController = TextEditingController();
  bool _isLoading = false;
  bool _obsecureText = true;
  bool _obsecureText2 = true;
  bool _obsecureText3 = true;
  ProfileModels profileModels = ProfileModels();

  getProfile() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('userId');
    var headersList = {
    
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/users_customers_profile');

    var body = {"users_customers_id": "$userId"};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      profileModels = profileModelsFromJson(resBody);

      print(resBody);
    } else {
      print(res.reasonPhrase);
      profileModels = profileModelsFromJson(resBody);
    }
  }

  deleteAccount()async{
    var headersList = {
 'Accept': 'application/json',
 'Content-Type': 'application/json' 
};
var url = Uri.parse('https://mecca.eigix.net/api/delete_account');

var body = {
    "user_email":profileModels.data!.email,
    "delete_reason" : "test delete",
    "comments":"Hello"
};

var req = http.Request('POST', url);
req.headers.addAll(headersList);
req.body = json.encode(body);


var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {
 data2 =json.decode(resBody);
  print(resBody);
}
else {
  print(res.reasonPhrase);
}

  }
  var data2;

//Api call to change password
  changePassword() async {
    var headersList = {
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://mecca.eigix.net/api/change_password');

    var body = {
      "email": profileModels.data!.email,
      "old_password": oldController.text,
      "password": newController.text,
      "confirm_password": confrimController.text,
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    data = json.decode(resBody);


    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
var data;
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        // Custom height for the AppBar
        child: Stack(
          children: [
            AppBar(
              flexibleSpace: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFFF7E683),
                      Color(0xFFE8B55B),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Profile',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: GlobalVariables.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 0,
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Password",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Old Password",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    obscureText: _obsecureText,
                    controller: oldController,
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
                        hintText: 'Old Password',
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
                    "New Password",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    obscureText: _obsecureText2,
                    controller: newController,
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
                            icon: _obsecureText
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility)),
                        hintText: 'New Password',
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
                    "Confirm Password",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    obscureText: _obsecureText3,
                    controller: confrimController,
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
                                _obsecureText3 = !_obsecureText3;
                              });
                            },
                            icon: _obsecureText
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
              const SizedBox(
                height: 23,
              ),
              GestureDetector(
                onTap: () async {
                  if (oldController.text.isNotEmpty &&
                      newController.text.isNotEmpty &&
                      confrimController.text.isNotEmpty) {
                    if (newController.text == confrimController.text) {
                      setState(() {
                        _isLoading = true;
                      });
                      print(newController.text);
                      print(confrimController.text);

                      await changePassword();
                      if (data['status']== 'success') {
                        CustomToast.showToast(
                            message: 'Password changed Successfuly');
                        setState(() {
                          _isLoading = false;
                          oldController.clear();
                          newController.clear();
                          confrimController.clear();
                        });
                      } else {
                        CustomToast.showToast(
                            message: "${data['message']}");
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      CustomToast.showToast(message: 'Password do not match');
                    }
                  } else {
                    CustomToast.showToast(message: 'All fields are required');
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
                            'UPDATE',
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
                height: 23,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Delete Account?",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: GlobalVariables.textColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Are you sure you want to delete your account?',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                  onTap: () {
                                   Navigator.pop(context);
                                  },
                                  child: const CustomButton(
                                    text: 'NO',
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  await deleteAccount();
                                  if(data2['status']== 'success'){
                                
                                   CustomToast.showToast(message: data2['message']);
                                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SignUpScreen()));  

                                  }
                                  
                                },
                                child: const PinkButton(text: 'YES')),
                              const SizedBox(
                                height: 23,
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: const PinkButton(
                  text: "DELETE ACCOUNT",
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
