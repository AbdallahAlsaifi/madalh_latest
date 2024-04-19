import 'package:chewie/chewie.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/auth/forgetPassword/forgetPassword.dart';
import 'package:madalh/auth/registerScreens.dart';
import 'package:madalh/auth/termsAndCondition.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:madalh/homePage.dart';
import 'package:madalh/partner/partnerLogin.dart';
import 'package:madalh/services/authentication.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'forgetPassword/registerForget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEmail = false;
  final videoPlayerController =
      VideoPlayerController.asset('assets/videos/mainVideo.mp4');
  late final chewieController =  ChewieController(
    showControls: false,
    showControlsOnInitialize: false,
    allowedScreenSleep: false,
    videoPlayerController: videoPlayerController,
    autoPlay: true,
    looping: true,
    aspectRatio: constants.aspectRatio,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chewieController.dispose();
      videoPlayerController.dispose();
    });
    super.dispose();
  }
//wianxjksn
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(top: 50),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: constants.screenWidth,
                    height: constants.screenHeight,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  ),
                ),
              ),
              Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,

                  // appBar: AppBar(
                  //   toolbarHeight: constants.screenHeight*0.2,
                  //   title: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       children: [
                  //         Logo(Logos.academia_edu),
                  //         SizedBox(height: 10,),
                  //         constants.smallText('Madalh', context, color: Colors.white)
                  //       ],
                  //     ),
                  //   ),
                  //   centerTitle: true,
                  //   automaticallyImplyLeading: false,
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  // ),
                  body: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: constants.screenHeight * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25,
                            ),
                            GestureDetector(
                              onDoubleTap: (){
                                chewieController.dispose();
                                constants.navigateTo(PartnerLogin(), context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      'assets/svg/logoWithoutBackground.svg',
                                      color: Colors.white,
                                      width: constants.screenWidth * 0.25,
                                      height: constants.screenWidth * 0.25,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/EnglishName.svg',
                                        color: Colors.white,
                                        width: constants.screenWidth * 0.5,
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svg/AraicName.svg',
                                        color: Colors.white,
                                        width: constants.screenWidth * 0.5,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: constants.screenWidth * 0.85,
                                  height: constants.screenWidth * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textDirection: TextDirection.ltr,
                                    onChanged: (value) {
                                      setState(() {
                                        isEmail =
                                            EmailValidator.validate(value);
                                      });
                                    },
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'إسم المسخدم او الإيميل',
                                        hintTextDirection: TextDirection.rtl),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: constants.screenWidth * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: constants.screenWidth * 0.85,
                                  height: constants.screenWidth * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    textDirection: TextDirection.ltr,
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'كلمة السر',
                                        hintTextDirection: TextDirection.rtl),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      navigateTo(
                                          RegisterScreenForget(), context);
                                    },
                                    child: constants.smallText(
                                        'نسيت كلمة السر؟', context,
                                        color: Colors.white))
                              ],
                            ),
                            SizedBox(
                              height: constants.screenWidth * 0.10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await FirebaseCustomAuth().SignIn(
                                        isEmail
                                            ? emailController.text.trim()
                                            : "${emailController.text.trim()}@user.madalh",
                                        passwordController.text.trim());
                                    if (auth.currentUser != null) {
                                      navigateTo(HomePage(), context);
                                    }
                                  },
                                  child: constants.longButton(
                                      'تسجيل الدخول', context,
                                      textColor: constants.azure1),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      navigateTo(TermsAndConditions(), context);
                                    },
                                    child: Text(
                                      ' شروط الإستخدام و الخصوصية',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                                Container(
                                  width: 5,
                                ),
                                Text(
                                  'عند المتابعة اوافق على',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            // SizedBox(
                            //   height: constants.screenWidth * 0.01,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     constants.longButtonWithLogo(
                            //       '  تسجيل الدخول بإستخدام',
                            //       Logo(Logos.google,),
                            //
                            //       context: context
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                              height: constants.screenHeight * 0.1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    constants.smallText(
                                        'ليس لديك حساب؟', context,
                                        color: Colors.white),
                                    GestureDetector(
                                      onTap: () => constants.navigateTo(
                                          registerScreens(), context),
                                      child: constants.longButton(
                                          'تسجيل حساب جديد', context,
                                          textColor: constants.azure1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(TermsAndConditions(), context);
                    },
                    child: Icon(
                      Bootstrap.shield_check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text('الدعم الفني')),
                            content: Container(
                              width: screenWidth * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _copyToClipboard('MaDaLh.info@gmail.com');
                                    },
                                    child: Container(
                                      child: Center(child: Text('MaDaLh.info@gmail.com', style: TextStyle(color: Colors.white),), ),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      _launchUrl("https://www.instagram.com/madalh.official");
                                    },
                                    child: Container(
                                      child: Center(child: Icon(Bootstrap.instagram, color: Colors.white,)),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      _launchUrl("https://www.facebook.com/MaDaLh.Official");
                                    },
                                    child: Container(
                                      child: Center(child: Icon(Bootstrap.facebook, color: Colors.white,)),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      _launchUrl("https://www.tiktok.com/@madalh.official");
                                    },
                                    child: Container(
                                      child: Center(child: Icon(Bootstrap.tiktok, color: Colors.white,)),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      _launchUrl("https://www.threads.net/@madalh.official");
                                    },
                                    child: Container(
                                      child: Center(child: Icon(Bootstrap.at, color: Colors.white,)),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      height: 50,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Bootstrap.headphones,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ الإيميل بنجاح')),
    );
  }

  Future<void> _launchUrl(url) async {

    if (!await launchUrl(Uri.parse('$url'))) {
      throw Exception('Could not launch $url');
    }
  }
}

