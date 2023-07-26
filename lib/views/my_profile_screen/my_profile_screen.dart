import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/auth_controller.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/controllers/post_controller.dart';
import 'package:the_nit_community/controllers/settings_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen2.dart';
import 'package:the_nit_community/views/friends_screen/all_friends_screen.dart';
import 'package:the_nit_community/views/friends_screen/user_all_friends_screen.dart';
import 'package:the_nit_community/views/home_screen/create_post_screen.dart';
import 'package:the_nit_community/views/my_profile_screen/image_change_screen/cover_image_screen.dart';
import 'package:the_nit_community/views/my_profile_screen/image_change_screen/profile_image_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:the_nit_community/widgets/info_dialog.dart';
import 'package:the_nit_community/widgets/post_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  var controller = Get.put(FriendController());
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
            icon: Icon(Icons.arrow_back_ios)),
        title: InkWell(
          onTap: () {
            Get.to(() => SearchUserScreen());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2.1)),
            child: Row(
              children: [
                Icon(Icons.search),
                15.widthBox,
                Text(
                  'Search',
                  style: GoogleFonts.openSans(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  var dataSnapshot = snapshot.data;
                  var data = snapshot.data!.data() as Map<String, dynamic>?;
                  // var friendData=data;
                  var friends = data?['friends'];
                  print(friends);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: 250,
                                  padding: const EdgeInsets.only(bottom: 58),
                                  child: Image.network(
                                    // "https://cdn.quotesgram.com/img/29/87/1410104370-11586.jpg",
                                    data!['coverPhoto'],
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: 98,
                                    fit: BoxFit.cover,
                                  )).onTap(() {
                                print('image is $auth.');
                              }),
                              Positioned(
                                  bottom: 61,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      print('upload button clicked.');
                                      Get.to(() => CoverImageScreen(
                                            coverPhoto: data!['coverPhoto'],
                                          ));
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.camera_alt),
                                      backgroundColor: Color(0xffdce0e0),
                                    ),
                                  ))
                            ],
                          ),
                          Positioned(
                              top: 60,
                              left: 10,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xffdce0e0),
                                      radius: 92,
                                      child: data!['user_profile_photo']
                                              .toString()
                                              .isEmpty
                                          ? const CircleAvatar(
                                              radius: 85,
                                              child: Icon(
                                                Icons.person_add_alt_1,
                                                size: 61,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 85,
                                              backgroundImage: NetworkImage(
                                                // "https://timelinecovers.pro/facebook-cover/download/light-of-the-world-john-christian-facebook-cover.jpg",
                                                data!['user_profile_photo']
                                                    .toString(),
                                                // width: 115,
                                                // height: 115,
                                                // fit: BoxFit.cover,
                                              ),
                                            )),
                                  Positioned(
                                      bottom: 35,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => ProfileImageScreen(
                                                profilePhoto:
                                                    data!['user_profile_photo'],
                                              ));
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.camera_alt),
                                          backgroundColor: Color(0xffdce0e0),
                                        ),
                                      ))
                                ],
                              ))
                        ],
                      ),
                      15.heightBox,
                      Row(
                        children: [
                          Text(
                            auth.currentUser!.displayName.toString(),
                            style: GoogleFonts.firaSans(
                                fontSize: 21, fontWeight: FontWeight.w600),
                          ).marginOnly(left: 25),
                          25.widthBox,
                          data!['verified']
                              ? const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                ).onLongPress(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.5)),
                                          backgroundColor: Colors.white,
                                          child: Container(
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "You're verified user.",
                                                      style:
                                                          GoogleFonts.openSans(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 18),
                                                    ),
                                                    const Icon(
                                                      Icons.verified,
                                                      color: Colors.blue,
                                                    )
                                                  ],
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
                      15.heightBox,

                      data['bio'].toString().isNotEmpty
                          ? Column(
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ).marginSymmetric(horizontal: 25, vertical: 8.0)
                              ],
                            )
                          : Container(),
                      const Divider(
                        thickness: 0.2,
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
                          var myUserData =
                              snapshot.data!.data() as Map<String, dynamic>?;

                          var myUserFriends = myUserData!['friends'];

                          for (int i = 0; i < myUserFriends.length; i++) {
                            for (int j = 0; j < friends.length; j++) {
                              if (myUserFriends[i]['userID'] ==
                                  friends[j]['userID']) {
                                mutualFriends.add(myUserFriends[i]);
                              }
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${myUserFriends.length} friends',
                                style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.8),
                              ).marginOnly(left: 10),
                              2.heightBox,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      myUserFriends.length,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: myUserFriends[
                                                                      index]
                                                                  ['userPhoto']
                                                              .isEmpty
                                                          ? const CircleAvatar(
                                                              child: Icon(
                                                                  Icons.person),
                                                            )
                                                          : Image.network(
                                                              // "https://timelinecovers.pro/facebook-cover/download/light-of-the-world-john-christian-facebook-cover.jpg",
                                                              myUserFriends[
                                                                      index]
                                                                  ['userPhoto'],
                                                              width: 125,
                                                              height: 125,
                                                              fit: BoxFit.cover,
                                                            ))
                                                  .marginSymmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5.0),
                                              2.heightBox,
                                              Text(
                                                myUserFriends[index]
                                                    ['username'],
                                                style: GoogleFonts.firaSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ).marginOnly(left: 15)
                                            ],
                                          ).onTap(() {
                                            print('friend clicked.');
                                            print(friends[index]['username']);
                                            print(friends[index]['userPhoto']);
                                            print(friends[index]['userID']);
                                            // print(userID);
                                            // Get.to(()=>HomeScreen());
                                            // homeController.navigateToFriendProfileScreen(username: friends[index]['username'], userPhoto: friends[index]['userPhoto'], userID: friends[index]['userID']);
                                            Get.to(() => FriendProfileScreen2(
                                                username: myUserFriends[index]
                                                    ['username'],
                                                userPhoto: myUserFriends[index]
                                                    ['userPhoto'],
                                                userID: myUserFriends[index]
                                                    ['userID']));
                                            print('route done');
                                            // Get.to(()=> FriendProfileScreen(username: friends[index]['username'], userPhoto: friends[index]['userPhoto'], userID: friends[index]['userID']));
                                          })),
                                ),
                              ),
                              18.heightBox,
                              Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(3.0)),
                                  child: Center(
                                      child: Text(
                                    'See all friends',
                                    style: GoogleFonts.firaSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ))).centered().onTap(() {
                                Get.to(() => AllFriendsScreen());
                              }),
                            ],
                          );
                        },
                      ),

                      3.1.heightBox,

                      //Segment for follower users

                      const Divider(
                        thickness: 0.2,
                        endIndent: 250,
                      ),
                      Text(
                        'Followers',
                        style: GoogleFonts.firaSans(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ).marginOnly(left: 10),
                      8.heightBox,

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              data!['followers'].length,
                              (index) => InkWell(
                                    onTap: () {
                                      Get.to(() => FriendProfileScreen(
                                          username: data!['followers'][index]
                                              ['username'],
                                          userPhoto: data!['followers'][index]
                                              ['userPhoto'],
                                          userID: data!['followers'][index]
                                              ['userID']));
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight:
                                                    Radius.circular(8.0))),
                                        elevation: 3.1,
                                        child: Column(
                                          children: [
                                            data!['followers'][index]
                                                        ['userPhoto']
                                                    .toString()
                                                    .isNotEmpty
                                                ? ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0)),
                                                    child: Image.network(
                                                      data!['followers'][index]
                                                          ['userPhoto'],
                                                      width: 91,
                                                      height: 91,
                                                      fit: BoxFit.cover,
                                                    ))
                                                : const CircleAvatar(
                                                    child: Icon(Icons.person),
                                                  ),
                                            10.heightBox,
                                            Text(
                                              data!['followers'][index]
                                                  ['username'],
                                              style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ).marginOnly(
                                                left: 3.1,
                                                right: 3.1,
                                                bottom: 3.1)
                                          ],
                                        )).marginAll(5.1),
                                  )),
                        ).marginAll(8.0),
                      ),

                      3.1.heightBox,

                      //Segment for following users

                      const Divider(
                        thickness: 0.2,
                        endIndent: 250,
                      ),
                      Text(
                        'Followings',
                        style: GoogleFonts.firaSans(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ).marginOnly(left: 10),
                      8.heightBox,

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              data!['followings'].length,
                              (index) => InkWell(
                                    onTap: () {
                                      Get.to(() => FriendProfileScreen(
                                          username: data!['followings'][index]
                                              ['username'],
                                          userPhoto: data!['followings'][index]
                                              ['userPhoto'],
                                          userID: data!['followings'][index]
                                              ['userID']));
                                    },
                                    child: Card(
                                      elevation: 3.1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0))),
                                      child: Column(
                                        children: [
                                          data!['followings'][index]
                                                      ['userPhoto']
                                                  .toString()
                                                  .isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0)),
                                                  child: Image.network(
                                                    data!['followings'][index]
                                                        ['userPhoto'],
                                                    width: 91,
                                                    height: 91,
                                                    fit: BoxFit.cover,
                                                  ))
                                              : const CircleAvatar(
                                                  child: Icon(Icons.person),
                                                ),
                                          10.heightBox,
                                          Text(
                                            data!['followings'][index]
                                                ['username'],
                                            style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ).marginOnly(
                                              left: 3.1,
                                              right: 3.1,
                                              bottom: 3.1)
                                        ],
                                      ),
                                    ).marginAll(5.1),
                                  )),
                        ).marginAll(8.0),
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

                      InkWell(
                        onTap: () {
                          Get.to(() => CreatePostScreen());
                        },
                        child: ListTile(
                          leading: auth.currentUser!.photoURL != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      auth.currentUser!.photoURL.toString()),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Text(
                              'Write something here..',
                              style: GoogleFonts.firaSans(fontSize: 13),
                            ).marginOnly(left: 8),
                          ),
                          trailing: const Icon(Icons.crop_original_rounded),
                        ),
                      ),

                      const Divider(
                        endIndent: 150,
                      ).marginOnly(left: 8.0),

                      //StreamBuilder for posts
                      StreamBuilder(
                          stream: FirebaseServices.getUserPosts(
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
                            var postData = snapshot.data!.docs;
                            if (postData.isEmpty) {
                              return Center(
                                child: Stack(
                                  children: [
                                    // Image.network(
                                    //     'https://png.pngtree.com/png-clipart/20230510/original/pngtree-brown-wooden-empty-guide-post-png-image_9155234.png'),
                                    Image.asset('assets/images/no_post.png'),
                                    Positioned(
                                        top: 230,
                                        // left: MediaQuery.of(context).size.width*0.15,
                                        child: Row(
                                          children: [
                                            Text(
                                              'OOOOPS!!',
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25),
                                            ).marginOnly(right: 100, left: 35),
                                            10.heightBox,
                                            Text(
                                              'No Posts!',
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            }

                            //show the posts
                            return Column(
                              children: List.generate(postData.length, (index) {
                                var postID = postData[index].id;
                                print(postID);
                                var post = postData[index].data()
                                    as Map<String, dynamic>;
                                return Stack(children: [
                                  Post(
                                    verified: post['userVerified'],
                                    comments: post['comments'],
                                    postImage: post['postImage'],
                                    likes: post['likes'],
                                    loved_it: post['loved_it'],
                                    postDesc: post['postDesc'].toString(),
                                    postTitle: post['postTitle'].toString(),
                                    username:
                                        post['postFromUsername'].toString(),
                                    userPhoto:
                                        post['postFromUserPhoto'].toString(),
                                    time: post['created_on'].toDate(),
                                    userID: post['postFromUserID'].toString(),
                                    postID: postID,
                                  ),
                                  Positioned(
                                      // right:15,
                                      //   top:25,
                                      top: 15,
                                      right: 12,
                                      child: IconButton(
                                        icon: Icon(Icons.more_horiz),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.delete,
                                                      ),
                                                      title: Text(
                                                              'Delete the post?')
                                                          .onTap(() async {
                                                        print(
                                                            'delete post button clicked.');
                                                        await Get.put(
                                                                PostController())
                                                            .deletePost(
                                                                postID: postID);
                                                        Navigator.pop(context);
                                                      }),
                                                      trailing: IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    child: ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: [
                                                                          Container(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
                                                                              child: Center(child: Text('Once you delete the post cannnot be recovered.\nNobody will be able to see your post.'))),
                                                                        ]),
                                                                  );
                                                                });
                                                          },
                                                          icon:
                                                              Icon(Icons.info)),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ))
                                ]);
                              }),
                            );
                          })
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
