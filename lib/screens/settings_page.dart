import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/theming/theme_provider.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theming/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void signOutUser(BuildContext context) {
    final AuthService firebaseAuthMethods = AuthService();
    firebaseAuthMethods.signOut(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color03,
      appBar: AppBar(
        backgroundColor: color03.withOpacity(0.1),
        elevation: 10,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.white,
          icon: const Icon(
              Icons.arrow_back_ios_new_rounded
          ),
        ),
        titleSpacing: 5,
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 25,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              signOutUser(context);
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
