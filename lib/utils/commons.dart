import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/font_face.dart';

void printVal(String value) {
  // print(value);
}

Widget textField (
    String labelText,
{
  Key? key,
  String? initialValue,
  FocusNode? focusNode,
  TextEditingController? controller,
  TextInputType? textInputType,
  TextInputAction? textInputAction,
  AutovalidateMode? autoValidateMode,
  bool? readonly,
  List<TextInputFormatter>? inputFormatters,
  bool? obscure,
  Color? textColor,
  FontWeight? textFontWeight,
  Color? enabledColor,
  Color? errorColor,
  VoidCallback? onTap,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
  String? Function(String?)? onSave,
  Widget? suffix,
  Brightness? keyboardAppearance
}) {
  return TextFormField(
    key: key,
    keyboardAppearance: keyboardAppearance ?? Brightness.light,
    focusNode: focusNode,
    initialValue: initialValue,
    controller: controller,
    autovalidateMode: autoValidateMode,
    textInputAction: textInputAction ?? TextInputAction.done,
    keyboardType: textInputType,
    readOnly: readonly ?? false,
    obscureText: obscure ?? false,
    inputFormatters: inputFormatters,
    cursorColor: ColorStyles.colorSecondary,
    textAlignVertical: TextAlignVertical(y: 0.05),
    onTap: onTap,
    onFieldSubmitted: onSubmitted,
    onChanged: onChanged,
    validator: validator,
    onSaved: onSave,
    textCapitalization: TextCapitalization.sentences,
    smartDashesType: SmartDashesType.disabled,
    style: FontFace.fontStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontColor: ColorStyles.colorSecondary,
    ),
    decoration: InputDecoration(
      suffix: suffix,
      labelText: labelText,
      labelStyle: FontFace.fontStyle(
        fontWeight: FontWeight.w400,
        fontColor: ColorStyles.colorSecondaryText,
        fontSize: 16.0,
      ),
      errorStyle: FontFace.fontStyle(
        fontColor: ColorStyles.colorSecondary,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorStyles.colorSecondary),
      ),
    ),
  );
}

Widget buttonFilled(String text, VoidCallback clickEvent) {
  return InkWell(
    onTap: clickEvent,
    child: Container(
      decoration: BoxDecoration(
        gradient: ColorStyles.mainGradient,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          ColorStyles.mainShadow,
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 10.0,
      ),
      child: Text(
        text,
        style: FontFace.fontStyle(
          fontColor: ColorStyles.colorWhite,
          fontSize: 18.0,
        ),
      ),
    ),
  );
}
