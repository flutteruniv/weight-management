import 'package:firebase_auth/firebase_auth.dart';

// 認証系の処理
class AuthRepository {
  static AuthRepository _instance;
  AuthRepository._();
  static AuthRepository get instance {
    if (_instance == null) {
      _instance = AuthRepository._();
    }
    return _instance;
  }

  final _auth = FirebaseAuth.instance;

  /// ログイン
  Future<User> login({String email, String password}) async {
    UserCredential firebaseUser =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("ログイン成功");
    return firebaseUser.user;
  }

  /// サインアップ
  Future<User> signUp({String email, String password}) async {
    final firebaseUser =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return firebaseUser.user;
  }

  /// サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ログイン中Firebaseユーザを返す
  User get firebaseUser => _auth.currentUser;

  /// ログイン中かどうかを返す
  bool get isLogin => _auth.currentUser != null;
}
