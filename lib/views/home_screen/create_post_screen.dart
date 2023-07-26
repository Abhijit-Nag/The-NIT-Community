import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/post_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:velocity_x/velocity_x.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key}) : super(key: key);
  var controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post'),
        actions: [
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 5.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: (controller.isEmpty.value)
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(3.0)),
                child: Text(
                  controller.postLoading.value ? 'Publishing....' :
                  'POST',
                  style: GoogleFonts.firaSans(
                      color: (controller.isEmpty.value)
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ).onTap(() async {
                if (controller.isEmpty.value == false) {
                  controller.postLoading(true);
                  await controller.uploadPost(
                      userID: auth.currentUser!.uid,
                      postTitle: controller.titleController.text,
                      postDesc: controller.descController.text,
                      context: context,
                      photo: auth.currentUser!.photoURL ?? "",
                      username: auth.currentUser!.displayName);
                  controller.postLoading(false);
                  VxToast.show(context, msg: "Posted successfully!");
                  Get.back();
                } else {
                  VxToast.show(context,
                      msg: "Please add some description about your post.");
                }
              }))
        ],
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseServices.getUserDetails(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;
                print('user image : ${data['user_profile_photo']}');
                return Column(
                  children: [
                    ListTile(
                      leading: data['user_profile_photo'].toString().isEmpty
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : Image.network(
                              data['user_profile_photo'],
                              width: 35,
                            ),
                      title: Text(data['username']),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Row(
                              children: [
                                const Icon(Icons.public),
                                8.widthBox,
                                const Text('Public'),
                              ],
                            ),
                          ).onTap(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            'Your post is managed to public by default.',
                                            style: GoogleFonts.openSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      )
                                    ]),
                                  );
                                });
                          }),
                          15.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Row(
                              children: [
                                const Icon(Icons.add),
                                3.widthBox,
                                const Text('Album'),
                              ],
                            ),
                          ).onTap(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          child: Text(
                                            'Your post is managed to album by default.',
                                            style: GoogleFonts.openSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.justify,
                                          ),
                                          height: 80,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          padding: const EdgeInsets.all(20.0),
                                        ),
                                      )
                                    ]),
                                  );
                                });
                          })
                        ],
                      ),
                    ),
                    15.heightBox,
                    TextFormField(
                      controller: controller.descController,
                      maxLines: 8,
                      onChanged: (value) {
                        if (value == "") {
                          controller.isEmpty(true);
                        } else {
                          controller.isEmpty(false);
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.8)))),
                    ),
                    // const Divider(),
                    Obx(() => controller.postImagePath.value.isNotEmpty
                        ? Image.file(
                            File(controller.postImagePath.value),
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : Container()),
                    InkWell(
                      onTap: () async {
                        await controller.pickPostImage(
                            method: "gallery", context: context);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.crop_original_rounded,
                          color: Colors.orange,
                        ),
                        title: Text('Photo'),
                      ).box.border(width: 0.1).make(),
                    ),
                    InkWell(
                      onTap: () async {
                        await controller.pickPostImage(
                            method: "camera", context: context);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                        title: Text('Camera'),
                      ).box.border(width: 0.1).make(),
                    ),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 20.0),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          controller.isTitleEmpty(true);
                                        } else {
                                          controller.isTitleEmpty(false);
                                          controller.title(value);
                                        }
                                      },
                                      maxLines: 3,
                                      controller: controller.titleController,
                                      decoration: InputDecoration(
                                        hintText: "Add appropriate title",
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      leading: const Icon(
                        Icons.title,
                      ),
                      title: const Text('Add title'),
                    ).box.border(width: 0.1).make(),
                    Obx(() => controller.isTitleEmpty.value
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: ListTile(
                              leading: Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange, width: 3),
                                      borderRadius: BorderRadius.circular(3.0)),
                                  child: const Icon(Icons.title)),
                              title: Text(controller.title.value),
                            )))
                  ],
                );
              })),
    );
  }
}
