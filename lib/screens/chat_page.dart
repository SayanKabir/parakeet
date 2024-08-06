import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parakeet/components/chat_input_field.dart';
import 'package:parakeet/services/auth_service.dart';
import 'package:parakeet/services/firestore_service.dart';
import '../components/chat_bubble.dart';
import '../theming/colors.dart';

class ChatPage extends StatefulWidget {
  final String phoneNumber;
  final String receiverID;

  const ChatPage(
      {super.key, required this.phoneNumber, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final AuthService _authMethods = AuthService();

  final FirestoreService _firestoreMethods = FirestoreService();

  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestoreMethods.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    final String myID = _authMethods.getCurrentUser()!.uid;

    return Scaffold(
      backgroundColor: color03,
      appBar: AppBar(
        backgroundColor: color03.withOpacity(0.1),
        elevation: 10,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        leadingWidth: 50,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            //open user's profile
          },
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.phoneNumber,
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestoreMethods.getMessages(myID, widget.receiverID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages found'));
                }
                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMine = message['senderID'] == myID;

                    return ChatBubble(
                      message: message['message'],
                      time: message['timestamp']
                          .toString(), // Replace with actual timestamp
                      isSentByMe: isMine,
                      isVoiceMessage:
                          false, // Handle voice message separately if needed
                    );
                  },
                );
              },
            ),
          ),

          //Message input and send area
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           focusNode: myFocusNode,
          //           controller: _messageController,
          //           decoration: InputDecoration(
          //             hintText: 'Enter your message',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.send),
          //         onPressed: sendMessage,
          //       ),
          //     ],
          //   ),
          // ),
          ChatInputField(
            textController: _messageController,
          ),
        ],
      ),
    );
  }
}
