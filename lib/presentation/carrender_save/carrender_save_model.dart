import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weight_management/domain/muscle_data.dart';
import 'package:weight_management/domain/app_user.dart';
import 'package:weight_management/repository/users_repository.dart';
import 'package:weight_management/services/dialog_helper.dart';

class CalenderSaveModel extends ChangeNotifier {
  AppUser myUser;
  String viewDate = (DateFormat('yyyy/MM/dd')).format(DateTime.now()); //表示する日付
  DateTime pickedDate = DateTime.now();
  double addWeight;
  double addFatPercentage;
  DateTime addedDate = DateTime.now();
  File imageFile;
  String imageURL = '';
  int angle = 0;
  String userDocumentID;
  List<MuscleData> muscleData = [];
  MuscleData sameDateMuscleData;
  bool loadingData = false;
  TextEditingController weightTextController, fatTextController;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final _usersRepository = UsersRepository.instance;

  Future initState() async {
    if (currentUser != null) {
      try {
        myUser = await _usersRepository.fetch();
        muscleData = await _usersRepository.getMuscleData(
            docID: myUser.documentID, orderByState: 'date', bool: true);
        userDocumentID = myUser.documentID;
      } catch (e) {
        print(e.toString());
      }

      imageFile = null;

      await judgeSameDate(viewDate);
      if (sameDateMuscleData != null) {
        print('set');
        set();
      } else {
        print('initialize');
        initialize();
      }
    }

    loadingData = true;
    notifyListeners();
  }

  Future changeAngle() {
    angle = angle + 45;
    if (angle == 360) angle = 0;
    notifyListeners();
  }

  Future deleteDate() {
    weightTextController = TextEditingController(text: '');
    fatTextController = TextEditingController(text: '');
    addWeight = null;
    addFatPercentage = null;
    imageFile = null;
  }

  void initialize() {
    weightTextController = TextEditingController(text: '');
    fatTextController = TextEditingController(text: '');
    addWeight = null;
    addFatPercentage = null;
    imageFile = null;
    imageURL = null;
    angle = 0;
  }

  Future judgeSameDate(String dateTime) async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentID)
        .collection('muscleData')
        .where('StringDate', isEqualTo: dateTime)
        .get();
    print(docs);
    final muscleData = docs.docs.map((doc) => MuscleData(doc)).toList();
    if (muscleData.isNotEmpty) {
      sameDateMuscleData = muscleData.first;
    } else {
      sameDateMuscleData = null;
    }
    imageFile = null;
    notifyListeners();
  }

  void set() {
    if (sameDateMuscleData != null) {
      weightTextController =
          TextEditingController(text: sameDateMuscleData.weight.toString());
      addWeight = double.parse(weightTextController.text);
      if (sameDateMuscleData.bodyFatPercentage != null) {
        fatTextController = TextEditingController(
            text: sameDateMuscleData.bodyFatPercentage.toString());
        addFatPercentage = double.parse(fatTextController.text);
      } else {
        fatTextController = TextEditingController(text: '');
        addFatPercentage = null;
      }
      if (sameDateMuscleData.imageURL != null) {
        imageURL = sameDateMuscleData.imageURL;
        if (sameDateMuscleData.angle != null) angle = sameDateMuscleData.angle;
      } else {
        imageURL = null;
      }
    } else {
      initialize();
    }
  }

  Future changeDate(DateTime pickedDate) async {
    this.pickedDate = pickedDate;
    selectDate(pickedDate);
    await judgeSameDate((DateFormat('yyyy/MM/dd')).format(pickedDate));
    set();
    print(viewDate);
    notifyListeners();
  }

  void selectDate(DateTime pickedDate) {
    viewDate = (DateFormat('yyyy/MM/dd')).format(pickedDate);
    addedDate = pickedDate;
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

  Future addDate(BuildContext context) async {
    if (addWeight == null) {
      throw ('体重を入力してください');
    } else {
      if (imageFile != null) imageURL = await _uploadImage();
      if (sameDateMuscleData == null) {
        _usersRepository.addMuscleData(
            user: myUser,
            weight: addWeight,
            fat: addFatPercentage,
            dateTime: pickedDate,
            imageURL: imageURL,
            angle: angle);
        print('追加');
        showAlertDialog(context, '追加しました');
      } else {
        _usersRepository.updateMuscleData(
            user: myUser,
            muscleData: sameDateMuscleData,
            weight: addWeight,
            fat: addFatPercentage,
            dateTime: pickedDate,
            imageURL: imageURL,
            angle: angle);
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
        .child("muscle/$userDocumentID/$viewDate")
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
