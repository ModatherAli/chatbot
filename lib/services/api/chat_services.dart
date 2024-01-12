import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../helper/logger_utils.dart';

class ChatServices {
  static String freeGPTUrl = dotenv.env['FREE_GPT_URL']!;

  static Stream<Response>? receiveMessageFromAI(String prompt) {
    Stream<Response>? stream;
    try {
      final response = http.post(
        Uri.parse(freeGPTUrl),
        body: {'message': prompt},
      );
      stream = response.asStream();
    } catch (e) {
      stream = Stream.error('Error');
      Logger.print('ai cant response: $e');
    }
    return stream;
  }
}
