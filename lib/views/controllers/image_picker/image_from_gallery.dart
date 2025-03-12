import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromGallery extends ChangeNotifier{

  File? image;
  Future<void> imagePickFromGallery() async{
    final picker = ImagePicker();
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);

    if(imagePicker != null){
      image = File(imagePicker.path);
    }else{
      print('Image not selected');
    }
  }
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

}
