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
      // physics: const NeverScrollableScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (messages[index].isAI) {
          return AIMessage(message: messages[index].message.toString());
        }
        return UserMessage(message: messages[index].message.toString());
      },
    );
  }
}
