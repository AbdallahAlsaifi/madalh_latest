import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/auth/loginScreen.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

class InitialView extends StatefulWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  final controller = PageController(initialPage: 0);
  bool isLoading = false;

  bool isPage1Done = false;
  bool isPage2Done = false;

  bool isEnglish = false;
  bool isArabic = false;

  bool isFemale = false;
  bool isMale = false;

  late final prefs;

  instantiatePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setPrefs(bool isLoading) async {
    bool success = false;
    try {
      setState(() {
        isLoading = true;
      });

      if (isArabic == true) {
        await prefs.setString(constants.prefsLanguage, 'arabic');
        await prefs.setBool('isFirstTime', false);
      } else if (isEnglish == true) {
        await prefs.setString(constants.prefsLanguage, 'english');
        await prefs.setBool('isFirstTime', false);
      }

      if (isMale == true) {
        await prefs.setString(constants.prefsGender, 'male');
        await prefs.setBool('isFirstTime', false);
      } else if (isFemale == true) {
        await prefs.setString(constants.prefsGender, 'female');
        await prefs.setBool('isFirstTime', false);
      }
      setState(() {
        success = true;
      });
    } catch (e) {
      setState(() {
        success = false;
      });
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error Please Try Again');
    }
    return success;
  }

  Widget tempLang(x, y) {
    Widget xx = constants.smallText(' ', context, color: Colors.white);
    if (x == true && y == false) {
      setState(() {
        xx = constants.smallText('المتابعة', color: Colors.white, context,);
      });
    } else if (x == false && y == true) {
      setState(() {
        xx = constants.smallText('Continue', context,color: Colors.white);
      });
    }
    return xx;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    instantiatePrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        progressIndicator: LoadingAnimationWidget.flickr(
            leftDotColor: constants.peach1, rightDotColor: constants.azure1,
            size: constants.screenWidth*0.1),
        isLoading: isLoading,
        child: Scaffold(
          body: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'اللغة',
                            style: TextStyle(
                                color: constants.azure1,
                                fontSize: constants.screenWidth * 0.11),
                          ),
                          Text(
                            ' إختار ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: constants.screenWidth * 0.11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Choose  ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: constants.screenWidth * 0.09),
                          ),
                          Text(
                            'Language',
                            style: TextStyle(
                                color: constants.azure1,
                                fontSize: constants.screenWidth * 0.09),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: constants.screenHeight * 0.16,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEnglish = true;
                                isArabic = false;
                                isPage1Done = true;
                              });
                            },
                            child: Container(
                              child:
                              Center(child: constants.smallText('English',context,color: Colors.white)),
                              width: constants.screenWidth * 0.32,
                              height: constants.screenWidth * 0.15,
                              decoration: BoxDecoration(
                                  color: isEnglish
                                      ? constants.azure1
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(45)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEnglish = false;
                                isArabic = true;
                                isPage1Done = true;
                              });
                            },
                            child: Container(
                              child:
                              Center(child: constants.smallText('العربية',context,color: Colors.white)),
                              width: constants.screenWidth * 0.32,
                              height: constants.screenWidth * 0.15,
                              decoration: BoxDecoration(
                                  color: isArabic
                                      ? constants.azure1
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(45)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: constants.screenHeight * 0.1,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isPage1Done == true) {
                                controller.animateToPage(1,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn);
                              }
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: constants.screenWidth * 0.4,
                                    height: constants.screenWidth * 0.13,
                                    decoration: BoxDecoration(
                                        gradient: isPage1Done
                                            ? constants.green
                                            : constants.greyG,
                                        borderRadius: BorderRadius.circular(
                                            45)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [tempLang(isArabic, isEnglish)],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () =>
                                controller.animateToPage(0,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn),
                            child: Icon(
                              Icons.arrow_circle_up,
                              color: Colors.black,
                              size: constants.screenWidth * 0.1,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: constants.screenHeight * 0.2,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: isArabic ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          constants.bigText('الجنس',context, color: Colors.black),
                          constants.bigText(' إختار',context, color: Colors.black),
                        ],
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          constants.bigText('Gender',context, color: Colors.black),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: constants.screenHeight * 0.05,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = true;
                                isFemale = false;
                                isPage2Done = true;
                              });
                            },
                            child: Container(
                              child: Center(child: isArabic
                                  ? constants.smallText('ذكر', context,color: Colors.white)
                                  : constants.smallText('Male', context,color: Colors.white)),
                              width: constants.screenWidth * 0.32,
                              height: constants.screenWidth * 0.15,
                              decoration: BoxDecoration(
                                  gradient: isMale ? constants.maleG : constants
                                      .greyG,
                                  borderRadius: BorderRadius.circular(45)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = false;
                                isFemale = true;
                                isPage2Done = true;
                              });
                            },
                            child: Container(
                              child: Center(child: isArabic
                                  ? constants.smallText('أنثى', context, color: Colors.white)
                                  : constants.smallText('Female', color: Colors.white,context,)),
                              width: constants.screenWidth * 0.32,
                              height: constants.screenWidth * 0.15,
                              decoration: BoxDecoration(
                                  gradient: isFemale
                                      ? constants.femaleG
                                      : constants.greyG,
                                  borderRadius: BorderRadius.circular(45)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: constants.screenHeight * 0.1,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (isPage2Done == true) {
                                bool x = await setPrefs(isLoading);
                                if (x == true) {
                                  constants.navigateTo(LoginScreen(), context);
                                }
                              }
                            },
                            child: Container(
                              width: constants.screenWidth * 0.4,
                              height: constants.screenWidth * 0.13,
                              decoration: BoxDecoration(

                                  gradient: isPage2Done
                                      ? constants.green
                                      : constants.greyG,
                                  borderRadius: BorderRadius.circular(45)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [tempLang(isArabic, isEnglish)],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
