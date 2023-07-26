import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';

class NotificationController extends GetxController {
  markAsRead({required notificationID}) async {
    await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(notificationCollections)
        .doc(notificationID)
        .update({"notification_read": true});
  }

  removeNotification({required notificationID}) async {
    await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(notificationCollections)
        .doc(notificationID)
        .delete();
  }
}
