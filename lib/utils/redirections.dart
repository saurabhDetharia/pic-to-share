import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pictoshare/ui/home.dart';
import 'package:pictoshare/ui/login_screen.dart';
import 'package:pictoshare/utils/strings.dart';

class Redirections {

  /// Navigation from splash screen
  static void fromSplashScreen() {
    final storage = GetStorage();
    if (storage.hasData(Keys.is_logged_in) && storage.read(Keys.is_logged_in)) {
      // User is logged in redirect to Home screen
      Get.off(() => Home());
    } else {
      // User is not logged in redirect to Login screen
      Get.off(() => LoginScreen());
    }
  }

  /// Remove top page from stack
  static void back() {
    Get.back();
  }

  /// To handle back press on Android
  static Future<bool> hardBack({Function? function}) async {
    if (function != null) {
      function;
    }
    return false;
  }

}