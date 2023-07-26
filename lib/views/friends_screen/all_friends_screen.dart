import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/chat_screen/message_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class AllFriendsScreen extends StatelessWidget {
  AllFriendsScreen({Key? key}) : super(key: key);
  var controller = Get.put(FriendController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Friends',
          style: GoogleFonts.firaSans(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SearchUserScreen());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.85,
              // padding: const EdgeInsets.symmetric(vertical:1),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  15.widthBox,
                  Text(
                    'Search Friends',
                    style: GoogleFonts.openSans(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ).marginOnly(left: 15),
            ).onTap(() {
              Get.to(() => SearchUserScreen());
            }),
            15.heightBox,
            StreamBuilder(
                stream: FirebaseServices.getUserDetails(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  var friendUserData = snapshot.data;
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  // print('all friends: $data');
                  var allFriends = data['friends'];
                  print('all friends : ${allFriends}');
                  if (allFriends.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          80.heightBox,
                          Image.asset(
                            'assets/images/best-friend.png',
                            width: MediaQuery.of(context).size.width * 0.51,
                          ),
                          Text(
                            'No friends.',
                            style: GoogleFonts.openSans(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${allFriends.length} ${allFriends.length > 1 ? 'friends' : 'friend'}',
                            style: GoogleFonts.firaSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.purple,
                                fontSize: 18),
                          ).marginOnly(left: 15),
                          // TextButton(onPressed: (){
                          //   showModalBottomSheet(
                          //
                          //       context: context, builder: (context){
                          //     return ListView(
                          //       shrinkWrap: true,
                          //       children: [
                          //         ListTile(
                          //           leading: const Icon(Icons.crop_original_rounded),
                          //           title: Text('Default', style: GoogleFonts.firaSans(
                          //
                          //           ),),
                          //         ),
                          //         InkWell(
                          //           child: InkWell(
                          //             onTap:(){
                          //               allFriends.sort((a, b) => a['friends_became_on'].compareTo(b['friends_became_on']),);
                          //             },
                          //             child: ListTile(
                          //               leading: const Icon(Icons.trending_up_outlined),
                          //               title: Text('Newest friend first', style: GoogleFonts.firaSans(
                          //
                          //               ),),
                          //             ),
                          //           ),
                          //         ),
                          //         ListTile(
                          //           leading: const Icon(Icons.trending_down_rounded),
                          //           title: Text('Oldest friend first', style: GoogleFonts.firaSans(
                          //
                          //           ),),
                          //         )
                          //       ],
                          //     );
                          //   });
                          // }, child: const Text('Sort')).marginOnly(right: 15)
                        ],
                      ),
                      ListView.separated(
                          separatorBuilder: (BuildContext context, index) =>
                              const Divider(
                                thickness: 0.8,
                                endIndent: 250,
                              ),
                          itemCount: allFriends.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: allFriends[index]['userPhoto']
                                      .toString()
                                      .isEmpty
                                  ? const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ).onTap(() {
                                      Get.to(() => FriendProfileScreen(
                                          username: allFriends[index]
                                              ['username'],
                                          userPhoto: allFriends[index]
                                              ['userPhoto'],
                                          userID: allFriends[index]['userID']));
                                    })
                                  : Image.network(
                                      allFriends[index]['userPhoto'].toString(),
                                      width: 35,
                                    ).onTap(() {
                                      Get.to(() => FriendProfileScreen(
                                          username: allFriends[index]
                                              ['username'],
                                          userPhoto: allFriends[index]
                                              ['userPhoto'],
                                          userID: allFriends[index]['userID']));
                                    }),
                              title: Row(
                                children: [
                                  Text(allFriends[index]['username'].toString())
                                      .marginOnly(left: 10)
                                      .onTap(() {
                                    Get.to(() => FriendProfileScreen(
                                        username: allFriends[index]['username'],
                                        userPhoto: allFriends[index]
                                            ['userPhoto'],
                                        userID: allFriends[index]['userID']));
                                  }),
                                  8.widthBox,
                                  data['blocked_friends'] == null
                                      ? Container()
                                      : data['blocked_friends'].any((element) =>
                                              element ==
                                              allFriends[index]['userID'])
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0)),
                                              height: 35,
                                              child: TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          height: 91,
                                                          child: Column(
                                                            children: [
                                                              const Divider(
                                                                endIndent: 250,
                                                                thickness: 0.8,
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await controller.unBlockFriend(
                                                                        friendID: allFriends[index]
                                                                            [
                                                                            'userID'],
                                                                        context:
                                                                            context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    VxToast.show(
                                                                        context,
                                                                        msg:
                                                                            "Your friend is unblocked");
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    leading: allFriends[index]['userPhoto']
                                                                            .toString()
                                                                            .isEmpty
                                                                        ? const CircleAvatar(
                                                                            child:
                                                                                Icon(Icons.person),
                                                                          )
                                                                        : Image.network(allFriends[index]
                                                                            [
                                                                            'userPhoto']),
                                                                    title: Text(
                                                                        'Unblock ${allFriends[index]['username']} ?',
                                                                        style: GoogleFonts.firaSans(
                                                                            // color: Colors.orange,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 15)),
                                                                  )),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.block,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    2.widthBox,
                                                    Text(
                                                      'Blocked',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container()
                                ],
                              ),
                              subtitle: Text(
                                '15 mutual friends',
                                style: GoogleFonts.firaSans(
                                    color: Colors.grey, fontSize: 12),
                              ).marginOnly(left: 10),
                              trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return ListView(
                                            shrinkWrap: true,
                                            children: [
                                              ListTile(
                                                leading: allFriends[index]
                                                            ['userPhoto']
                                                        .toString()
                                                        .isNotEmpty
                                                    ? Image.network(
                                                        allFriends[index]
                                                                ['userPhoto']
                                                            .toString(),
                                                        width: 35,
                                                      ).onTap(() {
                                                        Get.to(() => FriendProfileScreen(
                                                            username:
                                                                allFriends[
                                                                        index][
                                                                    'username'],
                                                            userPhoto:
                                                                allFriends[
                                                                        index][
                                                                    'userPhoto'],
                                                            userID: allFriends[
                                                                    index]
                                                                ['userID']));
                                                      })
                                                    : const CircleAvatar(
                                                        child:
                                                            Icon(Icons.person),
                                                      ).onTap(() {
                                                        Get.to(() => FriendProfileScreen(
                                                            username:
                                                                allFriends[
                                                                        index][
                                                                    'username'],
                                                            userPhoto:
                                                                allFriends[
                                                                        index][
                                                                    'userPhoto'],
                                                            userID: allFriends[
                                                                    index]
                                                                ['userID']));
                                                      }),
                                                title: Text(allFriends[index]
                                                        ['username'])
                                                    .onTap(() {
                                                  Get.to(() =>
                                                      FriendProfileScreen(
                                                          username:
                                                              allFriends[index]
                                                                  ['username'],
                                                          userPhoto:
                                                              allFriends[index]
                                                                  ['userPhoto'],
                                                          userID:
                                                              allFriends[index]
                                                                  ['userID']));
                                                }),
                                                subtitle: Text(
                                                  'Friends since ${intl.DateFormat("d MMMM y").format(allFriends[index]['friends_became_on'].toDate())}',
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              const Divider(),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => MessageScreen(),
                                                      arguments: [
                                                        allFriends[index]
                                                            ['username'],
                                                        friendUserData!.id
                                                      ]);
                                                },
                                                child: ListTile(
                                                  leading: const Icon(
                                                      Icons.message_rounded),
                                                  title: Text(
                                                      "Message ${allFriends[index]['username']}"),
                                                ),
                                              ),
                                              ListTile(
                                                  leading: const Icon(Icons
                                                      .remove_circle_outlined),
                                                  title: Text(
                                                      "Unfollow ${allFriends[index]['username']}"),
                                                  subtitle: Text(
                                                    'Stop seeing posts but stay friends.',
                                                    style: GoogleFonts.firaSans(
                                                        color: Colors.grey),
                                                  )),
                                              data['blocked_friends'].any(
                                                      (element) =>
                                                          element ==
                                                          allFriends[index]
                                                              ['userID'])
                                                  ? InkWell(
                                                      child: ListTile(
                                                          leading: const Icon(Icons
                                                              .person_add_disabled),
                                                          title: Text(
                                                              "Unblock ${allFriends[index]['username']}'s profile"),
                                                          subtitle: Text(
                                                            "${allFriends[index]['username']} will be able to see you or contact you on The NIT Community.",
                                                            style: GoogleFonts
                                                                .firaSans(
                                                                    color: Colors
                                                                        .grey),
                                                          )),
                                                      onTap: () async {
                                                        await controller
                                                            .unBlockFriend(
                                                                friendID:
                                                                    allFriends[
                                                                            index]
                                                                        [
                                                                        'userID'],
                                                                context:
                                                                    context);
                                                        Navigator.pop(context);
                                                        VxToast.show(context,
                                                            msg:
                                                                "Your friend is unblocked");
                                                      },
                                                    )
                                                  : InkWell(
                                                      child: ListTile(
                                                          leading: const Icon(Icons
                                                              .person_add_disabled),
                                                          title: Text(
                                                              "Block ${allFriends[index]['username']}'s profile"),
                                                          subtitle: Text(
                                                            "${allFriends[index]['username']} won't be able to see you or contact you on The NIT Community.",
                                                            style: GoogleFonts
                                                                .firaSans(
                                                                    color: Colors
                                                                        .grey),
                                                          )),
                                                      onTap: () async {
                                                        await controller
                                                            .blockFriend(
                                                                friendID:
                                                                    allFriends[
                                                                            index]
                                                                        [
                                                                        'userID'],
                                                                context:
                                                                    context);
                                                        Navigator.pop(context);
                                                        VxToast.show(context,
                                                            msg:
                                                                "Your friend is blocked");
                                                      },
                                                    ),
                                              InkWell(
                                                child: ListTile(
                                                    leading: const Icon(
                                                        Icons.person_remove),
                                                    title: Text(
                                                        "Unfriend ${allFriends[index]['username']} "),
                                                    subtitle: Text(
                                                      "Remove ${allFriends[index]['username']} as a friend.",
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              color:
                                                                  Colors.grey),
                                                    )),
                                                onTap: () async {
                                                  await controller.unFriend(
                                                      friendID:
                                                          allFriends[index]
                                                              ['userID']);
                                                  Navigator.pop(context);
                                                  VxToast.show(context,
                                                      msg:
                                                          "${allFriends[index]['username']} is not your friend anymore. You may send friend request to the user");
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.blue,
                                  )),
                            );
                          }),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
