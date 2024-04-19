import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madalh/controllers/constants.dart' as constants;

class OurMsg extends StatefulWidget {
  const OurMsg({Key? key}) : super(key: key);

  @override
  State<OurMsg> createState() => _OurMsgState();
}

class _OurMsgState extends State<OurMsg> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTerms();
  }

  String terms = '';

  getTerms() async {
    var appSettingsSnap = await FirebaseFirestore.instance.collection(
        'AppSettings').doc('appSettings').get();
    setState(() {
      terms = appSettingsSnap.data()!['ourMsg'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: constants.screenWidth * 0.8,
                  height: constants.screenHeight * 0.4,
                  child: SvgPicture.asset(
                      'assets/svg/ourMsg.svg'),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(terms, textDirection: TextDirection.rtl,),
            )
          ],
        ),
      ),
    );
  }
}
