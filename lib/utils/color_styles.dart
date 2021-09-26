import 'package:flutter/material.dart';

class ColorStyles {
  static const Color colorWhite = Color(0xffffffff);
  static const Color colorBlack = Color(0xff000000);
  static const Color colorDarkText = Color(0xff6b6b6b);
  static const Color colorSecondaryText = Color(0xffc2c2c2);
  static const Color colorPrimary = Color(0xffff9966);
  static const Color colorSecondary = Color(0xffff5e62);
  static const Color colorShadow = Color(0xb3ff5e62);

  static const mainGradient = LinearGradient(
    colors: [
      colorSecondary,
      colorPrimary,
    ],
  );

  static const BoxShadow mainShadow = BoxShadow(
      color: ColorStyles.colorShadow,
      blurRadius: 7.0,
      offset: Offset(0.0, 4.0)
  );
}