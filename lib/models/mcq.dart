import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';

class MCQ extends StatefulWidget {
  final bool multiAnswer;
  final List answers;
  final String question;
  final String questionId;
  final String cat;
  final String infoQ;
  final type;
  final controller;
  final isMainAnswer;
  final minAnswers;
  final WriteBatch batch;

  const MCQ({
    Key? key,
    required this.answers,
    required this.question,
    required this.multiAnswer,
    required this.cat,
    required this.questionId,
    required this.infoQ,
    required this.type,
    required this.controller,
    required this.batch,
    required this.isMainAnswer,
    required this.minAnswers,
  }) : super(key: key);

  @override
  State<MCQ> createState() => _MCQState();
}

class _MCQState extends State<MCQ> with TickerProviderStateMixin {
  List<MCAnswers> answers = [];

  late MCQuestion question;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    answers = List.generate(
      widget.answers.length,
      (index) => MCAnswers(AnswerText: widget.answers[index]),
    );
    question = MCQuestion(question: widget.question, answers: answers);
    Future.delayed(Duration(milliseconds: 150), () {
      _animationController.forward();
    });
    super.initState();
  }

  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );
  late Animation<Offset> _animation = Tween<Offset>(
    begin: Offset(9.0, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));
  int countTrue(List list) {
    return list.where((item) => item.isChosen == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<QController>(builder: (context, value, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AppService>(builder: (_, appVV, __) {
                  return GestureDetector(
                    onTap: () {
                      if (countTrue(answers) >= widget.minAnswers) {
                        if (value.index == value.questionScreens1.length - 1) {
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          value.addAnswer(
                              ans, question.question, widget.questionId,
                              category: widget.cat, type: widget.type);
                          widget.batch.set(
                              constants.firestore
                                  .collection('answers')
                                  .doc(constants.auth.currentUser!.uid)
                                  .collection('answers')
                                  .doc(widget.questionId),
                              {
                                "question": question.question,
                                "answer": ans,
                                "uid": widget.questionId,
                                'date': DateTime.now(),
                                "Images": [],
                                "cat": widget.cat,
                                'type': widget.type,
                                "status": 1,
                              },
                              SetOptions(merge: true));

                          try {
                            constants.commitChanges(widget.batch);
                            if (widget.isMainAnswer == true) {
                              constants.updateCategory(widget.cat);
                            }
                            Navigator.pop(context);
                            // appVV.setPageController(1, Duration.zero);
                            navigateTo(
                                HomePage(
                                  showCongrats: true,
                                ),
                                context);
                          } catch (e) {}
                        } else {
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          value.addAnswer(
                              ans, question.question, widget.questionId,
                              category: widget.cat, type: widget.type);
                          widget.batch.set(
                              constants.firestore
                                  .collection('answers')
                                  .doc(constants.auth.currentUser!.uid)
                                  .collection('answers')
                                  .doc(widget.questionId),
                              {
                                "question": question.question,
                                "answer": ans,
                                "uid": widget.questionId,
                                'date': DateTime.now(),
                                "Images": [],
                                "cat": widget.cat,
                                'type': widget.type,
                                "status": 1,
                              },
                              SetOptions(merge: true));

                          widget.controller.nextPage(
                              duration: Duration(milliseconds: 50),
                              curve: Curves.easeInOut);

                          value.getScreensList();
                        }
                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: countTrue(answers) < widget.minAnswers
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  );
                }),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  constants.smallText(question.question, context,
                      color: Colors.red),
                  SizedBox(
                    height: constants.screenHeight * 0.10,
                  ),
                  Wrap(
                    children: [
                      widget.infoQ.length > 3
                          ? constants.UserInfo(text: widget.infoQ)
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: constants.screenHeight * 0.05,
                  ),
                  Wrap(
                    spacing: constants.screenHeight * 0.015,
                    runSpacing: constants.screenHeight * 0.01,
                    children: List.generate(question.answers.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          // if (question.answers[index].isChosen == true) {
                          //   // setState(() {
                          //   //   question.answers[index].isChosen = false;
                          //   // });
                          // } else {
                          //   // {
                          //   //   setState(() {
                          //   //     question.answers[index].isChosen = true;
                          //   //   });
                          //   // }
                          // }
                          // if (countTrue(answers) >= widget.minAnswers) {
                          if (value.index ==
                              value.questionScreens1.length - 1) {
                            List<String> ans = answers
                                .where((item) => item.isChosen == true)
                                .map((item) => item.AnswerText)
                                .toList();
                            value.addAnswer(
                                ans, question.question, widget.questionId,
                                category: widget.cat, type: widget.type);
                            widget.batch.set(
                                constants.firestore
                                    .collection('answers')
                                    .doc(constants.auth.currentUser!.uid)
                                    .collection('answers')
                                    .doc(widget.questionId),
                                {
                                  "question": question.question,
                                  "answer": ans,
                                  "uid": widget.questionId,
                                  'date': DateTime.now(),
                                  "Images": [],
                                  "cat": widget.cat,
                                  'type': widget.type,
                                  "status": 1,
                                },
                                SetOptions(merge: true));

                            try {
                              constants.commitChanges(widget.batch);
                              if (widget.isMainAnswer == true) {
                                constants.updateCategory(widget.cat);
                              }
                              Navigator.pop(context);
                              // appVV.setPageController(1, Duration.zero);
                              navigateTo(
                                  HomePage(
                                    showCongrats: true,
                                  ),
                                  context);
                            } catch (e) {}
                          } else {
                            List<String> ans = answers
                                .where((item) => item.isChosen == true)
                                .map((item) => item.AnswerText)
                                .toList();
                            value.addAnswer(
                                ans, question.question, widget.questionId,
                                category: widget.cat, type: widget.type);
                            widget.batch.set(
                                constants.firestore
                                    .collection('answers')
                                    .doc(constants.auth.currentUser!.uid)
                                    .collection('answers')
                                    .doc(widget.questionId),
                                {
                                  "question": question.question,
                                  "answer": ans,
                                  "uid": widget.questionId,
                                  'date': DateTime.now(),
                                  "Images": [],
                                  "cat": widget.cat,
                                  'type': widget.type,
                                  "status": 1,
                                },
                                SetOptions(merge: true));

                            widget.controller.nextPage(
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeInOut);

                            value.getScreensList();
                          }
                          // } else {
                          //   debugPrint('hi>>>>>>>>>>>>>>>>>>>>>>>>>');
                          // }
                          // if (widget.multiAnswer == false) {
                          //   for (int i = 0;
                          //       i <= question.answers.length - 1;
                          //       i++) {
                          //     if (question.answers.elementAt(i) !=
                          //         question.answers[index]) {
                          //       question.answers[i].isChosen = false;
                          //     }
                          //   }
                          // }
                        },
                        child: SlideTransition(
                          position: _animation,
                          child: Chip(
                            label: constants.smallText(
                              question.answers[index].AnswerText,
                              context,
                            ),
                            backgroundColor:
                                question.answers[index].isChosen == true
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
