// ignore_for_file: unnecessary_string_interpolations, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_form/model/student.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formkey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase =
      Firebase.initializeApp(); // เตรียม firebase
  CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("students");
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
                                  await _studentCollection.add({
                                    "fname": myStudent.fname,
                                    "lname": myStudent.lname,
                                    "email": myStudent.email,
                                    "score": myStudent.score,
                                  });
                                  formkey.currentState?.reset();
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
