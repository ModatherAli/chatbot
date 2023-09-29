import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../res/constants.dart';

class MicView extends StatefulWidget {
  final bool speechEnabled;
  final void Function()? onKeyboardPressed;
  final void Function()? onRecord;
  final String text;
  const MicView({
    super.key,
    this.onKeyboardPressed,
    required this.speechEnabled,
    this.onRecord,
    required this.text,
  });

  @override
  State<MicView> createState() => _MicViewState();
}

class _MicViewState extends State<MicView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const Spacer(),
            AutoSizeText(
              widget.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                ),
                GestureDetector(
                  onTap: widget.onRecord,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          widget.speechEnabled
                              ? Icons.square_rounded
                              : Icons.mic_rounded,
                          size: 30,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onKeyboardPressed,
                  icon: const Icon(Icons.keyboard_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
