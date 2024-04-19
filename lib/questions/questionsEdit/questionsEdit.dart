import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:madalh/questions/questionsEdit/SQE.dart';
import 'package:madalh/questions/questionsEdit/mcqE.dart';
import 'package:provider/provider.dart';

import '../../controllers/systemController.dart';
import 'DQE.dart';
import 'FQE.dart';
import 'LQE.dart';
import 'hmcqE.dart';
import 'imcqe.dart';

class QuestionsEdit extends StatefulWidget {
  const QuestionsEdit({Key? key}) : super(key: key);

  @override
  State<QuestionsEdit> createState() => _QuestionsEditState();
}

class _QuestionsEditState extends State<QuestionsEdit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List answers = [];
  List answers2 = [];
  List answers3 = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> QuestionsDocuments = [];
  bool isRequested = false;
  bool isLoading = false;
  String gender = '';
  int matches = 0;
  int fmatches = 0;
  List requestsSent = [];

  List nackSent = [];
  DateTime lastFreeRequest = DateTime.now();
  Duration remainingTimeFemale = Duration(hours: 1);
  Duration remainingTimeMale = Duration(hours: 1);

  returnDoc(id) {
    for (var doc in QuestionsDocuments) {
      if (doc.id == id) {
        return doc;
      }
    }
  }

  checkAndReturnAccordingToStatus(status, original) {
    if (status == 0) {
      return Text(
        'تم رفض هذه الإجابة من قبل الإدارة',
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.white),
        // softWrap: true,
      );
    } else if (status == 1) {
      return Text(
        original,
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        // softWrap: true,
      );
    } else if (status == 2) {
      return Text(
        'بإنتظار موافقة الإدارة على الإجابة',
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.white),
        // softWrap: true,
      );
    } else if (status == 3) {
      return Text(
        'تم إعطاء فرصة من الإدارة لتغيير الإجابة',
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.white),
        // softWrap: true,
      );
    }
  }

  returnContainerList(index, answerList, female) {
    QueryDocumentSnapshot<Map<String, dynamic>> question =
        returnDoc(answerList[index].id);
    return GestureDetector(
      onTap: () {
        if (question['isEditable'] == true) {
          if (question['type'] == 2) {
            constants.navigateTo(
                MCQE(
                  answers: question['availableAnswer'],
                  question: question['question'],
                  multiAnswer: question['isMultiple'],
                  cat: question['category'],
                  questionId: question.id,
                  answeredAnswers: answers[index]['answer'],
                ),
                context);
          } else if (question['type'] == 0) {
            navigateTo(
                WeightSliderEdit(
                  question: question['question'],
                  questionId: question.id,
                  cat: question['category'],
                  isKg: false,
                ),
                context);
          } else if (question['type'] == 1) {
            navigateTo(
                WeightSliderEdit(
                  question: question['question'],
                  questionId: question.id,
                  cat: question['category'],
                  isKg: true,
                ),
                context);
          } else if (question['type'] == 3) {
            navigateTo(
                DQuestionEdit(
                  question: question['question'],
                  cat: question['category'],
                  questionId: question.id,
                  answer: answers[index]['answer'],
                ),
                context);
          } else if (question['type'] == 4) {
            navigateTo(
                FQuestionEdit(
                  question: question['question'],
                  cat: question['category'],
                  questionId: question.id,
                ),
                context);
          } else if (question['type'] == 5) {
            constants.navigateTo(
                IMCQE(
                  answers: question['availableAnswer'],
                  question: question['question'],
                  multiAnswer: question['isMultiple'],
                  cat: question['category'],
                  questionId: question.id,
                  ImageLinks: question['images'],
                ),
                context);
          } else if (question['type'] == 6) {
            navigateTo(
                LQuestionE(
                  question: question['question'],
                  cat: question['category'],
                  questionId: question.id,
                ),
                context);
          } else if (question['type'] == 7) {
            constants.navigateTo(
                HMCQE(
                  answers: question['availableAnswer'],
                  question: question['question'],
                  multiAnswer: question['isMultiple'],
                  cat: question['category'],
                  questionId: question.id,
                ),
                context);
          } else {}
        } else {
          Fluttertoast.showToast(msg: 'هذا السؤال لا يمكن تعديله');
        }
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              children: [
                Text(
                  answerList[index]['question'],
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(5),
              width: constants.screenWidth,
              // color: Theme.of(context).primaryColor == constants.peach1
              //     ? constants.azure1.withOpacity(0.5)
              //     : constants.peach1.withOpacity(0.5),
              child: Column(
                children: [
                  question['type'] == 5
                      ? Wrap(
                          alignment: WrapAlignment.start,
                          children: answerList[index]['Images'].length != 0
                              ? List.generate(
                                  answerList[index]['answer'].length,
                                  (iindex) => Container(
                                        margin: EdgeInsets.all(5),
                                        child: Chip(
                                          backgroundColor: Colors.white,
                                          label: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: constants.screenWidth *
                                                    0.25,
                                                height: constants.screenWidth *
                                                    0.25,
                                                child: Image.network(
                                                  answerList[index]['Images']
                                                      [iindex],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                height: 5,
                                              ),
                                              Chip(
                                                backgroundColor: Theme.of(
                                                                    context)
                                                                .primaryColor ==
                                                            constants.peach1 &&
                                                        female == true
                                                    ? constants.azure1
                                                    : constants.peach1,
                                                label: constants.smallText(
                                                    answerList[index]['answer']
                                                        [iindex],
                                                    context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                              : [])
                      : Chip(
                          label: checkAndReturnAccordingToStatus(
                              answerList[index]['status'],
                              answerList[index]['answer']
                                  .toString()
                                  .replaceAll('null,', '')
                                  .replaceAll('null', '')),
                          backgroundColor: Theme.of(context).primaryColor ==
                                      constants.peach1 &&
                                  female == true
                              ? constants.azure1
                              : constants.peach1,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  initializeScreen() async {
    setState(() {
      isLoading = true;
    });
    var snap = await _firestore
        .collection('answers')
        .doc(_auth.currentUser!.uid)
        .collection('answers')
        .get();

    var qsnap = await _firestore
        .collection('questions')
        .where('order', isEqualTo: 1)
        .get();
    var snap2 =
        await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();

    setState(() {
      answers = snap.docs;
      // Filter the documents that contain "شريك" in the "cat" field
      answers2 = answers
          .where((doc) => doc['cat'].toString().contains('شري'))
          .toList();

// Filter the documents that do not contain "شريك" in the "cat" field
      answers3 = answers
          .where((doc) => !doc['cat'].toString().contains('شري'))
          .toList();
      gender = snap2.data()!['gender'];
      QuestionsDocuments = qsnap.docs;
      isLoading = false;
    });
    print(QuestionsDocuments);
    print(answers);
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: constants.screenHeight * 0.10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Container(
                width: 5,
              ),
              Text('تعديل الإجابات'),
            ],
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(constants.screenWidth * 0.1),
                    bottomRight: Radius.circular(constants.screenWidth * 0.1)),
                gradient: Provider.of<AppService>(context, listen: false)
                    .systemGradient),
          ),
        ),
        body: SingleChildScrollView(
          physics: PageScrollPhysics(),
          child: Column(
            children: [
              constants.smallText('عني', context, color: Colors.redAccent),
              ListView.builder(
                physics: PageScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return returnContainerList(index, answers3, false);
                },
                itemCount: answers3.length,
                shrinkWrap: true,
              ),
              constants.smallText('عن الشريك', context,
                  color: Colors.redAccent),
              ListView.builder(
                physics: PageScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return returnContainerList(index, answers2, true);
                },
                itemCount: answers2.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            initializeScreen();
          },
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
        ));
  }
}
