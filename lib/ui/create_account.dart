import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pictoshare/ui/home.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/commons.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/strings.dart';
import 'package:pictoshare/utils/validators.dart';

class CreateAccount extends StatefulWidget {
  final String phoneNumber;
  final User userCredential;

  const CreateAccount({Key? key, required this.phoneNumber, required this.userCredential}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _createAccountFormKey = GlobalKey<FormState>();

  String _email = "", _password = "", _name = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.colorWhite,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _createAccountFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    // Title
                    Texts.createAccountTitle,
                    style: FontFace.fontStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    // Sub header
                    Texts.createAccountHeader,
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
                    // Name field
                    Texts.nameLabel,
                    controller: _nameController,
                    enabledColor: ColorStyles.colorSecondary,
                    textColor: ColorStyles.colorDarkText,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => isNameEmpty(value),
                    onSave: (val) => _name = val!,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 10.0,
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
                    Texts.createAccountButton.toUpperCase(),
                    () async {
                      if (_createAccountFormKey.currentState!.validate()) {
                        _createAccountFormKey.currentState!.save();
                        addUser();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Add the user details

  Future<void> addUser() async {

    // Register user
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password
      );
      userCredential.user!.sendEmailVerification();

      CollectionReference users = FirebaseFirestore.instance.collection('users');
      users.add({
        'name': _name,
        'email': _email,
        'phoneNumber': widget.phoneNumber,
        'emailVerified': widget.userCredential.emailVerified,
      })
        ..then((value) {
          // Account created
          final storage = GetStorage();
          storage.write(Keys.is_logged_in, true);
          storage.write(Keys.name, _name);
          storage.write(Keys.email, _email);
          storage.write(Keys.phone_number, widget.phoneNumber);
          storage.write(Keys.email_verified, widget.userCredential.emailVerified);

          _name = "";
          _email = "";
          _password = "";

          _nameController.text = "";
          _emailController.text = "";
          _passwordController.text = "";

          Get.snackbar(Texts.accountCreated, Texts.accountCreatedBody);
          Get.offAll(() => Home());
        })
        ..catchError((error) {
          // Failed to add user
          printVal("Failed to add user: $error");
          Get.snackbar(Texts.somethingWrong, Texts.accountCreateFailedBody);
        });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(Texts.accountCreateFailedBody, Texts.passwordTooWeek);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(Texts.accountCreateFailedBody, Texts.emailAlreadyExists);
      }
    } catch (e) {
      printVal(e.toString());
    }
  }
}
