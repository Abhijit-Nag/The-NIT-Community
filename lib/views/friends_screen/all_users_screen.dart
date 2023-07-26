import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({Key? key}) : super(key: key);
  var controller = Get.put(FriendController());
  @override
  Widget build(BuildContext context) {
    var profile = controller.getProfileDetails();
    return StreamBuilder(
        stream: FirebaseServices.getUserDetails(),
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
          if (snapshot.data!.data() == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var myProfileData = snapshot.data!.data();
          var myProfileUserData = myProfileData as Map<String, dynamic>?;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Suggestions',
                style: GoogleFonts.firaSans(),
              ),
              actions: [
                IconButton(onPressed: () {
                  Get.to(()=> SearchUserScreen());
                }, icon: const Icon(Icons.search))
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
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
                          var allUsersData = [];
                          print('length of users: ${data.length}');
                          for (int i = 0; i < data.length; i++) {
                            if (data[i]['email'] != auth.currentUser!.email) {
                              print(data[i]['email']);
                              allUsersData.add(data[i]);
                            }
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: allUsersData.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // var arrayy=[];
                                var userData = allUsersData[index].data()
                                    as Map<String, dynamic>;
                                print(userData);
                                if (userData['blocked_friends'].any((element) =>
                                    element == auth.currentUser!.uid)) {
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
                                              Get.to(() => FriendProfileScreen(
                                                  username: allUsersData[index]
                                                      ['username'],
                                                  userPhoto: allUsersData[index]
                                                      ['user_profile_photo'],
                                                  userID:
                                                      allUsersData[index].id));
                                            })
                                          : const CircleAvatar(
                                              child: Icon(Icons.person),
                                            ).onTap(() {
                                              Get.to(() => FriendProfileScreen(
                                                  username: allUsersData[index]
                                                      ['username'],
                                                  userPhoto: allUsersData[index]
                                                      ['user_profile_photo'],
                                                  userID:
                                                      allUsersData[index].id));
                                            }),
                                      title: Row(
                                        children: [
                                          Text(allUsersData[index]['username'])
                                              .marginOnly(left: 10)
                                              .onTap(() {
                                            print('userdata::::::::$userData');
                                            Get.to(() => FriendProfileScreen(
                                                username: allUsersData[index]
                                                    ['username'],
                                                userPhoto: allUsersData[index]
                                                    ['user_profile_photo'],
                                                userID:
                                                    allUsersData[index].id));
                                          }),
                                          allUsersData[index]['verified']
                                              ? const Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                ).marginOnly(left: 3.5)
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

                                          allUsersData[index]['friends'].any(
                                                  (element) =>
                                                      element['userID'] ==
                                                      auth.currentUser!.uid)
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15.0),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.0)),
                                                  child: Text(
                                                    "You both are already friends.",
                                                    style: GoogleFonts.firaSans(
                                                        color: Colors.white),
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
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                            child: TextButton(
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                  'Request sent',
                                                                  style: GoogleFonts
                                                                      .firaSans(
                                                                          color:
                                                                              Colors.white),
                                                                )),
                                                          )
                                                        : myProfileUserData?[
                                                                    'friend_requests']
                                                                .any((element) =>
                                                                    element[
                                                                        'userID'] ==
                                                                    allUsersData[
                                                                            index]
                                                                        .id)
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
                                                                            () async {
                                                                          print(
                                                                              allUsersData[index].id);
                                                                          var friendData =
                                                                              {
                                                                            "username":
                                                                                userData['username'],
                                                                            "email":
                                                                                userData['email'],
                                                                            "userPhoto":
                                                                                userData['user_profile_photo'],
                                                                            "userID":
                                                                                allUsersData[index].id
                                                                          };
                                                                          await controller.acceptFriendRequest(
                                                                              friendData: friendData);
                                                                          // await controller.sendFriendRequest(userData: userData, sendUserID:allUsersData[index].id );
                                                                          VxToast.show(
                                                                              context,
                                                                              msg: "Friend Request sent.");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Confirm',
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
                                                                    BorderRadius
                                                                        .circular(
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
                                                            child: TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await controller.cancelFriendRequest(
                                                                      userData:
                                                                          userData,
                                                                      sendUserID:
                                                                          allUsersData[index]
                                                                              .id);
                                                                  VxToast.show(
                                                                      context,
                                                                      msg:
                                                                          "Friend Request cancelled.");
                                                                },
                                                                child: Text(
                                                                  'Cancel Request',
                                                                  style: GoogleFonts
                                                                      .firaSans(
                                                                          color:
                                                                              Colors.black),
                                                                )),
                                                          )
                                                        : myProfileUserData?[
                                                                    'friend_requests']
                                                                .any((element) =>
                                                                    element[
                                                                        'userID'] ==
                                                                    allUsersData[
                                                                            index]
                                                                        .id)
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
                                                                          var friendData =
                                                                              {
                                                                            "email":
                                                                                userData['email'],
                                                                            "userID":
                                                                                allUsersData[index].id,
                                                                            "userPhoto":
                                                                                userData['user_profile_photo'],
                                                                            "username":
                                                                                userData['username']
                                                                          };
                                                                          await controller.deleteFriendRequest(
                                                                              friendData: friendData);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Delete',
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
                ),
              ),
            ),
          );
        });
  }
}
