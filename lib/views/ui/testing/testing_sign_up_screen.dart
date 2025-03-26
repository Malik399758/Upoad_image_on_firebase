import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_image/views/ui/testing/testing_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestingSignUpScreen extends StatefulWidget {
  const TestingSignUpScreen({super.key});

  @override
  State<TestingSignUpScreen> createState() => _TestingSignUpScreenState();
}

class _TestingSignUpScreenState extends State<TestingSignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  File? _image;
  final storage = FirebaseStorage.instance;
  String? imageUrl = '';
  String? downloadUrl;

  // upload user info
  Future<void> uploadData(String userId,String imageUrl)async{
    try{
      await FirebaseFirestore.instance.collection('testing_user').doc(userId).set(
        {
          'email' : emailController.text,
          'password' : passwordController.text,
          'imageUrl' : imageUrl,
        }
      );
    }catch(e){
      print('Error -------->$e');
    }
  }

  // get image from gallery

  Future<void> getImageFromGallery()async{
    try{
      final imagePicker = ImagePicker();
      final selectedImage =await imagePicker.pickImage(source: ImageSource.gallery);

      if(selectedImage != null){

        setState(() {
          _image = File(selectedImage.path);
        });

      }else{
        print('Image not selected');
      }

    } catch(e){
      print('Image selected error from gallery');
    }

  }

  // upload Image on Firebase storage

  Future<String?> uploadImageOnFireBaseStorage(String userId)async{
    try{
      // set directory

      Reference ref = await FirebaseStorage.instance.ref().child('testing_images/$userId.jpg');

      // upload image
      UploadTask uploadTask = ref.putFile(_image!);

      TaskSnapshot snapshot = await uploadTask;

      // download url

      downloadUrl = await ref.getDownloadURL();
      print('Download url -------->$downloadUrl');
      return downloadUrl;
    }catch(e){
      print('Uplaod Image error ----------->$e');
      return null;
    }
  }



  // get or fetch image from firebase storage real time

  Future<void> getImageFromFirebaseStorage(String userId)async{
    try{
      final currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser != null){
        final ref = storage.ref().child('testing_images/$userId.jpg');
        final url = await ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
      }else{
        print('Image load error');
      }
    } catch(e){
      print('Failed to load image ---->$e');
      setState(() {
        imageUrl = '';
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getImageFromFirebaseStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              child: GestureDetector(
                onTap: (){
                  getImageFromGallery();
                },
                  ),
              backgroundImage: _image == null ? AssetImage('assets/images/user_profile_image.png') : FileImage(_image!.absolute),
            ),
            SizedBox(height: 20,),

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Enter password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
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
                      email:emailController.text ,
                      password: passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sucessfully')));
                  uploadData(userId.user!.uid,_image!.path);
                  print('User Id Here ------------->$userId');
                  uploadImageOnFireBaseStorage(userId.user!.uid);
                  getImageFromFirebaseStorage(userId.user!.uid);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestingProfile()));
                  setState(() {
                    isLoading = false;
                  });
                } catch(e){
                  print('Error ------->$e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: isLoading ? CircularProgressIndicator(color: Colors.white,) :Text("Sign Up",style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('testing_user').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text('Something went wrong'));
                  }else if(!snapshot.hasData || snapshot.data?.docs == null){
                    return Center(child: Text('Data not found'));
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }else if(snapshot.data?.docs != null){
                    var userData = snapshot.data?.docs ?? {};
                    //print('User data -------->${userData.toString()}');
                    return Expanded(
                      child: ListView.builder(
                         itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (context,index){
                            return ListTile(
                             /* leading: downloadUrl!.isNotEmpty && downloadUrl != null ? CircleAvatar(
                                radius: 25,
                                backgroundImage:NetworkImage(downloadUrl.toString()),
                                  ) : CircleAvatar(child: Icon(Icons.image_not_supported),),*/
                              title: Text('${snapshot.data?.docs[index]['email']}'),
                              subtitle: Text('${snapshot.data?.docs[index]['password']}'),
                            );
                          }),
                    );
                  }else{
                    return Container();
                  }
                }),
            // downloadUrl!.isNotEmpty && downloadUrl != null ? Image.network(downloadUrl!) : CircleAvatar() ?? Container()

          ],
        ),
      ),
    );
  }
}
