// ignore_for_file: unnecessary_string_interpolations, avoid_print, prefer_const_declarations, await_only_futures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_form/model/storage_service.dart';
import 'package:project_form/model/student.dart';

import '../service/service.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formkey = GlobalKey<FormState>();
  var pathimg = "";
  final Storage storage = Storage();
  final Future<FirebaseApp> firebase =
      Firebase.initializeApp(); // เตรียม firebase
  // CollectionReference _studentCollection =
  //     FirebaseFirestore.instance.collection("students");
  Student myStudent = Student();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: Text("แบบฟอร์มบันทึกคะแนนสอบ")),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ชื่อนักเรียน",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อด้วยไอสัส"),
                            onSaved: (String? fname) {
                              myStudent.fname = fname!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "นามสกุล",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนนามสกุลไอสัส"),
                            onSaved: (String? lname) {
                              myStudent.lname = lname!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "อีเมล",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              EmailValidator(errorText: "อย่าเอ๋อ"),
                              RequiredValidator(errorText: "ป้อนemail ไอสัส")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              myStudent.email = email!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "คะแนน",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator:
                                RequiredValidator(errorText: "กรุณาป้อนคะแนน"),
                            onSaved: ((score) {
                              myStudent.score = score!;
                            }),
                            keyboardType: TextInputType.number,
                          ),
                           SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: ElevatedButton(onPressed: ()async{
                              final results = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png','jpg']
                              );
                              if(results == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No file select"),),
                                );
                                return null;
                              }
                              final path = results.files.single.path!;
                              final fileName = results.files.single.name;
                              myStudent.storage.fileName = fileName;
                              myStudent.storage.filePath = path;
                               myStudent.storage.filePath = path;
                              
                              setState(() {
                                pathimg = path;
                              });
                              // storage.uploadFile(path,fileName).then((value) => print("Done"),);
                              // print(path);
                              // print(fileName);
                              print(myStudent.storage.filePath+"/"+myStudent.storage.fileName);
                          }, child: Text("upload File")),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(child:
                          Image.file(
                            File(pathimg),
                            width: 200,
                            height: 200,
                             errorBuilder: ( context, error, stackTrace,){
                              return Image(image: AssetImage('assets/photo.png'),
                              width: 200,
                              
                              height: 200,);
                             }
                          ),),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                "save",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async{
                                formkey.currentState?.save();
                                if (formkey.currentState?.validate() == true) {
                                  formkey.currentState?.save();
                                  // print("${myStudent.fname}");
                                  // print("${myStudent.lname}");
                                  // print('${myStudent.email}');
                                  // print("${myStudent.score}");
                                  // await uploadFile(myStudent.storage.filePath,myStudent.storage.fileName);
                                  // await _studentCollection.add({
                                  //   "fname": myStudent.fname,
                                  //   "lname": myStudent.lname,
                                  //   "email": myStudent.email,
                                  //   "score": myStudent.score,
                                  // });
                                  await uploadProfile(myStudent);
                                  formkey.currentState?.reset();
                                  setState(() {
                                    pathimg = "";
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
