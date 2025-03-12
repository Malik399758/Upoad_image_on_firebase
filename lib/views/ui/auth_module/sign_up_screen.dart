/*
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_image/views/controllers/image_picker/image_from_gallery.dart';
import 'package:firebase_storage_image/views/controllers/sign_up_provider/image_from_gallery_provider.dart';
import 'package:firebase_storage_image/views/controllers/sign_up_provider/sign_up_user_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;
  bool isLoading = false;

  Future<void> bottomSheetBar(BuildContext context) {
    // final providerImage = Provider.of<ImageFromGallery>(context, listen: false);
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      imagePickFromGallery();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.image_rounded,
                      size: 50,
                    )),
                Icon(
                  CupertinoIcons.camera_fill,
                  size: 50,
                )
              ],
            ),
          );
        });
  }

  Future<void> imagePickFromGallery() async {
    final picker = ImagePicker();
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);

    if (imagePicker != null) {
      setState(() {
        _image = File(imagePicker.path);
      });
    } else {
      print('Image not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpUserInfoProvider>(context);
    final uploadProvider = Provider.of<ImageFromGalleryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',
            style: GoogleFonts.poppins(fontSize: 21, color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/images/user_profile_image.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 3,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              bottomSheetBar(context);
                            },
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: InputDecoration(
                    label: Text('Name'),
                    hintText: 'Enter name here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    label: Text('Email'),
                    hintText: 'Enter email here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _passwordController,
                decoration: InputDecoration(
                    label: Text('Password'),
                    hintText: 'Enter password here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    UserCredential user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Successfully')));
                    print('User Account ID ---------->${user.user!.uid}');

                    provider.getUserInfo(
                        user.user!.uid,
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _image!);

                    await ImageFromGalleryProvider();
                    Navigator.pop(context);
                    await uploadProvider.uploadImageOnFirBase(
                        user.user!.uid, _image!);
                    setState(() {
                      isLoading = false;
                    });
                  } on FirebaseException catch (e) {
                    print('Error ------------>$e');
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Wrong')));
                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    print('Error ---------->$e');
                    setState(() {
                      isLoading = false;
                    });
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.teal,
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : Center(
                          child: Text('Sign Up',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 21)),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_image/views/controllers/sign_up_provider/image_from_gallery_provider.dart';
import 'package:firebase_storage_image/views/controllers/sign_up_provider/sign_up_user_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;
  bool isLoading = false;

  Future<void> bottomSheetBar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      imagePickFromGallery();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.image_rounded,
                      size: 50,
                    )),
                Icon(
                  CupertinoIcons.camera_fill,
                  size: 50,
                )
              ],
            ),
          );
        });
  }

  Future<void> imagePickFromGallery() async {
    final picker = ImagePicker();
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);

    if (imagePicker != null) {
      setState(() {
        _image = File(imagePicker.path);
      });
    } else {
      print('Image not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpUserInfoProvider>(context);
    final uploadProvider = Provider.of<ImageFromGalleryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',
            style: GoogleFonts.poppins(fontSize: 21, color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/images/user_profile_image.png')
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 3,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              bottomSheetBar(context);
                            },
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: InputDecoration(
                    label: Text('Name'),
                    hintText: 'Enter name here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    label: Text('Email'),
                    hintText: 'Enter email here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                obscureText: true, // Hide password input
                decoration: InputDecoration(
                    label: Text('Password'),
                    hintText: 'Enter password here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select an image')));
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    UserCredential user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    String? imageUrl = await uploadProvider.uploadImageOnFirBase(
                        user.user!.uid, _image!);

                    print('Image Url ------------->$imageUrl');

                    provider.getUserInfo(
                        user.user!.uid,
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _image!.absolute); // Now passing the image URL instead of File

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Sign Up Successful')));

                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Error occurred')));
                  } catch (e) {
                    print('Error ---------->$e');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.teal,
                  ),
                  child: isLoading
                      ? Center(
                      child: CircularProgressIndicator(color: Colors.white))
                      : Center(
                    child: Text('Sign Up',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 21)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
