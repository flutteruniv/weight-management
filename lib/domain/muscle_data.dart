import 'package:cloud_firestore/cloud_firestore.dart';

class MuscleData {
  MuscleData(DocumentSnapshot doc) {
    documentID = doc.id;
    weight = doc.data()['weight'];
    imageURL = doc.data()['imageURL'];
    date = doc.data()['StringDate'];
  }

  String documentID;
  double weight;
  String imageURL;
  String date;
}
