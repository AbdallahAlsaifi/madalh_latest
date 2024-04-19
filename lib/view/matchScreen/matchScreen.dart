import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:madalh/homePage.dart';
import 'package:madalh/view/matchScreen/mainMatch.dart';
import 'package:madalh/view/matchScreen/matchProfile.dart';
import 'package:madalh/view/matchScreen/messages.dart';
import 'package:madalh/view/matchScreen/pokes.dart';
import 'package:madalh/view/matchScreen/requestScreen.dart';
import 'package:madalh/view/paymentScreen/paymentScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/matchScreenController.dart';
import '../../controllers/requestsController.dart';
import '../../controllers/systemController.dart';
import 'fav.dart';

class MatchScreen extends StatefulWidget {
  final screenIndex;

  const MatchScreen({Key? key, this.screenIndex = 0}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

  int pageIndex = 0;

  String gender = '';

  Widget screen1 = Container();
  Widget screen2 = Container();
  Widget screen3 = Container();

  bool isLoading = false;

  List matchDocs = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> PokeRec = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> PokeSent = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> ReqRec = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ReqSent = [];

  var userData = {};

  void _sendContactInformation(BuildContext context, docId) {
    showDialog(
      context: context,
      builder: (x) {
        PhoneNumber? ph;
        String? parent = '';
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    constants.smallText('معلومات ولي الأمر', context,
                        color: Colors.red)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropDown(
                      hint: Text('صلة القرابة'),
                      items: [
                        'أب',
                        'أم',
                        'أخ',
                        'أخت',
                        'قرابة',
                        'أخرى',
                      ],
                      onChanged: (value) {
                        setState(() {
                          parent = value;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  height: 7,
                ),
                Container(
                  width: constants.screenWidth * 0.8,
                  child: IntlPhoneField(
                    initialCountryCode: 'PS',
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    invalidNumberMessage: 'الرجاء إدخال رقم صحيح',
                    onChanged: (p) {
                      setState(() {
                        ph = p;
                      });
                    },
                  ),
                ),
                Container(
                  height: 7,
                ),
                Container(
                    padding: EdgeInsets.all(3),
                    width: constants.screenWidth * 0.8,
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                    child: TextField(
                      controller: controller,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration.collapsed(
                        hintText: 'العنوان',
                      ),
                    ))
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
                      if (ph != null) {
                        bool checkNumber =
                            await checkNumberIfSame(ph!, ph!.countryCode);

                        if (checkNumber == true) {
                          await _firestore
                              .collection('requests')
                              .doc(docId)
                              .update({
                            'recRes': {
                              'parent': parent,
                              'pn': ph!.completeNumber,
                              'location': controller.text
                            },
                            'recResType': 2,
                            'date': DateTime.now()
                          });

                          Navigator.of(x).pop();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'لا يمكن ارسال رقمك، يجب أن يكون رقم ولي الأمر');
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

  Future<bool> checkNumberIfSame(PhoneNumber ph, countryCode) async {
    String fpn = ph.number;

    String psStart = '+970';
    String ilStart = '+972';
    bool result = true;
    var users = await FirebaseFirestore.instance
        .collection('musers')
        .doc(_auth.currentUser!.uid)
        .get();
    var usersData = users.data()!;
    if (countryCode == ilStart || countryCode == psStart) {
      String ilN = ilStart + fpn;
      String psN = psStart + fpn;
      if (usersData['pNumber'] == ilN || usersData['pNumber'] == psN) {
        setState(() {
          result = false;
        });
      }
    }
    return result;
  }

  void _sendQuestion(BuildContext context, docId) {
    showDialog(
      context: context,
      builder: (x) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: EdgeInsets.all(3),
                    width: constants.screenWidth * 0.8,
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                    child: TextField(
                      controller: controller,
                      minLines: 3,
                      maxLines: 6,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration.collapsed(
                        hintText: 'السؤال',
                      ),
                    ))
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
                      Provider.of<AppService>(context, listen: false)
                          .matching();
                      Navigator.of(x).pop();
                    },
                  ),
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    child: Text("إرسال"),
                    onPressed: () async {
                      await _firestore
                          .collection('requests')
                          .doc(docId)
                          .update({
                        'question': {
                          'question': controller.text,
                          'qApprove': -1,
                          'answer': null,
                          'aApprove': null
                        },
                        'recResType': 3
                      });
                      Navigator.of(x).pop();
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

  getMatchesData() async {
    var reqsnap = await _firestore.collection('requests').get();
    var snap = await _firestore
        .collection('musers')
        .doc(_auth.currentUser!.uid)
        .collection('matches').orderBy('Similarity', descending: true)
        .get();
    var userSnap =
        await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> notificationsDocs =
        snap.docs;

    for (var i in notificationsDocs) {
      if (i['saw'] != true) {
        await i.reference.update({'saw': true});
      }
    }

    if (userSnap.data()!['gender'] == 'm') {
      var snap = await _firestore
          .collection('pokes')
          .where('recId', whereIn: [_auth.currentUser!.uid]).get();

      setState(() {
        PokeRec = snap.docs;
        ReqSent = reqsnap.docs
            .where((element) => element['senId'] == _auth.currentUser!.uid)
            .toList();
      });
    } else {
      var snap = await _firestore
          .collection('pokes')
          .where('senId', whereIn: [_auth.currentUser!.uid]).get();

      setState(() {
        PokeSent = snap.docs;
        ReqRec = reqsnap.docs
            .where((element) => element['recId'] == _auth.currentUser!.uid)
            .toList();
      });
    }
    setState(() {
      matchDocs = greaterThanOrEqual(snap.docs);
      userData = userSnap.data()!;
      gender = userSnap.data()!['gender'];
    });
  }
greaterThanOrEqual(List x){
    List temp = [];
    for(var e in x){
      if(double.parse(e['Similarity']) >= 39){
        temp.add(e);
      }
    }
    return temp;
}
  @override
  void initState() {
    // TODO: implement initState
    getMatchesData().then((_) {
      pageController
          .animateToPage(1,
              duration: Duration(milliseconds: 10), curve: Curves.linear)
          .then((_) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 10), curve: Curves.linear);
        setSaw();
      });

    });

    super.initState();
  }
setSaw()async{
    try{
      var snap = await _firestore.collection('musers').doc(_auth.currentUser!.uid).collection('matches').get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapDocs = snap.docs;

      for (var element in snapDocs) {
        await element.reference.update({
          'saw': true,
        });
      }
    }catch(e){}

}
  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(builder: (_, value, __) {
      return LoadingOverlay(
        color: Colors.white,
        progressIndicator: constants.loadingAnimation(),
        isLoading: isLoading,
        child: Scaffold(
            floatingActionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Bootstrap.chat_fill),
                    onPressed: () {
                      navigateTo(messagesScreen(), context);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Bootstrap.heart_fill),
                    onPressed: () {
                      navigateTo(favScreen(), context);
                    },
                  )
                ]),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                        key: CouchKeys.Key1,
                        onPressed: () {
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: pageIndex != 0
                                ? MaterialStateColor.resolveWith(
                                    (states) => Colors.grey)
                                : MaterialStateColor.resolveWith((states) =>
                                    Theme.of(context).primaryColor)),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Bootstrap.person_fill),
                              Text('التطابقات')
                            ],
                          ),
                        )),
                    FilledButton(
                        key: CouchKeys.Key2,
                        onPressed: () {
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                          setState(() {
                            pageIndex = 1;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: pageIndex != 1
                                ? MaterialStateColor.resolveWith(
                                    (states) => Colors.grey)
                                : MaterialStateColor.resolveWith((states) =>
                                    Theme.of(context).primaryColor)),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Bootstrap.hand_index),
                              Container(
                                width: 3,
                              ),
                              Text('النكزات')
                            ],
                          ),
                        )),
                    FilledButton(
                        key: CouchKeys.Key3,
                        onPressed: () {
                          pageController.animateToPage(2,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.bounceIn);
                          setState(() {
                            pageIndex = 2;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: pageIndex != 2
                                ? MaterialStateColor.resolveWith(
                                    (states) => Colors.grey)
                                : MaterialStateColor.resolveWith((states) =>
                                    Theme.of(context).primaryColor)),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              gender == 'm'
                                  ? Icon(Bootstrap.check_circle_fill)
                                  : Icon(Bootstrap.clock),
                              Container(
                                width: 3,
                              ),
                              gender == 'm'
                                  ? Text('الموافقات')
                                  : Text('الطلبات')
                            ],
                          ),
                        ))
                  ],
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      mainMatch(matchDoc: matchDocs),
                      pokeScreen(
                          gender: userData['gender'],
                          pokeSend: PokeSent,
                          pokeRec: PokeRec),
                      requestScreen(
                          gender: userData['gender'],
                          reqRec: ReqRec,
                          reqSent: ReqSent,
                          requestContainer: userData['gender'] == 'm'
                              ? RequestContainer2
                              : RequestContainer),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }

  Widget RequestContainer(index, int type) {
    TextEditingController controller = TextEditingController();
    if (type == 0) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.x_circle_fill,
                      color: Colors.red,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'لقد تم رفض هذا المستخدم',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 1) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار المستخدم لإجابة سؤالك',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              'بإنتظار الإجابة على السؤال', context,
                              color: Colors.red)
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 2) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.check_circle_fill,
                      color: Colors.green,
                    ),
                    Text(
                      'تم إخفاء ملفك عن المستخدم و إرسال معلومات ولي الأمر إليه',
                      style: TextStyle(color: Colors.green),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 3) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار المستخدم لإجابة سؤالك',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              'بإنتظار الإجابة على السؤال', context,
                              color: Colors.red)
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 4) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار المستخدم لإجابة سؤالك',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              'بإنتظار الإجابة على السؤال', context,
                              color: Colors.red)
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 5) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار المستخدم لإجابة سؤالك',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              'بإنتظار الإجابة على السؤال', context,
                              color: Colors.red)
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 6) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'تم الرد على سؤالك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Wrap(
                children: [
                  constants.smallText(
                      '(${ReqRec[index]['question']['question']})', context,
                      color: Colors.redAccent),
                ],
              ),
              Wrap(
                children: [
                  constants.smallText(
                      ReqRec[index]['answer']['answer'], context,
                      color: Colors.redAccent),
                ],
              ),
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.red)),
                              onPressed: () async {
                                await _firestore
                                    .collection('requests')
                                    .doc(ReqRec[index]['reqId'])
                                    .update({
                                  'recResType': 0,
                                });
                              },
                              child: Text('رفض')),
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.green)),
                              onPressed: () {
                                _sendContactInformation(
                                    context, ReqRec[index]['reqId']);
                              },
                              child: Text('قبول'))
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 7) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.red,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'لقد تم رفض سؤالك من قبل الإدارة، لديك فرصة أخيرة لسؤال آخر',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    ReqRec[index].data()!['question']['question'],
                    style: TextStyle(color: Colors.red),
                    textDirection: TextDirection.rtl,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2)),
                width: constants.screenWidth * 0.9,
                child: TextField(
                  controller: controller,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 150,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration.collapsed(
                    hintText: 'السؤال',
                  ),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  await _firestore
                      .collection('requests')
                      .doc(ReqRec[index].data()!['reqId'])
                      .update({
                    'question': {'question': controller.text, 'qApprove': -1},
                    'recResType': 3,
                  });
                },
                child: Text('ارسال'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange)),
              ),
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 8) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار المستخدم لإجابة سؤالك',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          constants.smallText(
                              'بإنتظار الإجابة على السؤال', context,
                              color: Colors.red)
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 9) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.check_circle_fill,
                      color: Colors.green,
                    ),
                    Text(
                      'تم إخفاء معلومات ولي الأمر لمرسلة سابقا للمستخدم',
                      style: TextStyle(color: Colors.green),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'لديك طلب جديد بإنتظار ردك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Container(
                      width: constants.screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.red)),
                              onPressed: () {},
                              child: Text('رفض')),
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.orange)),
                              onPressed: () {
                                _sendQuestion(context, ReqRec[index]['reqId']);
                              },
                              child: Text('إرسال سؤال')),
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.green)),
                              onPressed: () {
                                _sendContactInformation(
                                    context, ReqRec[index]['reqId']);
                              },
                              child: Text('قبول'))
                        ],
                      )),
                  Wrap(
                    children: [
                      constants.UserInfo(
                          textColor: Colors.green,
                          iconColor: Colors.green,
                          text:
                              'عند الموافقة سترسل معلومات ولي أمرك للمستخدم و سيتم اخفاء معلومات ملفك عنه و اذا لم يتواصل المستخدم مع ولي امرك سيتم إخفاء معلومات ولي أمرك عنه'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqRec[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqRec[index]
                                                    ['matchId'],
                                                userId: ReqRec[index]['senId'],
                                                similarityPercentage:
                                                    ReqRec[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    }
  }

  Widget RequestContainer2(
    index,
    int type,
  ) {
    TextEditingController controller = TextEditingController();
    if (type == 0) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.x_circle_fill,
                      color: Colors.red,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'لقد تم رفضك من قبل المستخدمة، حظا اوفر مع مستخدمة أخرى',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 1) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار رد المستخدمة على طلبك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 2) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.check_circle_fill,
                      color: Colors.green,
                    ),
                    Text(
                      'تم مشاركة معلومات ولي الأمر معك و سيتم اخفاء معلومات ولي الأمر خلال 4 أيام لخصوصية المستخدمة',
                      style: TextStyle(color: Colors.green),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Text(
                'صلة القرابة: ',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Text(
                '${ReqSent[index]['recRes']['parent']}',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Text(
                'رقم الهاتف: ',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Text(
                '${ReqSent[index]['recRes']['pn']}',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Text(
                'العنوان: ',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Text(
                '${ReqSent[index]['recRes']['location']}',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'لقد تم إخفاء ملف المستخدمة للخصوصية، وسيتم اخفاء معلومات ولي الأمر خلال 4 ايام');
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 3) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار رد المستخدمة على طلبك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 4) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار رد المستخدمة على طلبك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 5) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.orange,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'لقد تم سؤالك من قبل المستخدم وعلى حسب الإجابة سيتم القبول او الرفض من قبل المستخدم',
                      style: TextStyle(color: Colors.orange),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    ReqSent[index].data()!['question']['question'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: constants.screenWidth * 0.05,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2)),
                width: constants.screenWidth * 0.9,
                child: TextField(
                  controller: controller,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 150,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration.collapsed(
                    hintText: 'الإجابة',
                  ),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  await _firestore
                      .collection('requests')
                      .doc(ReqSent[index].data()!['reqId'])
                      .update({
                    'answer': {'answer': controller.text, 'aApprove': -1},
                    'recResType': 4,
                  });
                },
                child: Text('ارسال'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange)),
              ),
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 6) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'تم ارسال اجابتك الى المستخدمة، بإنتظار ردها',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 7) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار رد المستخدمة على طلبك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 8) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.pencil_square,
                      color: Colors.red,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'تم رفض إجابتك من قبل الإدارة و لديك فرضة اخيرة للإجابة، لقد تم سؤالك من قبل المستخدم وعلى حسب الإجابة سيتم القبول او الرفض من قبل المستخدم',
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    ReqSent[index].data()!['question']['question'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2)),
                width: constants.screenWidth * 0.9,
                child: TextField(
                  controller: controller,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 150,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration.collapsed(
                    hintText: 'الإجابة',
                  ),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  await _firestore
                      .collection('requests')
                      .doc(ReqSent[index].data()!['reqId'])
                      .update({
                    'answer': {'answer': controller.text, 'aApprove': -1},
                    'recResType': 4,
                  });
                },
                child: Text('ارسال'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange)),
              ),
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    } else if (type == 9) {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.check,
                      color: Colors.green,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'تم اخفاء المعلومات',
                      style: TextStyle(color: Colors.green),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'عندما تتعدى معلومات المستخدم 4 ايام يتم اخفاء معلومات المستخدم لذا تم إخفاء معلومات المستخدم لضمان الخصوصية',
                    style: TextStyle(color: Colors.orange),
                    textDirection: TextDirection.rtl,
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
          margin: EdgeInsets.only(top: 5),
          child: ExpansionTileCard(
            title: Container(
                width: constants.screenWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Bootstrap.clock,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'بإنتظار رد المستخدمة على طلبك',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                )),
            children: [
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 0),
                        width: constants.screenWidth * 0.9,
                        height: constants.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          gradient:
                              Provider.of<AppService>(context, listen: false)
                                          .systemGradient ==
                                      constants.femaleG
                                  ? constants.maleG
                                  : constants.femaleG,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Bootstrap.person_fill,
                                      color: Colors.white,
                                      size: constants.screenWidth * 0.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Bootstrap.heart_fill,
                                    color: Colors.redAccent,
                                  ),
                                  radius: constants.screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            shadowColor: Colors.black,
                            elevation: 2,
                            child: Container(
                              width: constants.screenWidth * 0.95,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text(
                                          'نسبة التطابق: ${ReqSent[index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .primaryColor ==
                                                    constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                                constants.screenWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: ReqSent[index]
                                                    ['matchId'],
                                                userId: ReqSent[index]['senId'],
                                                similarityPercentage:
                                                    ReqSent[index]['similarity']
                                                        .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constants.screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ],
          ));
    }
  }
}
