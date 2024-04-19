import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LandingPages extends StatefulWidget {
  const LandingPages({Key? key}) : super(key: key);

  @override
  State<LandingPages> createState() => _LandingPagesState();
}

class _LandingPagesState extends State<LandingPages> {
  Widget firstScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/svg/logoWithoutBackground.svg',
                    width: constants.screenWidth * 0.25,
                    height: constants.screenWidth * 0.25,
                  ),
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/EnglishName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                    Container(
                      height: 5,
                    ),
                    SvgPicture.asset(
                      'assets/svg/AraicName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(constants.screenWidth * 0.2),
                  child: SvgPicture.asset(
                    'assets/svg/welcoming.svg',
                    width: constants.screenWidth * 0.6,
                    height: constants.screenWidth * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$msg1',
                    style: TextStyle(
                        color: constants.landingColor,
                        fontSize: constants.screenWidth * 0.05),
                    textDirection: TextDirection.rtl,
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: EdgeInsets.all(constants.screenWidth * 0.1),
                    child: FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => constants.landingColor)),
                        onPressed: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceOut);
                        },
                        child: Icon(Icons.arrow_back)))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget secondScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/svg/logoWithoutBackground.svg',
                    width: constants.screenWidth * 0.25,
                    height: constants.screenWidth * 0.25,
                  ),
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/EnglishName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                    Container(
                      height: 5,
                    ),
                    SvgPicture.asset(
                      'assets/svg/AraicName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: constants.screenWidth * 0.2, bottom: constants.screenWidth * 0.2),
                  child: SvgPicture.asset(
                    'assets/svg/welcoming2.svg',
                    width: constants.screenWidth * 0.5,
                    height: constants.screenWidth * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$msg2',
                    style: TextStyle(
                        color: constants.landingColor,
                        fontSize: constants.screenWidth * 0.05),
                    textDirection: TextDirection.rtl,
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: EdgeInsets.all(constants.screenWidth * 0.1),
                    child: FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => constants.landingColor)),
                        onPressed: () {
                          _pageController.animateToPage(2,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceOut);
                        },
                        child: Icon(Icons.arrow_back)))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget thirdScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/svg/logoWithoutBackground.svg',
                    width: constants.screenWidth * 0.25,
                    height: constants.screenWidth * 0.25,
                  ),
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/EnglishName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                    Container(
                      height: 5,
                    ),
                    SvgPicture.asset(
                      'assets/svg/AraicName.svg',
                      width: constants.screenWidth * 0.5,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: constants.screenWidth * 0.2, bottom: constants.screenWidth * 0.2),
                  child: SvgPicture.asset(
                    'assets/svg/welcoming3.svg',
                    width: constants.screenWidth * 0.6,
                    height: constants.screenWidth * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$msg3',
                    style: TextStyle(
                        color: constants.landingColor,
                        fontSize: constants.screenWidth * 0.05),
                    textDirection: TextDirection.rtl,
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: EdgeInsets.all(constants.screenWidth * 0.1),
                    child: FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => constants.landingColor)),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('isLanding', false);
                          navigateTo(
                              MyApp(
                                isLanding: false,
                              ),
                              context);
                        },
                        child: Icon(Icons.arrow_back)))
              ],
            )
          ],
        ),
      ),
    );
  }

  PageController _pageController = PageController(initialPage: 0);
  String? msg1, msg2, msg3;

  getMsgs() async {
    var snap = await constants.firestore
        .collection('AppSettings')
        .doc('appSettings')
        .get();
    setState(() {
      msg1 = snap.data()!['welcomeMsg1'];
      msg2 = snap.data()!['welcomeMsg2'];
      msg3 = snap.data()!['welcomeMsg3'];
    });
  }
  checkPrefs()async{
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    final x = prefs.getBool('isLanding');
    if(x == false){
      navigateTo(
          MyApp(
            isLanding: false,
          ),
          context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    checkPrefs();
    getMsgs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            firstScreen(),
            secondScreen(),
            thirdScreen(),
          ],
        ),
      ),
    );
  }
}
