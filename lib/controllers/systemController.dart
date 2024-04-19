import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppService with ChangeNotifier {
  AppService() {
    getUserData();
  }

  MaterialColor _systemThemeColor_male = constants.maleSwatch;
  MaterialColor _systemThemeColor_female = constants.femaleSwatch;
  MaterialColor systemThemeColor = constants.maleSwatch;
  Color primaryColor = Colors.grey;

  // MaterialColor get systemThemeColor => _systemThemeColor;
  LinearGradient systemGradient = constants.femaleG;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userData = {};

  bool male = true;
  bool isEmailOrUserNameOk = false;

  checkUserName(userNameOrEmail) async {
    var snap = await _firestore.collection('musers').get();
    List userDocLists = snap.docs;
    bool isEmail = EmailValidator.validate(userNameOrEmail);
    bool okOrNot = true;
    if (isEmail == false) {
      for (var i in userDocLists) {
        if (i['username'] == userNameOrEmail) {
          okOrNot = false;
        }
      }
    } else {
      for (var i in userDocLists) {
        if (i['email'] == userNameOrEmail) {
          okOrNot = false;
        }
      }
    }

    return okOrNot;
  }

  getUserData() async {
    var snap = await FirebaseFirestore.instance
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = snap.data()!;

    if (userData['gender'] == 'm') {
      systemThemeColor = _systemThemeColor_male;
      systemGradient = constants.maleG;
      male = true;
      primaryColor = constants.azure1;
    } else {
      systemThemeColor = _systemThemeColor_female;
      systemGradient = constants.femaleG;
      male = false;
      primaryColor = constants.peach1;
    }
    notifyListeners();
  }

  void changeSystemThemeToFemale() {
    systemThemeColor = _systemThemeColor_female;
    notifyListeners();
  }

  void DecideSystemColor(String gender) {
    if (gender == 'm') {
      changeSystemThemeToMale();
    } else {
      changeSystemThemeToFemale();
    }
  }

  void changeSystemThemeToMale() {
    systemThemeColor = _systemThemeColor_male;
    notifyListeners();
  }

  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  getSystemColor() async {
    await getUserData();
  }

  Widget c = Container();

  textIntel(TextEditingController controller, bool emailCheck, bool emailVerify,
      BuildContext context) {
    if (controller.text.length <= 3) {
      c = constants.smallText('يرجى إستخدام 4 احرف فما فوق', context,
          color: Colors.redAccent);
      isEmailOrUserNameOk = false;
    } else if (emailCheck == true) {
      c = constants.smallText('لقد اخترت الإيميل', context,
          color: constants.azure1);
      isEmailOrUserNameOk = true;
    } else if (validCharacters.hasMatch(controller.text.trim()) == false &&
        emailCheck != true) {
      c = constants.smallText(
          'عليك استخدام الاحرف الانجليزية و الارقام فقط', context,
          color: Colors.redAccent);
      isEmailOrUserNameOk = false;
    } else {
      c = constants.smallText('لقد اخترت اسم مستخدم', context,
          color: constants.azure1);
      isEmailOrUserNameOk = true;
    }
    notifyListeners();
  }

  getTotalSimilarities(List x) {
    double xx = 0.0;
    for (double i in x) {
      xx += i;
    }
    xx = xx / x.length;
    return xx;
  }

  matching() async {
    final batch = _firestore.batch();
    print('### Started ###');
    var categorySnap =
        await _firestore.collection('questions').doc('qCat').get();
    List qcat = categorySnap.data()!['qcat'];
    List pqcat = categorySnap.data()!['pqcat'];
    int qcatlength = qcat.length;
    int pqcatlength = pqcat.length;
    double qcatPercentage = 100 / qcatlength;
    double pqcatPercentage = 100 / pqcatlength;
    int batchCount = 0;
    var answersDocumentsSnap = await _firestore.collection('answers').get();
    List<QueryDocumentSnapshot> answersDocs = answersDocumentsSnap.docs;
    List Matches = [];

    for (var userDoc in answersDocs) {
      /// user 1 loop
      ///
      var snap = await _firestore
          .collection('musers')
          .doc(userDoc.id)
          .collection('matches')
          .get();
      List userMatchesSnapDocs = snap.docs.length == 0 ? [] : snap.docs;
      List userMatchesIds =
          userMatchesSnapDocs.map((doc) => doc['userId']).toList();

      try {
        if (userDoc['isCompleteProfile'] == true) {
          print('### userDoc ${userDoc.id} ###');

          List<QueryDocumentSnapshot> aboutHim = [];
          List<QueryDocumentSnapshot> aboutHisPartner = [];
          var userAnswerssnap =
              await userDoc.reference.collection('answers').get();
          List<QueryDocumentSnapshot> useranswersDocs1 = userAnswerssnap.docs;
          for (var doc in useranswersDocs1) {
            if (qcat.contains(doc.get('cat'))) {
              aboutHim.add(doc);
            } else {
              aboutHisPartner.add(doc);
            }
          }

          for (var userDoc1 in answersDocs) {
            /// user 2 loop
            if (userDoc1.id != userDoc.id) {
              if (userMatchesIds.contains(userDoc1.id) == false) {
                if (userDoc1['isCompleteProfile'] == true) {
                  print('### userDoc ${userDoc1.id} ###');
                  var snap1 = await _firestore
                      .collection('musers')
                      .doc(userDoc.id)
                      .collection('matches')
                      .get();
                  List userMatchesSnapDocs1 = snap1.docs;
                  List userMatchesIds1 =
                      userMatchesSnapDocs1.map((doc) => doc['userId']).toList();
                  List<QueryDocumentSnapshot> aboutHim1 = [];
                  List<QueryDocumentSnapshot> aboutHisPartner1 = [];
                  var userAnswerssnap =
                      await userDoc1.reference.collection('answers').get();
                  List<QueryDocumentSnapshot> useranswersDocs1 =
                      userAnswerssnap.docs;
                  for (var doc in useranswersDocs1) {
                    if (qcat.contains(doc.get('cat'))) {
                      aboutHim1.add(doc);
                    } else {
                      aboutHisPartner1.add(doc);
                    }
                  }
                  double totalSimilarityforUser2 = 0.0;
                  List totalSimilarityforUser2list = [];

                  ///
                  double totalSimilarityforFirstUser = 0.0;
                  List totalSimilarityforFirstUserlist = [];

                  for (var category in pqcat) {
                    double percentage = 0.0;
                    int totalCategoryDocs = 0;
                    for (var himdoc in aboutHisPartner1) {
                      if (himdoc.get('cat').toString().trim() == category) {
                        totalCategoryDocs += 1;
                        for (var partnerdoc in aboutHim) {
                          if (partnerdoc.get('question') ==
                              himdoc.get('question')) {
                            if (partnerdoc.get('type') == 0 ||
                                partnerdoc.get('type') == 1) {
                              print(
                                  'Partner Answer double : ${partnerdoc.get('answer')}    Him Answer double : ${himdoc.get('answer')}');
                              if (himdoc.get('answer')[0] >=
                                      partnerdoc.get('answer')[0] &&
                                  himdoc.get('answer')[0] <=
                                      partnerdoc.get('answer')[1]) {
                                percentage += 1;
                              }
                            } else if (partnerdoc.get('type') == 2 ||
                                partnerdoc.get('type') == 5 ||
                                partnerdoc.get('type') == 6 ||
                                partnerdoc.get('type') == 7) {
                              List partnerAnswers = partnerdoc.get('answer');
                              List himAnswers = himdoc.get('answer');
                              bool isMatched = false;
                              if (partnerAnswers.contains(null)) {
                                partnerAnswers.remove(null);
                              }
                              if (himAnswers.contains(null)) {
                                himAnswers.remove(null);
                              }
                              for (var partnerAnswer in partnerAnswers) {
                                for (var himAnswer in himAnswers) {
                                  if (partnerAnswer != null &&
                                      himAnswer != null) {
                                    if (partnerAnswer.trim() ==
                                        himAnswer.trim()) {
                                      print(
                                          'Partner Answer: $partnerAnswer    Him Answer: $himAnswer');
                                      isMatched = true;
                                    }
                                  }
                                }
                              }
                              if (isMatched == true) {
                                percentage += 1;
                              }
                              print(isMatched);
                            }
                          }
                        }
                      }
                    }

                    totalSimilarityforUser2list.add(
                        (percentage.toDouble() / totalCategoryDocs.toDouble()) *
                            100.00);
                  }
                  for (var category in pqcat) {
                    double percentage = 0.0;
                    int totalCategoryDocs = 0;
                    for (var himdoc in aboutHisPartner) {
                      if (himdoc.get('cat').toString().trim() == category) {
                        totalCategoryDocs += 1;
                        for (var partnerdoc in aboutHim1) {
                          if (partnerdoc.get('question') ==
                              himdoc.get('question')) {
                            if (partnerdoc.get('type') == 0 ||
                                partnerdoc.get('type') == 1) {
                              print(
                                  'Partner Answer double : ${partnerdoc.get('answer')}    Him Answer double : ${himdoc.get('answer')}');
                              if (himdoc.get('answer')[0] >=
                                      partnerdoc.get('answer')[0] &&
                                  himdoc.get('answer')[0] <=
                                      partnerdoc.get('answer')[1]) {
                                percentage += 1;
                              }
                            } else if (partnerdoc.get('type') == 2 ||
                                partnerdoc.get('type') == 5 ||
                                partnerdoc.get('type') == 6 ||
                                partnerdoc.get('type') == 7) {
                              List partnerAnswers = partnerdoc.get('answer');
                              List himAnswers = himdoc.get('answer');
                              bool isMatched = false;
                              if (partnerAnswers.contains(null)) {
                                partnerAnswers.remove(null);
                              }
                              if (himAnswers.contains(null)) {
                                himAnswers.remove(null);
                              }
                              for (var partnerAnswer in partnerAnswers) {
                                for (var himAnswer in himAnswers) {
                                  if (himAnswer != null &&
                                      partnerAnswer != null) {
                                    if (partnerAnswer.trim() ==
                                        himAnswer.trim()) {
                                      print(
                                          'Partner Answer: $partnerAnswer    Him Answer: $himAnswer');
                                      isMatched = true;
                                    }
                                  }
                                }
                              }
                              if (isMatched == true) {
                                percentage += 1;
                              }
                              print(isMatched);
                            }
                          }
                        }
                      }
                    }

                    totalSimilarityforFirstUserlist.add(
                        (percentage.toDouble() / totalCategoryDocs.toDouble()) *
                            100.00);
                  }

                  totalSimilarityforUser2 =
                      getTotalSimilarities(totalSimilarityforUser2list);
                  totalSimilarityforFirstUser =
                      getTotalSimilarities(totalSimilarityforFirstUserlist);
                  print(totalSimilarityforUser2);
                  print(totalSimilarityforFirstUser);
                  final uid1 = Uuid().v1();
                  final uid2 = Uuid().v1();
                  var lastSnap3 = await _firestore
                      .collection('musers')
                      .doc(userDoc1.id)
                      .collection('matches')
                      .get();
                  List lastSnap2Docs3 = lastSnap3.docs;
                  List x3 = lastSnap2Docs3.map((doc) => doc['userId']).toList();
                  if (x3.contains(userDoc.id) == false) {
                    batch.set(
                        _firestore
                            .collection('musers')
                            .doc(userDoc1.id)
                            .collection('matches')
                            .doc(uid1),
                        {
                          'Similarity':
                              totalSimilarityforUser2.toStringAsFixed(2),
                          'date': DateTime.now(),
                          'matchId': uid1,
                          'saw': false,
                          'userId': userDoc.id,
                        });
                    batchCount += 1;
                  }
                  var lastSnap2 = await _firestore
                      .collection('musers')
                      .doc(userDoc.id)
                      .collection('matches')
                      .get();
                  List lastSnap2Docs = lastSnap2.docs;
                  List x = lastSnap2Docs.map((doc) => doc['userId']).toList();
                  if (x.contains(userDoc1.id) == false) {
                    batch.set(
                        _firestore
                            .collection('musers')
                            .doc(userDoc.id)
                            .collection('matches')
                            .doc(uid2),
                        {
                          'Similarity':
                              totalSimilarityforFirstUser.toStringAsFixed(2),
                          'date': DateTime.now(),
                          'matchId': uid2,
                          'saw': false,
                          'userId': userDoc1.id,
                        });
                    batchCount += 1;
                  }
                  if (batchCount >= 2) {
                    await batch.commit();
                  }
                }
              }
            }

            ///end of user 1 loop
          }
          print('completed User');
        }
        print('true');
      } catch (e) {
        print('passed User: $e');
      }

      ///end of user 1 loop
    }
  }

  // matchingUpdatedAlgo() async {
  //   final batch = _firestore.batch();
  //   print('### Started ###');
  //   var categorySnap =
  //   await _firestore.collection('questions').doc('qCat').get();
  //   List qcat = categorySnap.data()!['qcat'];
  //   List pqcat = categorySnap.data()!['pqcat'];
  //   var questions =
  //   await _firestore.collection('questions').get();
  //   var answersDocumentsSnap = await _firestore.collection('answers').get();
  //
  //   List<QueryDocumentSnapshot> answersDocs = answersDocumentsSnap.docs;
  //
  //   for (var userDoc in answersDocs) {
  //     /// user 1 loop
  //
  //     var snap = await _firestore
  //         .collection('musers')
  //         .doc(userDoc.id)
  //         .collection('matches')
  //         .get();
  //
  //     List userMatchesSnapDocs = snap.docs.length == 0 ? [] : snap.docs;
  //     List userMatchesIds =
  //     userMatchesSnapDocs.map((doc) => doc['userId']).toList();
  //
  //     try{
  //       DocumentSnapshot<Map<String, dynamic>> x24 = await _firestore.collection('answers').doc(userDoc.id).get();
  //       if(x24.data()!.containsKey('isCompleteProfile')){
  //         if (userDoc['isCompleteProfile'] == true) {
  //           print('### userDoc ${userDoc.id} ###');
  //
  //           List<QueryDocumentSnapshot> aboutHim = [];
  //           List<QueryDocumentSnapshot> aboutHisPartner = [];
  //           var userAnswerssnap =
  //           await userDoc.reference.collection('answers').get();
  //           List<QueryDocumentSnapshot> useranswersDocs = userAnswerssnap.docs;
  //           for (var doc in useranswersDocs) {
  //             if (qcat.contains(doc.get('cat'))) {
  //               aboutHim.add(doc);
  //             } else {
  //               aboutHisPartner.add(doc);
  //             }
  //           }
  //
  //           for (var userDoc1 in answersDocs) {
  //             /// user 2 loop
  //             print('1');
  //             if (userDoc1.id != userDoc.id) {
  //               if (userMatchesIds.contains(userDoc1.id) == false) {
  //               DocumentSnapshot<Map<String, dynamic>> x23 = await _firestore.collection('answers').doc(userDoc1.id).get();
  //               if(x23.data()!.containsKey('isCompleteProfile')){
  //                 if (userDoc1['isCompleteProfile'] == true) {
  //
  //                   var ssss1 = await _firestore.collection('musers').doc(userDoc1.id).get();
  //                   String userGender = ssss.data()!['gender'];
  //                   String userGender1 = ssss1.data()!['gender'];
  //                   if(userGender != userGender1){
  //                     print('### userDoc ${userDoc1.id} ###');
  //
  //                     List<QueryDocumentSnapshot> aboutHim1 = [];
  //                     List<QueryDocumentSnapshot> aboutHisPartner1 = [];
  //                     print('2');
  //
  //
  //                     var userAnswerssnap1 = await userDoc.reference.collection('answers').get();
  //                     List<QueryDocumentSnapshot> useranswersDocs1 = userAnswerssnap1.docs;
  //                     for (var doc in useranswersDocs1) {
  //                       if (qcat.contains(doc.get('cat'))) {
  //                         aboutHim1.add(doc);
  //                       } else {
  //                         aboutHisPartner1.add(doc);
  //                       }
  //                     }
  //                     print('3');
  //                     ///
  //                     ///                ///
  //                     /// Starting of ALGO ///
  //                     ///               ///
  //                     ///
  //
  //                     List xTemp = [0,1];
  //                     for(int nonNeeded in xTemp) {
  //                       if(nonNeeded == 0){
  //                         List aboutHimQuestions = [];
  //                         for (var e in questions.docs) {
  //                           final x = e.data()!['category'];
  //
  //                           if(x.toString().contains('شري') == true){
  //                             aboutHimQuestions.add(e);
  //                           }
  //                         }
  //                         int similarAnswers = 0;
  //                         for (var element in aboutHimQuestions) {
  //                           if(element['link'] != ''){
  //                             var SameQuestion;
  //                             var loopGuyQuestion;
  //                             for (var ele in aboutHisPartner) {
  //                               if(ele.id == element.id){
  //                                 SameQuestion = ele;
  //                               }
  //                             }
  //                             print('3.5');
  //                             print(element['link']);
  //                             for (var ele in aboutHim1) {
  //                               if(ele.id == element['link']){
  //                                 loopGuyQuestion = ele;
  //                               }
  //                             }
  //                             if(SameQuestion != null && loopGuyQuestion != null){
  //                               bool hasCommon = false;
  //
  //                               try{
  //                                 // hasCommon = hasCommonElements(SameQuestion!['answer'], loopGuyQuestion!['answer']);
  //                                 if(SameQuestion['answer'] is List && loopGuyQuestion['answer'] is List){
  //                                   for (var elementA in SameQuestion['answer']) {
  //                                     if (loopGuyQuestion['answer'].contains(elementA)) {
  //                                       hasCommon = true; // Found a common element
  //                                     }
  //                                   }
  //                                 }
  //
  //                               }catch(e){
  //                                 print(e);
  //                                 hasCommon = false;
  //                               }
  //                               if(hasCommon == true){
  //                                 similarAnswers += 1;
  //                               }
  //                             }
  //
  //                           }
  //                           print('4');
  //
  //                         }
  //                         final uid1 = Uuid().v1();
  //                         await _firestore
  //                             .collection('musers')
  //                             .doc(userDoc.id)
  //                             .collection('matches')
  //                             .doc(uid1).set({
  //                           'Similarity':
  //                           ((similarAnswers / aboutHimQuestions.length) * 100 ).toStringAsFixed(2),
  //                           'date': DateTime.now(),
  //                           'matchId': uid1,
  //                           'saw': false,
  //                           'userId': userDoc1.id,
  //                         });
  //                       }
  //                       else{
  //                         List aboutHimQuestions = [];
  //                         for (var e in questions.docs) {
  //                           final x = e.data()!['category'];
  //
  //                           if(x.toString().contains('شري') == true){
  //                             aboutHimQuestions.add(e);
  //                             print(x);
  //                           }
  //                         }
  //                         int similarAnswers = 0;
  //                         for (var element in aboutHimQuestions) {
  //                           if(element['link'] != ''){
  //                             var SameQuestion;
  //                             var loopGuyQuestion;
  //
  //                             for (var ele in aboutHisPartner1) {
  //                               if(ele.id == element.id){
  //                                 SameQuestion = ele;
  //                               }
  //                             }
  //                             for (var ele in aboutHim) {
  //                               if(ele.id == element['link']){
  //                                 loopGuyQuestion = ele;
  //                               }
  //                             }
  //                             if(SameQuestion != null && loopGuyQuestion != null){
  //                               bool hasCommon = false;
  //                               try{
  //                                 // hasCommon = hasCommonElements(SameQuestion!['answer'], loopGuyQuestion!['answer']);
  //                                 if(SameQuestion['answer'] is List && loopGuyQuestion['answer'] is List){
  //                                   for (var elementA in SameQuestion['answer']) {
  //                                     if (loopGuyQuestion['answer'].contains(elementA)) {
  //                                       hasCommon = true; // Found a common element
  //                                     }
  //                                   }
  //                                 }
  //                               }catch(e){
  //                                 hasCommon = false;
  //                                 print(e);
  //                               }
  //                               if(hasCommon == true){
  //                                 similarAnswers += 1;
  //                               }
  //                             }
  //
  //                           }
  //                           print('5');
  //
  //
  //                         }
  //                         final uid1 = Uuid().v1();
  //                         await _firestore
  //                             .collection('musers')
  //                             .doc(userDoc1.id)
  //                             .collection('matches')
  //                             .doc(uid1).set({
  //                           'Similarity':
  //                           ((similarAnswers / aboutHimQuestions.length) * 100 ).toStringAsFixed(2),
  //                           'date': DateTime.now(),
  //                           'matchId': uid1,
  //                           'saw': false,
  //                           'userId': userDoc.id,
  //                         });
  //                       }
  //                     }
  //
  //                   }
  //
  //
  //                   }
  //                 }
  //               }
  //
  //             }
  //
  //             ///end of user 1 loop
  //           }
  //           print('completed User');
  //         }
  //       }
  //
  //       print('true');
  //     }on FirebaseException catch(e){
  //       print('passed User: $e');
  //       print(e.stackTrace.toString());
  //     }
  //
  //     ///end of user 1 loop
  //   }
  // }

  newAndLastAlgo() async {
    DocumentSnapshot<Map<String, dynamic>> currentUserFileSnap =
        await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();

    Map<String, dynamic>? currentUserFileData = currentUserFileSnap.data();

    QuerySnapshot<Map<String, dynamic>> allAnswers =
        await _firestore.collection('answers').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allAnswersDocs =
        allAnswers.docs;

    QuerySnapshot<Map<String, dynamic>> allUsers =
        await _firestore.collection('musers').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allUsersDocs =
        allUsers.docs;

    QueryDocumentSnapshot<Map<String, dynamic>>? currentUserAnswersDoc;

    for (var element in allAnswersDocs) {
      if (element.id == currentUserFileData!['uid']) {
        var x = await element.reference.collection('answers').get();
      }
    }

    List IdsToRemoveFromAnswers = [];
    if (currentUserFileData!['gender'] == 'm') {
      for (var element in allUsersDocs) {
        if (element.data()['gender'] == 'm') {
          IdsToRemoveFromAnswers.add(element.id);
        }
      }
    } else {
      for (var element in allUsersDocs) {
        if (element.data()['gender'] == 'f') {
          IdsToRemoveFromAnswers.add(element.id);
        }
      }
    }
    List<QueryDocumentSnapshot<Map<String, dynamic>>> currentUserAnswers = [];
    var currenUserAnswersSnap = await _firestore
        .collection('answers')
        .doc(_auth.currentUser!.uid)
        .collection('answers')
        .get();
    currentUserAnswers = currenUserAnswersSnap.docs;

    QuerySnapshot<Map<String, dynamic>>? currentUserMatchesSnap =
        await _firestore
            .collection('musers')
            .doc(_auth.currentUser!.uid)
            .collection('matches')
            .get();
    if (currentUserMatchesSnap != null) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>>
          currentUserMatchesDocuments = currentUserMatchesSnap.docs;
      for (var element in currentUserMatchesDocuments) {
        IdsToRemoveFromAnswers.add(element['userId']);
      }
    }

    allAnswersDocs
        .removeWhere((element) => IdsToRemoveFromAnswers.contains(element.id));
    allAnswersDocs
        .removeWhere((element) => element.id == currentUserFileData['uid']);

    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        currentUserAnswersAboutHimSelf = [];
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        currentUserAnswersAboutHisPartner = [];

    /// Complete the algo from here
    for (var answerDoc in currentUserAnswers) {
      if (answerDoc['cat'].toString().contains('شريك')) {
        currentUserAnswersAboutHisPartner.add(answerDoc);
      } else {
        currentUserAnswersAboutHimSelf.add(answerDoc);
      }
    }

    var allQuestionsSnap = await _firestore.collection('questions').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allQuestionsDocuments =
        allQuestionsSnap.docs;
    allQuestionsDocuments.removeWhere((element) =>
        element.data()['category'].toString().contains('شريك') == false);

    for (var doc in allAnswersDocs) {
      var secondUserAnswersSnap =
          await doc.reference.collection('answers').get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> secondUserAnswers =
          secondUserAnswersSnap.docs;

      List<QueryDocumentSnapshot<Map<String, dynamic>>>
          secondUserAnswersAboutHimSelf = [];
      List<QueryDocumentSnapshot<Map<String, dynamic>>>
          secondUserAnswersAboutHisPartner = [];

      for (var answerDoc in secondUserAnswers) {
        if (answerDoc['cat'].toString().contains('ريك') == true) {
          secondUserAnswersAboutHisPartner.add(answerDoc);
        } else {
          secondUserAnswersAboutHimSelf.add(answerDoc);
        }
      }
      double matchPercentageForCurrentUser = 0.0;
      double matchPercentageForSecondUser = 0.0;
      int dividedAmount = 0;
      int type1match = 0;
      int type2match = 0;

      /// start to match current user with user no x in loop
      for (var answer in currentUserAnswersAboutHisPartner) {
        if (answer.data()!['type'] != 4) {
          QueryDocumentSnapshot<Map<String, dynamic>> similarQuestion =
              allQuestionsDocuments
                  .firstWhere((element) => element.id == answer.id);

          QueryDocumentSnapshot<Map<String, dynamic>>? toMatchAnswer;
          try {
            toMatchAnswer = secondUserAnswersAboutHimSelf.firstWhere(
                (element) => element.id == similarQuestion.data()!['link']);
          } catch (e) {
            toMatchAnswer = null;
          }
          print(toMatchAnswer);

          bool isMatched = false;
          if (answer.data()!['answer'] is List == true &&
              toMatchAnswer?.data()!['answer'] is List == true) {
            isMatched = hasCommonElements(
                answer.data()!['answer'], toMatchAnswer?.data()!['answer']);
          }

          if (isMatched == true) {
            type1match += 1;
          }
        }
      }

      for (var answer in secondUserAnswersAboutHisPartner) {
        if (answer.data()!['type'] != 4) {
          QueryDocumentSnapshot<Map<String, dynamic>> similarQuestion =
              allQuestionsDocuments
                  .firstWhere((element) => element.id == answer.id);

          QueryDocumentSnapshot<Map<String, dynamic>>? toMatchAnswer;
          try {
            toMatchAnswer = currentUserAnswersAboutHimSelf.firstWhere(
                (element) => element.id == similarQuestion.data()!['link']);
          } catch (e) {
            toMatchAnswer = null;
          }
          bool isMatched = false;
          if (answer.data()!['answer'] is List == true &&
              toMatchAnswer?.data()!['answer'] is List == true) {
            isMatched = hasCommonElements(
                answer.data()!['answer'], toMatchAnswer?.data()!['answer']);
          }

          if (isMatched == true) {
            type2match += 1;
          }
        }
      }
      final uid1 = Uuid().v1();
      final uid2 = Uuid().v1();
      int divideCount = 0;
      allQuestionsDocuments.forEach((element) {
        if (element.data()!.containsKey('link')) {
          if(element.data()!['link'].length > 5){
            divideCount += 1;
          }

        }
      });
      await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .collection('matches')
          .doc(uid1)
          .set({
        'Similarity': ((type1match / divideCount) * 100).toStringAsFixed(2),
        'date': DateTime.now(),
        'matchId': uid1,
        'saw': false,
        'userId': doc.id,
      });
      var snapForMatches = await FirebaseFirestore.instance
          .collection('musers')
          .doc(doc.id)
          .collection('matches')
          .get();
      bool isMatchedAlready = false;
      snapForMatches.docs.forEach((element) {
        if (element.id == _auth.currentUser!.uid) {
          isMatchedAlready = true;
        }
      });
      if (isMatchedAlready == true) {
        await _firestore
            .collection('musers')
            .doc(doc.id)
            .collection('matches')
            .doc(uid1)
            .set({
          'Similarity': ((type2match / divideCount) * 100).toStringAsFixed(2),
          'date': DateTime.now(),
          'matchId': uid2,
          'saw': false,
          'userId': _auth.currentUser!.uid,
        });
      }
    }
  }

  bool hasCommonElements(List listA, List listB) {
    for (var elementA in listA) {
      if (listB.contains(elementA)) {
        return true; // Found a common element
      }
    }
    return false; // No common elements found
  }

  matching3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int matchingCount = await prefs.getInt('matching') ?? 1;
    prefs.setInt('matching', matchingCount += 1);

    if (matchingCount % 2 == 0) {
      await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .update({'isCompleteProfile': true});
      var questionsCategorySnap =
          await _firestore.collection('questions').doc('qCat').get();
      List qcat = questionsCategorySnap.data()!['qcat'];
      List pqcat = questionsCategorySnap.data()!['pqcat'];

      var currentUserData = await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .get();
      String gender = currentUserData.data()!['gender'];
      QuerySnapshot allUsersSnapshot = gender == 'f'
          ? await _firestore
              .collection("musers")
              .where('gender', isEqualTo: 'm')
              .get()
          : await _firestore
              .collection("musers")
              .where('gender', isEqualTo: 'f')
              .get();
      List<DocumentSnapshot> allUsersDocuments = allUsersSnapshot.docs;

      QuerySnapshot allQSnapshot = await _firestore
          .collection("questions")
          .where('order', isEqualTo: 1)
          .get();
      List<DocumentSnapshot> allQDocuments = allQSnapshot.docs;

      List qcatQuestion = [];
      List pqcatQuestion = [];

      for (var question in allQDocuments) {
        if (qcat.contains(question['category']) && question['type'] != 4) {
          qcatQuestion.add(question.id);
        } else if (pqcat.contains(question['category']) &&
            question['type'] != 4) {
          pqcatQuestion.add(question.id);
        }
      }

      QuerySnapshot allUserAnswersSnapshot = await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .collection("answers")
          .get();
      List<DocumentSnapshot> allUserAnswersDocuments =
          allUserAnswersSnapshot.docs;

      List<DocumentSnapshot> qcatAnswers = [];
      List<DocumentSnapshot> pqcatAnswers = [];

      for (var answer in allUserAnswersDocuments) {
        if (qcatQuestion.contains(answer.id)) {
          qcatAnswers.add(answer);
        } else {
          pqcatAnswers.add(answer);
        }
      }

      Map<String, dynamic> similarities = {};
      allUsersDocuments.forEach((userDoc) async {
        if (userDoc['uid'] != _auth.currentUser!.uid) {
          var notCurrentUserSnap =
              await userDoc.reference.collection('answers').get();
          List<DocumentSnapshot> notCurrentUserDocuments =
              notCurrentUserSnap.docs;

          List<DocumentSnapshot> _qcatAnswers = [];
          List<DocumentSnapshot> _pqcatAnswers = [];
          for (var answer in notCurrentUserDocuments) {
            if (qcatQuestion.contains(answer.id)) {
              _qcatAnswers.add(answer);
            } else {
              _pqcatAnswers.add(answer);
            }
          }

          List<DocumentSnapshot> list1 = _qcatAnswers;
          List<DocumentSnapshot> list2 = pqcatAnswers;

// Assume the lists are already populated with the data

          Set<String> set1 = Set<String>();
          Set<String> set2 = Set<String>();

          for (var snapshot in list1) {
            String answer = snapshot["answer"].toString();
            if (answer != null) {
              set1.add(answer);
            }
          }

          for (var snapshot in list2) {
            String answer = snapshot["answer"].toString();
            if (answer != null) {
              set2.add(answer);
            }
          }

          Set<String> intersection = set1.intersection(set2);
          Set<String> union = set1.union(set2);

          double similarity = intersection.length / union.length;

          String uid = Uuid().v1();
          similarities[uid] = similarity;
          String matchId = Uuid().v1();
          String UserId = userDoc.id;
          // var x = await _firestore.collection("musers").doc(_auth.currentUser!.uid).collection('matches').get();
          // List xx = x.docs;

          QuerySnapshot querySnapshot = await _firestore
              .collection("musers")
              .doc(_auth.currentUser!.uid)
              .collection('matches')
              .where('userId', isEqualTo: UserId)
              .get();
          QuerySnapshot otherQuerySnapshot = await _firestore
              .collection("musers")
              .doc(userDoc.id)
              .collection('matches')
              .where('userId', isEqualTo: _auth.currentUser!.uid)
              .get();

          if (querySnapshot.docs.isEmpty) {
            await _firestore
                .collection("musers")
                .doc(_auth.currentUser!.uid)
                .collection('matches')
                .doc(matchId)
                .set({
              "matchId": matchId,
              "userId": userDoc.id,
              "Similarity": (similarity * 100).toStringAsFixed(2),
              "date": DateTime.now(),
              "saw": false,
            });
          }
          if (otherQuerySnapshot.docs.isEmpty) {
            await _firestore
                .collection("musers")
                .doc(userDoc.id)
                .collection('matches')
                .doc(matchId)
                .set({
              "matchId": matchId,
              "userId": _auth.currentUser!.uid,
              "Similarity": (similarity * 100).toStringAsFixed(2),
              "date": DateTime.now(),
              "saw": false,
            });
          }
        }
      });
    }
  }

  List<List<String>> createListsForCategories(List<String> categoryList) {
    // Use the map method to transform each category into a new list
    List<List<String>> categoryLists =
        categoryList.map((category) => <String>[]).toList();

    return categoryLists;
  }

  matching2() async {
    print('### Started ###');
    var categorySnap =
        await _firestore.collection('questions').doc('qCat').get();
    List qcat = categorySnap.data()!['qcat'];
    List pqcat = categorySnap.data()!['pqcat'];
    int qcatlength = qcat.length;
    int pqcatlength = pqcat.length;

    var answersDocumentsSnap = await _firestore.collection('answers').get();
    List<QueryDocumentSnapshot> answersDocs = answersDocumentsSnap.docs;

    print('### phase 1 ###');
    try {
      for (var userDoc in answersDocs) {
        print('### userDoc ${userDoc.id} ###');
        Map pcatanswers = {};
        Map pqcatanswers = {};
        var userAnswerssnap =
            await userDoc.reference.collection('answers').get();
        List<QueryDocumentSnapshot> answersDocs = userAnswerssnap.docs;
        for (var cat in qcat) {
          pcatanswers[cat] = [];
          for (var answerDoc in answersDocs) {
            if (answerDoc['cat'] == cat) {
              pcatanswers[cat] = pcatanswers[cat].add(answerDoc);
            }
          }
        }
        for (var cat in pqcat) {
          pqcatanswers[cat] = [];
          for (var answerDoc in answersDocs) {
            if (answerDoc['cat'] == cat) {
              pqcatanswers[cat] = pqcatanswers[cat].add(answerDoc);
            }
          }
        }
        print('### Lists | Start ###');
        print(pqcatanswers);
        print(pcatanswers);
        print('### Lists | Finished ###');
      }
    } catch (e) {
      print('Error in Phases: $e');
    }
  }

  MaterialColor materialColor = Colors.red;

  customTheme({String gender = 'f'}) {
    if (gender == 'm') {
      materialColor = constants.maleSwatch;
      notifyListeners();
    } else {
      materialColor = constants.femaleSwatch;
      notifyListeners();
    }
  }
}
