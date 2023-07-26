import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/views/auth_screen/login_screen.dart';
import 'package:the_nit_community/views/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      // Get.offAll(()=>  LoginScreen());

      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.offAll(() => LoginScreen());
        } else {
          Get.offAll(() => HomeScreen());
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5890FF).withOpacity(0.08),
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
