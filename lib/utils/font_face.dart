import 'package:flutter/cupertino.dart';
import 'package:pictoshare/utils/color_styles.dart';

class FontFace {
  static TextStyle fontStyle({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14.0,
    Color fontColor = ColorStyles.colorBlack,
  }) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: fontColor,
      fontFamily: 'Poppins',
    );
}
}