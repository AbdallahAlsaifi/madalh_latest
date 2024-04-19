import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/controllers/constants.dart';
import 'package:madalh/homePage.dart';

import '../models/QAModel.dart';
import '../questions/questions.dart';

class QController with ChangeNotifier {
  List<Widget> questionScreens = [];
  List<QuestionAnswers> DynamicQuestionAnswers = [];
  List<Widget> questionScreens1 = [];
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late WriteBatch fbatch;
  bool approved = true;

  int index = 0;

  String category = '';


  TextEditingController _controller = TextEditingController();
  fbatchset(DocumentReference document, data){


    try{fbatch.set(document, data, SetOptions(merge: true));}catch(e){debugPrint(e.toString());}
  }
  createfbatch(){
    fbatch = FirebaseFirestore.instance.batch();
    notifyListeners();

  }
  commitChanges()async{
    try{

      await fbatch.commit().whenComplete(() => debugPrint('Complete')).onError((error, stackTrace) => debugPrint(error.toString()));
    }catch(e){
      debugPrint(e.toString());
    }
  }
  getQuestionScreens() {
    return questionScreens;
  }
  clearIndex(){
    index = 0;
    notifyListeners();
  }

  int getScreensList() {

    return questionScreens1.length;
  }

  setListScreens(e) {
    questionScreens1 = e;
    notifyListeners();
  }

  clearListScreens(e) {
    questionScreens1 = e;
  }
  // disposePageController(){
  //   controllerPages.dispose();
  // }
  // assignPageController(){
  //   controllerPages = new PageController(initialPage: 0, keepPage: true);
  //   controlIndex(0);
  // }
  submitQuestionsToFirebase(category) async {
    List<String> cat = [category];
    try {
      setLoading(1);
      for (var element in DynamicQuestionAnswers) {
        await _firestore
            .collection('answers').doc(_auth.currentUser!.uid).
        set({
          'userId':_auth.currentUser!.uid
        });
        if(element.type == 4){
          await _firestore.collection('answers').doc(_auth.currentUser!.uid).collection('answers')
              .doc(element.QuestionId)
              .set({
            "question": element.Question,
            "answer": element.Answer,
            "uid": element.QuestionId,
            'date': element.Date,
            "Images":element.ImageLinks,
            "cat":element.category,
            'type':element.type,
            "status":2,
          });
        }else{
          await _firestore.collection('answers').doc(_auth.currentUser!.uid).collection('answers')
              .doc(element.QuestionId)
              .set({
            "question": element.Question,
            "answer": element.Answer,
            "uid": element.QuestionId,
            'date': element.Date,
            "Images":element.ImageLinks,
            "cat":element.category,
            'type':element.type,
            "status":1,
          });
        }

      }
      await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .update({'completedCat': FieldValue.arrayUnion(cat)});
      setLoading(0);

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setLoading(0);
  }

  clearSubmittedAnswers() {
    DynamicQuestionAnswers.clear();
    notifyListeners();
  }

  setLoading(int x) {
    if (x == 0) {
      isLoading = false;
    } else if (x == 1) {
      isLoading = true;
    }
    notifyListeners();
  }

  setApproved(int x) {
    if (x == 0) {
      approved = false;
    } else if (x == 1) {
      approved = true;
    }
  }

  controlIndex(int x) {
    index = x;
    notifyListeners();
  }



  clearList() {
    questionScreens = [];
    notifyListeners();
  }

  addAnswer(dynamic answer, String question, String questionId, {List<String> ImageLink = const [], required category, required type}) {
    DynamicQuestionAnswers.add(QuestionAnswers(
        QuestionId: questionId, Question: question, Answer: answer, ImageLinks: ImageLink, category: category, type: type));
    notifyListeners();
  }

  setCategory(x) {
    category = x;
    notifyListeners();
  }

  setScreensList(x) {
    questionScreens = x;
    notifyListeners();
  }
}


