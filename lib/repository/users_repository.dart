import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/user.dart';
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

  Future<List<MuscleData>> getMuscleData(docID) async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(docID)
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    return muscleData;
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

  ///ユーザー情報に更新があったらに呼び出す。
  Future<void> _updateLocalCache() async {
    final id = _auth.firebaseUser?.uid;
    if (id == null) {
      return null;
    }
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) {
      print("user not found");
    }
    _user = Users(doc);
  }

  void deleteLocalCache() {
    _user = null;
  }

  /// Firestoreにユーザーを登録する
  Future<void> registerUser(
      {String uid, String displayName, String email, String userID}) async {
    await _firestore.collection('users').doc(uid).set({
      "displayName": displayName,
      "email": email,
      "photoURL": "",
      "userID": userID,
      "createdAt": Timestamp.now(),
      'homeSauna': '',
    });
    //初回登録時に自分の投稿を自分のタイムラインに表示するために、タイムライン検索用配列に自分のuidを追加しておく。
    await _firestore
        .collection('users')
        .doc(uid)
        .collection("listsForTimeline")
        .doc("1")
        .set({
      "friendList": [uid]
    });
  }
}
