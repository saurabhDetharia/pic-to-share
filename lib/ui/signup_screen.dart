import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pictoshare/ui/create_account.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/commons.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/redirections.dart';
import 'package:pictoshare/utils/strings.dart';
import 'package:pictoshare/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _countryCode = "+1", _phoneNumber = "";

  TextEditingController _phoneNumberController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.colorWhite,
      body: WillPopScope(
        onWillPop: Redirections.hardBack,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Form(
                key: _signUpFormKey,
                child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  InkWell(
                    onTap: () => Redirections.back(),
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    // Title
                    Texts.signUpTitle,
                    style: FontFace.fontStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    // Sub header
                    Texts.signUpHeader,
                    style: FontFace.fontStyle(
                      fontColor: ColorStyles.colorDarkText,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 50.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      gradient: ColorStyles.mainGradient,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        ColorStyles.mainShadow.scale(0.3),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Phone number field
                    children: [
                      CountryCodePicker(
                        key: Key('signUpPhoneCountryCodePicker'),
                        onChanged: (value) {
                          _countryCode = value.dialCode!;
                        },
                        initialSelection: 'US',
                        favorite: ['+1', 'US'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        showFlag: true,
                        showFlagDialog: true,
                        dialogTextStyle: FontFace.fontStyle(
                          fontColor: ColorStyles.colorBlack,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        closeIcon: Icon(
                          CupertinoIcons.clear,
                          key: Key('signUpPhoneCloseIcon'),
                          size: 24.0,
                          color: ColorStyles.colorBlack,
                        ),
                        searchStyle: FontFace.fontStyle(
                          fontColor: ColorStyles.colorBlack,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                        searchDecoration: InputDecoration(
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            size: 24.0,
                            color: ColorStyles.colorSecondary,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorStyles.colorSecondary),
                          ),
                          labelText: Texts.search,
                          labelStyle: FontFace.fontStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                        ),
                        builder: (country) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _countryCode,
                                style: FontFace.fontStyle(
                                  fontColor: ColorStyles.colorDarkText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_down,
                                size: 18.0,
                                color: ColorStyles.colorSecondaryText,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: ColorStyles.colorSecondaryText, width: 1.25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: textField(
                          // Phone number field
                          Texts.phoneNumberLabel,
                          key: Key('signUpPhoneNumber'),
                          controller: _phoneNumberController,
                          enabledColor: ColorStyles.colorSecondary,
                          textColor: ColorStyles.colorDarkText,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.go,
                          validator: (value) => validatePhoneNumber(value),
                          onSave: (value) {
                            _phoneNumber = value!;
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  buttonFilled(
                    // Verify phone button
                    Texts.continueButton.toUpperCase(),
                    () async {
                      if (_signUpFormKey.currentState!.validate()) {
                        _signUpFormKey.currentState!.save();
                        bool isExist = await isPhoneNumberExist();
                        if (isExist) {
                          // User entered same phone number.
                          _phoneNumber = "";
                          _phoneNumberController.text = "";
                          _countryCode = "+1";
                          Get.snackbar(Texts.userExist, Texts.userExistBody);
                        } else {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          _verifyPhoneNumber(auth);
                        }
                      }
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Check if user entered already
  /// registered phone number
  Future<bool> isPhoneNumberExist() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (users.isBlank!) {
      DocumentSnapshot docSnapshot = await users.doc(_phoneNumber).get();
      if (docSnapshot.exists) {
        // User is found! Ask to login.
        return true;
      } else {
        // This user is not found, add as new user.
        return false;
      }
    } else {
      // No users found, add as new user
      return false;
    }
  }

  /// Show a bottom sheet to enter
  /// a verification code and verify
  /// code with Firebase authentication.
  void verificationCodeView(FirebaseAuth auth, String verificationId) {
    TextEditingController _verificationCodeController = TextEditingController();

    final _verificationCodeFormKey = GlobalKey<FormState>();

    String _verificationCode = "";

    Get.bottomSheet(
        // Show bottom sheet
        Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: ColorStyles.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      child: SingleChildScrollView(
        child: Form(
          key: _verificationCodeFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // Title
                Texts.verificationCodeTitle,
                style: FontFace.fontStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                // Sub header
                Texts.verificationCodeInstr,
                style: FontFace.fontStyle(
                  fontColor: ColorStyles.colorDarkText,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                child: textField(
                  // Verification code field
                  Texts.verificationCodeLabel,
                  key: Key('signUpVerification'),
                  controller: _verificationCodeController,
                  enabledColor: ColorStyles.colorSecondary,
                  textColor: ColorStyles.colorDarkText,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.go,
                  validator: (value) => validateVerificationCode(value),
                  onSave: (value) {
                    _verificationCode = value!;
                  },
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              buttonFilled(
                  // Verify phone button
                  Texts.continueButton.toUpperCase(), () async {
                _signInWithPhoneNumber(auth, verificationId, _verificationCode);
              }),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // verify phone number
  Future<void> _verifyPhoneNumber(_auth) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      printVal("verified");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      printVal("authExp: $authException");
    };

    PhoneCodeSent codeSent =
        (String? verificationId, [int? forceResendingToken]) async {
          _verificationId = verificationId!;
          verificationCodeView(_auth, verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+$_countryCode$_phoneNumber",
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      printVal(e.toString());
    }
  }

  /// Verify code
  Future<void> _signInWithPhoneNumber(_auth, _verificationId, _code) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: "123456",
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      printVal("success");
      if (!user.isBlank!) {

        Redirections.back();
        Get.to(() => CreateAccount(
          phoneNumber: _phoneNumber,
          userCredential: user,
        ));
      }
    } catch (e) {
      printVal(e.toString());
    }
  }
}
