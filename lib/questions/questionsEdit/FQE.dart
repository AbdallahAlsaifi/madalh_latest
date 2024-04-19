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

class FQuestionEdit extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;

  const FQuestionEdit({
    Key? key,
    required this.question,
    required this.questionId,
    required this.cat,
  }) : super(key: key);

  @override
  State<FQuestionEdit> createState() => _FQuestionEditState();
}

class _FQuestionEditState extends State<FQuestionEdit> {
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
                          .update({'answer':_controller.text, 'underReview':true, 'status': 2});
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  constants.smallText(widget.question, context,
                      color: Colors.red),
                  SizedBox(
                    height: constants.screenHeight * 0.10,
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
