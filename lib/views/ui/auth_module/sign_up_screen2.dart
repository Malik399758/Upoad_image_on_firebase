import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // pick image from gallery
  File? _image;
  Future<void> pickImageFromGallery() async{
    final picker = ImagePicker();
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if(selectedImage != null){
      setState(() {
        _image = File(selectedImage.path);
      });
    }else{
      print('Image not selected');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image not selected')));
    }
  }

  // User info details
  Future<void> userInfoUpload(String userId,File imageUrl) async{
    try{
      await FirebaseFirestore.instance.collection('userInformation').doc(userId).set({
        'user name' : _nameController.text,
        'email' : _emailController.text,
        'password' : _passwordController.text,
        'Image url' : imageUrl.path
      });
      print('Successfully user data stored');
    } on FirebaseException catch (e){
      print('Error ---------->$e');
    }
  }

  // Upload image on firebase

  Future<String?> uploadImageOnFireBase(String userId)async{
    try{
      Reference reference = FirebaseStorage.instance.ref().child('userImageDirectory/$userId');
      print('Reference -------------->${reference.toString()}');

      UploadTask uploadTask = reference.putFile(_image!);

      TaskSnapshot taskSnapshot = await uploadTask;

      final downloadUrl = await reference.getDownloadURL();
      print('Download Url -------------->>${downloadUrl.toString()}');
      return downloadUrl;
    }catch(e){
      print('Error ------------>${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: (){
                    pickImageFromGallery();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image == null ? AssetImage('assets/images/user_profile_image.png',) :
                        FileImage(_image!.absolute),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    label: Text('Name',style: GoogleFonts.poppins(),),
                    hintText: 'Enter name here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  label: Text('Email',style: GoogleFonts.poppins(),),
                  hintText: 'Enter email here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    label: Text('Password',style: GoogleFonts.poppins(),),
                    hintText: 'Enter password here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: ()async{
                  setState(() {
                    isLoading = true;
                  });
                  try{
                    UserCredential userId = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim());
                    print('User ID ------------>${userId.user!.uid}');
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully')));
                    await userInfoUpload(userId.user!.uid,_image!.absolute);
                    await uploadImageOnFireBase(userId.user!.uid);
          
                  } on FirebaseException catch(e){
                    print('Error ---->${e.message}');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account not created')));
                    setState(() {
                      isLoading = false;
                    });
                  }
          
                },
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal,
                  ),
                  child: isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,)) :
                  Center(child: Text('Sign Up',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

