import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/settings_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageAccountScreen extends StatelessWidget {
  ManageAccountScreen({Key? key}) : super(key: key);
  var controller = Get.put(SettingsController());
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.blue,
        ).onTap(() {
          Get.back();
        }),
        title: Text(
          'Manage your account',
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue),
        ),
        actions: [
          const CircleAvatar(child: Icon(Icons.person)).marginOnly(right: 15)
        ],
      ),
      body: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                var userData = await fireStore
                    .collection(userCollection)
                    .doc(auth.currentUser!.uid)
                    .get();
                if (userData!['verified']) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.5)),
                          backgroundColor: Colors.white,
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    "You're already a verified user.",
                                    style: GoogleFonts.openSans(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          backgroundColor: Colors.white,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                'Enter Verification Key ',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.blue),
                              ).marginAll(8.0),
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: TextFormField(
                                  controller:
                                      controller.verificationKeyController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                      hintText: 'Verification Key',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      margin: EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Close',
                                        style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  15.widthBox,
                                  InkWell(
                                    onTap: () async {
                                      focusNode.unfocus();
                                      await controller.verifyAccount(
                                          key: controller
                                              .verificationKeyController.text
                                              .toString(),
                                          context: context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      margin: EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Verify',
                                        style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
              },
              child: Card(
                margin: const EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.1)),
                child: ListTile(
                  leading: Icon(
                    Icons.verified_user_sharp,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Verify your account ?',
                    style: GoogleFonts.openSans(
                        // color: Colors.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.61)),
                  ),
                  subtitle: Text(
                    'Make yourself verified. Let people trust you more.',
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        backgroundColor: Colors.white,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text(
                              'Add Bio here',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ).marginAll(8.0),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0)),
                              child: TextFormField(
                                maxLines: 8,
                                controller: controller.bioController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                    hintText: 'Your Bio',
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
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    margin: EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                15.widthBox,
                                InkWell(
                                  onTap: () async {
                                    focusNode.unfocus();
                                    await controller.updateUserBio(
                                        bio: controller.bioController.text
                                            .toString(),
                                        context: context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    margin: EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Save',
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Card(
                margin: const EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.1)),
                child: ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Add your Bio ?',
                    style: GoogleFonts.openSans(
                        // color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.61)),
                  ),
                  subtitle: Text(
                    'Tell something about you. Let people know about you more.',
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
