import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class JustImageGet extends StatefulWidget {
  const JustImageGet({super.key});

  @override
  State<JustImageGet> createState() => _JustImageGetState();
}

class _JustImageGetState extends State<JustImageGet> {

  File? _image;
  String imageUrl = '';

  // get image from gallery
  Future<void> getImageFromGallery()async{
    try{
      final imagePicker = ImagePicker();
      final selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);

      if(selectedImage != null){
        setState(() {
          _image = File(selectedImage.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
                content: Text('Image selected')));
      }else{
        print('Image not selected');
      }

    } catch(e){
      print('error -------->$e');
    }
  }

  // upload Image

  Future<void> uploadImage()async{
    try{
      // directory
      Reference ref = FirebaseStorage.instance.ref().child('just_images.jpg');
      // upload
      await ref.putFile(_image!.absolute);

      // get
      imageUrl = await ref.getDownloadURL();

      print('Url ------------>${imageUrl.toString()}');
    } catch(e){
      print('error --->$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (){
              uploadImage();
            },
              child: Icon(Icons.upload,color: Colors.white,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                getImageFromGallery();
              },
                child: Icon(Icons.add,color: Colors.white,)),
          )
        ],
        title: Text('Just Image get',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          imageUrl.isNotEmpty ? Image.network(imageUrl,height: 100,) : CircleAvatar(),
        ],
      ),
    );
  }
}
