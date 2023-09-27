import 'package:get/get_state_manager/get_state_manager.dart';

import '../modules/message.dart';
import '../services/sql/sqflite_database.dart';

class ChatController extends GetxController {
  final List<Message> chatMessage = [];
  List<Map<String, Object?>> messages = [];

  final SqlDatabase _sqlDatabase = SqlDatabase();

  Future readData() async {
    messages = await _sqlDatabase.readData('SELECT * FROM Messages');
    update();
  }

  Future insertQRDate({
    required String message,
    int isImage = 0,
    int isAI = 0,
  }) async {
    await _sqlDatabase.insertData(
        "INSERT INTO 'Messages' ('message', 'is_image', 'is_ai') VALUES('$message','$isImage','$isAI')");
  }

  saveUserMessage() async {}

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
