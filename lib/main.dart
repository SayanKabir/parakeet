import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parakeet/screens/otp_screen.dart';
import 'package:parakeet/screens/signin_screen.dart';
import 'package:parakeet/services/auth_gate.dart';
import 'package:parakeet/theming/theme_provider.dart';
import 'package:parakeet/theming/themes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/enter_user_details_page.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyThemes.MyLightTheme,
      darkTheme: MyThemes.MyDarkTheme,
      // routes: {
      //   '/signin_page': (context) => SignInScreen(),
      //   '/otp_page': (context) => const OTPScreen(),
      // },
      home: const AuthGate(),
      // home: EnterUserDetailsPage(),
      // home: OTPScreen(
      //   otpCodeReturnBack: (String otp) async {
      //     // Debugging code: print the OTP to the console
      //     print("Received OTP: $otp");
      //     // Simulate a short delay to mimic an asynchronous operation
      //     await Future.delayed(Duration(seconds: 1));
      //   },
      //   phoneNumber: '1234567890',
      // ),
      // home: SignInScreen(),
    );
  }
}
