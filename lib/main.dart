import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pictoshare/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize local storage
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
    );
  }
}
