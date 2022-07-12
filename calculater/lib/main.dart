// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace, sort_child_properties_last

import 'dart:convert';
import 'dart:js';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import "dart:math";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Calculator"),
        ),
        body: Home(),
      ),
    );
  }
}


class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

TextEditingController high = TextEditingController();
TextEditingController weight = TextEditingController();
TextEditingController result = TextEditingController();

String _im = "urlToImage";

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _im = "null";
  }

  void BMI() {
    var bmi = int.parse(weight.text) / pow((int.parse(high.text) / 100), 2);
    var word =
        "น้ำหนักคุณคือ ${weight.text} ส่วนสูงคุณคือ ${high.text} ผลลัพธ์คุณคือ ";
    if (bmi >= 40)
      result.text = word + 'ลดซะ พี่หลามขอ';
    else if (bmi >= 35)
      result.text = word + 'อ้วนโคตร';
    else if (bmi >= 28.5)
      result.text = word + 'ไออ้วน';
    else if (bmi >= 23.5)
      result.text = word + 'เ ก เ ร แบบ มีพุง';
    else if (bmi >= 18.5)
      result.text = word + 'เ ก เ ร';
    else
      result.text = word + 'ขี้ก้าง';
  }

  void RandomPicture() {
    List<String> lst = <String>[
      "https://c.tenor.com/5r-IPcAVkxEAAAAd/%E0%B9%83%E0%B8%88%E0%B9%80%E0%B8%81%E0%B9%80%E0%B8%A3-gachi.gif",
      "https://c.tenor.com/V1ISRHpZyA0AAAAd/danny-lee-sunglasses.gif",
      "https://c.tenor.com/bbFzsZ-So-0AAAAM/husshere-tattari.gif",
      "https://c.tenor.com/z3c4kH-szGkAAAAd/%E0%B9%83%E0%B8%88%E0%B9%80%E0%B8%81%E0%B9%80%E0%B8%A3-unruly.gif",
      "https://c.tenor.com/Dsv0zMQAgUoAAAAd/danny-lee-super-kazuya.gif"
    ];
    var randomItem = (lst.toList()..shuffle()).first;
    setState(() {
      _im = randomItem;
      BMI();
    });
  }

  Image ImagePrint() {
    return Image.network(
      _im,
      scale: 1.5,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : LinearProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        heightFactor:1.3,
        child: Container(
          // width: 2000,
          // height: 1000,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/dark.jpg",
                scale: 1.5,
              ),
              SizedBox(height: 30),
              Container(
                child: Text("Calculator program",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Edu",
                        color: Color.fromARGB(255, 255, 0, 0))),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: high,
                  decoration: InputDecoration(
                      labelText: "ส่วนสูง",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(20)),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: weight,
                  decoration: InputDecoration(
                      labelText: "น้ำหนัก",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(20)),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                child: ElevatedButton(
                    onPressed: RandomPicture,
                    child: Text("ควย"),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(50, 30, 50, 30)))),
              ),
              SizedBox(height: 30),
              Text(result.text,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Edu",
                      color: Color.fromARGB(255, 255, 0, 0))),
              SizedBox(height: 30),
              ImagePrint(),
            ],
          ),
        ),
      ),
    );
  }
}
