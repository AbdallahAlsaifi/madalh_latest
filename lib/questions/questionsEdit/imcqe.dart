import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:madalh/controllers/constants.dart' as constants;

import '../../controllers/constants.dart';
import '../../controllers/questionsController.dart';
import '../../homePage.dart';
import '../../view/imagePreview.dart';

class IMCQE extends StatefulWidget {
  final bool multiAnswer;
  final List answers;
  final List ImageLinks;
  final String question;
  final String questionId;
  final String cat;



  const IMCQE(
      {Key? key,
        required this.answers,
        required this.ImageLinks,
        required this.question,
        required this.multiAnswer,
        required this.cat,
        required this.questionId,
        })
      : super(key: key);

  @override
  State<IMCQE> createState() => _IMCQEState();
}

class _IMCQEState extends State<IMCQE> {
  List<IMCAnswers> answers = [];

  late IMCQuestion question;

  @override
  void initState() {
    // TODO: implement initState
    answers = List.generate(
      widget.answers.length,
          (index) => IMCAnswers(AnswerText: widget.answers[index], ImageLink: widget.ImageLinks[index]),
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
                      if(countTrue(answers) >= 2){
                        try{
                          List<String> ans = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.AnswerText)
                              .toList();
                          List<String> Ians = answers
                              .where((item) => item.isChosen == true)
                              .map((item) => item.ImageLink)
                              .toList();
                          await FirebaseFirestore.instance
                              .collection('answers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('answers')
                              .doc(widget.questionId)
                              .update({'answer':ans, 'Images':Ians});
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'تم تعديل الإجابة بنجاح');
                        }catch(e){
                          Fluttertoast.showToast(msg: 'حدث خطأ ما، يرجى المحاولة مجددا');
                        }
                      }
                    },
                    child: Text('تعديل'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => countTrue(answers) < 2
                                ? Colors.white
                                : Theme.of(context).primaryColor)))
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: constants.screenHeight * 0.015,
                              runSpacing: constants.screenHeight * 0.01,
                              children: List.generate(question.answers.length, (index) {
                                return GestureDetector(
                                    onTap: () {
                                      if(question.answers[index].isChosen == true){
                                        setState(() {
                                          question.answers[index].isChosen = false;
                                        });
                                      }else{
                                        {
                                          setState(() {
                                            question.answers[index].isChosen = true;
                                          });
                                        }
                                      }

                                      if (widget.multiAnswer == false) {
                                        for (int i = 0;
                                        i <= question.answers.length - 1;
                                        i++) {
                                          if (question.answers.elementAt(i) !=
                                              question.answers[index]) {
                                            question.answers[i].isChosen = false;
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: constants.screenWidth*0.28,

                                      padding: EdgeInsets.all(5),
                                      color: question.answers[index].isChosen == false ? Colors.grey:Theme.of(context).primaryColor,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: constants.screenWidth*0.25,
                                                height: constants.screenWidth*0.25,
                                                child: Image.network(question.answers[index].ImageLink, fit: BoxFit.contain,),
                                              ),
                                              Container(height: 5,),
                                              constants.smallText(
                                                  question.answers[index].AnswerText, context),

                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              navigateTo(ImageScreen(url: Image.network(question.answers[index].ImageLink)), context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Align(alignment: Alignment.topRight,child: Icon(Icons.zoom_in)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                );
                              }),
                            ),
                          ),
                        ],
                      )
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