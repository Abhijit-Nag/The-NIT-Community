import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/chat_screen/message_screen.dart';
import 'package:the_nit_community/widgets/custom_loader.dart';
import 'package:velocity_x/velocity_x.dart';

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder(
              stream: FirebaseServices.getAllUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  // return const Center(child: CircularProgressIndicator(),);
                  return customLoader().scale(scaleValue: 0.8);
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                var data = snapshot.data!.docs;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // var userData= data![index] as Map<String, dynamic>?;
                      //   var userData= data![index].data() as Map<String, dynamic>?;
                      if (data[index].id == auth.currentUser!.uid) {
                        return Container();
                      }
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => MessageScreen(), arguments: [
                                data[index]['username'],
                                data[index].id
                              ]);
                            },
                            child: ListTile(
                              leading: data[index]['user_profile_photo']
                                      .toString()
                                      .isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          data[index]['user_profile_photo']),
                                    )
                                  : const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                              title: Row(
                                children: [
                                  Text(
                                    data[index]['username'],
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  data[index]['verified']
                                      ? const Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 18,
                                        ).marginOnly(left: 3.0)
                                      : Container()
                                ],
                              ),
                              subtitle: Text(
                                'Start chatting with ${data[index]['username']}.',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              trailing: const Icon(
                                Icons.chat,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 0.35,
                          ),
                        ],
                      );
                    });
              }),
        ),
      ),
    );
  }
}
