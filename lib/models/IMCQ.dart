import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madalh/view/imagePreview.dart';
import 'package:provider/provider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';

class IMCQ extends StatefulWidget {
  final bool multiAnswer;
  final List answers;
  final List ImageLinks;
  final String question;
  final String questionId;
  final String cat;
  final String infoQ;
  final WriteBatch batch;
  final controller;
  final isMainAnswer;
  final type;
  final minAnswers;

  const IMCQ({
    Key? key,
    required this.answers,
    required this.ImageLinks,
    required this.question,
    required this.multiAnswer,
    required this.cat,
    required this.batch,
    required this.questionId,
    required this.controller,
    required this.infoQ,
    required this.type,
    required this.minAnswers,
    required this.isMainAnswer,
  }) : super(key: key);

  @override
  State<IMCQ> createState() => _IMCQState();
}

class _IMCQState extends State<IMCQ> {
  List<IMCAnswers> answers = [];

  late IMCQuestion question;

  @override
  void initState() {
    // TODO: implement initState
    answers = List.generate(
      widget.answers.length,
      (index) => IMCAnswers(
          AnswerText: widget.answers[index],
          ImageLink: widget.ImageLinks[index]),
    );
    question = IMCQuestion(question: widget.question, answers: answers);
    print(widget.multiAnswer);
    super.initState();
  }

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
                GestureDetector(
                  onTap: () {
                    print(value.questionScreens1);
                    if (countTrue(answers) >= widget.minAnswers) {
                      if (value.index == value.questionScreens1.length - 1) {
                        List<String> ans = answers
                            .where((item) => item.isChosen == true)
                            .map((item) => item.AnswerText)
                            .toList();
                        List<String> Ians = answers
                            .where((item) => item.isChosen == true)
                            .map((item) => item.ImageLink)
                            .toList();
                        value.addAnswer(
                            ans, question.question, widget.questionId,
                            ImageLink: Ians,
                            category: widget.cat,
                            type: widget.type);
                        constants.setBatch(
                          batch: widget.batch,
                          questionId: widget.questionId,
                          question: widget.question,
                          ans: ans,
                          images: Ians,
                          cat: widget.cat,
                          type: widget.type,
                        );
                        try {
                          constants.commitChanges(widget.batch);
                          if (widget.isMainAnswer == true) {
                            constants.updateCategory(widget.cat);
                          }
                          Navigator.pop(context);

                          // final myChangeNotifier = AppService();
                          // myChangeNotifier.setPageController(1, Duration.zero).then((_){
                          //   final myChangeNotifier1 = AppService();
                          //   myChangeNotifier1.setPageController(2, Duration.zero);
                          // });
                          navigateTo(
                              HomePage(
                                showCongrats: true,
                              ),
                              context);
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
                        List<String> Ians = answers
                            .where((item) => item.isChosen == true)
                            .map((item) => item.ImageLink)
                            .toList();
                        constants.setBatch(
                          batch: widget.batch,
                          questionId: widget.questionId,
                          question: widget.question,
                          ans: ans,
                          images: Ians,
                          cat: widget.cat,
                          type: widget.type,
                        );
                        value.addAnswer(
                            ans, question.question, widget.questionId,
                            category: widget.cat,
                            ImageLink: Ians,
                            type: widget.type);
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
                      buttonColor: countTrue(answers) < widget.minAnswers
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              constants.smallText(question.question, context,
                  color: Colors.red),
              SizedBox(
                height: constants.screenHeight * 0.05,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.infoQ.length > 3
                          ? constants.UserInfo(text: widget.infoQ)
                          : Container(),
                      Wrap(spacing: 5,runSpacing: 15, children:  List.generate(question.answers.length,
                              (index) {
                            return Container(
                              width: screenWidth*0.45,
                              child: GestureDetector(
                                  onTap: () {
                                    if (question.answers[index].isChosen ==
                                        true) {
                                      setState(() {
                                        question.answers[index].isChosen =
                                        false;
                                      });
                                    } else {
                                      {
                                        setState(() {
                                          question.answers[index].isChosen =
                                          true;
                                        });
                                      }
                                    }

                                    if (widget.multiAnswer == false) {
                                      for (int i = 0;
                                      i <= question.answers.length - 1;
                                      i++) {
                                        if (question.answers.elementAt(i) !=
                                            question.answers[index]) {
                                          question.answers[i].isChosen =
                                          false;
                                        }
                                      }
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: constants.screenWidth * 0.28,
                                            padding: EdgeInsets.all(5),
                                            color: question.answers[index]
                                                .isChosen ==
                                                false
                                                ? Colors.grey.withOpacity(0.5)
                                                : Theme.of(context).primaryColor,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width:
                                                  constants.screenWidth * 0.5,
                                                  height:
                                                  constants.screenWidth * 0.5,
                                                  child: Image.network(
                                                    question
                                                        .answers[index].ImageLink,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                          constants.smallText(
                                              question.answers[index].AnswerText,
                                              context,
                                              color: Colors.red),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          navigateTo(ImageScreen(url: Image.network(question
                                              .answers[index].ImageLink)), context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(alignment: Alignment.topRight,child: Icon(Icons.zoom_in)),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          }),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class IMCAnswers {
  bool isChosen;
  final String AnswerText;
  final String ImageLink;

  IMCAnswers({
    required this.AnswerText,
    required this.ImageLink,
    this.isChosen = false,
  });
}

class IMCQuestion {
  String question;
  List<IMCAnswers> answers;

  IMCQuestion({required this.question, required this.answers});
}
