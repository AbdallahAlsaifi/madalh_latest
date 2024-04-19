import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../controllers/constants.dart';
import '../../controllers/systemController.dart';
import 'matchProfile.dart';

class matchCard extends StatefulWidget {
  final matchDocIndex;

  const matchCard({Key? key, required this.matchDocIndex}) : super(key: key);

  @override
  State<matchCard> createState() => _matchCardState();
}

class _matchCardState extends State<matchCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
              width: constants.screenWidth * 0.9,
              height: constants.screenHeight * 0.15,
              decoration: BoxDecoration(
                gradient: Provider
                    .of<AppService>(context, listen: false)
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
                  StreamBuilder(
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      List fav = snapshot.data['favProfiles'] ?? [];
                      return GestureDetector(
                        onTap: () async {
                          List x = [widget.matchDocIndex['userId']];
                          if(fav.contains(widget.matchDocIndex['userId']) == true){
                            await FirebaseFirestore.instance.collection('musers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'favProfiles': FieldValue.arrayRemove(x)});
                          }else{
                            await FirebaseFirestore.instance.collection('musers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'favProfiles': FieldValue.arrayUnion(x)});
                          }

                        },
                        child: AvatarGlow(
                          glowColor: Colors.white,
                          endRadius: 60.0,
                          child: Material(
                            // Replace this child with your own
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                fav.contains(widget.matchDocIndex['userId']) == true ? Bootstrap.heart_fill : Bootstrap.heart,
                                color:  Colors.redAccent ,
                              ),
                              radius: constants.screenWidth * 0.06,
                            ),
                          ),
                        ),
                      );
                    },
                    stream: FirebaseFirestore.instance
                        .collection('musers')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                  )
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'نسبة التطابق: ${widget
                                  .matchDocIndex['Similarity']}%',
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor ==
                                    constants.maleSwatch
                                    ? constants.peach1
                                    : constants.azure1,
                                fontSize: constants.screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              navigateTo(
                                  ReuseableMatchProfile(
                                    matchId: widget.matchDocIndex['matchId'],
                                    userId: widget.matchDocIndex['userId'],
                                    similarityPercentage: double.parse(
                                        widget.matchDocIndex['Similarity']),
                                  ),
                                  context);
                            },
                            child: Text(
                              'للمزيد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: constants.screenWidth * 0.06,
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
  }
}
