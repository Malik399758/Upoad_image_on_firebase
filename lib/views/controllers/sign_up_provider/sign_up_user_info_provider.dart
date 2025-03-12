import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpUserInfoProvider extends ChangeNotifier{
  BuildContext? get context => null;

/*  bool isLoading = false;
  bool isActive = true;

  void getBool(bool value) {
    isActive = value;
    notifyListeners();
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }*/

  Future<void> getUserInfo(String userId, String userName,String email,String password,File imageUrl)async{
    try{
      final firebaseFireStore = FirebaseFirestore.instance;
      await firebaseFireStore.collection('userInfo').doc().set(
        {
          'User Name' : userName,
          'Email' : email,
          'Password' : password,
          'imageUrl' :imageUrl
        }
      );
      print('User data successfully added');
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text('User Data Successfully added')));
    } on FirebaseException catch (error){
      print('Error ---------->${error.message}');
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text('User Data not added')));
    }
  }


}