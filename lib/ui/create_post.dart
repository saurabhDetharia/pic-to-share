import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/commons.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/strings.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String imagePath = "";
  TextEditingController _hashtagsController = TextEditingController();
  String _hashtags = "";
  bool isUploading = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.colorWhite,
      body: WillPopScope(
        onWillPop: () async {
          if (!isUploading) {
            Navigator.pop(context, false);
          }
          return false;
        },
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: isUploading,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context, false),
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
                          Texts.createPostTitle,
                          style: FontFace.fontStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5.0,
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
                          height: 30.0,
                        ),
                        InkWell(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            imagePath = image!.path;
                            setState(() {});
                          },
                          child: imagePath.isNotEmpty
                              ? Image.file(
                                  File(imagePath),
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                      color: ColorStyles.colorSecondaryText,
                                      style: BorderStyle.solid,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.add,
                                    color: ColorStyles.colorSecondaryText,
                                  ),
                                ),
                        ),
                        textField(
                          // Hashtags field
                          Texts.hashtagsLabel,
                          key: Key('createPostHashtags'),
                          controller: _hashtagsController,
                          enabledColor: ColorStyles.colorSecondary,
                          textColor: ColorStyles.colorDarkText,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            _hashtags = value;
                            List<String> hashtags = _hashtagsController.text.toString().trim().replaceAll(" ", "").split(",");
                            List newTags  = hashtags.toSet().toList();
                            _hashtags = newTags.join(", ");
                            _hashtagsController.text = _hashtags;
                          },
                          onSave: (value) {
                            _hashtags = value!;
                            List<String> hashtags = _hashtagsController.text.toString().trim().split(",");
                            List newTags = hashtags.toSet().toList();
                            _hashtags = newTags.join(", ");
                            _hashtagsController.text = _hashtags;
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        buttonFilled(
                          // Verify phone button
                          Texts.createPostButton.toUpperCase(),
                          () async {
                            if (imagePath.isNotEmpty) {
                              setState(() {
                                isUploading = true;
                              });
                              uploadImage(imagePath);
                            } else {
                              Get.snackbar(Texts.uploadFailed, Texts.noFileBody);
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isUploading,
                child: Container(
                  color: ColorStyles.colorBlack.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: ColorStyles.mainGradient,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
              color: ColorStyles.colorWhite,
            ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  /// To upload Image
  Future<void> uploadImage(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(filePath);
    List<String> fileName = filePath.split("/").last.split(".");

    String name = fileName[0] + DateTime.now().toIso8601String() + fileName[1];

    Reference ref = storage.ref().child('uploads/images/$name');

    try {
      await ref.putFile(file).then((task) async {
        if (task.state == TaskState.success) {
          String downloadUrl = await ref.getDownloadURL();
          String _email = GetStorage().read(Keys.email);
          String _name = GetStorage().read(Keys.name);
          users.where("email", isEqualTo: _email).get().then((value) {
            String uid = value.docs[0].id;

            List images = [];
            if (value.docs[0].data().toString().contains("images")) {
              images.addAll(value.docs[0].get("images"));

              _hashtags = _hashtagsController.text;
              List<String> hashtags = _hashtagsController.text.toString().trim().split(",");
              List newTags = hashtags.toSet().toList();
              _hashtags = newTags.join(", ");
              _hashtagsController.text = _hashtags;

              images.add({
                "url": downloadUrl,
                "tags": _hashtagsController.text,
                "name": _name,
                "created_at": "${DateTime.now()}"
              });

              FirebaseFirestore.instance.collection("users").doc(uid).update({"images": images});
              _hashtagsController.text = "";
              imagePath = "";
              _hashtags = "";
              isUploading = false;
              setState(() {});
              Navigator.pop(context, true);
            } else {
              _hashtags = _hashtagsController.text;
              List<String> hashtags = _hashtagsController.text.toString().trim().split(",");
              List newTags = hashtags.toSet().toList();
              _hashtags = newTags.join(", ");
              _hashtagsController.text = _hashtags;

              images.add({"url": downloadUrl, "tags": _hashtagsController.text, "name": _name, "created_at" : "${DateTime.now()}"});

              FirebaseFirestore.instance.collection("users").doc(uid).update({"images": images});
              _hashtagsController.text = "";
              imagePath = "";
              _hashtags = "";
              isUploading = false;
              setState(() {});
              Navigator.pop(context, true);
            }
          });
        }
      });
    } on FirebaseException catch (e) {
      printVal(e.toString());
      Get.snackbar(Texts.uploadFailed, Texts.uploadFailedBody);
    }
  }

}
