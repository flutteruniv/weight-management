import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/user.dart';

class CalenderSaveModel extends ChangeNotifier {
  String viewDate; //表示する日付
  DateTime pickedDate; //datepickerで取得する日付
  double additionalWeight; //textfieldで入力する値
  double additionalBodyFatPercentage;
  DateTime additionalDate = DateTime.now(); //firestoreに入れる日付
  File imageFile;
  List<MuscleData> muscleData = [];
  bool sameDate = false;
  MuscleData sameDateMuscleData;
  bool loadingData = false;
  TextEditingController weightTextController, fatTextController;
  String imageURL;

  List<Users> userData = [];
  String userDocID;

  bool hasData;

  Future deleteDate() {
    weightTextController = TextEditingController(text: '');
    fatTextController = TextEditingController(text: '');
    additionalWeight = null;
    additionalBodyFatPercentage = null;
    imageFile = null;
  }

  Future initData() async {
    final docss = await FirebaseFirestore.instance.collection('users').get();
    final userData = docss.docs.map((doc) => Users(doc)).toList();
    this.userData = userData;
    for (int i = 0; i < userData.length; i++) {
      if (userData[i].userID == FirebaseAuth.instance.currentUser.uid) {
        userDocID = userData[i].documentID;
        break;
      }
    }
    //データがあるかないか判断
    try {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .orderBy('date', descending: true)
          .get();
      final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
      this.muscleData = muscleData;
      if (muscleData[0] != null) hasData = true;
    } catch (e) {
      hasData = false;
    }
    loadingData = true;

    viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now());
    imageFile = null;

    if (hasData) {
      for (int i = 0; i < muscleData.length; i++) {
        if (viewDate == muscleData[i].date) {
          //更新
          sameDate = true;
          sameDateMuscleData = muscleData[i];
          if (sameDateMuscleData.imageURL != null) {
            // imageFile = File(sameDateMuscleData.imagePath);
            // imagePath = sameDateMuscleData.imagePath;
            imageURL = sameDateMuscleData.imageURL;
          }
          break;
        } else {
          //保存
          sameDate = false;
        }
      }

      if (sameDate) {
        if (sameDateMuscleData.bodyFatPercentage != null) {
          //同じ日付があればもともとの体重などを表示
          weightTextController =
              TextEditingController(text: sameDateMuscleData.weight.toString());
          fatTextController = TextEditingController(
              text: sameDateMuscleData.bodyFatPercentage.toString());
          additionalWeight = double.parse(weightTextController.text);
          additionalBodyFatPercentage = double.parse(fatTextController.text);
        } else if (sameDateMuscleData.bodyFatPercentage == null) {
          //体脂肪なしだと体脂肪の初期値なし
          weightTextController =
              TextEditingController(text: sameDateMuscleData.weight.toString());
          fatTextController = TextEditingController(text: '');
          additionalWeight = double.parse(weightTextController.text);
          additionalBodyFatPercentage = null;
        }
        if (sameDateMuscleData.imageURL != null) {
          // imageFile = File(sameDateMuscleData.imagePath);

          imageURL = sameDateMuscleData.imageURL;
        } else {
          imageFile = null;
        }
      } else {
        //同じ日付がなければ初期値なし
        weightTextController = TextEditingController(text: '');
        fatTextController = TextEditingController(text: '');
        additionalWeight = null;
        additionalBodyFatPercentage = null;
        imageFile = null;
        imageURL = null;
      }
    } else {
      weightTextController = TextEditingController(text: '');
      fatTextController = TextEditingController(text: '');
      additionalWeight = null;
      additionalBodyFatPercentage = null;
      imageFile = null;
      imageURL = null;
      sameDate = false;
    }

    notifyListeners();
  }

  Future setText() {
    if (sameDate) {
      if (sameDateMuscleData.bodyFatPercentage != null) {
        //同じ日付があればもともとの体重などを表示
        weightTextController =
            TextEditingController(text: sameDateMuscleData.weight.toString());
        fatTextController = TextEditingController(
            text: sameDateMuscleData.bodyFatPercentage.toString());
        additionalWeight = double.parse(weightTextController.text);
        additionalBodyFatPercentage = double.parse(fatTextController.text);
      } else if (sameDateMuscleData.bodyFatPercentage == null) {
        //体脂肪なしだと体脂肪の初期値なし
        weightTextController =
            TextEditingController(text: sameDateMuscleData.weight.toString());
        fatTextController = TextEditingController(text: '');
        additionalWeight = double.parse(weightTextController.text);
        additionalBodyFatPercentage = null;
      }
      if (sameDateMuscleData.imageURL != null) {
        //   imageFile = File(sameDateMuscleData.imagePath);
        imageURL = sameDateMuscleData.imageURL;
      } else {
        //   imageFile = null;

        imageURL = null;
      }
    } else {
      //同じ日付がなければ初期値なし
      weightTextController = TextEditingController(text: '');
      fatTextController = TextEditingController(text: '');
      additionalWeight = null;
      additionalBodyFatPercentage = null;
      imageFile = null;
      imageURL = null;
      sameDate = false;
    }
    notifyListeners();
  }

  Future fetchData() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .doc(userDocID)
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;
    notifyListeners();
  }

  Future judgeDate() async {
    for (int i = 0; i < muscleData.length; i++) {
      if (viewDate == muscleData[i].date) {
        //更新
        sameDate = true;
        sameDateMuscleData = muscleData[i]; //日付が同じならそのmuscledataを取得
        if (sameDateMuscleData.imageURL != null) {
          //写真があれば取得
          imageURL = sameDateMuscleData.imageURL;
        }
        break;
      } else {
        //保存
        sameDate = false;
      }
    }
    imageFile = null;
    notifyListeners();
  }

  void selectDate() async {
    //datepickerでとった値を入れる
    if (pickedDate != null) {
      viewDate = (DateFormat('yyyy/MM/dd')).format(pickedDate);
      additionalDate = pickedDate;
    }
    notifyListeners();
  }

  Future<int> showCupertinoBottomBar(BuildContext context) {
    //選択するためのボトムシートを表示
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('写真をアップロードしますか？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'カメラで撮影',
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'アルバムから選択',
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, 2);
              },
              isDefaultAction: true,
            ),
          );
        });
  }

  void showBottomSheet(BuildContext context) async {
    //ボトムシートから受け取った値によって操作を変える
    final cameraResult = await showCupertinoBottomBar(context);

    if (cameraResult == 0) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      imageFile = File(pickedFile.path);
    } else if (cameraResult == 1) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imageFile = File(pickedFile.path);
    }
    notifyListeners();
  }

  Future addDataToFirebase() async {
    //firebaseに値を追加
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (additionalWeight == null) {
      throw ('体重を入力してください');
    }
    if (imageFile != null && additionalBodyFatPercentage != null) {
      //写真と体脂肪率があるとき
      final imageURL = await _uploadImage();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .add(
        {
          'weight': additionalWeight,
          'bodyFatPercentage': additionalBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          'imageURL': imageURL,
        },
      );
    } else if (imageFile == null && additionalBodyFatPercentage != null) {
      //写真なし＆体脂肪率あり
      //   final imageURL = await _uploadImage();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .add(
        {
          'weight': additionalWeight,
          'bodyFatPercentage': additionalBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
        },
      );
    } else if (imageFile != null && additionalBodyFatPercentage == null) {
      //写真アリ＆体脂肪率なし
      final imageURL = await _uploadImage();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .add(
        {
          'weight': additionalWeight,
          //  'bodyFatPercentage': addBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          'imageURL': imageURL,
        },
      );
    } else if (imageFile == null && additionalBodyFatPercentage == null) {
      //写真なし＆体脂肪率なし
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .add(
        {
          'weight': additionalWeight,
          //  'bodyFatPercentage': addBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          //    'imageURL': imageURL,
        },
      );
    }
  }

  Future updateData(MuscleData muscleData) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (additionalWeight == null) {
      throw ('体重を入力してください');
    }
    if (imageFile != null && additionalBodyFatPercentage != null) {
      //写真と体脂肪率があるとき
      final imageURL = await _uploadImage();
      final document = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'bodyFatPercentage': additionalBodyFatPercentage,
        'imageURL': imageURL,
      });
    } else if (imageFile == null && additionalBodyFatPercentage != null) {
      final document = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'bodyFatPercentage': additionalBodyFatPercentage,
      });
    } else if (imageFile != null && additionalBodyFatPercentage == null) {
      final imageURL = await _uploadImage();
      final document = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'imageURL': imageURL,
      });
    } else if (imageFile == null && additionalBodyFatPercentage == null) {
      final document = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocID)
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
      });
    }
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    StorageTaskSnapshot snapshot = await storage
        .ref()
        .child("muscle/$userDocID/$viewDate")
        .putFile(imageFile)
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
