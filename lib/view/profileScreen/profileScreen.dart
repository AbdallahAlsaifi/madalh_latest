import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/controllers/questionsController.dart';
import 'package:madalh/controllers/systemController.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/questions/questionsEdit/questionsEdit.dart';
import 'package:madalh/questions/questionsReuseable.dart';
import 'package:provider/provider.dart';

import '../../homePage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double progress = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = true;
        progress = 0.25;
      });
    }).then((_) {
      getData().then((_) {
        setState(() {
          progress = 0.50;
        });
        calculatePercentage().then((_) {
          setState(() {
            progress = 0.75;
          });
          getUnansweredQuestions().then((_) {
            setState(() {
              progress = 1.0;
            });
            Finishing();
            Future.delayed(Duration.zero, () {
              setState(() {
                isLoading = false;
                showMsgNow = true;
              });
            });
            Future.delayed( Duration.zero, () {
              _showDialog(context);
              setState(() {
                showScaffold = true;
              });
            });
          });
        });
      });
    });
  }
  bool showScaffold = false;
  bool isLoading = false;
  bool showMsgNow = false;
  double totalPercentage = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List questionsCategories = [];
  late List pquestionsCategories = [];
  List additionalQuestions = [];
  List unAnsweredQuestions = [];
  late List finishedCat = [];
  String gender = '';
  bool dialogFlag = false;
  late final Query questionsRef;

  final answersRef = FirebaseFirestore.instance
      .collection('answers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('answers');

  Future<List<DocumentSnapshot>> getQuestions() async {
    QuerySnapshot querySnapshot = await questionsRef.get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getAnswers() async {
    QuerySnapshot querySnapshot = await answersRef.get();
    return querySnapshot.docs;
  }

  // Future<List<DocumentSnapshot>>
  getUnansweredQuestions() async {
    List<DocumentSnapshot> questions = await getQuestions();
    List<DocumentSnapshot> answers = await getAnswers();

    List<DocumentSnapshot> unansweredQuestions = [];
    for (var question in questions) {
      Map<String, dynamic> data = question.data() as Map<String, dynamic>;
      if (!data.containsKey('question') || !data.containsKey('uid')) {
        continue;
      }
      bool answered = false;
      for (var answer in answers) {
        Map<String, dynamic> answerData = answer.data() as Map<String, dynamic>;
        if (question.id == answer.id) {
          answered = true;
          break;
        }
      }
      if (!answered) {
        unansweredQuestions.add(question);
        setState(() {
          unAnsweredQuestions.add(question);
        });
      }
    }
  }

  Finishing() {
    for (var element in unAnsweredQuestions) {
      if (wordExists(finishedCat, element['category'])) {
        setState(() {
          additionalQuestions.add(element);
        });
      }
    }
  }

  bool wordExists(List list, String word) {
    return list.any((element) {
      return element.toLowerCase().trim() == word.toLowerCase().trim();
    });
  }

  void _showDialog(BuildContext context) {
    if (totalPercentage == 100) {
      if (!dialogFlag) {
        setState(() {
          dialogFlag = true;
        });
        showDialog(
          context: context,
          builder: (x) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Theme.of(context).primaryColor ==
                                  constants.maleSwatch
                              ? SvgPicture.asset(
                                  'assets/svg/matchingMen.svg',
                                  width: constants.screenWidth * 0.40,
                                  height: constants.screenWidth * 0.40,
                                )
                              : SvgPicture.asset(
                                  'assets/svg/matchingWomen.svg',
                                  width: constants.screenWidth * 0.40,
                                  height: constants.screenWidth * 0.40,
                                ),
                        ),
                      ],
                    ),
                    AnimatedTextKit(
                      totalRepeatCount: 1,
                      displayFullTextOnTap: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'مبروك! لقد اكملت ملفك، استرح الأن و دعنا نبحث لك عن الشريك المناسب. ستصلك الإشعارات الفورية في حال تم إيجاد شريك يناسب خياراتك',
                          textAlign: TextAlign.end,
                          speed: Duration(milliseconds: 60),
                        ),
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        child: Text("حسنا"),
                        onPressed: () {
                          AppService().newAndLastAlgo();
                          Navigator.of(x).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  calculatePercentage() async {
    // retrieve total number of questions from Firestore
    var snap = await constants.firestore.collection('musers').doc(constants.auth.currentUser!.uid).get();
    List completedCat = snap.data()!['completedCat'] ?? [];
    print(completedCat);
    if(completedCat.isEmpty){
      setState(() {
        totalPercentage = 0.0;
      });
    }else{
      var questionsRef1 = _firestore
          .collection('questions')
          .where('gender', whereIn: [gender, 'all']);
      var questionsSnapshot = await questionsRef1.get();
      int _totalQuestions = questionsSnapshot.docs.length;

      // retrieve number of answered questions from Firestore
      var answersRef = _firestore
          .collection('answers')
          .doc(_auth.currentUser!.uid)
          .collection('answers');
      var answersSnapshot = await answersRef.get();
      int _answeredQuestions = answersSnapshot.docs.length;

      // calculate percentage of answered questions
      double _totalPercentage = _answeredQuestions / _totalQuestions * 100;
      if (_totalPercentage >= 99) {
        _totalPercentage = 100;
        await _firestore
            .collection('musers')
            .doc(_auth.currentUser!.uid)
            .update({'isCompleteProfile': true});
        await _firestore
            .collection('answers')
            .doc(_auth.currentUser!.uid)
            .update({'isCompleteProfile': true});
      }
      setState(() {
        totalPercentage = _totalPercentage;
      });
    }

  }

  getData() async {
    try{
      var snap = await _firestore.collection('questions').doc('qCat').get();
      var snap2 =
      await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();
      setState(() {
        gender = snap2.data()!['gender'];
        questionsRef = _firestore
            .collection('questions')
            .where('gender', whereIn: [gender, 'all']);
        finishedCat = snap2.data()!['completedCat'] ?? [];
        questionsCategories = snap.data()!['qcat'];
        pquestionsCategories = snap.data()!['pqcat'];

        questionsCategories
            .removeWhere((element) => finishedCat.contains(element));
        pquestionsCategories
            .removeWhere((element) => finishedCat.contains(element));
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }

  // CleanCategories(cat) async {
  //   var snap = await _firestore.collection('questions').get();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<AppService>(builder: (__, valueServ, _) {
      return Container(
        padding: EdgeInsets.all(10),
        width: constants.screenWidth,
        height: constants.screenHeight*0.85,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    key: CouchKeys.Key5,
                    children: [
                      constants.bigText('الملف الشخصي', context,
                          color: Theme.of(context).primaryColor),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
              decoration: BoxDecoration(
                  gradient: valueServ.systemGradient,
                  borderRadius: BorderRadius.circular(25)),
              width: constants.screenWidth * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RatingStars(
                        value: totalPercentage,
                        maxValue: 100,
                        starCount: 10,
                        valueLabelVisibility: false,
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      totalPercentage == 100
                          ? Text(
                        'الملف مكتمل',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                          : Text(
                        'الملف غير مكتمل',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${totalPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            constants.UserInfo(
                text: 'هنا يتم ملئ ملفك الشخصي و متطلباتك عن ايجاد شريك حياتك'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(

                  children: [

                    questionsCategories.isEmpty
                        ? Container()
                        : Column(
                      children: [
                        Divider(
                          endIndent: 10,
                          indent: 10,
                        ),
                        constants.smallText('غير مكتمل', context,
                            color: Colors.redAccent),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Consumer<QController>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    //TODO: what happens after clicking

                                    QController()
                                        .setCategory(questionsCategories[index]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionReuseable(isMainAnswer: true,
                                              category: questionsCategories[index]),
                                        ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    width: constants.screenWidth * 0.9,
                                    height: constants.screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: constants.greyC),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        constants.smallText(
                                            '${questionsCategories[index]}',
                                            context,
                                            color: Colors.red),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: questionsCategories.length,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                    pquestionsCategories.isEmpty
                        ? Container()
                        : Column(
                      children: [
                        Divider(
                          endIndent: 10,
                          indent: 10,
                        ),
                        constants.smallText('غير مكتمل', context,
                            color: Colors.redAccent),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Consumer<QController>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    //TODO: what happens after clicking

                                    QController()
                                        .setCategory(pquestionsCategories[index]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionReuseable(isMainAnswer: true,
                                              category:
                                              pquestionsCategories[index]),
                                        ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    width: constants.screenWidth * 0.9,
                                    height: constants.screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: constants.greyC),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        constants.smallText(
                                            '${pquestionsCategories[index]}',
                                            context,
                                            color: Colors.red),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: pquestionsCategories.length,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                    additionalQuestions.isEmpty
                        ? Container()
                        : Column(
                      children: [
                        Divider(
                          endIndent: 10,
                          indent: 10,
                        ),
                        constants.smallText('غير مكتمل', context,
                            color: Colors.redAccent),
                        Consumer<QController>(
                          builder: (BuildContext context, value, Widget? child) {
                            return GestureDetector(
                              onTap: () {
                                //TODO: what happens after clicking

                                // QController()
                                //     .setCategory(additionalQuestions[index]['category']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionReuseable(isMainAnswer: false,
                                        category: additionalQuestions[0]
                                        ['category'],
                                        isExtra: true,
                                        AdditionalQuestions: additionalQuestions,
                                      ),
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                width: constants.screenWidth * 0.9,
                                height: constants.screenHeight * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: constants.greyC),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    constants.smallText('أسئلة إضافية', context,
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                    ),
                    finishedCat.isEmpty
                        ? Container()
                        : Column(
                      children: [
                        constants.smallText('مكتمل', context,
                            color: Colors.redAccent),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Consumer<QController>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    //TODO: what happens after clicking
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    width: constants.screenWidth * 0.9,
                                    height: constants.screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: valueServ.systemGradient),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Align(
                                                alignment: Alignment.bottomRight,
                                                child: Icon(
                                                  Bootstrap.star_fill,
                                                  color: Colors.white,
                                                )),
                                            constants.smallText(
                                              '${finishedCat[index]}',
                                              context,
                                            ),
                                            Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Icon(
                                                  Bootstrap.star_fill,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: finishedCat.length,
                          shrinkWrap: true,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: FilledButton(
                              onPressed: () {
                                navigateTo(QuestionsEdit(), context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Text('تعديل الإجابات'),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }));

  }
}
