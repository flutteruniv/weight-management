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
    try {
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
    } catch (e) {
      print(e.code);
      throw (_convertErrorMessage(e.code));
    }

    notifyListeners();
  }

  String _convertErrorMessage(e) {
    switch (e) {
      case 'invalid-email':
        return 'メールアドレスを正しい形式で入力してください';
      case 'too-many-requests':
        return 'しばらく待ってからお試し下さい';
      case 'email-already-in-use':
        return 'このメールアドレスはすでに登録されています。';
      case 'weak-password':
        return 'パスワードを6文字以上に設定してください';

      default:
        return '不明なエラーです';
    }
  }
}
