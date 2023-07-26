import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/friends_screen/all_friends_screen.dart';
import 'package:the_nit_community/views/friends_screen/all_users_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendRequestScreen extends StatelessWidget {
  FriendRequestScreen({Key? key}) : super(key: key);
  var controller = Get.put(FriendController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Friends',
                style: GoogleFonts.firaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ).marginOnly(left: 12),
              8.heightBox,
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        // color: Colors.grey.withOpacity(0.3),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Text(
                      'Suggestions',
                      style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ).onTap(() {
                    Get.to(() => AllUsersScreen());
                  }),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        // color: Colors.grey.withOpacity(0.3),
                        color: Colors.orange.withOpacity(0.48),
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Text(
                      'Your Friends',
                      style: GoogleFonts.firaSans(
                          color: Colors.purple, fontWeight: FontWeight.w600),
                    ),
                  ).onTap(() {
                    Get.to(() => AllFriendsScreen());
                  })
                ],
              ).marginOnly(left: 8),
              5.heightBox,
              const Divider(endIndent: 250),
              5.heightBox,
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
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    print(data);
                    if (data != null) {
                      print(data!['username']);
                    }
                    print(data!['friend_requests']);
                    var friendRequested = [];
                    for (int i = 0; i < data!['friend_requests'].length; i++) {
                      friendRequested.add(data!['friend_requests'][i]);
                    }
                    print('friend requested:  $friendRequested');
                    // return Container();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  friendRequested.length > 1
                                      ? 'Friend requests '
                                      : 'Friend request',
                                  style: GoogleFonts.firaSans(
                                      fontSize: 18,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600),
                                ),
                                8.widthBox,
                                Text(
                                  friendRequested.length.toString(),
                                  style: GoogleFonts.firaSans(
                                      fontSize: 20,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ).marginOnly(left: 8),
                            // Text('See all', style: GoogleFonts.firaSans(
                            //   color: Colors.blue,
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 18
                            // ),).marginOnly(right: 10)
                          ],
                        ),
                        15.heightBox,
                        ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: friendRequested.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: friendRequested[index]['userPhoto']
                                        .toString()
                                        .isEmpty
                                    ? const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ).onTap(() {
                                        Get.to(() => FriendProfileScreen(
                                            username: friendRequested[index]
                                                ['username'],
                                            userPhoto: friendRequested[index]
                                                ['userPhoto'],
                                            userID: friendRequested[index]
                                                ['userID']));
                                      })
                                    : Image.network(friendRequested[index]
                                                ['userPhoto']
                                            .toString())
                                        .onTap(() {
                                        Get.to(() => FriendProfileScreen(
                                            username: friendRequested[index]
                                                ['username'],
                                            userPhoto: friendRequested[index]
                                                ['userPhoto'],
                                            userID: friendRequested[index]
                                                ['userID']));
                                      }),
                                title: Text(friendRequested[index]['username']
                                        .toString())
                                    .marginOnly(left: 10)
                                    .onTap(() {
                                  Get.to(() => FriendProfileScreen(
                                      username: friendRequested[index]
                                          ['username'],
                                      userPhoto: friendRequested[index]
                                          ['userPhoto'],
                                      userID: friendRequested[index]
                                          ['userID']));
                                }),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${friendRequested[index]['mutual_friends'] ?? 15.toString()} mutual friends',
                                      style: GoogleFonts.firaSans(
                                          color: Colors.grey, fontSize: 12),
                                    ).marginOnly(left: 10),
                                    15.heightBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.31,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          child: TextButton(
                                              onPressed: () async {
                                                print(friendRequested[index]);
                                                await controller
                                                    .acceptFriendRequest(
                                                        friendData:
                                                            friendRequested[
                                                                index]);
                                                VxToast.show(context,
                                                    msg:
                                                        "Friend request accepted.");
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.white),
                                              )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.31,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          child: TextButton(
                                              onPressed: () async {
                                                var friendData = {
                                                  "email":
                                                      friendRequested[index]
                                                          ['email'],
                                                  "userID":
                                                      friendRequested[index]
                                                          ['userID'],
                                                  "userPhoto": friendRequested[
                                                              index][
                                                          'user_profile_photo'] ??
                                                      "",
                                                  "username":
                                                      friendRequested[index]
                                                          ['username']
                                                };
                                                print('delete button clicked!');
                                                print(friendData);
                                                await controller
                                                    .deleteFriendRequest(
                                                        friendData: friendData);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.black),
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                        15.heightBox,
                        const Divider(
                          endIndent: 180,
                        ),
                        Text(
                          'People You May Know',
                          style: GoogleFonts.firaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        ).marginOnly(left: 10),
                        StreamBuilder(
                            stream: FirebaseServices.getAllUsers(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              var data = snapshot.data!.docs;
                              // var allUsersData=[];
                              print('length of users: ${data.length}');
                              var allUsersData = data;
                              // for(int i=0;i<data.length;i++){
                              //   if(data[i]['email']!= auth.currentUser!.email){
                              //     print(data[i]['email']);
                              //     allUsersData.add(data[i]);
                              //
                              //   }
                              // }

                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: allUsersData.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // var arrayy=[];
                                    if (allUsersData[index].id ==
                                        auth.currentUser!.uid) {
                                      return Container();
                                    }
                                    var userData = allUsersData[index].data()
                                        as Map<String, dynamic>;
                                    print(userData);
                                    if (allUsersData[index]['friends'].any(
                                        (element) =>
                                            element['userID'] ==
                                            auth.currentUser!.uid)) {
                                      return Container();
                                    }
                                    if (allUsersData[index]
                                            ['friend_request_sent']
                                        .any((element) =>
                                            element['userID'] ==
                                            auth.currentUser!.uid)) {
                                      return Container();
                                    }
                                    return Column(
                                      children: [
                                        const Divider(
                                          endIndent: 250,
                                          thickness: 0.8,
                                        ),
                                        ListTile(
                                          leading: allUsersData[index]
                                                      ['user_profile_photo']
                                                  .toString()
                                                  .isNotEmpty
                                              ? Image.network(
                                                  allUsersData[index]
                                                      ['user_profile_photo'],
                                                  width: 35,
                                                ).onTap(() {
                                                  print(
                                                      'userdata::::::::$userData');
                                                  print(
                                                      'userID in friend request screen : ${allUsersData[index]['userID']}');
                                                  // Get.to(()=>FriendProfileScreen(username: allUsersData[index]['username'], userPhoto: allUsersData[index]['user_profile_photo'], userID: allUsersData[index]['userID']));
                                                })
                                              : const CircleAvatar(
                                                  child: Icon(Icons.person),
                                                ).onTap(() {
                                                  print(
                                                      'userdata::::::::$userData');
                                                  Get.to(() => FriendProfileScreen(
                                                      username:
                                                          allUsersData[index]
                                                              ['username'],
                                                      userPhoto: allUsersData[
                                                              index][
                                                          'user_profile_photo'],
                                                      userID:
                                                          allUsersData[index]
                                                              .id));
                                                }),
                                          title: Row(
                                            children: [
                                              Text(allUsersData[index]
                                                      ['username'])
                                                  .marginOnly(left: 10)
                                                  .onTap(() {
                                                print(
                                                    'userdata::::::::$userData');
                                                Get.to(() => FriendProfileScreen(
                                                    username:
                                                        allUsersData[index]
                                                            ['username'],
                                                    userPhoto: allUsersData[
                                                            index]
                                                        ['user_profile_photo'],
                                                    userID: allUsersData[index]
                                                        .id));
                                              }),
                                              allUsersData[index]['verified']
                                                  ? const Icon(
                                                      Icons.verified,
                                                      color: Colors.blue,
                                                    ).marginOnly(left: 3.0)
                                                  : Container()
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '15 mutual friends',
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ).marginOnly(left: 10),
                                              15.heightBox,
                                              // allUsersData[index]['friends'].any((element)=>element['userId']== auth.currentUser!.uid) ?
                                              //     Container(
                                              //
                                              //     ):

                                              allUsersData[index]['friends']
                                                      .any((element) =>
                                                          element['userID'] ==
                                                          auth.currentUser!.uid)
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3.0)),
                                                      child: Text(
                                                        "You both are already friends.",
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        allUsersData[index][
                                                                    'friend_requests']
                                                                .any((element) =>
                                                                    element[
                                                                        'userID'] ==
                                                                    auth.currentUser!
                                                                        .uid)
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3.0)),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.31,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {},
                                                                        child:
                                                                            Text(
                                                                          'Request sent',
                                                                          style:
                                                                              GoogleFonts.firaSans(color: Colors.white),
                                                                        )),
                                                              )
                                                            : Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            150),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3.0)),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.31,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          print(
                                                                              allUsersData[index].id);
                                                                          await controller.sendFriendRequest(
                                                                              userData: userData,
                                                                              sendUserID: allUsersData[index].id);
                                                                          VxToast.show(
                                                                              context,
                                                                              msg: "Friend Request sent.");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Add Friend',
                                                                          style:
                                                                              GoogleFonts.firaSans(color: Colors.white),
                                                                        )),
                                                              ),
                                                        allUsersData[index][
                                                                    'friend_requests']
                                                                .any((element) =>
                                                                    element[
                                                                        'userID'] ==
                                                                    auth.currentUser!
                                                                        .uid)
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3.0)),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await controller.cancelFriendRequest(
                                                                              userData: userData,
                                                                              sendUserID: allUsersData[index].id);
                                                                          VxToast.show(
                                                                              context,
                                                                              msg: "Friend Request cancelled.");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel Request',
                                                                          style:
                                                                              GoogleFonts.firaSans(color: Colors.black),
                                                                        )),
                                                              )
                                                            : Container(
                                                                // decoration: BoxDecoration(
                                                                //     color: Colors.grey.withOpacity(0.3),
                                                                //     borderRadius: BorderRadius.circular(3.0)
                                                                // ),
                                                                // width: MediaQuery.of(context).size.width*0.31,
                                                                // height: MediaQuery.of(context).size.height*0.05,
                                                                // child: TextButton(onPressed: (){
                                                                // }, child: Text('Remove',
                                                                //   style: GoogleFonts.firaSans(
                                                                //       color: Colors.black
                                                                //   ),)),
                                                                )
                                                      ],
                                                    )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }),
                      ],
                    );
                    //

                    // return const Center(child: Text('No Friend Requests'),);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
