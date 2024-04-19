import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/hoppiesController.dart';
import 'package:provider/provider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';

class HMCQ extends StatefulWidget {
  final bool multiAnswer;
  final List answers;
  final String question;
  final String questionId;
  final String cat;
  final String infoQ;
  final type;
  final WriteBatch batch;
  final controller;
  final isMainAnswer;

  const HMCQ({
    Key? key,
    required this.answers,
    required this.question,
    required this.multiAnswer,
    required this.cat,
    required this.questionId,
    required this.controller,
    required this.batch,
    required this.infoQ,
    required this.type,
    required this.isMainAnswer,

  }) : super(key: key);

  @override
  State<HMCQ> createState() => _HMCQState();
}

class _HMCQState extends State<HMCQ> {
  List<MCAnswers> answers = [];
  List<MCAnswers> answers2 = [];

  late MCQuestion question;

  @override
  void initState() {
    // TODO: implement initState

    answers = List.generate(
      constants.hoppies.length,
      (index) => MCAnswers(AnswerText: constants.hoppies[index]),
    );
    answers2 = List.generate(
      constants.hoppies.length,
      (index) => MCAnswers(AnswerText: constants.hoppies[index]),
    );
    question = MCQuestion(question: 'الهوايات', answers: answers);
    super.initState();
  }

  int countTrue(List list) {
    return list.where((item) => item.isChosen == true).length;
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<QController>(builder: (context, value, __) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(

                    onTap: () {
                      print(value.questionScreens1);
                      if(question.answers.where((item) => item.isChosen == true).length >= 1){
                        if (value.index == value.questionScreens1.length - 1) {
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          value.addAnswer(
                              ans, question.question, widget.questionId,category: widget.cat,type: widget.type);
                          constants.setBatch(batch: widget.batch,
                              questionId: widget.questionId,
                              question: widget.question,
                              ans: ans,
                              images: [],
                              cat: widget.cat,
                              type: widget.type,);
                          try {
                            constants.commitChanges(widget.batch);
                            if(widget.isMainAnswer == true){
                              constants.updateCategory(widget.cat);
                            }
                            Navigator.pop(context);
                            // final myChangeNotifier = AppService();
                            // myChangeNotifier.setPageController(1, Duration.zero).then((_){
                            //   final myChangeNotifier1 = AppService();
                            //   myChangeNotifier1.setPageController(2, Duration.zero);
                            // });
                            navigateTo(HomePage(showCongrats: true,), context);
                          } catch (e) {
                            print(e);
                          }
                          print('#### 1 ####');
                          print(value.index);
                          print(value.getScreensList());
                        } else {
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          value.addAnswer(
                              ans, question.question, widget.questionId,category: widget.cat,type: widget.type);
                          constants.setBatch(batch: widget.batch,
                              questionId: widget.questionId,
                              question: widget.question,
                              ans: ans,
                              images: [],
                              cat: widget.cat,
                              type: widget.type,);
                          widget.controller.nextPage(
                              duration: Duration(milliseconds: 50),
                              curve: Curves.easeInOut);
                          print('#### 2 ####');
                          print(value.questionScreens1);
                          print(value.index);
                          value.getScreensList();
                        }
                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: question.answers.where((item) => item.isChosen == true).length < 1
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  constants.smallText(question.question, context,
                      color: Colors.red),
                  SizedBox(
                    height: constants.screenHeight * 0.03,
                  ),
                  Wrap(children: [ widget.infoQ.length > 3 ? constants.UserInfo(text: widget.infoQ) : Container()],),
                  SizedBox(
                    height: constants.screenHeight * 0.02,
                  ),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Theme.of(context).primaryColor)),
                      padding: EdgeInsets.all(5),
                      width: constants.screenWidth * 0.8,
                      child:TextField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            hintText: 'إبحث عن هواية'
                        ),
                        controller: searchController,
                        onChanged: (c) {
                          setState(() {
                            question.answers = answers2
                                .where((element) =>
                                element.AnswerText.contains(c))
                                .toList();
                          });
                        },
                      )
                  ),
                  SizedBox(
                    height: constants.screenHeight * 0.03,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Wrap(
                            spacing: constants.screenHeight * 0.015,
                            runSpacing: constants.screenHeight * 0.01,
                            children:
                                List.generate(question.answers.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  if (question.answers[index].isChosen == true) {

                                    setState(() {
                                      question.answers[index].isChosen = false;
                                    });
                                  } else {

                                    {
                                      setState(() {
                                        question.answers[index].isChosen = true;
                                      });
                                    }
                                  }
                                },
                                child: Chip(
                                  label: constants.smallText(
                                      question.answers[index].AnswerText, context),
                                  backgroundColor:
                                      question.answers[index].isChosen == true
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
