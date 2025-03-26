import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TestingProfile extends StatefulWidget {
  const TestingProfile({super.key});

  @override
  State<TestingProfile> createState() => _TestingProfileState();
}

class _TestingProfileState extends State<TestingProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  String imageUrl = '';

  Future<void> getImage()async{
    try{
      Reference ref = storage.ref().child('testing_users/${currentUser!.uid}');
      String url = await ref.getDownloadURL();

      print('Url ------------------>$url');
      if(url.isNotEmpty){
        setState(() {
          imageUrl = url;
        });
      }
    } catch(e){
      print('Error image load ------->$e');
      imageUrl = '';
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          imageUrl.isNotEmpty ? CircleAvatar(
            backgroundImage: NetworkImage(imageUrl.toString()) ,
          ) : CircleAvatar()
        ],
      ),
    );
  }
}
