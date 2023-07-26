// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:the_nit_community/constants/firebase_constants.dart';
//
// class SearchUserController extends GetxController{
//
//   var searchTextController= TextEditingController();
//
//   var result=[].obs;
//
//
//   searchUser()async{
//     result.value.clear();
//     var usersQuerySnapshot =await fireStore.collection(userCollection).get();
//     List<DocumentSnapshot> users= usersQuerySnapshot.docs;
//     List<DocumentSnapshot> searched= users.where((element) => element['username'].toString().toLowerCase().contains(searchTextController.text.toLowerCase())).toList();
//     for(int i=0;i<searched.length;i++){
//       Map<String, dynamic>? searchedData = searched[i].data() as Map<String, dynamic>?;
//       result.value.add(searchedData);
//       print(searchedData!['username']);
//     }
//     print(result.value);
//   }
// }

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';

class SearchUserController extends GetxController {
  var userController = TextEditingController();
  var searchedUser = [].obs;

  Timer? debounce;

  fetchSearchedUser({required query}) async {
    if (debounce?.isActive ?? false) debounce!.cancel();

    searchedUser.value = [];
    debounce = Timer(const Duration(milliseconds: 1000), () async {
      var userDataQuerySnapshot =
          await fireStore.collection(userCollection).get();
      for (int i = 0; i < userDataQuerySnapshot.docs.length; i++) {
        var userDataSnapshot = userDataQuerySnapshot!.docs[i];
        var userData = userDataSnapshot.data();
        if (userData['username'].toString().contains(query)) {
          searchedUser.add(userDataSnapshot);
        }
      }
    });
  }
}
