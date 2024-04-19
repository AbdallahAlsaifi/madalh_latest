import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madalh/controllers/constants.dart' as constants;

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {


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
      terms = appSettingsSnap.data()!['tac'];
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
                  child: Theme
                      .of(context)
                      .primaryColor == constants.maleSwatch ? SvgPicture.asset(
                      'assets/svg/safeMen.svg') : SvgPicture.asset(
                      'assets/svg/safeWomen.svg'),),
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
