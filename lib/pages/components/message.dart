import 'package:flutter/material.dart';

class Message extends StatelessWidget {

  final String message;
  final bool isMe;

  const Message({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: isMe ?
              const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)
              ) :
              const BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)
              ),
              color: isMe ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.1)
          ),
          child: Text(
            message,
            softWrap: true,
            style: TextStyle(fontSize: 25, color: isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

}