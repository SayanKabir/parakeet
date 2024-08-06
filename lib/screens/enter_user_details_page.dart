import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/components/my_textfield.dart';
import 'package:parakeet/services/firestore_service.dart';
import 'package:parakeet/utility_functions/show_snackbar.dart';

import '../components/my_button.dart';
import '../models/my_user.dart';
import '../theming/colors.dart';

class EnterUserDetailsPage extends StatefulWidget {
  final UserCredential userCredential;
  const EnterUserDetailsPage({super.key, required this.userCredential});

  @override
  State<EnterUserDetailsPage> createState() => _EnterUserDetailsPageState();
}

class _EnterUserDetailsPageState extends State<EnterUserDetailsPage> {

  final nicknameController = TextEditingController();
  final bioController = TextEditingController();

  bool isLoading = false;

  void createNewUser() async {
    setState(() {
      isLoading = true;
    });
    final FirestoreService _firestore = FirestoreService();
    final String nickname = nicknameController.text.trim();
    final String bio = bioController.text.trim();
    if(nickname.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Please enter a display name for your profile');
      return;
    }
    final newUser = MyUser(
      id: widget.userCredential.user!.uid,
      phoneNumber: widget.userCredential.user!.phoneNumber ?? 'No phone number',
      nickname: nickname,
      bio: bio,
      photoUrl: '',
      friends: [],
      createdAt: Timestamp.now(),
    );
    _firestore.createNewUser(newUser, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        //   'About You',
        //   style: GoogleFonts.plusJakartaSans(
        //     fontSize: 25,
        //     color: Colors.white.withOpacity(0.9),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
        
                //Heading
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Add Your Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
        
                //Avatar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Avatar with border
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white30, // border color
                          width: 4.0, // border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 56, // Adjust the radius to fit inside the border
                        backgroundColor: Colors.white70,
                        backgroundImage: AssetImage('assets/avatars/Number=1.png'), // Set the image here
                      ),
                    ),
                    // Edit Icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white60,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.edit_rounded,
                          color: color03,
                        ),
                      ),
                    ),
                  ],
                ),
        
                //Nickname
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Nickname',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: nicknameController,
                          hintText: 'nickname',
                          minLines: 1,
                      )
                    ],
                  ),
                ),
        
                //About
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Short Bio',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: bioController,
                          hintText: 'nickname',
                        minLines: 3,
                      )
                    ],
                  ),
                ),

                //Done Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
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
                        text: 'Done',
                        onPressed: () {
                          createNewUser();
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
