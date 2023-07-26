import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/auth_controller.dart';
import 'package:the_nit_community/views/auth_screen/signup_screen.dart';
import 'package:the_nit_community/views/home_screen/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5890FF).withOpacity(0.12),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              50.heightBox,
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.green,
                    ),
                    hintText: 'Email',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none)),
              )
                  .box
                  .color(Colors.white.withOpacity(0.9))
                  .margin(const EdgeInsets.symmetric(horizontal: 35))
                  .roundedSM
                  .height(58)
                  .make(),
              15.heightBox,
              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Password',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none)),
              )
                  .box
                  .color(Colors.white.withOpacity(0.9))
                  .margin(const EdgeInsets.symmetric(horizontal: 35))
                  .roundedSM
                  .height(58)
                  .make(),
              15.heightBox,
              Obx(() {
                return controller.loading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3.0)),
                        width: MediaQuery.of(context).size.width * 0.31,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: TextButton(
                            onPressed: () async {
                              await controller.loginWithEmailPassword(
                                  email: controller.emailController.text,
                                  password: controller.passwordController.text,
                                  context: context);
                              print(auth.currentUser);
                              if (auth.currentUser != null) {
                                VxToast.show(context,
                                    msg: "User logged in successfully.");
                                Get.offAll(() => HomeScreen());
                              }
                              controller.loading(false);
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )),
                      );
              }),
              5.heightBox,
              const Divider(
                thickness: 0.3,
              ),
              Text(
                'Or you can login with another method',
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                ),
              ),
              5.heightBox,
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3)),
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.5),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      // await auth.signOut();
                      await controller.signInWithGoogle();
                      print('userData: ${auth.currentUser}');
                      if (auth.currentUser != null) {
                        VxToast.show(context,
                            msg: "User logged in successfully.");
                        Get.offAll(() => HomeScreen());
                      }
                    },
                    child: Row(
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                          width: 35,
                        ),
                        15.widthBox,
                        Text(
                          'Sign in with Google',
                          style: GoogleFonts.firaSans(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              15.heightBox,
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => SignUpScreen());
                    print(auth.currentUser);
                  },
                  child: Text(
                    'Create new account?',
                    style: GoogleFonts.firaSans(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
