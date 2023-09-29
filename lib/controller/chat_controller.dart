import 'dart:convert';

import 'package:chatbot/helper/logger_utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';

import '../modules/message.dart';
import '../services/api/chat_services.dart';
import '../services/sql/sqflite_database.dart';

class ChatController extends GetxController {
  List<Message> chatMessage = [];

  final SqlDatabase _sqlDatabase = SqlDatabase();

  @override
  void onInit() {
    super.onInit();
    getLastMessages();
  }

  Future getLastMessages() async {
    chatMessage = await _sqlDatabase.readData() ?? [];
    Logger.print(chatMessage.length);
    update();
  }

  Future saveMessage(Message message) async {
    await _sqlDatabase.insertData(message);
  }

  Future deleteMessage(Message message) async {
    await _sqlDatabase.deleteData(message);
    chatMessage.remove(message);
    update();
  }

  Future deleteAllChat() async {
    for (var message in chatMessage) {
      await _sqlDatabase.deleteData(message);
    }
    chatMessage.clear();
    update();
  }

  onUserSendMessage(String text) async {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(text);

    Message message = Message(
      content: stringBuffer,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    chatMessage.insert(0, message);
    saveMessage(message);
    update();
  }

  Future onAISendMessage(String text) async {
    Stream<Response>? stream = ChatServices.receiveMessageFromAI(text);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (stream != null) {
      Message message = Message(
        content: StringBuffer(),
        id: DateTime.now().millisecondsSinceEpoch,
        isAI: true,
      );
      chatMessage.insert(0, message);
      stream.listen((Response event) {
        var message = utf8.decode(event.bodyBytes);

        chatMessage.first.content.write('$message');
        update();
      }).onDone(() {
        saveMessage(message);
      });
    }

    update();
  }

  //   _getMessage() async {
  //   Message messageModule;

  //   StringBuffer stringBuffer = StringBuffer();
  //   stringBuffer.write('Hi. You can ask me anything'.tr);
  //   messageModule = Message(
  //     isAI: true,
  //     message: stringBuffer,
  //   );
  //   _chatMessage.add(messageModule);
  //   setState(() {});
  //   await _messageController.readData();
  //   for (var message in _messageController.messages) {
  //     StringBuffer buffer = StringBuffer();
  //     buffer.write(message['message'].toString());
  //     if (message['is_ai'] == 1) {
  //       messageModule = Message(
  //         isAI: true,
  //         isImage: message['is_image'] == 1,
  //         message: buffer,
  //       );
  //     } else {
  //       messageModule = Message(
  //         isAI: false,
  //         message: buffer,
  //       );
  //     }
  //     _chatMessage.add(messageModule);
  //   }
  //   setState(() {});
  // }
}
