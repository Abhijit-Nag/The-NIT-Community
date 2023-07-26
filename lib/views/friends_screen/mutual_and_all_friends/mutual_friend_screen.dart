import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';

class MutualFriendScreen extends StatelessWidget {
  List friendData;
  MutualFriendScreen({Key? key, required this.friendData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (friendData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/best-friend.png',
              width: MediaQuery.of(context).size.width * 0.51,
            ),
            Text(
              'No Mutual friends.',
              style: GoogleFonts.openSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: ListView.builder(
          itemCount: friendData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => FriendProfileScreen(
                    username: friendData[index]['username'],
                    userPhoto: friendData[index]['userPhoto'],
                    userID: friendData[index]['userID']));
              },
              child: ListTile(
                leading: friendData[index]['userPhoto'].toString().isEmpty
                    ? const CircleAvatar(
                        child: Icon(Icons.person),
                      )
                    : Image.network(
                        friendData[index]['userPhoto'],
                        width: 35,
                      ),
                title: Text(friendData[index]['username']),
              ),
            );
          }),
    );
  }
}
