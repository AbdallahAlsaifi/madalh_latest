import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/view/matchScreen/matchCard.dart';
import 'package:provider/provider.dart';

import '../../controllers/constants.dart';
import '../../controllers/systemController.dart';
import 'matchProfile.dart';
import 'package:madalh/controllers/constants.dart' as constants;
class mainMatch extends StatefulWidget {
  final matchDoc;
  const mainMatch({Key? key, required this.matchDoc}) : super(key: key);

  @override
  State<mainMatch> createState() => _mainMatchState();
}

class _mainMatchState extends State<mainMatch> {


  List matchDocs = [];
  @override
  void initState() {
    // TODO: implement initState
    setMatches();
    super.initState();
  }

  setMatches(){
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        matchDocs = widget.matchDoc;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                return matchCard(matchDocIndex: matchDocs[index]);
              },
              itemCount: matchDocs.length,
              shrinkWrap: true,
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                    child: constants.smallText(
                        'ليس لديك تطابقات حالية', context,
                        color: Colors.redAccent)),
                    Center(child: UserInfo(text: 'هنا تجد التطابقات بينك و بين المستخدمين من الجنس الآخر'))
                  ],
                )
          ],
        ),
      ),
    );
  }
}
