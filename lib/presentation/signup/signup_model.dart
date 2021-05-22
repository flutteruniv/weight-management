import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/repository/auth_repository.dart';
import 'package:weight_management/repository/users_repository.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final _authRepository = AuthRepository.instance;
  final _userRepository = UsersRepository.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    try {
      User _user =
          await _authRepository.signUp(email: mail, password: password);
      final newDoc =
          FirebaseFirestore.instance.collection('users').doc(_user.uid);
      _userRepository.registerUser(
          uid: _user.uid,
          email: _user.email,
          documentReference: newDoc,
          documentID: newDoc.id);
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
