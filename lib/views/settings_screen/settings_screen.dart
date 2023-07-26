import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/auth_controller.dart';
import 'package:the_nit_community/controllers/settings_controller.dart';
import 'package:the_nit_community/views/auth_screen/login_screen.dart';
import 'package:the_nit_community/views/my_profile_screen/my_profile_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:the_nit_community/views/settings_screen/manage_account_screen.dart';
import 'package:the_nit_community/views/settings_screen/manage_post_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsScreen extends StatelessWidget {
  var controller = Get.put(SettingsController());

  var authController = Get.put(AuthController());
  SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w600, fontSize: 22),
                    ).marginOnly(left: 15),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => ManagePostScreen());
                          },
                          child: CircleAvatar(
                                  backgroundColor:
                                      Colors.grey.withOpacity(0.15),
                                  child: Icon(Icons.settings))
                              .marginOnly(right: 15),
                        ),
                        CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(0.15),
                                child: Icon(Icons.search))
                            .onTap(() {
                          Get.to(() => SearchUserScreen());
                        })
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => MyProfileScreen());
                  },
                  child: ListTile(
                    leading: auth.currentUser!.photoURL!= null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                auth.currentUser!.photoURL.toString()),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                    title: Text(
                      auth.currentUser!.displayName.toString(),
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'See your profile',
                      style: GoogleFonts.openSans(
                          color: Colors.black.withOpacity(0.61),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            InkWell(
              onTap: () {
                Get.to(() => ManagePostScreen());
              },
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.manage_accounts_outlined),
                ),
                title: Text('Manage your posts'),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: ListView(shrinkWrap: true, children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'You can delete your post here. Click on it.',
                                      style: GoogleFonts.openSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                )
                              ]),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.help_center,
                      color: Colors.blue,
                    )),
              ),
            ),
            const Divider(
              thickness: 0.2,
            ),
            ExpansionTile(
              title: const Text('Help & Support'),
              leading: const CircleAvatar(child: Icon(Icons.question_mark_outlined)),
              children: [
                // Card(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(2.0)),
                //   elevation: 3,
                //   margin: const EdgeInsets.all(8.0),
                //   child: const ListTile(
                //     leading: Icon(
                //       Icons.assistant,
                //       color: Colors.blue,
                //     ),
                //     title: Text('Help Center'),
                //   ).color(Colors.white),
                // ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.5),
                                  color: Colors.white),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Text(
                                    'Type the issue you faced and send to us',
                                    style: GoogleFonts.openSans(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Divider(
                                    endIndent: 150,
                                  ).centered(),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: controller.feedbackController,
                                      decoration: InputDecoration(
                                          hintText: 'Enter your problem',
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.5),
                                              color: Colors.blue),
                                          child: Text(
                                            'Exit',
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.1),
                                          ),
                                        ),
                                      ),
                                      8.widthBox,
                                      InkWell(
                                        onTap: () async {
                                          if(controller.feedbackController.text.toString().isEmpty){
                                            VxToast.show(context, msg: "Please type feedback first.");
                                          }
                                          else {
                                            await controller.sendFeedBack(
                                                text: controller
                                                    .feedbackController.text
                                                    .toString());
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3.5)),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: [
                                                          Center(
                                                              child: Text(
                                                            'Thank you for your feedback!',
                                                            style: GoogleFonts
                                                                .firaSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        15.1,
                                                                    color: Colors
                                                                        .blue),
                                                          )),
                                                          Center(
                                                              child: Text(
                                                            'We will reach to you soon.',
                                                            style: GoogleFonts.firaSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 15.1,
                                                                color: Colors
                                                                    .orange
                                                                    .withOpacity(
                                                                        0.48)),
                                                          )),
                                                          15.heightBox,
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              width: 50,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.5),
                                                                  color: Colors
                                                                      .blue),
                                                              child: Text(
                                                                'Close',
                                                                style: GoogleFonts.openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15.1),
                                                              ).centered(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.5),
                                              color: Colors.blue),
                                          child: Text(
                                            'Send',
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0)),
                    elevation: 3,
                    margin: const EdgeInsets.all(8.0),
                    child: const ListTile(
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      title: Text('Report a problem'),
                    ).color(Colors.white),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0)),
                  elevation: 3,
                  margin: const EdgeInsets.all(8.0),
                  child: const ListTile(
                    leading: Icon(
                      Icons.my_library_books_rounded,
                      color: Colors.blue,
                    ),
                    title: Text('Terms & Policies'),
                  ).color(Colors.white),
                )
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            InkWell(
              onTap: () {
                Get.to(() => ManageAccountScreen());
              },
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Manage your account'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Divider(
              thickness: 0.2,
            ),
            Obx(() => Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.grey.withOpacity(0.3)),
                  child: authController.loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'Log out',
                          style:
                              GoogleFonts.openSans(fontWeight: FontWeight.w600),
                        ).centered(),
                ).onTap(() async {
                  authController.loading(true);
                  var providerID =
                      (auth.currentUser!.providerData[0].providerId);
                  print(providerID);
                  if (providerID == 'google.com') {
                    await GoogleSignIn().disconnect();
                  }
                  await auth.signOut();
                  Get.offAll(() => LoginScreen());
                  authController.loading(false);
                  VxToast.show(context, msg: "Logged out.");
                }))
          ],
        ).marginSymmetric(horizontal: 15),
      ),
    );
  }
}
