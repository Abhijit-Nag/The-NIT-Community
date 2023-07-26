import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget infoDialog(context, info) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: Text(
        info,
        style: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
      ).marginSymmetric(horizontal: 15),
    ),
  );
}
