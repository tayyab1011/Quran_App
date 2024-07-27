import 'package:flutter/material.dart';
import 'package:quran_app/helper/global_variables.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key, required this.hintText, required this.icon, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          hintStyle:  TextStyle(
              fontWeight: FontWeight.normal, color: GlobalVariables.labelColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.25))),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.25))),
        ));
  }
}
