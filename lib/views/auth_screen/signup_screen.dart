import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/auth_controller.dart';
import 'package:the_nit_community/views/home_screen/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
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
                controller: controller.nameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    hintText: 'Username',
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
                              controller.loading(true);
                              await controller.signUpWithEmail(
                                  email: controller.emailController.text,
                                  password: controller.passwordController.text,
                                  context: context);
                              if (auth.currentUser != null) {
                                // VxToast.show(context, msg: "User registered successfully.");
                                Get.offAll(() => HomeScreen());
                              }
                              controller.loading(false);
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )),
                      );
              }),
              25.heightBox,
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    // print(auth.currentUser);
                  },
                  child: Text(
                    'Login to existing account?',
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
