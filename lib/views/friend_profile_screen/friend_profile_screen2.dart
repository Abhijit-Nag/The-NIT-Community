import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/controllers/home_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/chat_screen/message_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/follower_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen2.dart';
import 'package:the_nit_community/views/friends_screen/user_all_friends_screen.dart';
import 'package:the_nit_community/views/home_screen/home_screen.dart';
import 'package:the_nit_community/views/my_profile_screen/my_profile_screen.dart';
import 'package:the_nit_community/widgets/exit_dialog.dart';
import 'package:the_nit_community/widgets/info_dialog.dart';
import 'package:the_nit_community/widgets/post_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class FriendProfileScreen2 extends StatelessWidget {
  String username, userPhoto, userID;
  FriendProfileScreen2(
      {Key? key,
      required this.username,
      required this.userPhoto,
      required this.userID})
      : super(key: key);

  var homeController = Get.put(HomeController());
  var controller = Get.put(FriendController());
  @override
  Widget build(BuildContext context) {
    if (userID == auth.currentUser!.uid) {
      return MyProfileScreen();
    }
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(username.isNotEmpty ? username : ''),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StreamBuilder for friends
              StreamBuilder(
                  stream: FirebaseServices.getUserDetails(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    var myUserDataSnapshot = snapshot.data;
                    var myUserData =
                        myUserDataSnapshot!.data() as Map<String, dynamic>?;

                    //stream builder for getting friendDetails
                    return StreamBuilder(
                        stream:
                            FirebaseServices.getFriendDetails(userID: userID),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          var dataSnapshot = snapshot.data;
                          var data =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          List<dynamic> followers = data!['followers'];
                          // var friendData=data;
                          var friends = data?['friends'];
                          print(friends);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      height: 250,
                                      padding:
                                          const EdgeInsets.only(bottom: 58),
                                      child: Image.network(
                                        "https://cdn.quotesgram.com/img/29/87/1410104370-11586.jpg",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        height: 98,
                                        fit: BoxFit.cover,
                                      )).onTap(() {
                                    print('image is $auth.');
                                  }),
                                  Positioned(
                                      top: 60,
                                      left: 10,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 92,
                                          child: data!['user_profile_photo']
                                                  .toString()
                                                  .isEmpty
                                              ? const CircleAvatar(
                                                  radius: 50,
                                                  child: Icon(
                                                    Icons.person_add_alt_1,
                                                    size: 50,
                                                  ),
                                                )
                                              : Image.network(
                                                  // "https://timelinecovers.pro/facebook-cover/download/light-of-the-world-john-christian-facebook-cover.jpg",
                                                  data!['user_profile_photo']
                                                      .toString(),
                                                  width: 115,
                                                  height: 115,
                                                  fit: BoxFit.cover,
                                                ))),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() =>
                                                FollowerScreen(userID: userID));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Followers ',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.blue),
                                              ),
                                              Text(
                                                '${data['followers'].length}+',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.blue),
                                              ).marginOnly(left: 3.0),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons
                                                        .notifications_on_outlined,
                                                    color: Colors.blue,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              15.heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            username,
                                            style: GoogleFonts.firaSans(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600),
                                          ).marginOnly(left: 25),
                                          8.widthBox,
                                          data!['verified']
                                              ? Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                ).onLongPress(() {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.5)),
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white),
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              children: [
                                                                ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons
                                                                        .verified,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  title: Text(
                                                                    "${data!['username']} is a verified user.",
                                                                    style: GoogleFonts.openSans(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }, key)
                                              : Container()
                                        ],
                                      ),
                                      myUserData!['blocked_friends'].any(
                                              (element) => element == userID)
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0)),
                                              child: Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (followers.any(
                                                          (element) =>
                                                              element[
                                                                  'userID'] ==
                                                              auth.currentUser!
                                                                  .uid)) {
                                                      } else {
                                                        await controller
                                                            .followUser(
                                                                userID: userID,
                                                                username:
                                                                    username,
                                                                userPhoto:
                                                                    userPhoto);
                                                      }
                                                    },
                                                    child: Text(
                                                      'Blocked',
                                                      style:
                                                          GoogleFonts.openSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.block_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ).scale(scaleValue: 0.61)
                                          : Container()
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 15.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    child: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            if (followers.any((element) =>
                                                element['userID'] ==
                                                auth.currentUser!.uid)) {
                                            } else {
                                              await controller.followUser(
                                                  userID: userID,
                                                  username: username,
                                                  userPhoto: userPhoto);
                                            }
                                          },
                                          child: Text(
                                            followers.any((element) =>
                                                    element['userID'] ==
                                                    auth.currentUser!.uid)
                                                ? 'Following..'
                                                : 'Follow',
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Icon(
                                          followers.any((element) =>
                                                  element['userID'] ==
                                                  auth.currentUser!.uid)
                                              ? Icons.person
                                              : Icons.add,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              15.heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      25.widthBox,
                                      data?['friends'].any((element) =>
                                              element['userID'] ==
                                              auth.currentUser!.uid)
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0)),
                                              child: Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Friends',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.group,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : data?['friend_request_sent'].any(
                                                  (element) =>
                                                      element['userID'] ==
                                                      auth.currentUser!.uid)
                                              ? Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.0)),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .person_add_alt_1_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          var friendData = {
                                                            "username": data[
                                                                'username'],
                                                            "userPhoto": data[
                                                                'user_profile_photo'],
                                                            "userID":
                                                                dataSnapshot
                                                                    ?.id,
                                                            "email":
                                                                data['email']
                                                          };
                                                          await controller
                                                              .acceptFriendRequest(
                                                                  friendData:
                                                                      friendData);
                                                        },
                                                        child: Text(
                                                          'Confirm',
                                                          style: GoogleFonts
                                                              .firaSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : data['friend_requests'].any(
                                                      (element) =>
                                                          element['userID'] ==
                                                          auth.currentUser!.uid)
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3.0)),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                          ),
                                                          TextButton(
                                                            onPressed: () {},
                                                            child: Text(
                                                              'Request sent',
                                                              style: GoogleFonts.firaSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3.0)),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .person_add_alt_1_rounded,
                                                            color: Colors.white,
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await controller
                                                                  .sendFriendRequest(
                                                                      userData:
                                                                          data,
                                                                      sendUserID:
                                                                          dataSnapshot!
                                                                              .id);
                                                              VxToast.show(
                                                                  context,
                                                                  msg:
                                                                      "Friend request sent.");
                                                            },
                                                            child: Text(
                                                              'Add friend',
                                                              style: GoogleFonts.firaSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                      15.widthBox,
                                      data?['blocked_friends'].any((element) =>
                                              element == auth.currentUser!.uid)
                                          ? InkWell(
                                              onTap: () {
                                                const info =
                                                    "Unfortunately you are blocked by your friend. You can't see his/her friends.\nPlease request your friend to unblock you to continue to message";
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        infoDialog(
                                                            context, info));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.58),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.0)),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.message_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    10.widthBox,
                                                    Text(
                                                      'Message',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ).marginOnly(right: 8.0),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0)),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.message_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      print(
                                                          'message button clicked.');
                                                      Get.to(
                                                          () => MessageScreen(),
                                                          arguments: [
                                                            data['username'],
                                                            dataSnapshot!.id
                                                          ]);
                                                    },
                                                    child: Text(
                                                      'Message',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.48),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    const Divider(
                                                      endIndent: 250,
                                                      thickness: 0.8,
                                                    ),
                                                    ListTile(
                                                      leading:
                                                          data['user_profile_photo']
                                                                  .toString()
                                                                  .isNotEmpty
                                                              ? Image.network(
                                                                  data['user_profile_photo']
                                                                      .toString(),
                                                                  width: 35,
                                                                ).onTap(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                })
                                                              : const CircleAvatar(
                                                                  child: Icon(Icons
                                                                      .person),
                                                                ).onTap(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                      title:
                                                          Text(data['username'])
                                                              .onTap(() {
                                                        Navigator.pop(context);
                                                      }),
                                                      // subtitle: Text('Friends since ${ intl.DateFormat("d MMMM y").format(allFriends[index]['friends_became_on'].toDate()) }', style: GoogleFonts.firaSans(
                                                      //     color: Colors.grey
                                                      // ),),
                                                    ),
                                                    const Divider(),
                                                    const Divider(
                                                      endIndent: 250,
                                                      thickness: 0.8,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            () =>
                                                                MessageScreen(),
                                                            arguments: [
                                                              data['username'],
                                                              dataSnapshot!.id
                                                            ]);
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(Icons
                                                            .message_rounded),
                                                        title: Text(
                                                            "Message ${data['username']}"),
                                                      ),
                                                    ),

                                                    const Divider(
                                                      endIndent: 250,
                                                      thickness: 0.25,
                                                    ),
                                                    //follow and unfollow button
                                                    InkWell(
                                                      onTap: () async {
                                                        if (followers.any(
                                                            (element) =>
                                                                element[
                                                                    'userID'] ==
                                                                auth.currentUser!
                                                                    .uid)) {
                                                          Navigator.pop(
                                                              context);
                                                          await controller
                                                              .unFollowUser(
                                                                  userID:
                                                                      userID);
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          await controller
                                                              .followUser(
                                                                  userID:
                                                                      userID,
                                                                  username:
                                                                      username,
                                                                  userPhoto:
                                                                      userPhoto);
                                                        }
                                                      },
                                                      child: ListTile(
                                                          leading: followers.any(
                                                                  (element) =>
                                                                      element[
                                                                          'userID'] ==
                                                                      auth.currentUser!
                                                                          .uid)
                                                              ? const Icon(Icons
                                                                  .remove_circle_outlined)
                                                              : const Icon(Icons
                                                                  .add_circle_outline),
                                                          title: Text(followers
                                                                  .any((element) =>
                                                                      element[
                                                                          'userID'] ==
                                                                      auth.currentUser!
                                                                          .uid)
                                                              ? "Unfollow ${data['username']}"
                                                              : "Follow ${data['username']}"),
                                                          subtitle: Text(
                                                            followers.any((element) =>
                                                                    element[
                                                                        'userID'] ==
                                                                    auth.currentUser!
                                                                        .uid)
                                                                ? 'Stop following ${data['username']} but stay friends.'
                                                                : 'Follow ${data['username']}',
                                                            style: GoogleFonts
                                                                .firaSans(
                                                                    color: Colors
                                                                        .grey),
                                                          )),
                                                    ),
                                                    const Divider(
                                                      endIndent: 250,
                                                      thickness: 0.8,
                                                    ),
                                                    //block and unblock button
                                                    myUserData!['blocked_friends']
                                                            .any((element) =>
                                                                element ==
                                                                userID)
                                                        ? InkWell(
                                                            child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .person_add_disabled),
                                                                title: Text(
                                                                    "Unblock ${data['username']}'s profile"),
                                                                subtitle: Text(
                                                                  "${data['username']} will be able to see you or contact you on The NIT Community.",
                                                                  style: GoogleFonts
                                                                      .firaSans(
                                                                          color:
                                                                              Colors.grey),
                                                                )),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await controller
                                                                  .unBlockFriend(
                                                                      friendID:
                                                                          dataSnapshot!
                                                                              .id,
                                                                      context:
                                                                          context);
                                                              VxToast.show(
                                                                  context,
                                                                  msg:
                                                                      "Your friend is unblocked");
                                                            },
                                                          )
                                                        : InkWell(
                                                            child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .person_add_disabled),
                                                                title: Text(
                                                                    "Block ${data['username']}'s profile"),
                                                                subtitle: Text(
                                                                  "${data['username']} won't be able to see you or contact you on The NIT Community.",
                                                                  style: GoogleFonts
                                                                      .firaSans(
                                                                          color:
                                                                              Colors.grey),
                                                                )),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await controller
                                                                  .blockFriend(
                                                                      friendID:
                                                                          dataSnapshot!
                                                                              .id,
                                                                      context:
                                                                          context);
                                                              VxToast.show(
                                                                  context,
                                                                  msg:
                                                                      "Your friend is blocked");
                                                            },
                                                          ),

                                                    const Divider(
                                                      endIndent: 250,
                                                      thickness: 0.25,
                                                    ),
                                                    //friend and unfriend button
                                                    InkWell(
                                                      child: ListTile(
                                                          leading: data['friends'].any((element) =>
                                                                  element['userID'] ==
                                                                  auth.currentUser!
                                                                      .uid)
                                                              ? const Icon(Icons
                                                                  .person_remove)
                                                              : const Icon(Icons
                                                                  .person_add_alt_1_rounded),
                                                          title: Text(
                                                              "Unfriend ${data['username']} "),
                                                          subtitle: Text(
                                                            "Remove ${data['username']} as a friend.",
                                                            style: GoogleFonts
                                                                .firaSans(
                                                                    color: Colors
                                                                        .grey),
                                                          )).color(data['friends']
                                                              .any((element) =>
                                                                  element['userID'] ==
                                                                  auth.currentUser!.uid)
                                                          ? Colors.grey.withOpacity(0.48)
                                                          : Colors.white.withOpacity(0.15)),
                                                      onTap: () async {
                                                        if (data['friends'].any(
                                                            (element) =>
                                                                element[
                                                                    'userID'] ==
                                                                auth.currentUser!
                                                                    .uid)) {
                                                          await controller
                                                              .unFriend(
                                                                  friendID:
                                                                      dataSnapshot!
                                                                          .id);
                                                          Navigator.pop(
                                                              context);
                                                          VxToast.show(context,
                                                              msg:
                                                                  "${data['username']} is not your friend anymore. You may send friend request to the user");
                                                        } else {
                                                          VxToast.show(context,
                                                              msg:
                                                                  "You're not friend of ${data['username']}.");
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 15.0),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          child: const Icon(Icons.more_horiz)))
                                ],
                              ),
                              data['bio'].toString().isNotEmpty ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    thickness: 0.2,
                                    endIndent: 250,
                                  ),
                                  Text(
                                    'Bio',
                                    style: GoogleFonts.firaSans(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ).marginOnly(left: 10),
                                  8.heightBox,

                                  Text(
                                    data['bio'],
                                    style: GoogleFonts.openSans(
                                        fontSize: 15, fontWeight: FontWeight.w500),
                                  ).marginSymmetric(horizontal: 25, vertical: 8.0)
                                ],
                              ) : Container(),
                              8.heightBox,
                              const Divider(
                                thickness: 0.8,
                                endIndent: 250,
                              ),
                              Text(
                                'Friends',
                                style: GoogleFonts.firaSans(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ).marginOnly(left: 10),
                              8.heightBox,

                              //StreamBuilder for mutual friends

                              StreamBuilder(
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
                                      child: Text(snapshot.toString()),
                                    );
                                  }

                                  var mutualFriends = [];
                                  var myUserData = snapshot.data!.data()
                                      as Map<String, dynamic>?;

                                  var myUserFriends = myUserData!['friends'];

                                  for (int i = 0;
                                      i < myUserFriends.length;
                                      i++) {
                                    for (int j = 0; j < friends.length; j++) {
                                      if (myUserFriends[i]['userID'] ==
                                          friends[j]['userID']) {
                                        mutualFriends.add(myUserFriends[i]);
                                      }
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${mutualFriends.length} mutual friends',
                                        style: GoogleFonts.firaSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.8),
                                      ).marginOnly(left: 10),
                                      2.heightBox,
                                      data?['blocked_friends'].any((element) =>
                                              element == auth.currentUser!.uid)
                                          ? Center(
                                              child: Stack(children: [
                                                Text("Unfortunately you are blocked by your friend. You can't see his/her friends.")
                                                    .marginSymmetric(
                                                        horizontal: 15),
                                                Positioned(
                                                    top: 6.18,
                                                    right: 35,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          var info =
                                                              "Unfortunately you are blocked by your friend. You can't see his/her friends.\nPlease request your friend to unblock you to see his/her friends.";
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  infoDialog(
                                                                      context,
                                                                      info));
                                                        },
                                                        icon: Icon(
                                                          Icons.info_rounded,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.58),
                                                        )))
                                              ]),
                                            )
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(
                                                    friends.length,
                                                    (index) => Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: friends[index]['userPhoto']
                                                                            .isEmpty
                                                                        ? const CircleAvatar(
                                                                            child:
                                                                                Icon(Icons.person),
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            // "https://timelinecovers.pro/facebook-cover/download/light-of-the-world-john-christian-facebook-cover.jpg",
                                                                            friends[index]['userPhoto'],
                                                                            width:
                                                                                125,
                                                                            height:
                                                                                125,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ))
                                                                .marginSymmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        5.0),
                                                            2.heightBox,
                                                            Text(
                                                              friends[index]
                                                                  ['username'],
                                                              style: GoogleFonts
                                                                  .firaSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15),
                                                            ).marginOnly(
                                                                left: 15)
                                                          ],
                                                        ).onTap(() {
                                                          print(
                                                              'friend clicked.');
                                                          print(friends[index]
                                                              ['username']);
                                                          print(friends[index]
                                                              ['userPhoto']);
                                                          print(friends[index]
                                                              ['userID']);
                                                          print(userID);
                                                          // Get.to(()=>HomeScreen());
                                                          // homeController.navigateToFriendProfileScreen(username: friends[index]['username'], userPhoto: friends[index]['userPhoto'], userID: friends[index]['userID']);
                                                          Get.to(() => FriendProfileScreen(
                                                              username: friends[
                                                                      index]
                                                                  ['username'],
                                                              userPhoto: friends[
                                                                      index]
                                                                  ['userPhoto'],
                                                              userID: friends[
                                                                      index]
                                                                  ['userID']));
                                                          print('route done');
                                                          // Get.to(()=> FriendProfileScreen(username: friends[index]['username'], userPhoto: friends[index]['userPhoto'], userID: friends[index]['userID']));
                                                        })),
                                              ),
                                            ),
                                      18.heightBox,
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 15.0),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          child: Center(
                                              child: Text(
                                            'See all friends',
                                            style: GoogleFonts.firaSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ))).centered().onTap(() {
                                        if (data?['blocked_friends'].any(
                                            (element) =>
                                                element ==
                                                auth.currentUser!.uid)) {
                                          var info =
                                              "Unfortunately you are blocked by your friend. You can't see his/her friends.\nPlease request your friend to unblock you to see his/her friends.";
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  infoDialog(context, info));
                                        } else {
                                          Get.to(() => UserAllFriendsScreen(
                                                userID: userID,
                                              ));
                                        }
                                      }),
                                    ],
                                  );
                                },
                              ),

                              25.heightBox,
                              Text(
                                'Posts',
                                style: GoogleFonts.firaSans(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ).marginOnly(left: 20),
                              const Divider(
                                endIndent: 150,
                              ).marginOnly(left: 8.0),

                              //StreamBuilder for posts
                              StreamBuilder(
                                  stream: FirebaseServices.getUserPosts(
                                      userID: userID),
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
                                    var postData = snapshot.data!.docs;
                                    if (postData.isEmpty) {
                                      return Center(
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                                'assets/images/no_post.png'),
                                            Positioned(
                                                top: 230,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'OOOOPS!!',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25),
                                                    ).marginOnly(
                                                        right: 100, left: 35),
                                                    10.heightBox,
                                                    Text(
                                                      'No Posts!',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      );
                                    }
                                    if (data?['blocked_friends'].any(
                                        (element) =>
                                            element == auth.currentUser!.uid)) {
                                      return Center(
                                        child: Stack(children: [
                                          Text("Unfortunately you are blocked by your friend. You can't see his/her posts.")
                                              .marginSymmetric(horizontal: 15),
                                          Positioned(
                                              top: 6.18,
                                              right: 35,
                                              child: IconButton(
                                                  onPressed: () {
                                                    const info =
                                                        "Unfortunately you are blocked by your friend. You can't see his/her posts.\nPlease request your friend to unblock you to see his/her posts.";
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            infoDialog(
                                                                context, info));
                                                  },
                                                  icon: Icon(
                                                    Icons.info_rounded,
                                                    color: Colors.black
                                                        .withOpacity(0.58),
                                                  )))
                                        ]),
                                      );
                                    }

                                    //show the posts
                                    return Column(
                                      children: List.generate(postData.length,
                                          (index) {
                                        var postID = postData[index].id;
                                        print(postID);
                                        var post = postData[index].data()
                                            as Map<String, dynamic>;
                                        return Post(
                                          verified: post['userVerified'],
                                          comments: post['comments'],
                                          postImage: post['postImage'],
                                          likes: post['likes'],
                                          loved_it: post['loved_it'],
                                          postDesc: post['postDesc'].toString(),
                                          postTitle:
                                              post['postTitle'].toString(),
                                          username: post['postFromUsername']
                                              .toString(),
                                          userPhoto: post['postFromUserPhoto']
                                              .toString(),
                                          time: post['created_on'].toDate(),
                                          userID:
                                              post['postFromUserID'].toString(),
                                          postID: postID,
                                        );
                                      }),
                                    );
                                  })
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
