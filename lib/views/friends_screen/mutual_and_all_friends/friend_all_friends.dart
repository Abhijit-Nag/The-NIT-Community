import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendAllFriends extends StatelessWidget {
  List allFriends;
  FriendAllFriends({Key? key, required this.allFriends}) : super(key: key);
  var controller = Get.put(FriendController());

  @override
  Widget build(BuildContext context) {
    if (allFriends.isEmpty) {
      return Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/best-friend.png',
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      );
    }
    return Scaffold(
        body: StreamBuilder(
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
              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              return ListView.builder(
                  itemCount: allFriends.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: FirebaseServices.getFriendDetails(
                            userID: allFriends[index]['userID']),
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
                          var friendData =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          if (friendData!['blocked_friends'].any(
                              (element) => element == auth.currentUser!.uid)) {
                            return Container();
                          }
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                index > 0
                                    ? const Divider(
                                        endIndent: 250,
                                        thickness: 0.8,
                                      )
                                    : Container(),
                                ListTile(
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
                                              userID: allFriends[index]
                                                  ['userID']));
                                        })
                                      : Image.network(
                                          allFriends[index]['userPhoto'],
                                          width: 35,
                                        ).onTap(() {
                                          Get.to(() => FriendProfileScreen(
                                              username: allFriends[index]
                                                  ['username'],
                                              userPhoto: allFriends[index]
                                                  ['userPhoto'],
                                              userID: allFriends[index]
                                                  ['userID']));
                                        }),
                                  title: Text(allFriends[index]['username'])
                                      .onTap(() {
                                    Get.to(() => FriendProfileScreen(
                                        username: allFriends[index]['username'],
                                        userPhoto: allFriends[index]
                                            ['userPhoto'],
                                        userID: allFriends[index]['userID']));
                                  }),
                                  trailing: allFriends[index]['userID'] ==
                                          auth.currentUser!.uid
                                      ? Container(
                                          width: 80,
                                          padding: const EdgeInsets.all(3.0),
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'YOU',
                                            style: GoogleFonts.firaSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )
                                      : userData!['friends'].any((element) =>
                                              element['userID'] ==
                                              allFriends[index]['userID'])
                                          ? Container(
                                              width: 150,
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
                                            ).scale(scaleValue: 0.7)
                                          : userData!['friend_request_sent']
                                                  .any((element) =>
                                                      element['userID'] ==
                                                      allFriends[index]
                                                          ['userID'])
                                              ? Container(
                                                  width: 130,
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
                                                      TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          'Request Sent',
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
                                                ).scale(scaleValue: 0.7)
                                              : userData!['friend_requests']
                                                      .any((element) =>
                                                          element['userID'] ==
                                                          allFriends[index]
                                                              ['userID'])
                                                  ? Container(
                                                      child: Text(
                                                        'Confirm',
                                                        style: GoogleFonts
                                                            .firaSans(),
                                                      ),
                                                    )
                                                      .scale(scaleValue: 0.7)
                                                      .onTap(() async {
                                                      var friendToBeAdded = {
                                                        "username":
                                                            allFriends[index]
                                                                ['username'],
                                                        "email":
                                                            allFriends[index]
                                                                ['email'],
                                                        "userID":
                                                            allFriends[index]
                                                                ['userID'],
                                                        "userPhoto":
                                                            allFriends[index]
                                                                ['userPhoto']
                                                      };
                                                      await controller
                                                          .acceptFriendRequest(
                                                              friendData:
                                                                  friendToBeAdded);
                                                    })
                                                  : IconButton(
                                                      onPressed: () async {
                                                        var userProfileData = {
                                                          "username":
                                                              allFriends[index]
                                                                  ['username'],
                                                          "userPhoto":
                                                              allFriends[index]
                                                                  ['userPhoto'],
                                                          "userID":
                                                              allFriends[index]
                                                                  ['userID'],
                                                          "email":
                                                              allFriends[index]
                                                                  ['email']
                                                        };
                                                        await controller
                                                            .sendFriendRequest(
                                                                userData:
                                                                    userProfileData,
                                                                sendUserID:
                                                                    allFriends[
                                                                            index]
                                                                        [
                                                                        'userID']);
                                                        VxToast.show(context,
                                                            msg:
                                                                "Friend Request sent.");
                                                      },
                                                      icon: const Icon(
                                                        Icons.person_add_alt,
                                                        color: Colors.blue,
                                                      )),
                                ),
                              ],
                            ),
                          );
                        });
                  });
            }));
  }
}
