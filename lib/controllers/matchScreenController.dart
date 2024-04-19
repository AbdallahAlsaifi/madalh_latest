import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:madalh/controllers/systemController.dart';
import 'package:provider/provider.dart';
import '../view/matchScreen/matchProfile.dart';
import 'constants.dart' as constants;
import 'constants.dart';
class MatchScreenController with ChangeNotifier {
  String gender = '';
  var userData = {};
  bool isLoading = false;
  List<DocumentSnapshot> notificationsDocs = [];
  List<Widget> screens = [];
  int matches = 0;
  var matchData = {};
  List matchDocs = [];
  BuildContext? context;
  List PokeRec = [];
  List PokeSent = [];
  List ReqRec = [];
  List ReqSent = [];
  final PageController pageController =
  PageController(initialPage: 0, keepPage: true);
  int pageIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget x = Container();
  Widget x2 = Container();
  Widget screen1 = Container();
  Widget screen2 = Container();
  Widget screen3 = Container();
  MatchScreenController(){
    Start();
  }
  Start(){
    setLoading(1);
    GetGender()
        .then((value) => getMatchesData(context))
        .then((value) => updateSaw())
        .then((value) => getRequestData())
        .then((value) => PokeScreen(context))
        .then((value) => RequestScreen(gender, context))
        .catchError((error) => print('Error occurre: $error'));
    setLoading(0);

  }
  updateContext(co){
    context = co;
  }
  GetGender() async {
    var snap2 = await FirebaseFirestore.instance
        .collection('musers')
        .doc(_auth.currentUser!.uid)
        .get();

    gender = snap2.data()!['gender'];
    userData = snap2.data()!;
    notifyListeners();
  }
  getMatchesData(context) async {
    var snap = await _firestore
        .collection('musers')
        .doc(_auth.currentUser!.uid)
        .collection('matches')
        .get();
    var userSnap =
    await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();


      matchDocs = snap.docs;
      matches = userSnap.data()!['matches'] ?? 0;
      screen1 = SingleChildScrollView(
        child: Column(
          children: [
            // Center(
            //   child: constants.smallText('ليس لديك اشعارات حاليا', context,
            //       color: Colors.red),
            // ),
            matchDocs.length > 0
                ? ListView.builder(
              physics: PageScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 0),
                          width: constants.screenWidth * 0.9,
                          height: constants.screenHeight * 0.15,
                          decoration: BoxDecoration(
                            gradient: Provider.of<AppService>(context,
                                listen: false)
                                .systemGradient ==
                                constants.femaleG
                                ? constants.maleG
                                : constants.femaleG,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Bootstrap.person_fill,
                                        color: Colors.white,
                                        size:
                                        constants.screenWidth * 0.2,
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
                                    radius:
                                    constants.screenWidth * 0.06,
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
                                width: constants.screenWidth * 0.9,
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
                                        child: Text(
                                          'نسبة التطابق: ${matchDocs[index]['Similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor ==
                                                constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection:
                                          TextDirection.rtl,
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId:
                                                matchDocs[index]
                                                ['matchId'],
                                                userId: matchDocs[index]
                                                ['userId'],
                                                similarityPercentage:
                                                double.parse(matchDocs[
                                                index]
                                                ['Similarity']),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'للمزيد',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection:
                                          TextDirection.rtl,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                );
              },
              itemCount: matchDocs.length,
              shrinkWrap: true,
            )
                : Center(
                child: constants.smallText(
                    'ليس لديك تطابقات حالية', context,
                    color: Colors.redAccent))
          ],
        ),
      );
    notifyListeners();
  }
  void _sendContactInformation(BuildContext context) {
    showDialog(
      context: context,
      builder: (x) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      // rq.updateContactRelation(value!);
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
                    // rq.updatePhone(p);
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
                    // controller: rq.controller,
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
                    Provider.of<AppService>(context, listen: false).matching();
                    Navigator.of(x).pop();
                  },
                ),
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.green)),
                  child: Text("إرسال"),
                  onPressed: () {
                    Provider.of<AppService>(context, listen: false).matching();
                    Navigator.of(x).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  setLoading(x){
    if(x == 0){
      isLoading = false;
    }else{
      isLoading = true;
    }
    notifyListeners();
  }
  void _sendQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (x) {
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
                    // controller: rq.controller,
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
                    Provider.of<AppService>(context, listen: false).matching();
                    Navigator.of(x).pop();
                  },
                ),
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.green)),
                  child: Text("إرسال"),
                  onPressed: () {
                    Provider.of<AppService>(context, listen: false).matching();
                    Navigator.of(x).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  setPageIndex(x){
    pageIndex = x;
    notifyListeners();
  }
  disposePageIndex(){
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 10),
        curve: Curves.bounceIn);
    pageIndex = 0;

  }
  updateSaw() async {
    var x = await FirebaseFirestore.instance
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('matches')
        .orderBy('date', descending: true)
        .get();

      notificationsDocs = x.docs;

    for (var i in notificationsDocs) {
      if (i['saw'] != true) {
        await FirebaseFirestore.instance
            .collection('musers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('matches')
            .doc(i.id)
            .update({'saw': true});
      }
    }
    notifyListeners();
  }




   PokeScreen(context) {

     if (gender == 'm') {

       x = SingleChildScrollView(
         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           PokeRec.isNotEmpty
               ? ListView.builder(
             itemBuilder: (BuildContext context, int index) {
               return Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             top: 10, left: 10, right: 10, bottom: 0),
                         width: constants.screenWidth * 0.9,
                         height: constants.screenHeight * 0.15,
                         decoration: BoxDecoration(
                           gradient: Provider.of<AppService>(context,
                               listen: false)
                               .systemGradient ==
                               constants.femaleG
                               ? constants.maleG
                               : constants.femaleG,
                           borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(10),
                               topRight: Radius.circular(10)),
                         ),
                         child: Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceEvenly,
                           children: [
                             Expanded(
                               child: Container(
                                 padding: EdgeInsets.all(5),
                                 child: Column(
                                   mainAxisAlignment:
                                   MainAxisAlignment.center,
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
                               width: constants.screenWidth * 0.9,
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
                                       child: Text(
                                         'نسبة التطابق: ${PokeRec[index]['similarity']}%',
                                         style: TextStyle(
                                           color: Theme.of(context)
                                               .primaryColor ==
                                               constants.maleSwatch
                                               ? constants.peach1
                                               : constants.azure1,
                                           fontSize:
                                           constants.screenWidth *
                                               0.06,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         textDirection: TextDirection.rtl,
                                       ),
                                     ),
                                     FilledButton(
                                       onPressed: () {
                                         navigateTo(
                                             ReuseableMatchProfile(
                                               matchId: PokeRec[index]
                                               ['matchId'],
                                               userId: PokeRec[index]
                                               ['senId'],
                                               similarityPercentage:
                                               PokeRec[index]
                                               ['similarity']
                                                   .toDouble(),
                                             ),
                                             context);
                                       },
                                       child: Text(
                                         'تم نكزك',
                                         style: TextStyle(
                                           color: Colors.white,
                                           fontSize:
                                           constants.screenWidth *
                                               0.06,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         textDirection: TextDirection.rtl,
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ),
                           )
                         ],
                       )
                     ],
                   ),
                 ],
               );
             },
             itemCount: PokeRec.length,
             shrinkWrap: true,
           )
               : constants.smallText('لم تنكز من قبل اي احد  لحد الأن', context)
         ]),
       );

     } else {

       x = SingleChildScrollView(
         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           PokeSent.isNotEmpty == true
               ? ListView.builder(
             itemBuilder: (BuildContext context, int index) {
               return Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             top: 10, left: 10, right: 10, bottom: 0),
                         width: constants.screenWidth * 0.9,
                         height: constants.screenHeight * 0.15,
                         decoration: BoxDecoration(
                           gradient: Provider.of<AppService>(context,
                               listen: false)
                               .systemGradient ==
                               constants.femaleG
                               ? constants.maleG
                               : constants.femaleG,
                           borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(10),
                               topRight: Radius.circular(10)),
                         ),
                         child: Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceEvenly,
                           children: [
                             Expanded(
                               child: Container(
                                 padding: EdgeInsets.all(5),
                                 child: Column(
                                   mainAxisAlignment:
                                   MainAxisAlignment.center,
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
                               width: constants.screenWidth * 0.9,
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
                                       child: Text(
                                         'نسبة التطابق: ${PokeSent[index]['similarity']}%',
                                         style: TextStyle(
                                           color: Theme.of(context)
                                               .primaryColor ==
                                               constants.maleSwatch
                                               ? constants.peach1
                                               : constants.azure1,
                                           fontSize:
                                           constants.screenWidth *
                                               0.06,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         textDirection: TextDirection.rtl,
                                       ),
                                     ),
                                     FilledButton(
                                       onPressed: () {
                                         navigateTo(
                                             ReuseableMatchProfile(
                                               matchId: PokeSent[index]
                                               ['matchId'],
                                               userId: PokeSent[index]
                                               ['recID'],
                                               similarityPercentage:
                                               PokeSent[index]
                                               ['similarity'],
                                             ),
                                             context);
                                       },
                                       child: Text(
                                         'تم النكز',
                                         style: TextStyle(
                                           color: Colors.white,
                                           fontSize:
                                           constants.screenWidth *
                                               0.06,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         textDirection: TextDirection.rtl,
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ),
                           )
                         ],
                       )
                     ],
                   ),
                 ],
               );
             },
             itemCount: PokeSent.length,
             shrinkWrap: true,
           )
               : constants.smallText('لم تنكزي أحد إلى حد الأن', context,
               color: Colors.redAccent)
         ]),
       );

     }

    notifyListeners();
  }

   RequestScreen(String gender, context) {
    if (gender == 'm') {
      x2 = SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          userData['requestsSent'].length > 0
              ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Divider(),
                    Container(
                      width: constants.screenWidth * 0.9,
                      child: ExpansionTileCard(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time_outlined),
                          ],
                        ),
                        children: [
                          Text('لم يتم الرد بالمعلومات حتى الأن'),
                        ],
                      ),
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
                            gradient: Provider.of<AppService>(context,
                                listen: false)
                                .systemGradient ==
                                constants.femaleG
                                ? constants.maleG
                                : constants.femaleG,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                width: constants.screenWidth * 0.9,
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
                                        child: Text(
                                          'نسبة التطابق: ${userData['requestsSent'][index]['similarity']}%',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor ==
                                                constants.maleSwatch
                                                ? constants.peach1
                                                : constants.azure1,
                                            fontSize:
                                            constants.screenWidth *
                                                0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection:
                                          TextDirection.rtl,
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId: userData[
                                                'requestsSent']
                                                [index]['matchId'],
                                                userId: userData[
                                                'requestsSent']
                                                [index]['userId'],
                                                similarityPercentage:
                                                userData['requestsSent']
                                                [index]
                                                ['similarity']
                                                    .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'بإنتظار الرد',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            constants.screenWidth *
                                                0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection:
                                          TextDirection.rtl,
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
              );
            },
            itemCount: userData['requestsSent'].length,
            shrinkWrap: true,
          )
              : constants.smallText('لم تطلب اي معلومات  لحد الأن', context)
        ]),
      );
    } else {
      x2 = SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          userData['requestsRec'].length > 0
              ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Divider(),
                    Container(
                        width: constants.screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
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
                                  _sendQuestion(context);
                                },
                                child: Text('إرسال سؤال')),
                            FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateColor.resolveWith(
                                            (states) => Colors.green)),
                                onPressed: () {
                                  _sendContactInformation(context);
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
                            gradient: Provider.of<AppService>(context,
                                listen: false)
                                .systemGradient ==
                                constants.femaleG
                                ? constants.maleG
                                : constants.femaleG,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                            'نسبة التطابق: ${userData['requestsRec'][index]['similarity']}%',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor ==
                                                  constants.maleSwatch
                                                  ? constants.peach1
                                                  : constants.azure1,
                                              fontSize:
                                              constants.screenWidth *
                                                  0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textDirection:
                                            TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: FilledButton(
                                          onPressed: () {
                                            navigateTo(
                                                ReuseableMatchProfile(
                                                  matchId: userData[
                                                  'requestsRec']
                                                  [index]['matchId'],
                                                  userId: userData[
                                                  'requestsRec']
                                                  [index]['userId'],
                                                  similarityPercentage:
                                                  userData['requestsRec']
                                                  [index][
                                                  'similarity']
                                                      .toDouble(),
                                                ),
                                                context);
                                          },
                                          child: Text(
                                            'عرض الملف',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              constants.screenWidth *
                                                  0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textDirection:
                                            TextDirection.rtl,
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
              );
            },
            itemCount: userData['requestsRec'].length,
            shrinkWrap: true,
          )
              : constants.smallText('لم يصلك اي طلب معلومات  لحد الأن', context)
        ]),
      );
    }
    notifyListeners();
  }

animatePageController(x){
  pageController.animateToPage(x,
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceIn);
  notifyListeners();
}

  getPokeDataM() async {
    var snap = await _firestore.collection('pokes').where('recId', whereIn: [_auth.currentUser!.uid]).get();

    PokeRec = snap.docs;
    notifyListeners();
  }
  getPokeDataF() async {
    var snap = await _firestore.collection('pokes').where('senId', whereIn: [_auth.currentUser!.uid]).get();


      PokeSent = snap.docs;

    notifyListeners();

  }

  getRequestData() async {
    var snap = await _firestore.collection('requests').get();
    if (gender == 'm') {

        ReqSent = snap.docs
            .where((element) => element['senId'] == _auth.currentUser!.uid)
            .toList();

    } else if (gender == 'f') {

        ReqRec = snap.docs
            .where((element) => element['recId'] == _auth.currentUser!.uid)
            .toList();

    }
    notifyListeners();
  }
}
