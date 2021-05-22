import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:weight_management/domain/ideal_muscle_data.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/auth_repository.dart';

/// ログインしているユーザーを操作する
class UsersRepository {
  static UsersRepository _instance;
  UsersRepository._();
  static UsersRepository get instance {
    if (_instance == null) {
      _instance = UsersRepository._();
    }
    return _instance;
  }

  final _auth = AuthRepository.instance;
  final _firestore = FirebaseFirestore.instance;

  /// ユーザー情報（ここで保持することでメモリキャッシュしている）
  Users _user;

  /// ユーザーを返す
  /// 一度取得したらメモリキャッシュしておく
  Future<Users> fetch() async {
    if (_user == null) {
      final id = _auth.firebaseUser?.uid;
      if (id == null) {
        return null;
      } else {
        print(id);
      }
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        print("user not found!");
      }
      _user = Users(doc);
    }
    return _user;
  }

  /// Firestoreにユーザーを登録する
  Future<void> registerUser(
      {String uid,
      String email,
      DocumentReference documentReference,
      String documentID}) async {
    await documentReference.set({
      "userID": uid,
      "email": email,
      "createdAt": Timestamp.now(),
      "documentID": documentID,
    });
  }

  Future<void> deleteMuscleData(Users user, MuscleData muscleData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.documentID)
        .collection('muscleData')
        .doc(muscleData.documentID)
        .delete();
  }

  Future<List<MuscleData>> getMuscleData(
      {String docID, String orderByState, bool bool}) async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(docID)
        .collection('muscleData')
        .orderBy(orderByState, descending: bool)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    return muscleData;
  }

  Future<IdealMuscleData> getIdealMuscleData({String docID}) async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(docID)
        .collection('idealMuscleData')
        .limit(1)
        .get();
    final idealMuscleData =
        docs.docs.map((doc) => IdealMuscleData(doc)).toList();
    final idealMuscle = idealMuscleData.first;
    return idealMuscle;
  }

  Future<void> addMuscleData(
      {Users user,
      double weight,
      double fat,
      DateTime dateTime,
      String imageURL,
      int angle}) async {
    final ref = _firestore
        .collection("users")
        .doc(user.documentID)
        .collection("muscleData");
    await ref.add({
      'weight': weight,
      'bodyFatPercentage': fat,
      'date': Timestamp.fromDate(dateTime),
      'StringDate': (DateFormat('yyyy/MM/dd')).format(dateTime),
      'imageURL': imageURL,
      'angle': angle,
    });
  }

  Future<void> updateMuscleData(
      {Users user,
      MuscleData muscleData,
      double weight,
      double fat,
      DateTime dateTime,
      String imageURL,
      int angle}) async {
    final ref = _firestore
        .collection("users")
        .doc(user.documentID)
        .collection("muscleData")
        .doc(muscleData.documentID);
    await ref.update({
      'weight': weight,
      'bodyFatPercentage': fat,
      'date': Timestamp.fromDate(dateTime),
      'StringDate': (DateFormat('yyyy/MM/dd')).format(dateTime),
      'imageURL': imageURL,
      'angle': angle,
    });
  }

  Future<void> addIdealMuscleData(
      {Users user,
      double weight,
      double fat,
      DateTime dateTime,
      String imageURL,
      int angle}) async {
    final ref = _firestore
        .collection("users")
        .doc(user.documentID)
        .collection("idealMuscleData");
    await ref.add({
      'weight': weight,
      'bodyFatPercentage': fat,
      'date': Timestamp.fromDate(dateTime),
      'StringDate': (DateFormat('yyyy/MM/dd')).format(dateTime),
      'imageURL': imageURL,
      'angle': angle,
    });
  }

  Future<void> updateIdealMuscleData({
    Users user,
    IdealMuscleData idealMuscleData,
    double weight,
    double fat,
    DateTime dateTime,
    String imageURL,
  }) async {
    final ref = _firestore
        .collection("users")
        .doc(user.documentID)
        .collection("idealMuscleData")
        .doc(idealMuscleData.documentID);
    await ref.update({
      'weight': weight,
      'bodyFatPercentage': fat,
      'date': Timestamp.fromDate(dateTime),
      'StringDate': (DateFormat('yyyy/MM/dd')).format(dateTime),
      'imageURL': imageURL,
    });
  }
}
