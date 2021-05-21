import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser(DocumentSnapshot doc) {
    documentID = doc.id;
    userID = doc.data()['userID'];
  }
  String documentID;
  String userID;
}
