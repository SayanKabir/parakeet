import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/components/my_button.dart';
import 'package:parakeet/screens/otp_screen.dart';
import 'package:parakeet/utility_functions/show_snackbar.dart';
import '../services/auth_service.dart';
import '../theming/colors.dart';
import 'otp_bottom_sheet.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String countryCode = "+91";
  String phoneNumber = "";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FocusNode keyboardFocusNode = FocusNode();
  bool isLoading = false;

  void changeLoadingState(bool newState) {
    setState(() {
      isLoading = newState;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  bool validatePhoneNumber(String phoneNumber) {
    return (phoneNumber.isNotEmpty && phoneNumber.length == 10);
  }

  void sendOTP(BuildContext context) {

    if(!validatePhoneNumber(phoneController.text)) {
      showSnackBar(context, 'Invalid Phone Number');
      return;
    }

    setState(() {
      isLoading = true;
      keyboardFocusNode.unfocus();
    });

    phoneNumber = countryCode + phoneController.text;
    final AuthService firebaseAuthMethods = AuthService();
    firebaseAuthMethods.phoneSignIn(context, phoneNumber, () => stopLoading);
  }

  @override
  void initState(){
    super.initState();
    isLoading = false;
  }

  @override
  void dispose(){
    super.dispose();
    phoneController.dispose();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topCenter,
                colors: [
                  color03,
                  color08,
                ],
              ),
            ),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color(0xFF91C98F), // Light green
            //       Color(0xFF2BB2A8), // Teal
            //       Color(0xFF0585A1), // Darker teal
            //       Color(0xFF444A5A), // Gray
            //     ],
            //     stops: [0.1, 0.4, 0.7, 1.0],
            //   ),
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //LOGO AND WELCOME TEXT
                Column(
                  children: [
                    //LOGO ICON
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Image.asset('assets/app-logo-final-bg-removed.png'),
                      ),
                    ),

                    //WELCOME TO PARAKEET
                    Text(
                      'Login to Parakeet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80,),

                //INPUT BOX
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // COUNTRY CODE AND PHONE NUMBER ROW
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: keyboardFocusNode,
                                controller: phoneController,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      countryCode,
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Phone Number',
                                  hintStyle: GoogleFonts.manrope(
                                    color: Colors.white54,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                cursorColor: Colors.white70,
                                cursorWidth: 1.5,
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // SEND OTP BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AnimatedSwitcher(
                          transitionBuilder: (Widget child, Animation<double> animation){
                            return ScaleTransition(scale: animation, child: child,);
                          },
                          duration: const Duration(milliseconds: 250),
                          child: isLoading
                              ? Container(
                            key: const ValueKey<int>(1),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: color03,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.5,
                            ),
                          )
                              : SizedBox(
                                height: 50,
                                width: 130,
                                child: MyButton(
                                  key: const ValueKey<int>(2),
                                  text: 'Send OTP',
                                  onPressed: (){
                                    sendOTP(context);
                                  },
                                  ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                //PRIVACY POLICY
                GestureDetector(
                  onTap: (){
                    //open privacy policy url
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Privacy Policy',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color1,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
