import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:select_searchable_list/select_searchable_list.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../../controllers/constants.dart';
import '../../controllers/questionsController.dart';
import '../../homePage.dart';


class LQuestionE extends StatefulWidget {
  final String question;
  final String questionId;
  final String cat;


  const LQuestionE({
    Key? key,

    required this.question,
    required this.questionId,
    required this.cat,
    })
   : super(key: key);

  @override
  State<LQuestionE> createState() => _LQuestionEState();
}

class _LQuestionEState extends State<LQuestionE> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedArea;

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
        ),
        DropdownMenuItem(
          child: Text('خارج فلسطين و الأردن'),
          value: 'خارج فلسطين و الأردن',
        ),DropdownMenuItem(
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
                    if(checkIfOk() == true){
                      try{

                        await FirebaseFirestore.instance
                            .collection('answers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('answers')
                            .doc(widget.questionId)
                            .update({'answer':[_selectedCountry,_selectedCity,_selectedArea], });
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
                              (states) => Theme.of(context).primaryColor)))
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // constants.smallText(widget.question, context,
                //     color: Colors.red),
                constants.smallText(widget.question, context, color: Colors.red),
                SizedBox(
                  height: constants.screenHeight * 0.10,
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
                    if (_selectedCountry == 'الأردن' || _selectedCountry == 'فلسطين')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCityDropdown(),
                        ],
                      ),
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
  bool checkIfOk(){
    if(_selectedCountry == 'فلسطين' && _selectedCity != null && _selectedArea != null){
      return true;
    }else if(_selectedCountry == 'الأردن' && _selectedCity != null){
      return true;
    }else if(_selectedCountry == 'خارج فلسطين و الأردن'){
      return true;
    }else if(_selectedCountry == 'غير ذلك'){
      return true;
    }else{
      return false;
    }
  }
}
