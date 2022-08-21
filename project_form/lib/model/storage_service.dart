import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';

class Storage{
  // final FirebaseStorage storage = FirebaseStorage.instance;
  String fileName = "";
  String filePath = "";

  // Future <void> uploadFile(
  //   String filePath,
  //   String fileName,
  // ) async{
  //   File file = File(filePath);
  //   try{
  //     await storage.ref('test/$fileName').putFile(file);
  //   }on firebase_core.FirebaseException catch(e){
  //     print(e);
  //   }
  // }
}