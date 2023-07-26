import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/views/chat_screen/all_chat_screen.dart';
import 'package:the_nit_community/views/chat_screen/suggestion_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chats',
                  style: GoogleFonts.firaSans(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 25),
                ).marginOnly(left: 28),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            TabBar(tabs: [
              Text(
                'Your messages',
                style: GoogleFonts.firaSans(
                    color: Colors.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              Text(
                'Suggestions',
                style: GoogleFonts.firaSans(
                    color: Colors.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ]),
            8.heightBox,
            Expanded(
              child:
                  TabBarView(children: [AllChatScreen(), SuggestionScreen()]),
            ),
          ],
        ),
      ),
    );
  }
}
