import 'package:flutter/cupertino.dart';


enum EditStatus { initial, processing, success, error }
class QuestionsEditController with ChangeNotifier{

  EditStatus _editStatus = EditStatus.initial;



}