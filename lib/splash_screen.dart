import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'res/constants.dart';
import 'screens/chat/chat_screen.dart';

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: 200,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      screenFunction: () async {
        _controller.forward();
        return ChatScreen();
      },
      splash: Directionality(
        textDirection: TextDirection.ltr,
        child: SplashScreen(controller: _controller),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.controller}) : super(key: key);

  final AnimationController controller;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Animation<double?> _flightLeft;
  late final Animation<double?> _flightRight;
  late final Animation<double?> _box;

  @override
  void initState() {
    _flightLeft = Tween<double?>(begin: 50, end: 100).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0, 0.8, curve: Curves.linear)));

    _flightRight = Tween<double?>(begin: 50, end: 100).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0, 0.8, curve: Curves.linear)));

    _box = Tween<double?>(begin: 30, end: 100).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.8, 1, curve: Curves.decelerate)));

    _flightLeft.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "AI ChatBot",
                textStyle:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                speed: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
        Positioned(
          left: _flightLeft.value,
          bottom: 0,
          child: const Icon(
            Icons.send,
            size: 20,
          ),
        ),
        Positioned(
          right: _flightRight.value,
          bottom: 0,
          child: const RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.send,
              size: 20,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _box.value,
              width: 100,
              child: Image.asset(Constants.appIcon),
            ))
      ],
    );
  }
}
