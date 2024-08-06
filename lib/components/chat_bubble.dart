import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByMe;
  final bool isVoiceMessage;

  ChatBubble({
    required this.message,
    required this.time,
    required this.isSentByMe,
    this.isVoiceMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.green[100] : Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: isSentByMe ? Radius.circular(12.0) : Radius.circular(0),
            bottomRight: isSentByMe ? Radius.circular(0) : Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isVoiceMessage)
              Row(
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: isSentByMe ? Colors.black : Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 40,
                      color: isSentByMe ? Colors.green : Colors.white,
                      // Placeholder for waveform or voice message UI
                    ),
                  ),
                ],
              )
            else
              Text(
                message,
                style: TextStyle(
                  color: isSentByMe ? Colors.black : Colors.white,
                ),
              ),
            const SizedBox(height: 5.0),
            Text(
              time,
              style: TextStyle(
                color: isSentByMe ? Colors.black54 : Colors.white54,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
