import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:madalh/view/paymentScreen/femalePaymentScreen.dart';
import 'package:madalh/view/paymentScreen/paymentScreen.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:uuid/uuid.dart';

class ReuseableMatchProfile extends StatefulWidget {
  final double similarityPercentage;
  final String userId;
  final String matchId;

  ReuseableMatchProfile(
      {Key? key,
      required this.similarityPercentage,
      required this.userId,
      required this.matchId})
      : super(key: key);

  @override
  State<ReuseableMatchProfile> createState() => _ReuseableMatchProfileState();
}

class _ReuseableMatchProfileState extends State<ReuseableMatchProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List answers = [];
  bool isRequested = false;
  bool isPoked = false;
  bool isLoading = false;
  bool isSubscribed = false;
  String gender = '';
  int matches = 0;
  int fmatches = 0;
  List requestsSent = [];
  List nackSent = [];
  List msgSent = [];

  Future<bool> checkDocumentExists(
      String collectionPath, String field, dynamic value) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  DateTime lastFreeRequest = DateTime.now();
  Duration remainingTimeFemale = Duration(hours: 1);
  Duration remainingTimeMale = Duration(hours: 1);

  checkIfRequested(List<QueryDocumentSnapshot<Map<String, dynamic>>> x) {
    x.forEach((element) {
      if (element['senId'] == _auth.currentUser!.uid) {
        setState(() {
          isRequested = true;
        });
      }
    });
    // await _firestore.collection('requests').doc(uniqId).set(
    //     {
    //       'senId':_auth.currentUser!.uid,
    //       'recId':widget.userId,
    //       'recRes':null,
    //       'recResType':-1,
    //       'question':null
    //     });
  }

  checkIfPoked(List<QueryDocumentSnapshot<Map<String, dynamic>>> x) {
    x.forEach((element) {
      if (element['senId'] == _auth.currentUser!.uid) {
        setState(() {
          isPoked = true;
        });
      }
    });
    // await _firestore.collection('requests').doc(uniqId).set(
    //     {
    //       'senId':_auth.currentUser!.uid,
    //       'recId':widget.userId,
    //       'recRes':null,
    //       'recResType':-1,
    //       'question':null
    //     });
  }

  int messages = 0;

  initializeScreen() async {
    var snap = await _firestore
        .collection('answers')
        .doc(widget.userId)
        .collection('answers')
        .orderBy('date', descending: false)
        .get();
    var snap2 =
        await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();
    var reqSnap = await _firestore.collection('requests').get();
    var pokeSnap = await _firestore.collection('pokes').get();

    // QuerySnapshot allQSnapshot = await _firestore
    //     .collection("questions")
    //     .where('order', isEqualTo: 1)
    //     .get();
    // QuerySnapshot userProfileAnswers = await _firestore
    //     .collection('musers')
    //     .doc(widget.userId)
    //     .collection('answers')
    //     .get();
    // var questionsCategorySnap =
    //     await _firestore.collection('questions').doc('qCat').get();
    // List qcat = questionsCategorySnap.data()!['qcat'];
    // List pqcat = questionsCategorySnap.data()!['pqcat'];
    //
    // List<DocumentSnapshot> allQDocuments = allQSnapshot.docs;
    //
    // List qcatQuestion = [];
    // List pqcatQuestion = [];
    //
    // for (var question in allQDocuments) {
    //   if (qcat.contains(question['category'])) {
    //     qcatQuestion.add(question.id);
    //   } else if (pqcat.contains(question['category'])) {
    //     pqcatQuestion.add(question.id);
    //   }
    // }
    //
    // List answerss = userProfileAnswers.docs;
    // List answersx = [];
    // answerss = snap.docs;
    // for (var element in answerss) {
    //   if (qcatQuestion.contains(element['uid'])) {
    //     answersx.add(element);
    //   }
    // }
    List<QueryDocumentSnapshot<Map<String, dynamic>>> requestsDocs =
        reqSnap.docs;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> pokesDocs = pokeSnap.docs;

    setState(() {
      answers = snap.docs;
      gender = snap2.data()!['gender'];
      messages = snap2.data()!['messages'];
      msgSent = snap2.data()!['msgSent'];
      matches = snap2.data()!['matches'] ?? 0;
      fmatches = snap2.data()!['fmatches'] ?? 0;
      isSubscribed = snap2.data()!['isSubscribed'];
      requestsSent = snap2
              .data()!['requestsSent']
              .map((map) =>
                  map['userId']) // extract the 'uid' value from each map
              .toList() ??
          [];
      nackSent = snap2
              .data()!['nackSent']
              .map((map) =>
                  map['userId']) // extract the 'uid' value from each map
              .toList() ??
          [];
      lastFreeRequest =
          snap2.data()!['lastFreeRequest'].toDate() ?? DateTime.now();
      remainingTimeFemale =
          DateTime.now().difference(lastFreeRequest).inHours < 8
              ? Duration(hours: 8) - DateTime.now().difference(lastFreeRequest)
              : Duration.zero;
      remainingTimeMale =
          DateTime.now().difference(lastFreeRequest).inHours < 24
              ? Duration(hours: 24) - DateTime.now().difference(lastFreeRequest)
              : Duration.zero;
    });
    if (gender == 'm') {
      checkIfRequested(requestsDocs);
    } else {
      checkIfPoked(pokesDocs);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeScreen();
  }
  returnTextAccordingToType(text, type){
    if(type == 0){
      return text+' cm';
    } else if(type == 1){
      return text+' kg';
    }else{
      return text;
    }
  }
  checkAndReturnAccordingToStatus(status, original, {type}) {
    if (status == 0) {
      return Column(
        children: [
          Text(
            'تم رفض هذه الإجابة من قبل الإدارة',
            textDirection: TextDirection.rtl,
            maxLines: 3,
            style: TextStyle(color: Colors.grey),
            // softWrap: true,
          ),
        ],
      );
    } else if (status == 1) {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor == constants.femaleSwatch
                ? constants.azure1
                : constants.peach1,
            borderRadius: BorderRadius.circular(screenWidth * 0.1)),
        child: Text(
          returnTextAccordingToType(original, type),
          textDirection: TextDirection.rtl,

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          // softWrap: true,
        ),
      );
    } else if (status == 2) {
      return Text(
        'بإنتظار موافقة الإدارة على الإجابة',
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.grey),
        // softWrap: true,
      );
    } else if (status == 3) {
      return Text(
        'تم إعطاء فرصة من الإدارة لتغيير الإجابة',
        textDirection: TextDirection.rtl,

        style: TextStyle(color: Colors.grey),
        // softWrap: true,
      );
    }
  }

  void _sendQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (x) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                constants.smallText('إرسال رسالة للمستخدم', context,
                    color: Colors.red),
                constants.UserInfo(text: 'ترسل لمرة واحدة فقط'),
                Container(
                    padding: EdgeInsets.all(3),
                    width: constants.screenWidth * 0.8,
                    child: TextField(
                        controller: controller,
                        minLines: 3,
                        maxLines: 6,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            label: Text(
                              'الرسالة',
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder())))
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent)),
                    child: Text("الغاء"),
                    onPressed: () {
                      Navigator.of(x).pop();
                    },
                  ),
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    child: Text("إرسال"),
                    onPressed: () async {
                      bool exist = await checkDocumentExists(
                          'messages', 'senId', _auth.currentUser!.uid);
                      if (exist) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('لقد أرسلت مسبقا لهذا المستخدم'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        if (messages >= 1) {
                          final uid = Uuid().v1();
                          await _firestore.collection('messages').doc(uid).set({
                            'question': controller.text,
                            'oldQuestion': '',
                            'answer': 'لا يوجد حتى الأن',
                            'oldAnswer': '',
                            'status': 1,
                            'chance': 0,
                            'date': DateTime.now(),
                            'senId': _auth.currentUser!.uid,
                            'recId': widget.userId
                          });
                          setState(() {
                            messages -= 1;
                          });
                          await _firestore
                              .collection('musers')
                              .doc(_auth.currentUser!.uid)
                              .update({'messages': messages});
                          Fluttertoast.showToast(
                              msg:
                                  'تم ارسال سؤالك إلى الإدارة حتى يتم الموافقة عليه ثم يستم ارساله للمستخدم للإجابة عليه');
                          Navigator.of(x).pop();
                        } else {
                          navigateTo(
                              FemaleBundleScreen(
                                isNoMatches: true,
                              ),
                              context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('لم يتبقى لديك رسائل يومية'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return gender == 'm'
        ? Scaffold(
            bottomNavigationBar: Container(
              width: constants.screenWidth,
              height: constants.screenHeight * 0.1,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: isRequested == true
                      ? Colors.grey
                      : Theme.of(context).primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    //male
                    onTap: () async {
                      if (isRequested == false) {
                        if (matches > 0) {
                          if (isSubscribed == true) {
                            setState(() {
                              matches -= 1;
                            });
                            final uniqId = Uuid().v1();
                            await _firestore
                                .collection('musers')
                                .doc(_auth.currentUser!.uid)
                                .update({'matches': matches});
                            await _firestore
                                .collection('requests')
                                .doc(uniqId)
                                .set({
                              'reqId': uniqId,
                              'senId': _auth.currentUser!.uid,
                              'recId': widget.userId,
                              'recRes': null,
                              'recResType': -1,
                              'question': null,
                              'matchId': widget.matchId,
                              'similarity': widget.similarityPercentage
                            });
                            setState(() {
                              isRequested == true;
                            });
                            Fluttertoast.showToast(
                                msg: 'تم  طلب معلومات المستخدم بنجاح');
                            Navigator.pop(context);
                          } else {
                            if (widget.similarityPercentage <= 60) {
                              setState(() {
                                matches -= 1;
                              });
                              final uniqId = Uuid().v1();
                              await _firestore
                                  .collection('musers')
                                  .doc(_auth.currentUser!.uid)
                                  .update({'matches': matches});
                              await _firestore
                                  .collection('requests')
                                  .doc(uniqId)
                                  .set({
                                'reqId': uniqId,
                                'senId': _auth.currentUser!.uid,
                                'recId': widget.userId,
                                'recRes': null,
                                'recResType': -1,
                                'question': null,
                                'matchId': widget.matchId,
                                'similarity': widget.similarityPercentage
                              });
                              setState(() {
                                isRequested == true;
                              });
                              Fluttertoast.showToast(
                                  msg: 'تم  طلب معلومات المستخدم بنجاح');
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'يجب عليك الإشتراك لطلبات النسب العالية');
                              navigateTo(
                                  MaleBundleScreen(
                                    isNoMatches: true,
                                  ),
                                  context);
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'يجب عليك الإشتراك لزيادة الطلبات اليومية');
                          navigateTo(
                              MaleBundleScreen(
                                isNoMatches: true,
                              ),
                              context);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'تم ارسال طلبك بالفعل من قبل، يرجى إنتظار الرد');
                      }
                    },
                    child: Container(
                      width: constants.screenWidth * 0.7,
                      height: constants.screenHeight * 0.09,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: isRequested == true
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Bootstrap.person_fill,
                            color: Colors.white,
                          ),
                          isRequested == true
                              ? FittedBox(
                                  child: constants.smallText(
                                      'بإنتظار موافقة صاحب الملف', context),
                                )
                              : FittedBox(
                                  child: constants.smallText(
                                      'طلب معلومات التواصل', context),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text('%نسبة التطابق: ${widget.similarityPercentage}'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: PageScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(border: Border.all()),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    answers[index]['question'],
                                    textDirection: TextDirection.rtl,
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: constants.screenWidth,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    answers[index]['type'] == 5
                                        ? Wrap(
                                            alignment: WrapAlignment.start,
                                            children: answers[index]['Images']
                                                        .length !=
                                                    0
                                                ? List.generate(
                                                    answers[index]['answer']
                                                        .length,
                                                    (iindex) => Chip(
                                                      backgroundColor:
                                                          Colors.white,
                                                      label: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: constants
                                                                    .screenWidth *
                                                                0.25,
                                                            height: constants
                                                                    .screenWidth *
                                                                0.25,
                                                            child:
                                                                Image.network(
                                                              answers[index]
                                                                      ['Images']
                                                                  [iindex],
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 5,
                                                          ),
                                                          Chip(
                                                            backgroundColor:
                                                                Theme.of(context)
                                                                            .primaryColor ==
                                                                        constants
                                                                            .peach1
                                                                    ? constants
                                                                        .azure1
                                                                    : constants
                                                                        .peach1,
                                                            label: constants
                                                                .smallText(
                                                                    answers[index]
                                                                            [
                                                                            'answer']
                                                                        [
                                                                        iindex],
                                                                    context),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : [])
                                        : checkAndReturnAccordingToStatus(
                                            answers[index]['status'],
                                            answers[index]['answer']
                                                .toString()
                                                .replaceAll('null,', '')
                                                .replaceAll('null', '')
                                                .replaceAll('0.0', '')
                                                .replaceAll(']', '')
                                                .replaceAll('[', ''), type: answers[index]['type'])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: answers.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          )
        :
        //Female
        Scaffold(
            bottomNavigationBar: Container(
              width: constants.screenWidth,
              height: constants.screenHeight * 0.1,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: isPoked == true
                      ? Colors.grey
                      : Theme.of(context).primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    //female
                    onTap: () async {
                      if (isPoked == false) {
                        if (fmatches > 0) {
                          if (isSubscribed == true) {
                            setState(() {
                              fmatches -= 1;
                            });
                            final uniqId = Uuid().v1();
                            await _firestore
                                .collection('musers')
                                .doc(_auth.currentUser!.uid)
                                .update({'fmatches': fmatches});
                            await _firestore
                                .collection('pokes')
                                .doc(uniqId)
                                .set({
                              'pokeId': uniqId,
                              'senId': _auth.currentUser!.uid,
                              'recId': widget.userId,
                              'recRes': null,
                              'recResType': -1,
                              'question': null,
                              'matchId': widget.matchId,
                              'similarity': widget.similarityPercentage
                            });
                            setState(() {
                              isPoked == true;
                            });
                          } else {
                            if (widget.similarityPercentage <= 65) {
                              setState(() {
                                fmatches -= 1;
                              });
                              final uniqId = Uuid().v1();
                              await _firestore
                                  .collection('musers')
                                  .doc(_auth.currentUser!.uid)
                                  .update({'fmatches': fmatches});
                              await _firestore
                                  .collection('pokes')
                                  .doc(uniqId)
                                  .set({
                                'pokeId': uniqId,
                                'senId': _auth.currentUser!.uid,
                                'recId': widget.userId,
                                'recRes': null,
                                'recResType': -1,
                                'question': null,
                                'matchId': widget.matchId,
                                'similarity': widget.similarityPercentage
                              });
                              setState(() {
                                isPoked == true;
                              });
                              Fluttertoast.showToast(
                                  msg: 'تم نكز المستخدم بنجاح');
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'يجب عليك الإشتراك لزيادة لنكز النسب العالية');
                              navigateTo(
                                  FemaleBundleScreen(
                                    isNoMatches: true,
                                  ),
                                  context);
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'يجب عليك الإشتراك لزيادة عدد النكزات اليومية');
                          navigateTo(
                              FemaleBundleScreen(
                                isNoMatches: true,
                              ),
                              context);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'تم ارسال طلبك بالفعل من قبل، يرجى إنتظار الرد');
                      }
                    },
                    child: Container(
                      width: constants.screenWidth * 0.7,
                      height: constants.screenHeight * 0.09,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: isPoked == true
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Bootstrap.hand_index,
                            color: Colors.white,
                          ),
                          isPoked == true
                              ? constants.smallText(
                                  'تم نكز صاحب الملف من قبل', context)
                              : constants.smallText('نكز صاحب الملف', context)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text('%نسبة التطابق: ${widget.similarityPercentage}'),
              centerTitle: true,
              actions: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () {
                      if (msgSent.contains(widget.userId) == true) {
                        Fluttertoast.showToast(
                            msg: 'لقد ارسلت رسالة للمستخدم من قبل');
                      } else {
                        _sendQuestion(context);
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Bootstrap.chat_fill,
                          color: Colors.white,
                          size: constants.screenWidth * 0.1,
                        ),
                        Icon(
                          Bootstrap.star_fill,
                          color: Colors.amber,
                          size: constants.screenWidth * 0.05,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: PageScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(border: Border.all()),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    answers[index]['question'],
                                    textDirection: TextDirection.rtl,
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: constants.screenWidth,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    answers[index]['type'] == 5
                                        ? Wrap(
                                            alignment: WrapAlignment.start,
                                            children: answers[index]['Images']
                                                        .length !=
                                                    0
                                                ? List.generate(
                                                    answers[index]['answer']
                                                        .length,
                                                    (iindex) => Chip(
                                                      backgroundColor:
                                                          Colors.white,
                                                      label: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: constants
                                                                    .screenWidth *
                                                                0.25,
                                                            height: constants
                                                                    .screenWidth *
                                                                0.25,
                                                            child:
                                                                Image.network(
                                                              answers[index]
                                                                      ['Images']
                                                                  [iindex],
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 5,
                                                          ),
                                                          Chip(
                                                            backgroundColor:
                                                                Theme.of(context)
                                                                            .primaryColor ==
                                                                        constants
                                                                            .femaleSwatch
                                                                    ? constants
                                                                        .azure1
                                                                    : constants
                                                                        .peach1,
                                                            label: constants
                                                                .smallText(
                                                                    answers[index]
                                                                            [
                                                                            'answer']
                                                                        [
                                                                        iindex],
                                                                    context),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : [])
                                        : checkAndReturnAccordingToStatus(
                                        answers[index]['status'],
                                        answers[index]['answer']
                                            .toString()
                                            .replaceAll('null,', '')
                                            .replaceAll('null', '')
                                            .replaceAll(']', '')
                                            .replaceAll('[', ''), type: answers[index]['type'])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: answers.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
