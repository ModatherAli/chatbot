import 'package:get/get_state_manager/get_state_manager.dart';

import '../services/sql/sqflite_database.dart';

class MessageController extends GetxController {
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
}
