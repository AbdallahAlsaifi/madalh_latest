import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../../homePage.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getNotificationsData();
    super.initState();
  }

  List<DocumentSnapshot> notificationsDocs = [];

  getNotificationsData() async {
    var x = await FirebaseFirestore.instance
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications').orderBy('date', descending: true)
        .get();
    setState(() {
      notificationsDocs = x.docs;
    });
    for (var i in notificationsDocs) {
      if (i['saw'] != true) {
        await FirebaseFirestore.instance
            .collection('musers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notifications').doc(i.id).update({'saw': true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: PageScrollPhysics(),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Center(
            //   child: constants.smallText('ليس لديك اشعارات حاليا', context,
            //       color: Colors.red),
            // ),
            ListView.builder(key: CouchKeys.Key4,
              physics: PageScrollPhysics(),

              itemBuilder: (BuildContext context, int index) {
                return notificationsDocs[index]['saw'] != true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dismissible(
                      onDismissed: (direction) async {
                        await constants.firestore.collection('musers').doc(
                            constants.auth.currentUser!.uid).collection(
                            'notifications').doc(notificationsDocs[index].id).delete();
                      },
                      key: Key(notificationsDocs[index].id),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: constants.screenWidth * 0.9,
                        constraints: BoxConstraints(
                            minHeight: constants.screenHeight * 0.1),

                        decoration: BoxDecoration(
                            color: constants.greyC,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Text(
                                        notificationsDocs[index]['text'],
                                        style: TextStyle(),
                                        textDirection: TextDirection.rtl,
                                      )
                                    ],
                                  ),
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          width: constants.screenWidth * 0.1,
                                          height: constants.screenWidth * 0.1,
                                        ),
                                        Icon(
                                          Bootstrap.bell_fill,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dismissible(
                      onDismissed: (direction) async {
                        await constants.firestore.collection('musers').doc(
                            constants.auth.currentUser!.uid).collection(
                            'notifications').doc(notificationsDocs[index].id).delete();
                      },
                      key: Key(notificationsDocs[index].id),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: constants.screenWidth * 0.9,

                        decoration: BoxDecoration(
                            color: constants.greyC,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Text(
                                        notificationsDocs[index]['text'],
                                        style: TextStyle(),
                                        textDirection: TextDirection.rtl,
                                      )
                                    ],
                                  ),
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          width: constants.screenWidth * 0.1,
                                          height: constants.screenWidth * 0.1,
                                        ),
                                        Icon(
                                          Bootstrap.bell_fill,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: notificationsDocs.length,
              shrinkWrap: true,)
            , constants.UserInfo(text: 'هنا ستصل الإشعارات الخاصة بك'),

          ],
        ),
      ),
    );
  }
}
