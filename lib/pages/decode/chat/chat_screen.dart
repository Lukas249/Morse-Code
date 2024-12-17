import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/basic_chat.dart';
import '../../components/message.dart';
import '../../morse_code_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {

  final List<Widget> _messagesList = [];

  void onSubmitMessage(String message) {
    String decodedMorseCode = MorseCodeText.decode(message);

    if (!MorseCodeText.isValidMorseCode(message) || decodedMorseCode.trim() == "") {
      Fluttertoast.showToast(
          msg: "Message must contain correct sequence of dots, dashes and spaces",
          toastLength: Toast.LENGTH_SHORT
      );

      return;
    }

    _messagesList.add(Message(message: message, isMe: true));
    _messagesList.add(Message(message: decodedMorseCode, isMe: false));
  }

  @override
  Widget build(BuildContext context) {
    return BasicChat(
      messagesList: _messagesList,
      onSubmitMessage: onSubmitMessage,
      isTransmitting: false,
      onTransmissionEnd: () {},
    );
  }

}