import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/widgets/custom_loader.dart';
import 'package:velocity_x/velocity_x.dart';

class FollowerScreen extends StatelessWidget {
  String userID;
  FollowerScreen({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Followers',
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              endIndent: 150,
              thickness: 0.35,
            ),
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
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  var dataSnapshot = snapshot.data;
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic> followers = data['followers'];
                  if (followers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          20.heightBox,
                          Image.asset(
                            'assets/images/best-friend.png',
                            width: MediaQuery.of(context).size.width * 0.61,
                          ),
                          Text(
                            'No followers',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: followers.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              // const Divider(thickness: 0.73,),
                              InkWell(
                                onTap: () {
                                  Get.to(() => FriendProfileScreen(
                                      username: followers[index]['username'],
                                      userPhoto: followers[index]['userPhoto'],
                                      userID: followers[index]['userID']));
                                },
                                child: StreamBuilder(
                                    stream: FirebaseServices.getFriendDetails(
                                        userID: followers[index]['userID']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return customLoader()
                                            .scale(scaleValue: 0.8);
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      }

                                      var friendData = snapshot.data!.data()
                                          as Map<String, dynamic>?;
                                      return Column(
                                        children: [
                                          index == 0
                                              ? Container()
                                              : const Divider(
                                                  endIndent: 150,
                                                  thickness: 0.41,
                                                ),

                                          ListTile(
                                            leading: followers[index]
                                                        ['userPhoto']
                                                    .toString()
                                                    .isNotEmpty
                                                ? Image.network(
                                                    followers[index]
                                                        ['userPhoto'].toString(),
                                                    width: 48,
                                                  )
                                                : const CircleAvatar(
                                                    child: Icon(Icons.person),
                                                  ),
                                            title: Text(
                                              followers[index]['username'],
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                            trailing: friendData!['verified']
                                                ? const Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                  )
                                                : Container(width: 1 ,height: 1,),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ).marginSymmetric(horizontal: 25);
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
