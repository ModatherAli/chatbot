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
  final dynamic id;
  final dynamic message;
  final bool isAI;

  // factory MessageModule.fromJson(Map<String, dynamic> json) => MessageModule(
  //       message: json["message"],
  //       isImage: json["is_image"],
  //       isAI: json["is_ai"],
  //     );

  Map<String, dynamic> toJson() => {
        "message": message,
        "is_ai": isAI,
      };
}
