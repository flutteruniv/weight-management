import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:weight_management/repository/auth_repository.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _authRepository = AuthRepository.instance;

  String email;

  Future<String> sendPasswordResetEmail(
      String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      Flushbar(
        message: "パスワードリセットメールを送信しました",
        backgroundColor: Colors.blue,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      )..show(context);
    } catch (error) {
      switch (error.code) {
        case 'invalid-email':
          Flushbar(
            message: "無効なメールアドレスです",
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 3),
          )..show(context);
          break;
        case 'user-not-found':
          Flushbar(
            message: "メールアドレスが登録されていません",
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 3),
          )..show(context);
          break;
        default:
          Flushbar(
            message: "メール送信に失敗しました",
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 3),
          )..show(context);
          break;
      }
    }
    notifyListeners();
  }

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    try {
      final user = await _authRepository.login(email: mail, password: password);
    } catch (e) {
      print(e.code);
      throw (_convertErrorMessage(e.code));
    }
    // TODO 端末に保存
    notifyListeners();
  }

  String _convertErrorMessage(e) {
    switch (e) {
      case 'invalid-email':
        return 'メールアドレスを正しい形式で入力してください';
      case 'wrong-password':
        return 'パスワードが間違っています';
      case 'user-not-found':
        return 'ユーザーが見つかりません';
      case 'user-disabled':
        return 'ユーザーが無効です';
      case 'too-many-requests':
        return 'しばらく待ってからお試し下さい';
      default:
        return '不明なエラーです';
    }
  }
}
