import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CalenderSaveModel extends ChangeNotifier {
  String viewDate; //表示する日付
  DateTime pickedDate; //datepickerで取得する日付
  double additionalWeight; //textfieldで入力する値
  double additionalBodyFatPercentage;
  DateTime additionalDate = DateTime.now(); //firestoreに入れる日付
  File imageFile;
  List<MuscleData> muscleData = [];
  bool sameDate;
  MuscleData sameDateMuscleData;
  bool loadingData = false;
  String imagePath;

  Future fetchDataJudgeDate() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;

    loadingData = true;

    viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now());
    for (int i = 0; i < muscleData.length; i++) {
      if (viewDate == muscleData[i].date) {
        //更新
        sameDate = true;
        sameDateMuscleData = muscleData[i];
        if (sameDateMuscleData.imagePath != null)
          imageFile = File(sameDateMuscleData.imagePath);
        break;
      } else {
        //保存
        sameDate = false;
      }
    }
    notifyListeners();
  }

  Future fetchData() async {
    final docs = await FirebaseFirestore.instance
        .collection('muscleData')
        .orderBy('date', descending: true)
        .get();
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    this.muscleData = muscleData;
  }

  Future judgeDate() async {
    for (int i = 0; i < muscleData.length; i++) {
      if (viewDate == muscleData[i].date) {
        //更新
        sameDate = true;
        sameDateMuscleData = muscleData[i];
        if (sameDateMuscleData.imagePath != null)
          imageFile = File(sameDateMuscleData.imagePath);
        break;
      } else {
        //保存
        sameDate = false;
      }
    }
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
    final result = await showCupertinoBottomBar(context);

    if (result == 0) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      imagePath = pickedFile.path;
      if (sameDate == true) sameDateMuscleData.imagePath = imagePath;
      imageFile = File(imagePath);
    } else if (result == 1) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imagePath = pickedFile.path;
      if (sameDate == true) sameDateMuscleData.imagePath = imagePath;
      imageFile = File(imagePath);
    }
    notifyListeners();
  }

  //写真をカメラロールから選ぶ
  /* Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }
*/
  Future addDataToFirebase() async {
    //firebaseに値を追加
    if (additionalWeight == null) {
      throw ('体重を入力してください');
    }
    if (imageFile != null && additionalBodyFatPercentage != null) {
      //写真と体脂肪率があるとき
      final imageURL = await _uploadImage();
      await FirebaseFirestore.instance.collection('muscleData').add(
        {
          'weight': additionalWeight,
          'bodyFatPercentage': additionalBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          'imageURL': imageURL,
          'imagePath': imagePath,
        },
      );
    } else if (imageFile == null && additionalBodyFatPercentage != null) {
      //写真なし＆体脂肪率あり
      //   final imageURL = await _uploadImage();
      await FirebaseFirestore.instance.collection('muscleData').add(
        {
          'weight': additionalWeight,
          'bodyFatPercentage': additionalBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          //    'imageURL': imageURL,
        },
      );
    } else if (imageFile != null && additionalBodyFatPercentage == null) {
      //写真アリ＆体脂肪率なし
      final imageURL = await _uploadImage();
      await FirebaseFirestore.instance.collection('muscleData').add(
        {
          'weight': additionalWeight,
          //  'bodyFatPercentage': addBodyFatPercentage,
          'date': Timestamp.fromDate(additionalDate),
          'StringDate': viewDate,
          'imageURL': imageURL,
          'imagePath': imagePath,
        },
      );
    } else if (imageFile == null && additionalBodyFatPercentage == null) {
      //写真なし＆体脂肪率なし
      //   final imageURL = await _uploadImage();
      await FirebaseFirestore.instance.collection('muscleData').add(
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
    if (additionalWeight == null) {
      throw ('体重を入力してください');
    }
    if (imageFile != null && additionalBodyFatPercentage != null) {
      //写真と体脂肪率があるとき
      final imageURL = await _uploadImage();
      final document = FirebaseFirestore.instance
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'bodyFatPercentage': additionalBodyFatPercentage,
        'imageURL': imageURL,
        'imagePath': imagePath,
      });
    } else if (imageFile == null && additionalBodyFatPercentage != null) {
      final document = FirebaseFirestore.instance
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'bodyFatPercentage': additionalBodyFatPercentage,
      });
    } else if (imageFile != null && additionalBodyFatPercentage == null) {
      final imageURL = await _uploadImage();
      final document = FirebaseFirestore.instance
          .collection('muscleData')
          .doc(muscleData.documentID);
      await document.update({
        'weight': additionalWeight,
        'imageURL': imageURL,
        'imagePath': imagePath,
      });
    } else if (imageFile == null && additionalBodyFatPercentage == null) {
      final document = FirebaseFirestore.instance
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
        .child("muscle/$additionalWeight")
        .putFile(imageFile)
        .onComplete;
    final String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
