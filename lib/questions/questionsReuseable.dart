import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/questionsController.dart';
import 'package:madalh/models/LQ.dart';
import 'package:madalh/questions/questions.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../models/DQ.dart';
import '../models/FQ.dart';
import '../models/IMCQ.dart';
import '../models/SQ.dart';
import '../models/hoppiesmcq.dart';
import '../models/mcq.dart';

class QuestionReuseable extends StatefulWidget {
  final String category;
  bool isExtra;
  List AdditionalQuestions;
  final isMainAnswer;

  QuestionReuseable(
      {Key? key,
      required this.category,
      required this.isMainAnswer,
      this.isExtra = false,
      this.AdditionalQuestions = const []})
      : super(key: key);

  @override
  State<QuestionReuseable> createState() => _QuestionReuseableState();
}

class _QuestionReuseableState extends State<QuestionReuseable> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();
  List<Widget> questionScreens1 = [];
  final batch = FirebaseFirestore.instance.batch();
  final QController _qController = QController();

  @override
  void initState() {
    if (widget.isExtra == false) {
      getQuestions(widget.category);
    } else {
      getQuestions2(widget.AdditionalQuestions);
    }
    WidgetsFlutterBinding.ensureInitialized();
    // _qController.createfbatch();
    super.initState();
  }

  PageController controllerPages =
      new PageController(initialPage: 0, keepPage: true);

  getQuestions(category) async {
    var snap2 = await _firestore
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String gender = snap2.data()!['gender'];

    QuerySnapshot querySnapshot = await _firestore
        .collection("questions")
        .where("category", isEqualTo: category)
        .where('gender', whereIn: [gender, 'all']).get();
    List list = querySnapshot.docs;
    list.sort((a, b) => a.data()['orderNo'].compareTo(b.data()['orderNo']));
    List<Widget> questionScreens = [];
    for (int i = 0; i < list.length; i++) {
      ///here info badge
      if (list[i]['type'] == 0) {
        questionScreens.add(WeightSlider(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          questionId: list[i].id,
          type: list[i]['type'],
          cat: category,
          isKg: false,
          controller: controllerPages,
          infoQ: list[i]['infoBadge'] ?? '',
        ));
      } else if (list[i]['type'] == 1) {
        questionScreens.add(WeightSlider(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          type: list[i]['type'],
          questionId: list[i].id,
          controller: controllerPages,
          cat: category,
          isKg: true,
          infoQ: list[i]['infoBadge'] ?? '',
        ));
      } else if (list[i]['type'] == 2) {
        questionScreens.add(MCQ(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          answers: list[i]['availableAnswer'],
          type: list[i]['type'],
          question: list[i]['question'],
          controller: controllerPages,
          cat: category,
          multiAnswer: list[i]['isMultiple'],
          minAnswers: list[i]['minAnswers'],
          questionId: list[i].id,
          infoQ: list[i]['infoBadge'] ?? '',
        ));
      } else if (list[i]['type'] == 3) {
        questionScreens.add(
          DQuestion(
            isMainAnswer: widget.isMainAnswer,
            batch: batch,
            question: list[i]['question'],
            type: list[i]['type'],
            controller: controllerPages,
            cat: category,
            infoQ: list[i]['infoBadge'] ?? '',
            questionId: list[i].id,
          ),
        );
      } else if (list[i]['type'] == 4) {
        questionScreens.add(FQuestion(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          controller: controllerPages,
          type: list[i]['type'],
          cat: category,
          infoQ: list[i]['infoBadge'] ?? '',
          questionId: list[i].id,
        ));
      } else if (list[i]['type'] == 5) {
        questionScreens.add(IMCQ(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          answers: list[i]['availableAnswer'],
          question: list[i]['question'],
          type: list[i]['type'],
          minAnswers: list[i]['minAnswers'],
          controller: controllerPages,
          infoQ: list[i]['infoBadge'] ?? '',
          cat: category,
          multiAnswer: list[i]['isMultiple'],
          questionId: list[i].id,
          ImageLinks: list[i]['images'],
        ));
      } else if (list[i]['type'] == 6) {
        questionScreens.add(LQuestion(
          isPartner: list[i]['partner'] ?? false,
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          type: list[i]['type'],
          controller: controllerPages,
          infoQ: list[i]['infoBadge'] ?? '',
          questionId: list[i].id,
          cat: category,
        ));
      } else if (list[i]['type'] == 7) {
        questionScreens.add(HMCQ(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          answers: list[i]['availableAnswer'],
          question: list[i]['question'],
          controller: controllerPages,
          type: list[i]['type'],
          cat: category,
          infoQ: list[i]['infoBadge'] ?? '',
          multiAnswer: list[i]['isMultiple'],
          questionId: list[i].id,
        ));
      }
    }
    setState(() {
      questionScreens1 = questionScreens;
    });
    Provider.of<QController>(context, listen: false)
        .setListScreens(questionScreens1);
    Provider.of<QController>(context, listen: false).clearIndex();
  }

  List<DocumentSnapshot> removeMatchingElements(
      List<DocumentSnapshot> list1, List<DocumentSnapshot> list2) {
    list1.removeWhere((element1) {
      return list2.any((element2) {
        return element1.id == element2.id;
      });
    });
    return list1;
  }

  getQuestions2(additionalQ) async {
    // QuerySnapshot querySnapshot = await _firestore
    //     .collection("questions")
    //     .where("category", isEqualTo: category)
    //     .get();
    // QuerySnapshot querySnapshot2 = await _firestore
    //     .collection("musers").doc(FirebaseAuth.instance.currentUser!.uid).collection('answers')
    //     .where("category", isEqualTo: category)
    //     .get();
    // var list1 = querySnapshot.docs;
    // var list2 = querySnapshot2.docs;
    //
    var list = additionalQ;

    List<Widget> questionScreens = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i]['type'] == 0) {
        questionScreens.add(WeightSlider(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          questionId: list[i].id,
          type: list[i]['type'],
          cat: list[i]['category'],
          infoQ: list[i]['infoBadge'] ?? '',
          isKg: false,
          controller: controllerPages,
        ));
      } else if (list[i]['type'] == 1) {
        questionScreens.add(WeightSlider(
          batch: batch,
          isMainAnswer: widget.isMainAnswer,
          question: list[i]['question'],
          type: list[i]['type'],
          questionId: list[i].id,
          controller: controllerPages,
          cat: list[i]['category'],
          infoQ: list[i]['infoBadge'] ?? '',
          isKg: true,
        ));
      } else if (list[i]['type'] == 2) {
        questionScreens.add(MCQ(
          batch: batch,
          isMainAnswer: widget.isMainAnswer,
          answers: list[i]['availableAnswer'],
          question: list[i]['question'],
          type: list[i]['type'],
          minAnswers: list[i]['minAnswers'],
          controller: controllerPages,
          cat: list[i]['category'],
          infoQ: list[i]['infoBadge'] ?? '',
          multiAnswer: list[i]['isMultiple'],
          questionId: list[i].id,
        ));
      } else if (list[i]['type'] == 3) {
        questionScreens.add(DQuestion(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          type: list[i]['type'],
          controller: controllerPages,
          infoQ: list[i]['infoBadge'] ?? '',
          cat: list[i]['category'],
          questionId: list[i].id,
        ));
      } else if (list[i]['type'] == 4) {
        questionScreens.add(FQuestion(
          isMainAnswer: widget.isMainAnswer,
          batch: batch,
          question: list[i]['question'],
          controller: controllerPages,
          type: list[i]['type'],
          cat: list[i]['category'],
          infoQ: list[i]['infoBadge'] ?? '',
          questionId: list[i].id,
        ));
      } else if (list[i]['type'] == 5) {
        questionScreens.add(
          IMCQ(
            batch: batch,
            answers: list[i]['availableAnswer'],
            minAnswers: list[i]['minAnswers'],
            infoQ: list[i]['infoBadge'] ?? '',
            question: list[i]['question'],
            controller: controllerPages,
            isMainAnswer: widget.isMainAnswer,
            multiAnswer: list[i]['isMultiple'],
            type: list[i]['type'],
            questionId: list[i].id,
            ImageLinks: list[i]['images'],
            cat: list[i]['category'],
          ),
        );
      } else if (list[i]['type'] == 6) {
        questionScreens.add(LQuestion(
          batch: batch,
          isPartner: list[i]['partner'] ?? false,
          isMainAnswer: widget.isMainAnswer,
          question: list[i]['question'],
          infoQ: list[i]['infoBadge'] ?? '',
          controller: controllerPages,
          type: list[i]['type'],
          questionId: list[i].id,
          cat: list[i]['category'],
        ));
      } else if (list[i]['type'] == 7) {
        questionScreens.add(HMCQ(
          batch: batch,
          isMainAnswer: widget.isMainAnswer,
          answers: list[i]['availableAnswer'],
          type: list[i]['type'],
          question: list[i]['question'],
          controller: controllerPages,
          infoQ: list[i]['infoBadge'] ?? '',
          cat: list[i]['category'],
          multiAnswer: list[i]['isMultiple'],
          questionId: list[i].id,
        ));
      }
    }
    setState(() {
      questionScreens1 = questionScreens;
    });
    Provider.of<QController>(context, listen: false)
        .setListScreens(questionScreens1);
    Provider.of<QController>(context, listen: false).clearIndex();
  }

  // int currentIndex = 0;
  bool approved = true;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      constants.smallText(widget.category, context,
                          color: Colors.redAccent),
                    ],
                  ),
                  elevation: 0,
                  centerTitle: true,
                ),
                body: Consumer<QController>(
                  builder: (_, data, __) {
                    return data.isLoading == true
                        ? Center(child: constants.loadingAnimation())
                        : Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  // This widget is used as a container for the dot indicator
                                  child: Row(
                                    // This widget aligns its children horizontally
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        questionScreens1.length, (index) {
                                      return Container(
                                        width: 8.0,
                                        // width of the dot
                                        height: 8.0,
                                        // height of the dot
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        // margin around the dot
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle, // shape of the dot
                                          color: index ==
                                                  data.index // color of the dot
                                              ? Theme.of(context)
                                                  .primaryColor // active dot color
                                              : Color.fromRGBO(0, 0, 0,
                                                  0.4), // inactive dot color
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: PageView.builder(
                                  key: PageStorageKey(widget.category),

                                  onPageChanged: (int index) {
                                    data.controlIndex(index);
                                  },

                                  controller: controllerPages,

                                  itemBuilder: (context, index) {
                                    return questionScreens1[index];
                                  },

                                  // physics: const NeverScrollableScrollPhysics(),

                                  itemCount: questionScreens1.length,

                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
              Consumer<QController>(builder: (_, data, __) {
                return GestureDetector(
                    onTap: () {
                      // data.commitChanges();
                      // data.createfbatch();
                      batch.commit();
                      List<Widget> x = [];
                      Provider.of<QController>(context, listen: false)
                          .clearIndex();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.clear,
                        color: Colors.redAccent,
                      ),
                    ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
