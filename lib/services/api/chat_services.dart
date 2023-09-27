import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../helper/logger_utils.dart';

class ChatServices {
  static String freeGPTUrl = 'https://gpt.bookskai.com';

  static Future<String> receiveMessageFromAI(String prompt) async {
    String responseMessage;
    try {
      final response = await http.post(
        Uri.parse(freeGPTUrl),
        body: {'message': prompt},
      );

      if (response.statusCode.toString().startsWith('20')) {
        final data = jsonDecode(response.body);
        responseMessage = '$data';
        log('$data');
      } else {
        throw Exception('Failed to generate text: ${response.statusCode}');
      }
    } catch (e) {
      responseMessage = 'Error';
      Logger.print('ai cant response: $e');
    }
    return responseMessage;
  }
}
