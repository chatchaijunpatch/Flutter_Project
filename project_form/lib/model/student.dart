import 'package:project_form/model/storage_service.dart';

class Student {
  String fname;
  String lname;
  String email;
  String score;
  Storage storage = Storage();
  Student({this.fname = '', this.lname = '', this.email = '', this.score = '',});
  

}
