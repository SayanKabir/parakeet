import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parakeet/screens/enter_user_details_page.dart';
import 'package:parakeet/screens/home_screen.dart';
import 'package:parakeet/services/firestore_service.dart';
import '../screens/otp_screen.dart';
import '../utility_functions/show_snackbar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //GET CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // PHONE SIGN IN
  Future<void> phoneSignIn(BuildContext context, String phoneNumber, VoidCallback stopSigninScreenLoading) async {
    final FirestoreService firestore = FirestoreService();
    if (kIsWeb) {
      try {
        ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OTPScreen(
              stopSigninScreenLoading: stopSigninScreenLoading,
              otpCodeReturnBack: (String otp) async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: result.verificationId,
                    smsCode: otp,
                  );
                  UserCredential userCredential = await _auth.signInWithCredential(credential);
                  if (userCredential.additionalUserInfo!.isNewUser) {
                    // New user
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => EnterUserDetailsPage(userCredential: userCredential,)),
                    );
                  } else {
                    // Existing user
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => HomePage()),
                    );
                    showSnackBar(context, "Welcome back!");
                    // Navigate to a different screen if necessary
                  }
                } catch (e) {
                  showSnackBar(context, e.toString());
                }
              },
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential userCredential = await _auth.signInWithCredential(
                credential);
            if (userCredential.additionalUserInfo!.isNewUser) {
              // New user
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => EnterUserDetailsPage(userCredential: userCredential,)),
              );
            } else {
              // Existing user
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => HomePage()),
              );
              showSnackBar(context, "Welcome back!");
              // Navigate to a different screen if necessary
            }
          } catch (e) {
            showSnackBar(context, e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context, e.message!);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  OTPScreen(
                    stopSigninScreenLoading: stopSigninScreenLoading,
                    otpCodeReturnBack: (String otp) async {
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider
                            .credential(
                          verificationId: verificationId,
                          smsCode: otp,
                        );
                        UserCredential userCredential = await _auth
                            .signInWithCredential(credential);
                        if (userCredential.additionalUserInfo!.isNewUser) {
                          // New user
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (context) => EnterUserDetailsPage(userCredential: userCredential,)),
                          );
                        } else {
                          // Existing user
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (context) => HomePage()),
                          );
                          showSnackBar(context, "Welcome back!");
                          // Navigate to a different screen if necessary
                        }
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }
                    },
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        showSnackBar(context, "No user is currently signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showSnackBar(context, 'Please re-authenticate and try again.');
        // Implement re-authentication flow
      } else {
        showSnackBar(context, e.message!);
      }
    }
  }
}
