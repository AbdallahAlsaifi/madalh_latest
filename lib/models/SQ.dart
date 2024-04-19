import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';

class WeightSlider extends StatefulWidget {
  final bool isKg;
  final String question;
  final String questionId;
  final String cat;
  final controller;
  final String infoQ;
  final type;
  final WriteBatch batch;
  final isMainAnswer;

  const WeightSlider({
    Key? key,
    required this.question,
    required this.isKg,
    required this.questionId,
    required this.cat,
    required this.batch,
    required this.infoQ,
    required this.type,
    required this.isMainAnswer,
    required this.controller,
  }) : super(key: key);

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  final WeightSliderController _controller =
      WeightSliderController(initialWeight: 100, minWeight: 30);

  late double _weight;
  double _weight2 = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _weight = _controller.initialWeight;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<QController>(
                  builder: (_, value, __) {
                    return GestureDetector(
                      onTap: () {
                        if (value.index == value.questionScreens1.length - 1) {
                          value.addAnswer(
                              _weight, widget.question, widget.questionId,
                              category: widget.cat, type: widget.type);
                          constants.setBatch(
                            batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: [_weight, _weight2],
                            images: [],
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
                          } catch (e) {}
                        } else {
                          constants.setBatch(
                            batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: [_weight, _weight2],
                            images: [],
                            cat: widget.cat,
                            type: widget.type,
                          );
                          value.addAnswer(
                              _weight, widget.question, widget.questionId,
                              category: widget.cat, type: widget.type);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                constants.smallText(widget.question, context,
                    color: Colors.redAccent),
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
                widget.isKg == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              widget.isKg
                                  ? '${_weight.round()} kg'
                                  : '${_weight.round()} cm',
                              context,
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
                      )
                    : Container(child: widget.cat.contains('شريك') == true ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        constants.smallText(
                            widget.isKg
                                ? '${_weight.round()} kg'
                                : '${_weight.round()} cm',
                            context,
                            color: Colors.redAccent),
                        constants.smallText('  من  ', context,
                            color: Colors.redAccent),
                      ],
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        constants.smallText(
                            widget.isKg
                                ? '${_weight2.round()} kg'
                                : '${_weight2.round()} cm',
                            context,
                            color: Colors.redAccent),
                        constants.smallText('  الى  ', context,
                            color: Colors.redAccent),
                      ],
                    ),
                    VerticalWeightSlider(
                      controller: WeightSliderController(
                          minWeight: _weight.toInt()),
                      onChanged: (double value) {
                        setState(() {
                          _weight2 = value;
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
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    constants.smallText(
                        widget.isKg
                            ? '${_weight.round()} kg'
                            : '${_weight.round()} cm',
                        context,
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
                ),)
              ],
            ),
          ),
        );
      }),
    );
  }
}
