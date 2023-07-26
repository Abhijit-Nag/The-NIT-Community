import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/controllers/friend_controller.dart';
import 'package:the_nit_community/controllers/search_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchUserScreen extends StatelessWidget {
  SearchUserScreen({Key? key}) : super(key: key);
  var controller = Get.put(SearchUserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white)),
          child: TextFormField(
            controller: controller.userController,
            onChanged: (value) async {
              await controller.fetchSearchedUser(
                  query: controller.userController.text);
            },
            decoration: InputDecoration(
                hintText: 'Search users..',
                prefixIcon: const Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.searchedUser.isEmpty
                ? Column(
                    children: [
                      Image.asset('assets/images/searching_bg.jpg'),
                      Text(
                        'Search Existing Users.',
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue),
                      )
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.searchedUser.length,
                    itemBuilder: (context, index) {
                      print(
                          'this is the user from search: ${controller.searchedUser[index].toString()}');
                      var data = controller.searchedUser[index].data();
                      return InkWell(
                        onTap: () {
                          Get.to(() => FriendProfileScreen(
                              username: data['username'],
                              userPhoto: data['user_profile_photo'],
                              userID: controller.searchedUser[index].id));
                        },
                        child: Column(
                          children: [
                            // const Divider( thickness: 0.85,  ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(3.0)),
                              margin: const EdgeInsets.symmetric(vertical: 3.0),
                              padding: const EdgeInsets.all(3.0),
                              child: ListTile(
                                leading: data!['user_profile_photo']
                                        .toString()
                                        .isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            data['user_profile_photo']),
                                      )
                                    : CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                title: Row(
                                  children: [
                                    Text(
                                      data['username'].toString(),
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    data['verified']
                                        ? const Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                          ).marginOnly(left: 8.0)
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).marginSymmetric(horizontal: 25))

            // StreamBuilder(
            //   stream: FirebaseServices.getSearchedUsers(query: controller.userController.text),
            //     builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            //   if(!snapshot.hasData){
            //     return const Center(child: CircularProgressIndicator(),);
            //   }
            //   if(snapshot.hasError){
            //     return Center(child: Text(snapshot.error.toString()),);
            //   }
            //   var data= snapshot.data!.docs;
            //   // return Text('hello');
            //   // return Obx(() => Text(controller.searchedUser.value));
            //
            //   return ListView.builder(
            //     shrinkWrap: true,
            //       itemCount: data.length,
            //       itemBuilder: (context, index){
            //       return ListTile(
            //         leading: const CircleAvatar(child: Icon(Icons.person),),
            //         title: Text(data[index]['username']),
            //       );
            //   });
            //
            // })

            // StreamBuilder(
            //     stream: FirebaseServices.getAllUsers(),
            //     builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            //       if(!snapshot.hasData){
            //         return const Center(child: CircularProgressIndicator(),);
            //       }
            //       if(snapshot.hasError){
            //         return Center(child: Text(snapshot.error.toString()),);
            //       }
            //       var data= snapshot.data!.docs;
            //       return ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: data.length,
            //           itemBuilder: (context, index){
            //             if(data[index]['username'].toString().contains(controller.searchedUser.value)) {
            //               return Column(
            //                 children: [
            //                   const Divider(
            //                     endIndent: 250,
            //                     thickness: 0.3,
            //                   ),
            //                   ListTile(
            //                     leading: CircleAvatar(
            //                       child: Icon(Icons.person),
            //                     ),
            //                     title: Text(data[index]['username']),
            //                   ),
            //                 ],
            //               );
            //             }
            //             return Container();
            //           });
            //     })
          ],
        ),
      ),
    );
  }
}
