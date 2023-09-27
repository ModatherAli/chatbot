import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controller/theme_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class UserTextField extends StatefulWidget {
  const UserTextField({
    super.key,
    required this.textController,
    this.onSendText,
    this.onMicPressed,
    this.onChanged,
    this.onPressImage,
  });
  final TextEditingController textController;
  final void Function()? onSendText;
  final void Function()? onPressImage;
  final void Function()? onMicPressed;
  final void Function(String)? onChanged;
  @override
  State<UserTextField> createState() => _UserTextFieldState();
}

class _UserTextFieldState extends State<UserTextField> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String transcription = '';
  bool isListening = false;

  void startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          transcription = result.recognizedWords;
        });
      },
    );
  }

  void stopListening() {
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return Card(
        // color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
          // height: 50,
          decoration: BoxDecoration(
            color: themeController.isDark ? Constants.darkColor : Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 5),
              Expanded(
                flex: 7,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: widget.textController,
                      onChanged: widget.onChanged,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.textController.text.isEmpty,
                replacement: IconButton(
                  onPressed: widget.onSendText,
                  icon: const Icon(Icons.send),
                  color: Constants.primaryColor,
                ),
                child: IconButton(
                  onPressed: widget.onMicPressed,
                  icon: const Icon(Icons.mic),
                  color: Constants.primaryColor,
                ),
              ),
              Visibility(
                visible: widget.textController.text.isNotEmpty,
                child: IconButton(
                  onPressed: widget.onPressImage,
                  icon: const Icon(Icons.image),
                  color: Constants.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
