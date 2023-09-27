import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration delay;
  final Duration duration;

  const TypingText({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 24),
    this.delay = const Duration(milliseconds: 300),
    this.duration = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late String _displayedText;

  @override
  void initState() {
    super.initState();
    _displayedText = '';
    _controller = AnimationController(
        vsync: this, duration: widget.duration * widget.text.length)
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final numCharsToShow = (_controller.value * widget.text.length).floor();
        _displayedText = widget.text.substring(0, numCharsToShow);
        if (_displayedText.length != widget.text.length) {
          _displayedText = '${_displayedText}_';
        }
        return Text(_displayedText, style: widget.textStyle);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
