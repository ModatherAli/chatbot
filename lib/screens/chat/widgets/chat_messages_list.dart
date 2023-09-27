import 'package:chatbot/modules/message.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class ChatMessagesList extends StatelessWidget {
  final List<Message> messages;
  const ChatMessagesList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (messages[index].isAI) {
          return AIMessage(message: messages[index].message);
        }
        return UserMessage(message: messages[index].message);
      },
    );
  }
}
