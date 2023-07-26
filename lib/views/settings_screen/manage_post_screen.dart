import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/post_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/widgets/post_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class ManagePostScreen extends StatelessWidget {
  const ManagePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Your Posts',
              style: GoogleFonts.openSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue),
            ),
            const Divider(
              endIndent: 150,
              color: Colors.blue,
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.15),
            child: Icon(
              Icons.settings,
            ),
          ).marginOnly(right: 15).onTap(() {
            Get.back();
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posts',
              style: GoogleFonts.firaSans(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ).marginOnly(left: 20),
            const Divider(
              endIndent: 150,
            ).marginOnly(left: 8.0),
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
                      var post = postData[index].data() as Map<String, dynamic>;
                      return Stack(children: [
                        Post(
                          comments: post['comments'],
                          postImage: post['postImage'],
                          verified: post['userVerified'],
                          likes: post['likes'],
                          loved_it: post['loved_it'],
                          postDesc: post['postDesc'].toString(),
                          postTitle: post['postTitle'].toString(),
                          username: post['postFromUsername'].toString(),
                          userPhoto: post['postFromUserPhoto'].toString(),
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
                                            title: Text('Delete the post?')
                                                .onTap(() async {
                                              print(
                                                  'delete post button clicked.');
                                              await Get.put(PostController())
                                                  .deletePost(postID: postID);
                                              Navigator.pop(context);
                                            }),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          child: ListView(
                                                              shrinkWrap: true,
                                                              children: [
                                                                Container(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.0)),
                                                                    child: Center(
                                                                        child: Text(
                                                                      'Once you delete the post cannnot be recovered.\nNobody will be able to see your post.',
                                                                      style: GoogleFonts.openSans(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ))),
                                                              ]),
                                                        );
                                                      });
                                                },
                                                icon: Icon(Icons.info)),
                                          )
                                        ],
                                      );
                                    });
                              },
                            ))
                      ]);
                    }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
