import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildOTPTextFields(TextEditingController controller, BuildContext context) {
  return SizedBox(
    width: 50,
    height: 80,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        counterText: "", // This hides the counter text
      ),
      style: GoogleFonts.roboto(fontSize: 24.0, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
    ),
  );
}