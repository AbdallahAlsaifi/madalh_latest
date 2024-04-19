import 'package:flutter/cupertino.dart';
import '../questions/questions.dart';
import 'constants.dart' as constants;

class HoppieController with ChangeNotifier{
  List<MCAnswers> answers = [];
  List<MCAnswers> answers2 = [];
  late MCQuestion question;
  HoppieController(){

  }


}