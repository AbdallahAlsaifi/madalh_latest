import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/models/userModel.dart' as model;
import 'package:uuid/uuid.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../controllers/constants.dart';
import '../homePage.dart';

class FirebaseCustomAuth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpUser({
    required String promocode,
    required String fname,
    required String lname,
    required String email,
    required String password,
    required String username,
    required String pNumber,
    required String gender,
    required bd,
    required country,
    required context,
  }) async {
    bool result = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      String uid = Uuid().v1();
      String Nuid = Uuid().v1();
      _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      model.UserModel user = model.UserModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        promocode: promocode,
        fname: fname.toLowerCase().trim(),
        lname: lname.toLowerCase().trim(),
        email: email.trim(),
        completedCat: [],
        username: username,
        pNumber: pNumber,
        gender: gender,
        lastLoginDate: DateTime.now(),
        regDate: DateTime.now(),
        role: 'user',
        bd: bd,
        country: country,
        matches: 0,
        isActive: false,
        requestsRec: [],
        requestsSent: [],
        nackRec: [],
        nackSent: [],
        fmatches: 3,
        matchesProcess: {},
        lastFreeRequest: DateTime.now(),
        subscriptionDate: null,
        isSubscribed: false,
        isCompleteProfile: false,
        isDisabled: false,
        didCheckUpdate: true,
        messages: 3,
        msgSent: [],
        favProfiles: [],
      );

      await _firestore
          .collection('musers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
            user.toJson(),
          );

      await _firestore
          .collection('musers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notifications')
          .doc(Nuid)
          .set({
        'text':
            'مرحبا بك في مدله، الأفضل في إيجاد شريك حياتك بما يتناسب مع خياراتك. الرجاء ملئ ملفك كي نستطيع أن نبحث لك بأفضل الخوارزميات عن شريكك',
        'saw': false,
        'isDataShared': false,
        'date': DateTime.now(),
      });

      await _firestore.collection('answers').doc(auth.currentUser!.uid).set(
        {
          'uid': auth.currentUser!.uid,
        },
      );

      result = true;
      navigateTo(const HomePage(), context);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: e.toString().split(']')[1]);
      result = false;
    }

    return result;
  }

// phoneSignIn(String phoneNumber) async {
//   await _auth.verifyPhoneNumber(phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential cred) {
//
//
//       },
//       verificationFailed: (e){},
//       codeSent: ((String verificationId, int? resendToken) async{
//
//   },
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
// }

  Future<void> SignIn(emailOrUsername, password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailOrUsername, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: constants.getMessageFromErrorCode(e));
    }
  }

  Future<void> SignOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

///TODO:answers issue