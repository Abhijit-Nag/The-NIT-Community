import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            child: "Are you sure, you want to exit?"
                .text
                .fontWeight(FontWeight.bold)
                .color(Colors.black.withOpacity(0.5))
                .size(18)
                .make(),
          ),
          10.heightBox,
          const Divider(),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      'Yes',
                      style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    )),
              ),
              15.widthBox,
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No',
                        style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18))),
              )
            ],
          )
        ],
      ).box.roundedSM.padding(const EdgeInsets.all(10)).height(150).make(),
    ),
  );
}
