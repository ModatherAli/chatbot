import 'dart:convert';
import 'dart:developer';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:http/http.dart' as http;

String OPENAI_API_KEY = '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';

class OpenAiAPI {
  String completionsUrl = 'https://api.openai.com/v1/chat/completions';
  String imagesUrl = 'https://api.openai.com/v1/images/generations';

  Future<Map<String, dynamic>> sendMessage({
    required String messageText,
    bool wantsImage = false,
  }) async {
    Map<String, dynamic> requestBody = textRequestBody(messageText);
    String uri = completionsUrl;
    if (wantsImage) {
      requestBody = imageRequestBody(messageText);
      uri = imagesUrl;
    }

    var response = await http.post(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $OPENAI_API_KEY"
      },
      body: json.encode(requestBody),
    );

    log('Response status: ${response.statusCode}');
    Map<String, dynamic> responseJson =
        jsonDecode(utf8.decode(response.bodyBytes));
    log('Response body: $responseJson');
    return responseJson;
  }

  Map<String, dynamic> textRequestBody(String messageText) {
    return {
      "temperature": 0.1,
      "n": 1,
      "model": 'gpt-4',
      "messages": [
        {
          "role": "user",
          "content": """
              $messageText
              """,
        }
      ],
    };
  }

  Map<String, dynamic> imageRequestBody(String messageText) {
    return {
      "prompt": messageText,
      "n": 1,
      "size": "1024x1024",
    };
  }
}
