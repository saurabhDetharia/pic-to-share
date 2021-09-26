import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/redirections.dart';
import 'package:pictoshare/utils/strings.dart';

/// This is the Splash screen
/// After 3s user will be redirected
/// to the Login screen, if they haven't
/// logged in, else will be redirected
/// to the Home screen.

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer; // Timer for splash screen

  @override
  void initState() {
    super.initState();
    // Move to next screen after 3 seconds
    timer = Timer(Duration(seconds: 3), () {
      timer.cancel();
      Redirections.fromSplashScreen();
    });
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Texts.appName,
          style: FontFace.fontStyle(
            fontWeight: FontWeight.w800,
            fontSize: 60.0,
          ).copyWith(
              foreground: Paint()
                ..shader = ColorStyles.mainGradient.createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // If app is killed before
    // timer finishes, cancel timer.
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }
}
