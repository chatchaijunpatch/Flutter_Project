import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_form/model/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_form/model/student.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students");


Future<void> uploadProfile(Student myStudent) async{
   var result = await _studentCollection.add({
    "fname": myStudent.fname,
    "lname": myStudent.lname,
    "email": myStudent.email,
    "score": myStudent.score,
    });

  await _studentCollection.doc(result.id).collection('images_file').add(
    {
      "id" : result.id, 
      "filePath": myStudent.storage.filePath,
      "fileName": myStudent.storage.fileName,
    }
  );
  await uploadFile(myStudent.storage.filePath, myStudent.storage.fileName);

}
Future <void> uploadFile(
    String filePath,
    String fileName,
  ) async{
    File file = File(filePath);
    try{
      await storage.ref('test/$fileName').putFile(file);
    }on firebase_core.FirebaseException catch(e){
      print(e);
    }
  }