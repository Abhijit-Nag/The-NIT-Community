import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customLoader() {
  return VxShimmer(
      child: Row(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
      ),
      15.widthBox,
      Column(
        children: [
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
          ),
          15.heightBox,
          Container(
            width: 150,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
          ),
          15.heightBox,
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
          )
        ],
      )
    ],
  ).marginAll(25));
}
