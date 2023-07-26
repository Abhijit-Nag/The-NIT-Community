import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen2.dart';
import 'package:the_nit_community/views/friends_screen/mutual_and_all_friends/friend_all_friends.dart';
import 'package:the_nit_community/views/friends_screen/mutual_and_all_friends/mutual_friend_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class UserAllFriendsScreen extends StatelessWidget {
  String userID;
  UserAllFriendsScreen({Key? key, required this.userID}) : super(key: key);
  var controller = Get.put(FriendController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 25,),
            height: MediaQuery.of(context).size.height * 0.075,
            // padding: const EdgeInsets.symmetric(vertical:1),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Friends',
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              endIndent: 250,
              thickness: 0.8,
            ),
            15.heightBox,
            StreamBuilder(
                stream: FirebaseServices.getFriendDetails(userID: userID),
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

                  var friendsData =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  var friends = friendsData!['friends'];

                  return StreamBuilder(
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
                        children: [
                          TabBar(
                            tabs: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Mutual Friends',
                                      style: GoogleFonts.firaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    2.widthBox,
                                    Text(
                                      '(${mutualFriends.length})',
                                      style: GoogleFonts.firaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'All Friends',
                                      style: GoogleFonts.firaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    2.widthBox,
                                    Text(
                                      '(${friends.length})',
                                      style: GoogleFonts.firaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).marginSymmetric(horizontal: 18),
                          //

                          Container(
                            height: MediaQuery.of(context).size.height * 0.778,
                            width: MediaQuery.of(context).size.width * 1,
                            // color: Colors.orange,
                            child: TabBarView(children: [
                              MutualFriendScreen(friendData: mutualFriends),
                              FriendAllFriends(allFriends: friends),
                            ]),
                            // child: Text('something'),
                            // color: Colors.orange,
                          ),
                        ],
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
