import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_form/service/service.dart';

class DisplayScreen extends StatefulWidget {
  DisplayScreen({Key? key}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final Stream<QuerySnapshot> _students =
      FirebaseFirestore.instance.collection("students").snapshots();
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
          return Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((document) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        child: StreamBuilder(
                          stream: usersRef
                              .doc(document.id)
                              .collection("images_file")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshot2) {
                            return ListView(
                              shrinkWrap: true,
                              children: snapshot2.data!.docs.map((document2) {
                                print(document2['filePath']);
                                return FutureBuilder(
                                    future: getImage(document2['fileName']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot3) {
                                      if (snapshot3.connectionState ==
                                              ConnectionState.done &&
                                          snapshot3.hasData) {
                                        return CircleAvatar(
                                          radius: 30,
                                            child: Image.network(
                                              snapshot3.data!,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            );
                                            
                                      }
                                      if (snapshot3.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot3.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      return CircleAvatar();
                                    });
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      // FittedBox(child: Text(document['score'])),

                      title: Text(document['fname']+" "+ document['lname']),
                      subtitle: Text(document['email']+" "+ document['score']),
                      
                      // subtitle: StreamBuilder(
                      //   stream: usersRef
                      //       .doc(document.id)
                      //       .collection("images_file")
                      //       .snapshots(),
                      //   builder: (context,
                      //       AsyncSnapshot<QuerySnapshot> snapshot2) {
                      //     return ListView(
                      //       shrinkWrap: true,
                      //       children: snapshot2.data!.docs.map((document2) {
                      //         print(document2['filePath']);
                      //         return FutureBuilder(
                      //             future: getImage(document2['fileName']),
                      //             builder: (BuildContext context,
                      //                 AsyncSnapshot<String> snapshot3) {
                      //               if (snapshot3.connectionState ==
                      //                       ConnectionState.done &&
                      //                   snapshot3.hasData) {
                      //                 return Container(
                      //                   child: Image.network(snapshot3.data!),
                      //                 );
                      //               }
                      //               if (snapshot3.connectionState ==
                      //                       ConnectionState.waiting ||
                      //                   !snapshot3.hasData) {
                      //                 return CircularProgressIndicator();
                      //               }
                      //               return Container();
                      //             });
                      //       }).toList(),
                      //     );
                      //   },
                      // ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
