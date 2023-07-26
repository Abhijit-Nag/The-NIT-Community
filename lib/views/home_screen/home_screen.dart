import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/auth_screen/login_screen.dart';
import 'package:the_nit_community/views/chat_screen/chat_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/friend_request_screen/friend_request_screen.dart';
import 'package:the_nit_community/views/home_screen/create_post_screen.dart';
import 'package:the_nit_community/views/home_screen/home.dart';
import 'package:the_nit_community/views/notifications_screen/notifications_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:the_nit_community/views/settings_screen/settings_screen.dart';
import 'package:the_nit_community/views/tv_screen/tv_screen.dart';
import 'package:the_nit_community/widgets/exit_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context, builder: (context) => exitDialog(context));
            return false;
          },
          child: StreamBuilder(
              stream: FirebaseServices.getUserDetails(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                if (snapshot.data!.data() == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                print('this is userData: $userData');
                var friendRequestNumber = userData['friend_requests'].length;
                // var friendRequestNumber = 0;

                return StreamBuilder(
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

                      var notificationData = snapshot.data!.docs;
                      var notificationNumber = 0;
                      // print('this is notification length in testing mode of app : ${notificationData.length}');

                      for (int i = 0; i < notificationData.length; i++) {
                        if (notificationData[i]['notification_read'] == false) {
                          notificationNumber++;
                        }
                      }
                      return Scaffold(
                        appBar: AppBar(
                          // backgroundColor: Colors.orange.withOpacity(0.5),
                          automaticallyImplyLeading: false,
                          toolbarHeight: 100,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'The NIT Community',
                                    style: GoogleFonts.firaSans(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 21),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            // Get.to(()=> FriendProfileScreen());
                                            // Get.put(FriendController()).updateAuthProfileImage();
                                            print(
                                                'image is : ${userData['user_profile_photo']}');
                                            Get.to(() => CreatePostScreen());
                                          },
                                          icon: const Icon(Icons.add).circle(
                                              radius: 35,
                                              backgroundColor: Colors.grey
                                                  .withOpacity(0.2))),
                                      IconButton(
                                          onPressed: () {
                                            Get.to(() => SearchUserScreen());
                                          },
                                          icon: const Icon(Icons.search).circle(
                                              radius: 35,
                                              backgroundColor: Colors.grey
                                                  .withOpacity(0.2))),
                                      StreamBuilder(
                                          stream: FirebaseServices.getMyChats(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return IconButton(
                                                  onPressed: () async {
                                                    Get.to(() => ChatScreen());
                                                  },
                                                  icon: const Icon(
                                                    Icons.chat,
                                                    color: Colors.blue,
                                                  ).circle(
                                                      radius: 35,
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withOpacity(0.2)));
                                            }
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    snapshot.error.toString()),
                                              );
                                            }

                                            var messageData =
                                                snapshot.data!.docs;
                                            int pending = 0;
                                            for (int i = 0;
                                                i < messageData.length;
                                                i++) {
                                              if (messageData[i]['chatRead'] ==
                                                      false &&
                                                  messageData[i]['fromID'] !=
                                                      auth.currentUser!.uid) {
                                                pending++;
                                              }
                                            }
                                            return InkWell(
                                              onTap: () {
                                                Get.to(() => ChatScreen());
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.chat,
                                                    color: Colors.blue,
                                                  ).circle(
                                                      radius: 35,
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withOpacity(0.2)),
                                                  pending > 0
                                                      ? Text(
                                                          pending > 99
                                                              ? '$pending+'
                                                              : pending
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                          .box
                                                          .color(Colors.blue
                                                              .withOpacity(
                                                                  0.15))
                                                          .roundedFull
                                                          .padding(
                                                              const EdgeInsets
                                                                  .all(3.35))
                                                          .make()
                                                          .marginOnly(
                                                            bottom: 15,
                                                          )
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  )
                                ],
                              ),
                              8.heightBox,
                              TabBar(
                                tabs: [
                                  Icon(Icons.home_outlined),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.group_outlined),
                                      Text(
                                        friendRequestNumber > 99
                                            ? '$friendRequestNumber+'
                                            : friendRequestNumber.toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                          .box
                                          .color(Colors.blue.withOpacity(0.15))
                                          .roundedFull
                                          .padding(const EdgeInsets.all(3.35))
                                          .make()
                                          .marginOnly(
                                            bottom: 15,
                                          )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.notifications_outlined),
                                      Text(
                                        notificationNumber > 99
                                            ? '$notificationNumber+'
                                            : notificationNumber.toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                          .box
                                          .color(Colors.blue.withOpacity(0.15))
                                          .roundedFull
                                          .padding(const EdgeInsets.all(3.35))
                                          .make()
                                          .marginOnly(
                                            bottom: 15,
                                          )
                                    ],
                                  ),
                                  Icon(Icons.menu),
                                ],
                              ),
                            ],
                          ).paddingOnly(bottom: 10),
                        ),
                        body: TabBarView(
                          children: [
                            Home(photoURL: userData['user_profile_photo']),
                            FriendRequestScreen(),
                            // FriendProfileScreen(),
                            // TvScreen(),
                            NotificationsScreen(userData: userData),
                            SettingsScreen(),
                          ],
                        ),
                      );
                    });
              })),
    );
  }
}
