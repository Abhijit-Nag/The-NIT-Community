import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  var loading = false.obs;

  loginWithEmailPassword(
      {required email, required password, required context}) async {
    loading(true);
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        VxToast.show(context, msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        VxToast.show(context, msg: "Wrong password provided for that user.");
      }
    }
    loading(false);
  }

  signUpWithEmail({required email, required password, required context}) async {
    loading(true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);
      // if(auth.currentUser!=null){
      //   await auth.currentUser!.updateDisplayName(nameController.text);
      // }
      await credential.user!.updateDisplayName(nameController.text);
      await credential.user!.updatePhotoURL("");
      print('user display name: ${credential.user!.displayName}');
      print('auth user display name: ${auth.currentUser!.displayName}');
      // print(credential.di)

      await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .set({
        "username": nameController.text.toString(),
        "password": password,
        "email": email,
        "auth_provider": credential.user?.providerData[0].providerId,
        "user_profile_photo": credential.user?.providerData[0].photoURL ?? "",
        "friend_requests": FieldValue.arrayUnion([]),
        "friend_request_sent": FieldValue.arrayUnion([]),
        "friends": FieldValue.arrayUnion([]),
        "blocked_friends": FieldValue.arrayUnion([]),
        "followers": FieldValue.arrayUnion([]),
        "followings": FieldValue.arrayUnion([]),
        "verified": false,
        "bio":"",
        "coverPhoto":"https://cdn.quotesgram.com/img/29/87/1410104370-11586.jpg"
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        VxToast.show(context, msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        VxToast.show(context,
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
    loading(false);
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    print('user after google login: ${auth.currentUser!.uid}');

    var result = await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .get();
    if(result.exists){

    }
    else {
      print('result from database: ${result.data()}');
      await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .set({
        "username": auth.currentUser!.displayName,
        "password": "",
        "email": auth.currentUser!.email,
        "auth_provider": auth.currentUser!.providerData[0].providerId,
        "user_profile_photo": auth.currentUser!.providerData[0].photoURL,
        "friend_requests": FieldValue.arrayUnion([]),
        "friend_request_sent": FieldValue.arrayUnion([]),
        "friends": FieldValue.arrayUnion([]),
        "blocked_friends": FieldValue.arrayUnion([]),
        "followers": FieldValue.arrayUnion([]),
        "followings": FieldValue.arrayUnion([]),
        "verified": false,
        "bio": "",
        "coverPhoto":
            "https://cdn.quotesgram.com/img/29/87/1410104370-11586.jpg"
      }, SetOptions(merge: true));
    }
  }

  updateProfile() async {}
}
