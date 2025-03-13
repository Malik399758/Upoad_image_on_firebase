import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrudOperationScreen extends StatefulWidget {
  const CrudOperationScreen({super.key});

  @override
  State<CrudOperationScreen> createState() => _CrudOperationScreenState();
}

class _CrudOperationScreenState extends State<CrudOperationScreen> {
  final _fistNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool isLoading = false;
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  // Create operation
  Future<void> createData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_fistNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty) {
        await firebaseFireStore.collection('CrudOperation').add({
          'first name': _fistNameController.text,
          'last name': _lastNameController.text,
        });
      }
      setState(() {
        isLoading = false;
      });

      print('Successfully added');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successfully data added')));
    } catch (e) {
      print('Error ---------->$e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data not added')));
    }
  }

  // Read operation
  Stream<QuerySnapshot> readData() {
    return firebaseFireStore.collection('CrudOperation').snapshots();
  }

  // update operation
  
  Future<void> updatedData(String updateFirstName,String updateLastName,String docId)async{
    TextEditingController updatedFirst = TextEditingController(text: updateFirstName);
    TextEditingController updatedLast = TextEditingController(text: updateLastName);
    return showDialog(context: context,
        builder: (context){
         return AlertDialog(
           title: Text('Edit Data',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold),),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextFormField(
                 controller:updatedFirst ,
                 decoration: InputDecoration(
                     prefixIcon: Icon(Icons.person),
                     label: Text('First name'),
                     hintText: 'Enter Edit name',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(14),
                     )),
               ),
               SizedBox(height: 10,),
               TextFormField(
                 controller: updatedLast,
                 decoration: InputDecoration(
                     prefixIcon: Icon(Icons.person),
                     label: Text('Last name'),
                     hintText: 'Enter edit name',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(14),
                     )),
               ),
             ],
           ),
           actions: [
             ElevatedButton(onPressed: (){
               Navigator.pop(context);
             },
                 child: Text('No',style: GoogleFonts.poppins(fontSize: 15),)),
             ElevatedButton(
                 onPressed: ()async{
                   if(updatedFirst.text.isNotEmpty && updatedLast.text.isNotEmpty){
                     await firebaseFireStore.collection('CrudOperation').doc(docId).update(
                       {
                         'first name' : updatedFirst.text,
                         'last name' : updatedLast.text
                       }
                     );
                     Navigator.pop(context);
                   }
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User data updated')));
                 },
                 child: Text('Update data',style: GoogleFonts.poppins(fontSize: 15),))
           ],
         );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crud operation',
          style: GoogleFonts.aclonica(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _fistNameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  label: Text(' First Name'),
                  hintText: 'Enter first name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  label: Text(' Last Name'),
                  hintText: 'Enter last name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await createData();
              },
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(14)),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : Center(
                        child: Text(
                        'Add',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Expanded(
              child: StreamBuilder(
                  stream: readData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Data not found'));
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['first name'],style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600),),
                            subtitle: Text(data['last name'],style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () => updatedData(data['first name'],data['last name'],doc.id),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.teal,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await firebaseFireStore
                                          .collection('CrudOperation')
                                          .doc(doc.id)
                                          .delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('User data deleted')));
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
