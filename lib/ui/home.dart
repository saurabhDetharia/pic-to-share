import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pictoshare/ui/create_post.dart';
import 'package:pictoshare/ui/login_screen.dart';
import 'package:pictoshare/utils/color_styles.dart';
import 'package:pictoshare/utils/font_face.dart';
import 'package:pictoshare/utils/strings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final storage = GetStorage();

  var _name = "", _email = "", _emailVerified = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List posts = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getImages();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getUserDetails();
      getImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.colorWhite,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                      Expanded(
                        child: Text.rich(TextSpan(
                        text: Texts.welcome,
                        style: FontFace.fontStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            // Title
                            text: _name.toString() + "!",
                            style: FontFace.fontStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],),),
                      ),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      storage.erase();
                      Get.offAll(LoginScreen());
                    },
                    child: Icon(
                        CupertinoIcons.power
                    ),
                  ),
                    ],
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
                height: 20.0,
              ),
              _emailVerified ? getPosts() : verifyEmail()
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _emailVerified,
        child: InkWell(
          onTap: () async {
            bool res = await Navigator.push(context, CupertinoModalPopupRoute(builder: (context) => CreatePost()));
            if (res) {
              getImages();
            }
          },
          child: Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ColorStyles.mainGradient,
              boxShadow: [
                ColorStyles.mainShadow,
              ],
            ),
            child: Icon(
              CupertinoIcons.add,
              color: ColorStyles.colorWhite,
            ),
          ),
        ),
      ),
    );
  }

  /// Get stored user details and
  /// if email is not verified, check
  /// updated status
  Future<void> getUserDetails() async {
    _name = storage.read(Keys.name);
    _email = storage.read(Keys.email);
    _emailVerified = storage.read(Keys.email_verified);

    if (!_emailVerified) {
      User user = FirebaseAuth.instance.currentUser!;
      user.reload().then((value) {
        _emailVerified = user.emailVerified;
      });
      if (_emailVerified) {
        var docSnapshot = await users.where('email', isEqualTo: _email).get();
        if (docSnapshot.docs.isNotEmpty) {
          // Check if email verified
          users.doc().update({'emailVerified': true});
          if (_emailVerified) {
            storage.write(Keys.email_verified, _emailVerified);
          }
        }
      }
    }
  }

  /// Ask user to verify email
  Widget verifyEmail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/mailbox.jpg"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            // Title
            Texts.verifyEmail,
            textAlign: TextAlign.center,
            style: FontFace.fontStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontColor: ColorStyles.colorDarkText,
            ),
          ),
        ),
      ],
    );
  }

  /// To show there is no posts
  Widget emptyFeed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/create_post.jpg"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            // Title
            Texts.createPost,
            textAlign: TextAlign.center,
            style: FontFace.fontStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontColor: ColorStyles.colorDarkText,
            ),
          ),
        ),
      ],
    );
  }

  /// Check for posts and show accordingly
  Widget getPosts() {
    return posts.isEmpty
        ? emptyFeed()
        : Expanded(
            child: GridView.builder(
              itemCount: posts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return Container(
                  height: 100.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: ColorStyles.colorWhite,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: ColorStyles.colorSecondaryText,
                        blurRadius: 5.0,
                        offset: Offset(4.0, 4.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                          ),
                          child: Image.network(
                            posts[index]["url"],
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // Person name
                              posts[index]["name"],
                              style: FontFace.fontStyle(
                                fontColor: ColorStyles.colorDarkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                            Visibility(
                              visible: posts[index]["tags"].toString().isNotEmpty,
                              child: Text(
                                // Hashtags
                                posts[index]["tags"],
                                style: FontFace.fontStyle(
                                  fontColor: ColorStyles.colorDarkText,
                                ),
                              ),
                            ),
                            Text(
                              // Upload date
                              posts[index]["created_at"],
                              style: FontFace.fontStyle(
                                fontColor: ColorStyles.colorDarkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  /// To fetch all the uploaded images...
  void getImages() {
    posts.clear();
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data().containsKey("images")) {
          List images = element.get("images");
          posts.addAll(images);
        }
      });
      posts = posts.reversed.toList();
      setState(() {});
    });
  }
}
