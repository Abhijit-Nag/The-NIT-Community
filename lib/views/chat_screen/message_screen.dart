import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/chat_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var controller = Get.put(ChatController());
  // final FocusNode focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  @override

  // @override
  // void initState() {
  //   Future.delayed(const Duration(milliseconds: 3500), () {
  //     print('hello!');
  //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  //   });
  //
  //   super.initState();
  // }

  // final messageFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseServices.getFriendDetails(userID: Get.arguments[1]),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          var friendData = snapshot.data!.data() as Map<String, dynamic>?;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      15.widthBox,
                      friendData!['user_profile_photo'].toString().isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  friendData['user_profile_photo']),
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                      15.widthBox,
                      Text(Get.arguments[0]).onTap(() {
                        Get.to(() => FriendProfileScreen(
                            username: friendData!['username'],
                            userPhoto: friendData!['user_profile_photo'],
                            userID: snapshot.data!.id));
                      })
                    ],
                  ),
                  const Divider(
                    thickness: 0.25,
                  )
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Expanded(
                      child: Container(
                        // color: Colors.yellow,
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : StreamBuilder(
                                stream: FirebaseServices.getMessages(
                                    chatDocID: controller.chatDocID.toString()),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  var data = snapshot.data!.docs;
                                  var prevDate = "";

                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOut,
                                    );
                                  });

                                  print(
                                      'this is focus status: ${controller.focusNode.value.hasFocus}');

                                  if (data.isEmpty) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'You have no conversation with ${friendData['username']}.Start messaging with ${friendData['username']}.',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.black.withOpacity(0.48)),
                                      ).marginSymmetric(horizontal: 20),
                                    );
                                  }

                                  return ListView.builder(
                                      itemCount: data.length,
                                      controller: _scrollController,
                                      itemBuilder: (context, index) {
                                        if (data[index]['created_on'] == null) {
                                          return Text(
                                            'Fetching messages..',
                                            style: GoogleFonts.openSans(
                                                color: Colors.grey),
                                          );
                                        }
                                        var show = false;

                                        if (prevDate !=
                                            intl.DateFormat("yMMMMd").format(
                                                data[index]['created_on']
                                                    .toDate())) {
                                          show = true;
                                          prevDate = intl.DateFormat("yMMMMd")
                                              .format(data[index]['created_on']
                                                  .toDate());
                                        } else {
                                          show = false;
                                        }

                                        if (data[index]['uid'] ==
                                            auth.currentUser!.uid) {
                                          if (data[index]['created_on'] ==
                                              null) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Column(
                                            children: [
                                              show
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0)),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        prevDate,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.48),
                                                                fontSize: 12),
                                                      ),
                                                    )
                                                  : Container(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 150),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.15),
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      18.0),
                                                              topRight:
                                                                  Radius.circular(
                                                                      18.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      18.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0))),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[index]
                                                                  ['msg'],
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontSize: 13.1
                                                              ),
                                                            ),
                                                          ),
                                                          8.heightBox,
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  intl.DateFormat(
                                                                          "h:mma")
                                                                      .format(data[index]
                                                                              [
                                                                              'created_on']
                                                                          .toDate()),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts.openSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                2.widthBox,
                                                                data[index][
                                                                        'messageRead']
                                                                    ? const Icon(
                                                                        Icons
                                                                            .done_all_rounded,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            18,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .done_all_rounded,
                                                                        size:
                                                                            18,
                                                                      ).onTap(
                                                                        () {
                                                                        print(auth
                                                                            .currentUser!
                                                                            .photoURL);
                                                                      })
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  auth.currentUser!.photoURL !=
                                                          null
                                                      ? CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(auth
                                                                  .currentUser!
                                                                  .photoURL
                                                                  .toString()),
                                                        ).marginAll(3.0)
                                                      : const CircleAvatar(
                                                          child: Icon(
                                                              Icons.person),
                                                        ).marginAll(3.0),
                                                ],
                                              ).marginSymmetric(
                                                  vertical: 8.0,
                                                  horizontal: 3.0),
                                            ],
                                          );
                                        } else {
                                          if (data[index]['created_on'] ==
                                              null) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Column(
                                            children: [
                                              show
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0)),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        prevDate,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.48),
                                                                fontSize: 12),
                                                      ),
                                                    )
                                                  : Container(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  friendData['user_profile_photo']
                                                          .toString()
                                                          .isNotEmpty
                                                      ? CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(friendData[
                                                                      'user_profile_photo']
                                                                  .toString()),
                                                        ).marginAll(3.0)
                                                      : const CircleAvatar(
                                                          child: Icon(
                                                              Icons.person),
                                                        ).marginAll(3.0),
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 150),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange
                                                              .withOpacity(
                                                                  0.15),
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      18.0),
                                                              topRight:
                                                                  Radius.circular(
                                                                      18.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      18.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0))),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[index]
                                                                  ['msg'],
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontSize: 13.1
                                                              ),
                                                            ),
                                                          ),
                                                          8.heightBox,
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  intl.DateFormat(
                                                                          "h:mma")
                                                                      .format(data[index]
                                                                              [
                                                                              'created_on']
                                                                          .toDate()),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts.openSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                2.widthBox,
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).marginSymmetric(
                                                  vertical: 8.0,
                                                  horizontal: 3.0),
                                            ],
                                          );
                                        }
                                      });
                                }),
                        // height: 80,
                      ),
                    )),
                Obx(() => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: controller.msgController,
                        focusNode: controller.focusNode.value,
                        decoration: InputDecoration(
                            hintText: 'Type your message',
                            suffixIcon: const Icon(Icons.send).onTap(() async {
                              print(
                                  'the username in the message screen is: ${Get.arguments[0]}');
                              await controller.sendMessage(
                                  context: context,
                                  message: controller.msgController.text);
                            }),
                            prefixIcon: const CircleAvatar(
                              child: Icon(Icons.person),
                            ).marginAll(8.0),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ))
              ],
            ).color(Colors.orange.withOpacity(0.03)),
          );
        });
  }
}
