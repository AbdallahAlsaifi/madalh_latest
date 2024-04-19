import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import 'package:madalh/controllers/constants.dart' as constants;

import '../../controllers/constants.dart';
import '../../controllers/questionsController.dart';
import '../../homePage.dart';


class WeightSliderEdit extends StatefulWidget {
  final bool isKg;
  final String question;
  final String questionId;
  final String cat;

  const WeightSliderEdit(
      {Key? key,
        required this.question,
        required this.isKg,
        required this.questionId,
        required this.cat,
        })
      : super(key: key);

  @override
  State<WeightSliderEdit> createState() => _WeightSliderEditState();
}

class _WeightSliderEditState extends State<WeightSliderEdit> {
  late WeightSliderController _controller;
  double _weight = 30;

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
        initialWeight: _weight, minWeight: 0, interval: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<QController>(builder: (_, value, __) {
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
                      try{

                        await FirebaseFirestore.instance
                            .collection('answers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('answers')
                            .doc(widget.questionId)
                            .update({'answer':_weight});
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'تم تعديل الإجابة بنجاح');
                      }catch(e){
                        Fluttertoast.showToast(msg: 'حدث خطأ ما، يرجى المحاولة مجددا');
                        debugPrint(e.toString());
                      }
                    },
                    child: Text('تعديل'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => _weight < 30
                                ? Colors.white
                                : Theme.of(context).primaryColor)))
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                constants.smallText(widget.question, context,
                    color: Colors.redAccent),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    constants.smallText(
                        widget.isKg ? '${_weight.round()} kg' : '${_weight.round()} cm', context,
                        color: Colors.redAccent),
                    VerticalWeightSlider(
                      controller: _controller,
                      onChanged: (double value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                      indicator: Container(
                        height: 1.5,
                        width: 200.0,
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}