import 'package:chatbot/modules/message.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class ChatMessagesList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController? scrollController;
  const ChatMessagesList(
      {super.key, required this.messages, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      reverse: true,
      shrinkWrap: true,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (messages[index].isAI) {
          Message message = messages[index];
          if (message.content.isEmpty) {
            return AIWriting();
          }
          return AIMessage(
            message: message,
            lastMessage: index == 0,
          );
        }
        return UserMessage(message: messages[index]);
      },
    );
  }
}
