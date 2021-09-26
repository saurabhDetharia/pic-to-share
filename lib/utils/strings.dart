class Keys {
  static const String is_logged_in = "isLoggedIn";
  static const String name = "name";
  static const String email = "email";
  static const String phone_number = "phoneNumber";
  static const String email_verified = "emailVerified";
}

class Texts {
  static const String appName = "PicToShare";

  /// Sign in UI
  static const String signInTitle = "Sign In";
  static const String signInHeader = "Sign in with your registered email and password.\n";
  static const String signInButton = "Sign In";
  static const String signUpTitle = "Sign Up";
  static const String signUpHeader = "We'll send you a verification code over your phone number.";
  static const String signUpButton = "Sign Up";
  static const String emailAddressLabel = "Email address";
  static const String phoneNumberLabel = "Phone number";
  static const String passwordLabel = "Password";
  static const String notAccount = "Not having an account? ";
  static const String verificationCodeTitle = "Verification code";
  static const String verificationCodeInstr = "Please enter the verification code you received on your phone number.";
  static const String verificationCodeLabel = "Verification code";

  /// Create account UI
  static const String createAccountTitle = "Create Account";
  static const String createAccountHeader = "Please provide following details for your new account. ";
  static const String createAccountButton = "Create Account";
  static const String nameLabel = "Name";

  /// Sign in alerts
  static const String signInSuccessBody = "You are signed in successfully.";
  static const String signInFailed = "Sign in failed";
  static const String userExist = "Already exist";
  static const String userExistBody = "You are already connected with us! Please sign in to continue.";
  static const String accountCreated = "Account created";
  static const String accountCreatedBody = "Your account created successfully.";
  static const String accountCreateFailedBody = "Your account cannot be created.";

  /// Validations
  static const String emailBlankError = "Please enter email address.";
  static const String emailInvalidError = "Please enter valid email address.";
  static const String passwordBlankError = "Please enter password.";
  static const String passwordMinLenError = "Password should be atleast 6 characters.";
  static const String emailAlreadyExists = "The account already exists for that email.";
  static const String passwordTooWeek = "The password provided is too weak.";
  static const String phoneNoBlankError = "Please enter phone number.";
  static const String phNoInvalidError = "Please enter valid phone number.";
  static const String phNoInvalidAlertMessage = "The provided phone number is not valid.";
  static const String verificationCodeBlankError = "Please enter verification code.";
  static const String verificationCodeInvalidError = "Verification code must be of 6 digits.";
  static const String nameBlankError = "Please enter your name.";

  /// Commons
  static const String success = "Successful";
  static const String continueButton = "continue";
  static const String search = "Search";
  static const String somethingWrong = "Something went wrong! Please try again later.";

  /// Home
  static const String welcome = "Welcome,\n";
  static const String logout = "Logout";
  static const String verifyEmail = "To get started, please verify your email first.";
  static const String createPost = "Be the first, post now!";

  /// Uploading
  static const String uploadFailed = "Uploading failed";
  static const String uploadFailedBody = "Your selected file, cannot be uploaded. Please try again.";
  static const String noFileBody = "Please select the image.";

  /// Create post
  static const String createPostTitle = "Create post";
  static const String createPostButton = "Create post";
  static const String hashtagsLabel = "Hashtags";

}