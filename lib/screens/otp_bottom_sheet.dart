import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/components/my_button.dart';

import '../utility_functions/build_otp_textfields.dart';


class OTPBottomSheet extends StatelessWidget {
  final TextEditingController otpController;
  final VoidCallback onPressed;

  OTPBottomSheet({super.key, required this.otpController, required this.onPressed});

  List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            height: 5,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                //HEADING
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "One-Time Password",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                    ),
                ),
              ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return buildOTPTextFields(otpControllers[index], context);
                  }),
                ),
                const SizedBox(height: 16.0),

                //VERIFY BUTTON
                MyButton(
                  text: 'Verify',
                  onPressed: (){

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}