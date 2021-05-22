import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weight_management/domain/ideal_muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/auth_repository.dart';
import 'package:weight_management/repository/users_repository.dart';
import 'package:weight_management/services/dialog_helper.dart';

class MyPageModel extends ChangeNotifier {
  double idealWeight;
  double idealFat;
  File idealImageFile;
  String idealImagePath;
  String idealImageURL;
  List<Users> userData = [];
  String userDocID;
  List<IdealMuscleData> idealMuscleList = [];
  IdealMuscleData idealMuscle;
  TextEditingController idealWeightTextController, idealFatTextController;
  bool hasIdealMuscle = false;
  int angle = 0;

  final User currentUser = FirebaseAuth.instance.currentUser;
  final _usersRepository = UsersRepository.instance;
  final _authRepository = AuthRepository.instance;
  Users myUser;

  Future changeAngle() {
    angle = angle + 45;
    if (angle == 360) angle = 0;
    notifyListeners();
  }

  Future sighOut() {
    _authRepository.signOut();
  }

  Future fetch(BuildContext context) async {
    if (currentUser != null) {
      try {
        myUser = await _usersRepository.fetch();
        idealMuscle =
            await _usersRepository.getIdealMuscleData(docID: myUser.documentID);
        hasIdealMuscle = true;
        setText();
      } catch (e) {
        hasIdealMuscle = false;
        print("${e.toString()}マイページ");
      }
    }
  }

  Future setText() {
    idealWeight = idealMuscle.weight;
    idealWeightTextController =
        TextEditingController(text: idealWeight.toString());

    if (idealFat != null) {
      idealFat = idealMuscle.bodyFatPercentage;
      idealFatTextController = TextEditingController(text: idealFat.toString());
    }
    if (idealImageURL != null) {
      idealImageURL = idealMuscle.imageURL;
    }
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    idealImagePath = pickedFile.path;
    idealImageFile = File(idealImagePath);
    notifyListeners();
  }

  Future addDate(BuildContext context) async {
    if (idealWeight == null) {
      throw ('体重を入力してください');
    } else {
      if (idealImageFile != null) idealImageURL = await _uploadImage();
      if (!hasIdealMuscle) {
        _usersRepository.addIdealMuscleData(
          user: myUser,
          weight: idealWeight,
          fat: idealFat,
          dateTime: DateTime.now(),
          imageURL: idealImageURL,
        );
        print('追加');
        showAlertDialog(context, '追加しました');
      } else {
        _usersRepository.updateIdealMuscleData(
          user: myUser,
          idealMuscleData: idealMuscle,
          weight: idealWeight,
          fat: idealFat,
          dateTime: DateTime.now(),
          imageURL: idealImageURL,
        );
        print('更新');
        showAlertDialog(context, '更新しました');
      }
    }
    notifyListeners();
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    StorageTaskSnapshot snapshot = await storage
        .ref()
        .child("idealMuscle/$userDocID")
        .putFile(idealImageFile)
        .onComplete;
    final String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  void showProgressDialog(context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
