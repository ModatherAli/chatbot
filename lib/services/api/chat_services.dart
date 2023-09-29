import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../helper/logger_utils.dart';

class ChatServices {
  static String freeGPTUrl = dotenv.env['FREE_GPT_URL']!;

  static Stream<Response>? receiveMessageFromAI(String prompt) {
    // String responseMessage;
    Stream<Response>? stream;
    try {
      final response = http.post(
        Uri.parse(freeGPTUrl),
        body: {'message': prompt},
      );
      // response.asStream().listen((event) {
      //   Logger.print(event.body);
      // });
      stream = response.asStream();
      // return stream;
      // StreamSubscription streamSubscription =
      //     response.asStream().listen((event) {
      //   Logger.print(event.body);
      //   // responseMessage = event.body;
      // });
      // streamSubscription.
      // if (response.statusCode.toString().startsWith('20')) {
      //   final data = jsonDecode(response.body);
      //   responseMessage = '$data';
      //   log('$data');
      // } else {
      //   throw Exception('Failed to generate text: ${response.statusCode}');
      // }
    } catch (e) {
      stream = Stream.error('Error');
      Logger.print('ai cant response: $e');
    }
    return stream;
  }
}
