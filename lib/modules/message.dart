// To parse this JSON data, do
//
//     final messageModule = messageModuleFromJson(jsonString);

import 'dart:convert';

// MessageModule messageModuleFromJson(String str) =>
//     MessageModule.fromJson(json.decode(str));

String messageModuleToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.id,
    required this.content,
    this.isAI = false,
  });

  final int id;
  String content;
  final bool isAI;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json["message"],
      isAI: json["is_ai"] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        "message": content.toString().trim(),
        "is_ai": isAI ? 1 : 0,
      };
}
