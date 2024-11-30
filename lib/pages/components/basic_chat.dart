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
    final theme = Theme.of(context);
    
    return Container(
        padding: const  EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
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
                hintText: "Enter your message here...",
                filled: true,
                fillColor: theme.colorScheme.onSurface.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                       vertical: 20.0,
                       horizontal: 20.0, ),
                suffixIcon: IconButton(
                    onPressed: () {
                      submitMessage(context);
                    },
                  icon: Icon(Icons.send, color: theme.colorScheme.primary)),
              ),
            ),
          ],
        ),
      );
  }

}