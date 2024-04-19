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


class DQuestionEdit extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;
  final answer;

  const DQuestionEdit({
    Key? key,
    required this.question,
    required this.questionId,
    required this.cat,
    required this.answer,

  }) : super(key: key);

  @override
  State<DQuestionEdit> createState() => _DQuestionEditState();
}

class _DQuestionEditState extends State<DQuestionEdit> {
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

                      await FirebaseFirestore.instance
                          .collection('answers')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('answers')
                          .doc(widget.questionId)
                          .update({'answer':chosenDate});
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'تم تعديل الإجابة بنجاح');
                    }catch(e){
                      Fluttertoast.showToast(msg: 'حدث خطأ ما، يرجى المحاولة مجددا');
                    }
                  },
                  child: Text('تعديل'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor)))
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
                    Container(
                        child: CalendarDatePicker(
                      initialDate: widget.answer.toDate(),
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
