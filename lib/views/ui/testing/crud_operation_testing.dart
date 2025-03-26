import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CrudOperationTesting extends StatefulWidget {
  const CrudOperationTesting({super.key});

  @override
  State<CrudOperationTesting> createState() => _CrudOperationTestingState();
}

class _CrudOperationTestingState extends State<CrudOperationTesting> {
  final nameController = TextEditingController();
  bool isLoading = false;
  final fireStore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  File? _image;
  String imageUrl = '';

  // Upload image to Firebase Storage
  Future<void> uploadImage() async {
    if (_image == null) return;

    setState(() => isLoading = true);
    try {
      final ref = storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();

      await addData(imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Image uploaded successfully', style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload image: $e', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Add data to Firestore
  Future<void> addData(String imageUrl) async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter a name!', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await fireStore.collection("crud_operation_testing").add({
        'firstName': nameController.text,
        'imageUrl': imageUrl,
      });

      nameController.clear();
      _image = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Data added successfully', style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to add data: $e', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Pick image from gallery
  Future<void> getImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() => _image = File(pickedImage.path));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Image selected successfully', style: TextStyle(color: Colors.white)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('No image selected', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error selecting image: $e', style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  // Get data stream from Firestore
  Stream<QuerySnapshot> getData() {
    return fireStore.collection('crud_operation_testing').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Operation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: getImage,
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              if (_image != null)
                Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _image != null ? uploadImage() : addData(''),
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black87),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 3),
              StreamBuilder(
                stream: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Data Found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(user['firstName'] ?? 'No Name'),
                        leading: user['imageUrl'] != null && user['imageUrl'].isNotEmpty
                            ? Image.network(user['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.person),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}