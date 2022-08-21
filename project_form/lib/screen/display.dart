import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  DisplayScreen({Key? key}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final  Stream<QuerySnapshot> _students = FirebaseFirestore.instance.collection("students").snapshots();
  final usersRef = FirebaseFirestore.instance.collection("students");
  @override
  Widget build(BuildContext context) {
    print(_students);
    return Scaffold(
      appBar: AppBar(
        title: Text("รายงานคะแนนสอบ"),
      ),
      body: StreamBuilder(
        stream: _students,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: ListTile(
                  leading: CircleAvatar(
                    radius:40,
                    child: FittedBox(child: Text(document['score'])),
                  ),
                  title: Text(document['fname'] + document['lname']),
                  // subtitle: Text(usersRef.doc(document.id).id),
                ),
              );
              
            }).toList(),
          );
        },
      ),
    );
  }
}
