import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:select_searchable_list/select_searchable_list.dart';

import '../controllers/constants.dart' as constants;
import '../controllers/constants.dart';
import '../controllers/questionsController.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../questions/questions.dart';
import '../view/congrats/congrats.dart';
import 'newLocationSheet.dart';

class LQuestion extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;
  final controller;
  final String infoQ;
  final type;
  final isMainAnswer;
  final WriteBatch batch;
  final isPartner;

  const LQuestion({
    Key? key,
    required this.question,
    required this.questionId,
    required this.cat,
    required this.batch,
    required this.infoQ,
    required this.type,
    required this.controller,
    required this.isPartner,
    required this.isMainAnswer,
  }) : super(key: key);

  @override
  State<LQuestion> createState() => _LQuestionState();
}

class _LQuestionState extends State<LQuestion> {
  // TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedArea;
  List<List<String?>> additionalLocations = [];

  DropdownButton<String> buildCountryDropdown() {
    return DropdownButton<String>(
      value: _selectedCountry,
      hint: Text('إختر الدولة'),
      items: [
        DropdownMenuItem(
          child: Text('الأردن'),
          value: 'الأردن',
        ),
        DropdownMenuItem(
          child: Text('فلسطين'),
          value: 'فلسطين',
        ),DropdownMenuItem(
          child: Text('سوريا'),
          value: 'سوريا',
        ),DropdownMenuItem(
          child: Text('لبنان'),
          value: 'لبنان',
        ),
        // DropdownMenuItem(
        //   child: Text('خارج فلسطين و الأردن'),
        //   value: 'خارج فلسطين و الأردن',
        // )
        DropdownMenuItem(
          child: Text('غير ذلك'),
          value: 'غير ذلك',
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
          _selectedCity = null;
          _selectedArea = null;
        });
      },
    );
  }


  DropdownButton<String> buildCityDropdown() {
    List<String> cities = [];

    if (_selectedCountry == 'الأردن') {
      cities = constants.jcities;
    } else if (_selectedCountry == 'فلسطين') {
      cities = constants.pcities;
    }else if (_selectedCountry == 'سوريا') {
      cities = constants.scities;
    }else if (_selectedCountry == 'لبنان') {
      cities = constants.lcities;
    }

    return DropdownButton<String>(
      value: _selectedCity,
      hint: Text('إختر المدينة'),
      items: cities.map((city) {
        return DropdownMenuItem(
          child: Text(city),
          value: city,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
          _selectedArea = null;
        });
      },
    );
  }

  DropdownButton<String> buildAreaDropdown() {
    Map<String, List<String>> areas = constants.palestineAreas;

    List<String> areaList = areas[_selectedCity] ?? [];

    return DropdownButton<String>(
      value: _selectedArea,
      hint: Text('إختر المنطقة'),
      items: areaList.map((area) {
        return DropdownMenuItem(
          child: Text(area),
          value: area,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedArea = value;
        });
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MyBottomSheet(
          onSave: (value) {
            // Do something with the value
            setState(() {
              additionalLocations.add(value);
            });
            print('Value saved: $value');
            print('Value saved: $additionalLocations');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPartner == true ?

    /// if For Partner
    SafeArea(
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
                    onTap: () {
                      if (checkIfOk() == true) {
                        if (value.index == value.questionScreens1.length - 1) {
                          value.addAnswer(
                              [_selectedCountry, _selectedCity, _selectedArea],
                              widget.question,
                              widget.questionId,
                              category: widget.cat,
                              type: widget.type);
                          List<String?> flattened_list = additionalLocations.expand((list) => list).toList();
                          constants.setBatch(
                            batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: flattened_list + [
                              _selectedCountry,
                              _selectedCity,
                              _selectedArea
                            ],
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
                            // final myChangeNotifier = context.read<AppService>();
                            // myChangeNotifier.setPageController(1, Duration.zero).then((_){
                            //   final myChangeNotifier1 = context.read<AppService>();
                            //   myChangeNotifier1.setPageController(2, Duration.zero);
                            // });
                            navigateTo(HomePage(showCongrats: true,), context);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          List<String?> flattened_list = additionalLocations.expand((list) => list).toList();
                          constants.setBatch(
                            batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: flattened_list + [
                              _selectedCountry,
                              _selectedCity,
                              _selectedArea
                            ],
                            images: [],
                            cat: widget.cat,
                            type: widget.type,);
                          value.addAnswer(
                              [_selectedCountry, _selectedCity, _selectedArea],
                              widget.question,
                              widget.questionId,
                              category: widget.cat,
                              type: widget.type);
                          widget.controller.nextPage(
                              duration: Duration(milliseconds: 50),
                              curve: Curves.easeInOut);
                        }
                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: checkIfOk() == true
                            ? Theme
                            .of(context)
                            .primaryColor
                            : Colors.white),
                  );
                },
              )
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // constants.smallText(widget.question, context,
                //     color: Colors.red),
                constants.smallText(widget.question, context,
                    color: Colors.red),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCountryDropdown(),
                      ],
                    ),
                    if (_selectedCountry == 'الأردن' ||
                        _selectedCountry == 'فلسطين'||
                        _selectedCountry == 'سوريا'||
                        _selectedCountry == 'لبنان'
                    )
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCityDropdown(),
                        ],
                      ),
                    if (_selectedCountry == 'الأردن' ||
                        _selectedCountry == 'سوريا'||
                        _selectedCountry == 'لبنان'
                    )
                      Center(child: Text("وذلك يشمل قراها"),),
                    if (_selectedCountry == 'فلسطين' && _selectedCity != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildAreaDropdown(),
                        ],
                      ),
                  ],
                ),

                /// Here
                _selectedCountry != null ? FilledButton(onPressed: () {
                  _showBottomSheet(context);
                }, child: Text('إضافة عنوان آخر')) : Container(),
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: additionalLocations.length >= 1
                      ? additionalLocations.map((e) =>
                      Text(e.toString().replaceAll('null', '').replaceAll(',', ''))).toList(): []) ,
              ],
            ),
          ),
        ),
      ),
    )
        :

    ///if Not Partner
    SafeArea(
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
                    onTap: () {
                      if (checkIfOk() == true) {
                        if (value.index == value.questionScreens1.length - 1) {
                          value.addAnswer(
                              [_selectedCountry, _selectedCity, _selectedArea],
                              widget.question,
                              widget.questionId,
                              category: widget.cat,
                              type: widget.type);
                          constants.setBatch(
                            batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: [
                              _selectedCountry,
                              _selectedCity,
                              _selectedArea
                            ],
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
                            navigateTo(HomePage(showCongrats: true,), context);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          constants.setBatch(batch: widget.batch,
                            questionId: widget.questionId,
                            question: widget.question,
                            ans: [
                              _selectedCountry,
                              _selectedCity,
                              _selectedArea
                            ],
                            images: [],
                            cat: widget.cat,
                            type: widget.type,);
                          value.addAnswer(
                              [_selectedCountry, _selectedCity, _selectedArea],
                              widget.question,
                              widget.questionId,
                              category: widget.cat,
                              type: widget.type);
                          widget.controller.nextPage(
                              duration: Duration(milliseconds: 50),
                              curve: Curves.easeInOut);
                        }
                      }
                    },
                    child: constants.longButton('المتابعة', context,
                        buttonColor: checkIfOk() == true
                            ? Theme
                            .of(context)
                            .primaryColor
                            : Colors.white),
                  );
                },
              )
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // constants.smallText(widget.question, context,
                //     color: Colors.red),
                constants.smallText(widget.question, context,
                    color: Colors.red),
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCountryDropdown(),
                      ],
                    ),
                    if (_selectedCountry == 'الأردن' ||
                        _selectedCountry == 'فلسطين'||
                        _selectedCountry == 'سوريا'||
                        _selectedCountry == 'لبنان'
                    )
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCityDropdown(),
                        ],
                      ),
                    if (_selectedCountry == 'الأردن' ||
                        _selectedCountry == 'سوريا'||
                        _selectedCountry == 'لبنان'
                    )
                      Center(child: Text("وذلك يشمل قراها"),),
                    if (_selectedCountry == 'فلسطين' && _selectedCity != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildAreaDropdown(),
                        ],
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkIfOk() {
    if (_selectedCountry == 'فلسطين' &&
        _selectedCity != null &&
        _selectedArea != null) {
      return true;
    } else if (_selectedCountry == 'الأردن' && _selectedCity != null) {
      return true;
    } else if (_selectedCountry == 'سوريا' && _selectedCity != null) {
      return true;
    } else if (_selectedCountry == 'لبنان' && _selectedCity != null) {
      return true;
    } else if (_selectedCountry == 'غير ذلك') {
      return true;
    } else {
      return false;
    }
  }
}
