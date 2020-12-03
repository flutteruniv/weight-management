import 'package:cloud_firestore/cloud_firestore.dart';

class IdealMuscleData {
  IdealMuscleData(DocumentSnapshot doc) {
    documentID = doc.id;
    weight = doc.data()['weight'];
    imageURL = doc.data()['imageURL'];
    bodyFatPercentage = doc.data()['bodyFatPercentage'];
    imagePath = doc.data()['imagePath'];
  }
  String documentID;
  double weight;
  String imageURL;
  double bodyFatPercentage;
  String imagePath;
}
