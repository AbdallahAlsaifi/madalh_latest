import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/controllers/hoppiesController.dart';
import 'package:provider/provider.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../../controllers/constants.dart';
import '../../controllers/questionsController.dart';
import '../../homePage.dart';
import '../questions.dart';


class HMCQE extends StatefulWidget {
  final bool multiAnswer;
  final List answers;
  final String question;
  final String questionId;
  final String cat;



  const HMCQE({
    Key? key,
    required this.answers,
    required this.question,
    required this.multiAnswer,
    required this.cat,
    required this.questionId,

  }) : super(key: key);

  @override
  State<HMCQE> createState() => _HMCQEState();
}

class _HMCQEState extends State<HMCQE> {
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('إلغاء'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.redAccent))),
                  FilledButton(
                      onPressed: () async {
                        try{
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          await FirebaseFirestore.instance
                              .collection('answers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('answers')
                              .doc(widget.questionId)
                              .update({'answer':ans});
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'تم تعديل الإجابة بنجاح');
                        }catch(e){
                          Fluttertoast.showToast(msg: 'حدث خطأ ما، يرجى المحاولة مجددا');
                        }
                      },
                      child: Text('تعديل'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => countTrue(answers) < 1
                                  ? Colors.white
                                  : Theme.of(context).primaryColor)))
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        constants.smallText(question.question, context,
                            color: Colors.red),
                        SizedBox(
                          height: constants.screenHeight * 0.10,
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
                                question.answers = answers
                                    .where((element) =>
                                    element.AnswerText.contains(c))
                                    .toList();
                              });
                            },
                          )
                        ),
                        SizedBox(
                          height: constants.screenHeight * 0.10,
                        ),
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
              ),
            ),
          ),
        );
      }),
    );
  }
}
