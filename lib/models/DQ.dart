import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madalh/view/congrats/congrats.dart';
import 'package:provider/provider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';

class DQuestion extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;
  final String infoQ;
  final type;
  final WriteBatch batch;

  final controller;
  final isMainAnswer;

  const DQuestion({
    Key? key,
    required this.question,
    required this.questionId,
    required this.cat,
    required this.infoQ,
    required this.type,
    required this.batch,required this.isMainAnswer,


    required this.controller,
  }) : super(key: key);

  @override
  State<DQuestion> createState() => _DQuestionState();
}

class _DQuestionState extends State<DQuestion> {
  DateTime chosenDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<QController>(
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: () {
                      if (value.index == value.questionScreens1.length - 1) {
                        value.addAnswer(
                            chosenDate, widget.question, widget.questionId,
                            category: widget.cat, type: widget.type);
                        constants.setBatch(batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: chosenDate,
                            images: [],
                            cat: widget.cat,
                            type: widget.type);
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

                        }
                      } else {
                        value.addAnswer(
                            chosenDate, widget.question, widget.questionId,
                            category: widget.cat, type: widget.type);
                        constants.setBatch(batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: chosenDate,
                            images: [],
                            cat: widget.cat,
                            type: widget.type);
                        widget.controller.nextPage(
                            duration: Duration(milliseconds: 50),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: Theme
                            .of(context)
                            .primaryColor),
                  );
                },
              )
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
                    constants.smallText(widget.question, context,
                        color: Colors.red),
                    SizedBox(
                      height: constants.screenHeight * 0.18,
                    ),
                    Wrap(children: [
                      widget.infoQ.length > 3 ? constants.UserInfo(
                          text: widget.infoQ) : Container()
                    ],),
                    SizedBox(
                      height: constants.screenHeight * 0.18,
                    ),
                    Container(
                        child: CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                          onDateChanged: (DateTime value) {
                            setState(() {
                              chosenDate = value;
                            });
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
