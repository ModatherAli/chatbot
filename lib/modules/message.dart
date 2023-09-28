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
  final StringBuffer message;
  final bool isAI;

  factory Message.fromJson(Map<String, dynamic> json) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(json["message"]);

    return Message(
      id: json['id'],
      message: stringBuffer,
      isAI: json["is_ai"] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        "message": message.toString().trim(),
        "is_ai": isAI ? 1 : 0,
      };
}
