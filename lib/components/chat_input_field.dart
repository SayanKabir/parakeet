import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parakeet/components/my_button.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController textController;
  const ChatInputField({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
      ),
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: const EdgeInsets.all(5),
            onPressed: (){},
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Type your message',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  icon: const Icon(Icons.emoji_emotions_rounded),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  icon: const Icon(Icons.keyboard_voice_rounded),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
