import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String role;
  final String fname;
  final String lname;
  final String email;
  final String username;
  final String pNumber;
  final String gender;
  final DateTime bd;
  final regDate;
  final lastLoginDate;
  final bool blackList;
  final String country;
  final String uid;
  final matches;
  final isActive;
  final requestsRec;
  final requestsSent;
  final nackRec;
  final nackSent;
  final fmatches;
  final matchesProcess;
  final lastFreeRequest;
  final isSubscribed;
  final subscriptionDate;
  final isCompleteProfile;
  final isDisabled;
  final didCheckUpdate;
  final messages;
  final msgSent;
  final favProfiles;
  final completedCat;
  final promocode;

  const UserModel({
    required this.role,
    required this.fname,
    required this.lname,
    required this.promocode,
    required this.email,
    required this.username,
    required this.pNumber,
    required this.gender,
    required this.regDate,
    required this.lastLoginDate,
    required this.bd,
    this.blackList = false,
    required this.country,
    required this.uid,
    required this.matches,
    required this.isActive,
    required this.requestsRec,
    required this.requestsSent,
    required this.nackRec,
    required this.nackSent,
    required this.fmatches,
    required this.matchesProcess,
    required this.lastFreeRequest,
    required this.isSubscribed,
    required this.subscriptionDate,
    required this.isCompleteProfile,
    required this.isDisabled,
    required this.didCheckUpdate,
    required this.messages,
    required this.msgSent,
    required this.completedCat,
    required this.favProfiles,
  });

  Map<String, dynamic> toJson() => {
        "role": role,
        "promocode": promocode,
        "fname": fname,
        "lname": lname,
        "email": email,
        "username": username,
        "pNumber": pNumber,
        "gender": gender,
        "regDate": regDate,
        "lastLoginDate": lastLoginDate,
        "bd": bd,
        "country": country,
        "blackList": blackList,
        "uid": uid,
        "matches": matches,
        "isActive": isActive,
        "requestsRec": requestsRec,
        "requestsSent": requestsSent,
        "nackRec": nackRec,
        "nackSent": nackSent,
        "fmatches": fmatches,
        "matchesProcess": matchesProcess,
        "lastFreeRequest": lastFreeRequest,
        "isSubscribed": isSubscribed,
        "subscriptionDate": subscriptionDate,
        "isCompleteProfile": isCompleteProfile,
        "isDisabled": isDisabled,
        "didCheckUpdate": didCheckUpdate,
        "messages": messages,
        "msgSent": msgSent,
        "favProfiles": favProfiles,
        "completedCat": completedCat,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      role: snapshot['role'],
      fname: snapshot['fname'],
      lname: snapshot['lname'],
      promocode: snapshot['promocode'],
      email: snapshot['email'],
      username: snapshot['username'],
      pNumber: snapshot['pNumber'],
      gender: snapshot['gender'],
      regDate: snapshot['regDate'],
      lastLoginDate: snapshot['lastLoginDate'],
      bd: snapshot['bd'],
      blackList: snapshot['blackList'],
      country: snapshot['country'],
      uid: snapshot['uid'],
      matches: snapshot['matches'],
      isActive: snapshot['isActive'],
      completedCat: snapshot['completedCat'],
      requestsRec: snapshot['requestsRec'],
      requestsSent: snapshot['requestsSent'],
      nackRec: snapshot['nackRec'],
      nackSent: snapshot['nackSent'],
      fmatches: snapshot['fmatches'],
      matchesProcess: snapshot['matchesProcess'],
      lastFreeRequest: snapshot['lastFreeRequest'],
      isSubscribed: snapshot['isSubscribed'],
      subscriptionDate: snapshot['subscriptionDate'],
      isCompleteProfile: snapshot['isCompleteProfile'],
      isDisabled: snapshot['isDisabled'],
      didCheckUpdate: snapshot['didCheckUpdate'],
      messages: snapshot['messages'],
      msgSent: snapshot['msgSent'],
      favProfiles: snapshot['favProfiles'],
    );
  }
}
