import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/screens/settings_page.dart';
import 'package:parakeet/services/auth_service.dart';
import 'package:parakeet/services/firestore_service.dart';
import 'package:parakeet/theming/colors.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestore = FirestoreService();

  Future<void> _refresh() async {
    setState(() {}); // Refresh the state to trigger the stream builder to fetch new data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color03,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          backgroundColor: color03.withOpacity(0.1),
          elevation: 10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Image.asset('assets/app-logo-final-bg-removed.png'),
                ),
              ),
              Text(
                'Parakeet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              icon: Icon(Icons.settings_rounded, size: 30, color: color04),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
          _refresh();
        },
        edgeOffset: 0,
        strokeWidth: 2.5,
        backgroundColor: Colors.white,
        color: color03,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No users found"));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;

                String id = userData['id'] ?? 'Unknown UID';
                String displayName = userData['nickname'] ?? 'No name';

                // if (id == _authService.getCurrentUser()!.uid) {
                //   displayName = 'TheCoolestPersonOnEarth';
                // } else {
                //   displayName = userData['nickname'] ?? 'No name';
                // }

                return ListTile(
                  leading: const Icon(Icons.person, size: 30,),
                  title: Text(displayName, style: GoogleFonts.manrope(fontSize: 20)),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ChatPage(
                          phoneNumber: displayName,
                          receiverID: id,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
