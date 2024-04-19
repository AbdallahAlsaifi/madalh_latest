import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madalh/controllers/constants.dart';
import 'package:madalh/view/settings/ourMsg.dart';

class PartnerClass {
  static getPromoCode() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var snap = await _firestore
        .collection('pusers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snap['promoCode'];
  }

  static getUsers() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String promoCode = await getPromoCode();
    var snap = await _firestore
        .collection('musers')
        .where('promoCode', isEqualTo: promoCode)
        .get();
    return snap.docs;
  }

  static getActiveUsers() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String promoCode = await getPromoCode();
    var snap = await _firestore
        .collection('musers')
        .where('promoCode', isEqualTo: promoCode)
        .where('isActive', isEqualTo: true)
        .get();
    return snap.docs;
  }

  static getSubscribedUsers() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String promoCode = await getPromoCode();
    var snap = await _firestore
        .collection('musers')
        .where('promoCode', isEqualTo: promoCode)
        .where('isSubscribed', isEqualTo: true)
        .get();
    return snap.docs;
  }

  static getMatchedUsers() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List users = await getUsers();
    int counter = 0;
    if (users.isNotEmpty) {
      users.forEach((element) async {
        var snap = await _firestore
            .collection('requests')
            .where('reqId', isEqualTo: element.id).where('recResType', isEqualTo: 9)
            .get();
        if (snap.docs.length >= 1) {
          counter += 1;
        }
        var snap2 = await _firestore
            .collection('requests')
            .where('recId', isEqualTo: element.id).where('recResType', isEqualTo: 9)
            .get();
        if (snap2.docs.length >= 1) {
          counter += 1;
        }
      });
    }
    return counter;
  }
  static getDetails()async{
    var snap = await FirebaseFirestore.instance.collection('pusers').doc(FirebaseAuth.instance.currentUser!.uid).get();
    return snap;
  }

  static updateUserDoc(DocumentSnapshot doc, data, field, context)async{
    try{
      await doc.reference.update({'$field':data});
      MsgDialog(context, 'تم ارسال طلب التحديث بنجاح');
    }catch(e){
      MsgDialog(context, e.toString());
    }
  }


  static getAllData() async {
    final allUsersCounter = await getUsers();
    final allActiveCounter = await getActiveUsers();
    final allSubscribedCounter = await getSubscribedUsers();
    final userDoc = await getDetails();
    int allMatchesCounter = await getMatchedUsers();
    return {
      'allU':allUsersCounter.length.toString(),
      'allA':allActiveCounter.length.toString(),
      'allS':allSubscribedCounter.length.toString(),
      'allM':allMatchesCounter.toString(),
      'userDoc':userDoc
    };
  }
}
