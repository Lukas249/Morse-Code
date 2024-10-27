import 'package:flutter/material.dart';

class BasicChat extends StatefulWidget {
  final List<Widget> messagesList;
  final Function(String) onSubmitMessage;

  const BasicChat({super.key, required this.messagesList, required this.onSubmitMessage});

  @override
  State<StatefulWidget> createState() {
    return BasicChatState();
  }

}

class BasicChatState extends State<BasicChat> {
  final TextEditingController _textEditingController = TextEditingController();

  void submitMessage(BuildContext context) {
    widget.onSubmitMessage(_textEditingController.text);
    _textEditingController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                children: widget.messagesList.reversed.toList(),
              ),
            ),
            TextField(
              controller: _textEditingController,
              textAlignVertical: TextAlignVertical.center,
              onEditingComplete: () {
                submitMessage(context);
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      submitMessage(context);
                    },
                    icon: const Icon(Icons.send)),
              ),
            ),
          ],
        ),
      );
  }

}