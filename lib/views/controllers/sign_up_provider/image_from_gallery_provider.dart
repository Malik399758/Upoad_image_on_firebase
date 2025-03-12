import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ImageFromGalleryProvider extends ChangeNotifier{

  Future<String?> uploadImageOnFirBase(String userId,File imageUrl) async{
    try{
      // create directory
      Reference reference = FirebaseStorage.instance.ref().child('userInfoImage/$userId.jpg');

      // upload
      UploadTask uploadTask = reference.putFile(imageUrl);

      TaskSnapshot taskSnapshot = await uploadTask;

      print('Task Snap shot ----------->$taskSnapshot');

      final downloadUrl = await reference.getDownloadURL();
      print('Download Url ------------->$downloadUrl');
      return downloadUrl;
    }catch(e){
      print('Error ----------->$e');
    }
  }
}