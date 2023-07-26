import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;
var fireStore = FirebaseFirestore.instance;

const userCollection = "users";
const postCollection = "posts";
const commentsCollection = "comments";
const notificationCollections = "notifications";
const chatCollection = "chats";
const messageCollection = "messages";
const feedbackCollection = "feedbacks";
