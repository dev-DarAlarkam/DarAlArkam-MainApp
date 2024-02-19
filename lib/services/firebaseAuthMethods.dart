import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../ui/home/home.dart';
import './utils/showSnackBar.dart';


class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  static bool signedWithGoogle = false;
  FirebaseAuthMethods(this._auth);


  //Sign in with Email
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context}) async
  {
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await sendEmailVerification(context);
      }
      on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message!);
      }
  }

  //Email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try{
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, "تم ارسال رسالة تأكيد لبريدك الالكتروني");
    } on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);
    }
  }

  //Email SignIn
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context}) async
  {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
          await _auth.signInWithCredential(credential);
          signedWithGoogle = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  //FACEBOOK SIGN IN
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  //APPLE SIGN IN
  Future<void> signInWithApple(BuildContext context) async {
    //todo: make it only for the apple users (check the platform and then based on the continue

    try {

      final appleProvider = AppleAuthProvider();
      await _auth.signInWithProvider(appleProvider);

    } on FirebaseAuthException catch(e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  Future<void> signOut(BuildContext context) async {
    if (signedWithGoogle){
      GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.disconnect();
      signedWithGoogle = false;
    }
    await _auth.signOut()
        .then((value) => Navigator.pop(context, const Home()))
        .then((value) {showSnackBar(context, "لقد تم تسجيل الخروج بنجاح!");});
  }
}


