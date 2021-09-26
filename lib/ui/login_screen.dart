import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pictoshare/ui/signup_screen.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/commons.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/strings.dart';
import 'package:pictoshare/utils/validators.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _signInFormKey = GlobalKey<FormState>();

  String _password = "", _email = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorStyles.colorWhite,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _signInFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    // Title
                    Texts.signInTitle,
                    style: FontFace.fontStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    // Sub header
                    Texts.signInHeader,
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
                  textField(
                    // Email address field
                    Texts.emailAddressLabel,
                    controller: _emailController,
                    enabledColor: ColorStyles.colorSecondary,
                    textColor: ColorStyles.colorDarkText,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => validateEmail(value),
                    onSave: (val) => _email = val!,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  textField(
                    // Password field
                    Texts.passwordLabel,
                    controller: _passwordController,
                    enabledColor: ColorStyles.colorSecondary,
                    textColor: ColorStyles.colorDarkText,
                    textInputType: TextInputType.text,
                    obscure: true,
                    textInputAction: TextInputAction.go,
                    validator: (value) => validatePassword(value),
                    onSave: (val) => _password = val!,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  buttonFilled(
                      // Sign in button
                      Texts.signInButton.toUpperCase(), () async {
                    if (_signInFormKey.currentState!.validate()) {
                      _signInFormKey.currentState!.save();
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _email,
                            password: _password
                        );
                        // Fields are valid, remove the password
                        if (userCredential.user != null) {
                          // Clear the user data

                          CollectionReference users = FirebaseFirestore.instance.collection('users');
                          await users.where('email', isEqualTo: _email).get().then((value) {
                            final storage = GetStorage();
                            storage.write(Keys.name, value.docs[0].get('name'));
                            storage.write(Keys.email, value.docs[0].get('email'));
                            storage.write(Keys.email_verified, value.docs[0].get('emailVerified'));
                            storage.write(Keys.is_logged_in, true);

                            Get.snackbar(Texts.success, Texts.signInSuccessBody);
                            Get.to(() => Home());
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                        _passwordController.text = "";
                        if (e.code == 'weak-password') {
                          printVal("weak-password");
                          Get.snackbar(Texts.signInFailed, Texts.passwordTooWeek);
                        } else if (e.code == 'email-already-in-use') {
                          printVal("email in use");
                          Get.snackbar(Texts.signInFailed, Texts.emailAlreadyExists);
                        }
                      } catch (e) {
                        _passwordController.text = "";
                        Get.snackbar(Texts.signInFailed, Texts.somethingWrong);
                      }
                    }
                  }),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text.rich( // Signup text
                    TextSpan(
                      text: Texts.notAccount,
                      style: FontFace.fontStyle(
                        fontColor: ColorStyles.colorSecondaryText,
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: Texts.signUpTitle,
                          style: FontFace.fontStyle(
                            fontColor: ColorStyles.colorSecondary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer:TapGestureRecognizer()..onTap = () {
                            Get.to(() => SignUpScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
