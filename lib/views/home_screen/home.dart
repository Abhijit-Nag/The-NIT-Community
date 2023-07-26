import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/home_screen/create_post_screen.dart';
import 'package:the_nit_community/views/my_profile_screen/my_profile_screen.dart';
import 'package:the_nit_community/widgets/custom_loader.dart';
import 'package:the_nit_community/widgets/post_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatelessWidget {
  String photoURL;
  Home({Key? key, required this.photoURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.withOpacity(0.1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: photoURL.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(photoURL),
                      ).onTap(() {
                        Get.to(() => MyProfileScreen());
                      })
                    : CircleAvatar(
                        child: Icon(Icons.person),
                      ).onTap(() {
                        Get.to(() => MyProfileScreen());
                      }),
                title: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.5))),
                  child: Text(
                    'Write something here..',
                    style: GoogleFonts.firaSans(fontSize: 13),
                  ).marginOnly(left: 8),
                ).onTap(() {
                  Get.to(() => CreatePostScreen());
                }),
                trailing: const Icon(Icons.crop_original_rounded).onTap(() {
                  Get.to(() => CreatePostScreen());
                }),
              ),
              StreamBuilder(
                  stream: FirebaseServices.getAllPosts(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    var data = snapshot.data!.docs;

                    return Column(
                      children: List.generate(data.length, (index) {
                        var postID = data[index].id;
                        print(postID);
                        var post = data[index].data() as Map<String, dynamic>;
                        if (post['created_on'] == null) {
                          return const Center(
                            child: Text('Publishing..'),
                          );
                        }
                        return StreamBuilder(
                            stream: FirebaseServices.getFriendDetails(
                                userID: post['postFromUserID']),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                // return const Center (child: CircularProgressIndicator());
                                return customLoader();
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.toString()),
                                );
                              }
                              var friendData = snapshot.data!.data()
                                  as Map<String, dynamic>?;
                              if (friendData?['blocked_friends'].any(
                                  (element) =>
                                      element == auth.currentUser!.uid)) {
                                return Container();
                              }
                              return Post(
                                comments: post['comments'],
                                verified: post['userVerified'],
                                likes: post['likes'],
                                loved_it: post['loved_it'],
                                postImage: post['postImage'],
                                postDesc: post['postDesc'].toString(),
                                postTitle: post['postTitle'].toString(),
                                username: post['postFromUsername'].toString(),
                                userPhoto: post['postFromUserPhoto'].toString(),
                                time: post['created_on'].toDate(),
                                userID: post['postFromUserID'].toString(),
                                postID: postID,
                              );
                            });
                      }),
                    );
                    // return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
