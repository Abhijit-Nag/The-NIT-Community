import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/chat_screen/message_screen.dart';
import 'package:the_nit_community/widgets/custom_loader.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class AllChatScreen extends StatelessWidget {
  const AllChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseServices.getMyChats(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            var chatsData = snapshot.data!.docs;
            var data = [];
            for (int i = 0; i < chatsData.length; i++) {
              var dataItem = chatsData[i].data() as Map<String, dynamic>?;
              if (dataItem!['created_on'] != null &&
                  dataItem['last_message'].toString().trim().isNotEmpty) {
                data.add(dataItem);
              }
            }
            data.sort(
              (a, b) => b['created_on'].compareTo(a['created_on']),
            );
            print('all chats: $data');
            if (data.isEmpty) {
              return Center(child: Image.asset('assets/images/no_chat.jpg'));
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (data[index]['last_message']
                      .toString()
                      .trim()
                      .isNotEmpty) {
                    var friendID = "";
                    if (data[index]['users_id'][0] == auth.currentUser!.uid) {
                      friendID = data[index]['users_id'][1];
                    } else {
                      friendID = data[index]['users_id'][0];
                    }
                    print(
                        'print ${index + 1} : ${data[index]['last_message']}');
                    return StreamBuilder(
                        stream:
                            FirebaseServices.getFriendDetails(userID: friendID),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            // return const Center(child: CircularProgressIndicator(),);
                            return customLoader().scale(scaleValue: 0.8);
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => MessageScreen(), arguments: [
                                      userData!['username'],
                                      friendID
                                    ]);
                                  },
                                  child: Container(
                                    color: (data[index]['chatRead'] == false &&
                                            (data[index]['fromID'] !=
                                                auth.currentUser!.uid))
                                        ? Colors.blue.withOpacity(0.12)
                                        : Colors.white,
                                    child: ListTile(
                                      leading: userData!['user_profile_photo']
                                              .toString()
                                              .isNotEmpty
                                          ? Image.network(
                                              userData!['user_profile_photo'],
                                              width: 50,
                                            )
                                          : const CircleAvatar(
                                              child: Icon(Icons.person)),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              userData!['username'],
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          userData!['verified']
                                              ? const Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                ).marginOnly(left: 8.0)
                                              : Container()
                                        ],
                                      ),
                                      subtitle: Text(
                                        data[index]['last_message'],
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            intl.DateFormat("h:mma").format(
                                                data[index]['created_on']
                                                    .toDate()),
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w600,
                                                // fontSize: 13.1,
                                                color: Colors.black
                                                    .withOpacity(0.71)),
                                          ),
                                          Text(
                                            intl.DateFormat("yMMMMd").format(
                                                data[index]['created_on']
                                                    .toDate()),
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w600,
                                                // fontSize: 13.1,
                                                color: Colors.black
                                                    .withOpacity(0.71)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                8.heightBox,
                                const Divider(
                                  thickness: 0.25,
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  return Container();
                });
          }),
    );
  }
}
