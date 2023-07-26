import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    await getChatDocID();
    print('seen Message process');

    var chatDocReference = fireStore.collection(chatCollection).doc(chatDocID);
    var chatDocSnapshot = await chatDocReference.get();
    if (chatDocSnapshot.exists) {
      if (chatDocSnapshot['fromID'] != auth.currentUser!.uid) {
        await seenMessage(chatDocID: chatDocID);
      }
    }
    print('seen Message process.');
    super.onInit();
  }

  var isLoading = false.obs;

  var chatDocID = "";
  var friendID = Get.arguments[1];
  var friendName = Get.arguments[0];

  var msgController = TextEditingController();

  ScrollController scrollController = ScrollController();

  var focusNode = FocusNode().obs;

  getChatDocID() async {
    isLoading.value = true;
    var chat = await fireStore.collection(chatCollection).where('users',
        isEqualTo: {auth.currentUser!.uid: null, friendID: null}).get();

    if (chat.docs.isNotEmpty) {
      //  chat exists
      chatDocID = chat.docs.single.id;

      var dataReference = fireStore.collection(chatCollection).doc(chatDocID);
      var data = await dataReference.get();
      if (data['fromID'] != auth.currentUser!.uid) {
        await dataReference.update({"chatRead": true});
      }
    } else {
      var docRef = await fireStore.collection(chatCollection).add({
        "sender_name": auth.currentUser!.displayName,
        "friend_name": friendName,
        "created_on": null,
        "fromID": auth.currentUser!.uid,
        "toID": friendID,
        "last_message": "",
        "users_id": [friendID, auth.currentUser!.uid],
        "users": {auth.currentUser!.uid: null, friendID: null},
        "chatRead": true
      });

      chatDocID = docRef.id;
    }

    isLoading.value = false;
  }

  sendMessage({required context, required message}) async {
    if (msgController.text.trim().isNotEmpty) {
      await fireStore.collection(chatCollection).doc(chatDocID).update({
        "created_on": FieldValue.serverTimestamp(),
        "last_message": message,
        "fromID": auth.currentUser!.uid,
        "toID": friendID,
        "chatRead": false
      });

      await fireStore
          .collection(chatCollection)
          .doc(chatDocID)
          .collection(messageCollection)
          .add({
        "created_on": FieldValue.serverTimestamp(),
        "msg": message,
        "uid": auth.currentUser!.uid,
        "messageRead": false
      });
      scrollToBottom();
    } else {
      VxToast.show(context, msg: "Please type some message first.");
    }

    msgController.text = "";
  }

  seenMessage({required chatDocID}) async {
    print('seenMessage process started.');
    await fireStore
        .collection(chatCollection)
        .doc(chatDocID)
        .update({"chatRead": true});
    var messageReference = await fireStore
        .collection(chatCollection)
        .doc(chatDocID)
        .collection(messageCollection)
        .get();
    for (int i = 0; i < messageReference.docs.length; i++) {
      var messageID = messageReference.docs[i].id;
      await fireStore
          .collection(chatCollection)
          .doc(chatDocID)
          .collection(messageCollection)
          .doc(messageID)
          .update({"messageRead": true});
    }

    print('seenMessage process ended.');

    // scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
