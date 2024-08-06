import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/components/my_button.dart';
import 'package:parakeet/screens/enter_user_details_page.dart';

import '../theming/colors.dart';
import '../utility_functions/build_otp_textfields.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback stopSigninScreenLoading;
  final Future<void> Function(String otp) otpCodeReturnBack;

  OTPScreen(
      {super.key, required this.phoneNumber, required this.otpCodeReturnBack, required this.stopSigninScreenLoading});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  void resendOTP(BuildContext context) {
    //
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.stopSigninScreenLoading();
    });
    isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color03,
      appBar: AppBar(
        backgroundColor: color03.withOpacity(0.1),
        // elevation: 10,
        leading: IconButton(
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        titleSpacing: 5,
        // title: Text(
        //   'Phone Verification',
        //   style: GoogleFonts.plusJakartaSans(
        //     fontSize: 25,
        //     color: Colors.white.withOpacity(0.9),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                //Headings
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      //Heading
                      Text(
                        'Confirm Your Number',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 30,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
        
                      //Enter code text
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          'Enter the code sent to ${widget.phoneNumber}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                //OTP Textfields
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return buildOTPTextFields(otpControllers[index], context);
                    }),
                  ),
                ),
        
                const SizedBox(
                  height: 30,
                ),
        
                //Resend code button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t get a code ? ',
                      ),
                      GestureDetector(
                        onTap: () {
                          resendOTP(context);
                        },
                        child: Text('Send again'),
                      ),
                    ],
                  ),
                ),
        
                //Animated Verify Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AnimatedSwitcher(
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    duration: const Duration(milliseconds: 250),
                    child: isLoading
                        ? Container(
                            key: const ValueKey<int>(1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.5,
                            ),
                          )
                        : SizedBox(
                            height: 50,
                            width: 100,
                            child: MyButton(
                              backgroundColor: Colors.white30,
                              key: const ValueKey<int>(2),
                              text: 'Verify',
                              onPressed: () async {
                                // otpCodeReturnBack =  otpControllers.map((controller) => controller.text).join();
                                // verifyOTPFunction;
                                // // Navigator.push(
                                // //     context,
                                // //     MaterialPageRoute(builder: (context) => EnterUserDetailsPage()),
                                // // );
                                setState(() {
                                  isLoading = true;
                                });
                                String otp = otpControllers
                                    .map((controller) => controller.text)
                                    .join();
                                await widget.otpCodeReturnBack(otp).then(
                                      (value) => setState(() {
                                        isLoading = false;

                                      }),
                                    );
                              },
                            ),
                          ),
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
