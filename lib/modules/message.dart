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
    required this.message,
    this.isAI = false,
  });

  final int id;
  final dynamic message;
  final bool isAI;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        message: json["message"],
        isAI: json["is_ai"] == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "message": message,
        "is_ai": isAI ? 1 : 0,
      };
}
