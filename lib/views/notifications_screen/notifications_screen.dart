import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/notification_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/chat_screen/message_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/post_screen/post_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class NotificationsScreen extends StatelessWidget {
  Map<String, dynamic> userData;
  NotificationsScreen({Key? key, required this.userData}) : super(key: key);
  var controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notifications',
                  style: GoogleFonts.firaSans(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )).marginOnly(left: 10),
            StreamBuilder(
                stream: FirebaseServices.getUserNotifications(
                    userID: auth.currentUser!.uid),
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
                  if (data.isEmpty) {
                    return Center(
                      child: Image.asset(
                        'assets/images/no-notification.png',
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    );
                  }
                  print('length of notification data: ${data.length}');
                  print(userData['userID']);
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        print('notification data: $data');
                        return Column(
                          children: [
                            const Divider(
                              endIndent: 250,
                            ),
                            InkWell(
                              child: ListTile(
                                leading: data[index]
                                            ['notificationFromUserPhoto']
                                        .toString()
                                        .isEmpty
                                    ? const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ).onTap(() {
                                        Get.to(() => FriendProfileScreen(
                                            username: data[index]
                                                ['notificationFromUsername'],
                                            userPhoto: data[index]
                                                ['notificationFromUserPhoto'],
                                            userID: data[index]
                                                ['notificationFromUserID']));
                                      })
                                    : Image.network(
                                        data[index]
                                            ['notificationFromUserPhoto'],
                                        width: 35,
                                      ).onTap(() {
                                        Get.to(() => FriendProfileScreen(
                                            username: data[index]
                                                ['notificationFromUsername'],
                                            userPhoto: data[index]
                                                ['notificationFromUserPhoto'],
                                            userID: data[index]
                                                ['notificationFromUserID']));
                                      }),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index]
                                              ['notificationFromUsername'],
                                          style: GoogleFonts.firaSans(
                                              fontWeight: FontWeight.w600),
                                        ).onTap(() {
                                          Get.to(() => FriendProfileScreen(
                                              username: data[index]
                                                  ['notificationFromUsername'],
                                              userPhoto: data[index]
                                                  ['notificationFromUserPhoto'],
                                              userID: data[index]
                                                  ['notificationFromUserID']));
                                        }),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              intl.DateFormat("h:mma").format(data[
                                                          index][
                                                      'notification_created_on']
                                                  .toDate()),
                                              style: GoogleFonts.firaSans(
                                                  fontSize: 12.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
                                            ),
                                            Text(
                                              intl.DateFormat("yMMMMd").format(
                                                  data[index][
                                                          'notification_created_on']
                                                      .toDate()),
                                              style: GoogleFonts.firaSans(
                                                  fontSize: 12.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  data[index]['notificationMessage'],
                                  style: GoogleFonts.firaSans(),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ListView(
                                              shrinkWrap: true,
                                              children: [
                                                ListTile(
                                                  leading: data[index][
                                                              'notificationFromUserPhoto']
                                                          .toString()
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          data[index][
                                                                  'notificationFromUserPhoto']
                                                              .toString(),
                                                          width: 35,
                                                        ).onTap(() {
                                                          Get.to(() => FriendProfileScreen(
                                                              username: data[
                                                                      index][
                                                                  'notificationFromUsername'],
                                                              userPhoto: data[
                                                                      index][
                                                                  'notificationFromUserPhoto'],
                                                              userID: data[
                                                                      index][
                                                                  'notificationFromUserID']));
                                                        })
                                                      : const CircleAvatar(
                                                          child: Icon(
                                                              Icons.person),
                                                        ).onTap(() {
                                                          Get.to(() => FriendProfileScreen(
                                                              username: data[
                                                                      index][
                                                                  'notificationFromUsername'],
                                                              userPhoto: data[
                                                                      index][
                                                                  'notificationFromUserPhoto'],
                                                              userID: data[
                                                                      index][
                                                                  'notificationFromUserID']));
                                                        }),
                                                  title: Text(
                                                    data[index][
                                                        'notificationFromUsername'],
                                                    style: GoogleFonts.openSans(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
                                                  ).onTap(() {
                                                    Get.to(() => FriendProfileScreen(
                                                        username: data[index][
                                                            'notificationFromUsername'],
                                                        userPhoto: data[index][
                                                            'notificationFromUserPhoto'],
                                                        userID: data[index][
                                                            'notificationFromUserID']));
                                                  }),
                                                ),
                                                const Divider(),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        () => MessageScreen(),
                                                        arguments: [
                                                          data[index][
                                                              'notificationFromUsername'],
                                                          data[index][
                                                              'notificationFromUserID']
                                                        ]);
                                                  },
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.message_rounded,
                                                      color: Colors.blue,
                                                    ),
                                                    title: Text(
                                                        "Message ${data[index]['notificationFromUsername']}"),
                                                    subtitle: Text(
                                                      "Start messaging with ${data[index]['notificationFromUsername']}.",
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await controller
                                                        .removeNotification(
                                                            notificationID:
                                                                data[index].id);
                                                  },
                                                  child: ListTile(
                                                      leading: const Icon(Icons
                                                          .remove_circle_outlined),
                                                      title: Text(
                                                          "Remove notification?"),
                                                      subtitle: Text(
                                                        "Don't want to see this notification? You can remove it from here.",
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .grey),
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await controller.markAsRead(
                                                        notificationID:
                                                            data[index].id);
                                                  },
                                                  child: ListTile(
                                                      leading: const Icon(
                                                        Icons
                                                            .mark_chat_read_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      title:
                                                          Text("Mark as read "),
                                                      subtitle: Text(
                                                        "Mark this notification as read.",
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .grey),
                                                      )),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.more_horiz)),
                              )
                                  .box
                                  .color(data[index]['notification_read']
                                      ? Colors.white
                                      : Colors.blue.withOpacity(0.15))
                                  .make(),
                              onTap: () async {
                                await controller.markAsRead(
                                    notificationID: data[index].id);
                                print(
                                    'this is notification data : ${data[index].data()}');
                                if (data[index]['notification_type'] ==
                                    "reaction") {
                                  //  go to the post page
                                  Get.to(() => PostScreen(
                                        postID: data[index]
                                            ['notificationPostID'],
                                      ));
                                } else if (data[index]['notification_type'] ==
                                    "posts") {
                                  Get.to(() => PostScreen(
                                      postID: data[index]
                                          ['notificationPostID']));
                                } else {
                                  //  go the user profile page whose notification has come to you
                                  Get.to(() => FriendProfileScreen(
                                      username: data[index]
                                          ['notificationFromUsername'],
                                      userPhoto: data[index]
                                          ['notificationFromUserPhoto'],
                                      userID: data[index]
                                          ['notificationFromUserID']));
                                }
                              },
                            ),
                          ],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
