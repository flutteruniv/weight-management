import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weight_management/domain/muscle_data.dart';

class CalenderSaveModel extends ChangeNotifier {
  String viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now()); //表示する日付
  DateTime picked; //datepickerで取得する日付
  double addWeight; //textfieldで入力する値
  DateTime addDate = DateTime.now(); //firestoreに入れる日付
  File imageFile;

  void selectDate() async {
    //datepickerでとった値を入れる
    if (picked != null) {
      viewDate = (DateFormat('yyyy/MM/dd')).format(picked);
      addDate = picked;
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
      imageFile = File(pickedFile.path);
    } else if (result == 1) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imageFile = File(pickedFile.path);
    }
    notifyListeners();
  }

  //写真をカメラロールから選ぶ
  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future addDataToFirebase() async {
    //firebaseに値を追加
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    final imageURL = await _uploadImage();
    await FirebaseFirestore.instance.collection('muscleData').add(
      {
        'weight': addWeight,
        'date': Timestamp.fromDate(addDate),
        'StringDate': viewDate,
        'imageURL': imageURL,
      },
    );
  }

  Future upDateData(MuscleData muscleData) async {
    if (addWeight == null) {
      throw ('体重を入力してください');
    }
    final document = FirebaseFirestore.instance
        .collection('muscleData')
        .doc(muscleData.documentID);
    await document.update({'weight': addWeight});
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    StorageTaskSnapshot snapshot = await storage
        .ref()
        .child("muscle/$addWeight")
        .putFile(imageFile)
        .onComplete;
    final String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
