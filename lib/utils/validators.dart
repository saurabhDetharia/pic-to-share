import 'package:pictoshare/utils/strings.dart';

/// To check password is empty or lesser than 6 characters
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return Texts.passwordBlankError;
  } else if (value.length < 6) {
    return Texts.passwordMinLenError;
  }
  return null;
}

/// To check email is valid or not
String? validateEmail(String? email) {
  RegExp emailRegx = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (email != null && email.isEmpty) {
      return Texts.emailBlankError;
    } else if (!emailRegx.hasMatch(email!)) {
      return Texts.emailInvalidError;
    }
    return null;
}

/// To check phone number is valid or not
String? validatePhoneNumber(String? phNo) {
    RegExp phNoRegx = RegExp(r'^-?[0-9]+$');
    if (phNo != null && phNo.isEmpty) {
      return Texts.phoneNoBlankError;
    } else if (!phNoRegx.hasMatch(phNo!)) {
      return Texts.phNoInvalidError;
    }
    return null;
}

/// To check verification code is valid or not
String? validateVerificationCode(String? code) {
    RegExp digitRegx = RegExp(r'^-?[0-9]{6}$');
    if (code != null && code.isEmpty) {
      return Texts.verificationCodeBlankError;
    } else if (!digitRegx.hasMatch(code!)) {
      return Texts.verificationCodeInvalidError;
    }
    return null;
}

/// To check name is empty or not
String? isNameEmpty(String? name) {
    if (name != null && name.isEmpty) {
      return Texts.nameBlankError;
    }
    return null;
}