import 'package:cloud_firestore/cloud_firestore.dart';

class MuscleData {
  MuscleData(DocumentSnapshot doc) {
    documentID = doc.id;
    weight = doc.data()['weight'];
  }

  String documentID;
  double weight;
}
