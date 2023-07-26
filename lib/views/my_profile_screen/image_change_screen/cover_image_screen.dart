import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/controllers/settings_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class CoverImageScreen extends StatelessWidget {
  String coverPhoto;
  CoverImageScreen({Key? key, required this.coverPhoto}) : super(key: key);
  var settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            )),
        title: Text(
          'Update Cover Photo',
          style: GoogleFonts.openSans(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Obx(() => Column(
                children: [
                  InkWell(
                    child: const ListTile(
                      leading: Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                      title: Text('Take photo from gallery'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    onTap: () async {
                      await settingsController.changeImage(
                          context: context, method: "gallery");
                      // Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: const ListTile(
                      leading: Icon(
                        Icons.camera_alt_outlined,
                      ),
                      title: Text('Take photo from camera'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    onTap: () async {
                      await settingsController.changeImage(
                          context: context, method: "camera");
                      // Navigator.pop(context);
                    },
                  ),
                  50.heightBox,
                  settingsController.profileImagePath.value.isNotEmpty
                      ? Image.file(
                          File(settingsController.profileImagePath.value),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          coverPhoto,
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                  InkWell(
                    onTap: () async {
                      settingsController.loading(true);
                      await settingsController.uploadCoverImage(
                          context: context);
                      VxToast.show(context, msg: "Cover Photo Updated.");
                      settingsController.loading(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: settingsController.loading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
