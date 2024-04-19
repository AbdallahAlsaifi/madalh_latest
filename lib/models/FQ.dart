import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';

class FQuestion extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;
  final controller;
  final String infoQ;
  final type;
  final isMainAnswer;
  final WriteBatch batch;
  const FQuestion(
      {Key? key,
        required this.question,
        required this.questionId,
        required this.cat,
        required this.controller,
        required this.infoQ,
        required this.type,
        required this.batch,
        required this.isMainAnswer,

      })
      : super(key: key);

  @override
  State<FQuestion> createState() => _FQuestionState();
}

class _FQuestionState extends State<FQuestion> {
  TextEditingController _controller = TextEditingController();

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
        width: constants.screenWidth,
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<QController>(
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: ()  {

                      if (value.index == value.questionScreens1.length - 1) {
                        value.addAnswer(_controller.text, widget.question,
                            widget.questionId,category: widget.cat, type: widget.type);
                        constants.setBatch(batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: _controller.text,
                            images: [],
                            cat: widget.cat,
                            type: widget.type, status: 2);
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
                        value.addAnswer(_controller.text, widget.question,
                            widget.questionId,category: widget.cat,type: widget.type);
                        constants.setBatch(batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: _controller.text,
                            images: [],
                            cat: widget.cat,
                            type: widget.type, status: 2);
                        widget.controller.nextPage(
                            duration: Duration(milliseconds: 50),
                            curve: Curves.easeInOut);

                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: Theme.of(context).primaryColor),
                  );
                },
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  constants.smallText(widget.question, context,
                      color: Colors.red),
                  SizedBox(
                    height: constants.screenHeight * 0.18,
                  ),
                  Wrap(children: [ widget.infoQ.length > 3 ? constants.UserInfo(text: widget.infoQ) : Container()],),
                  SizedBox(
                    height: constants.screenHeight * 0.18,
                  ),
                  Container(
                    child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {});
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        maxLines: 5,
                        minLines: 5,
                        maxLength: 200,
                        inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[اأإء-ي]+$')),
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-Z]+$')),

                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 2.0),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}