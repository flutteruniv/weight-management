import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final User user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;

    if (user != null) {
      uid = user.uid;
    }
    final email = user.email;

    final newDoc = FirebaseFirestore.instance.collection('users').doc();
    newDoc.set(
      {
        'email': email,
        'createdAt': Timestamp.now(),
        'userID': uid,
        'documentID': newDoc.id,
      },
    );
    notifyListeners();
  }
}
