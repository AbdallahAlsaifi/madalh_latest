import 'package:chewie/chewie.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/auth/loginScreen.dart';
import 'package:madalh/exportConstants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../auth/forgetPassword/registerForget.dart';
import '../auth/registerScreens.dart';
import '../auth/termsAndCondition.dart';
import '../controllers/constants.dart';
import '../controllers/systemController.dart';
import '../homePage.dart';
import '../services/authentication.dart';

class PartnerLogin extends StatefulWidget {
  const PartnerLogin({super.key});

  @override
  State<PartnerLogin> createState() => _PartnerLoginState();
}

class _PartnerLoginState extends State<PartnerLogin> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(top: 50),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Consumer<AppService>(builder: (_, as, __) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('الشركاء'),
                centerTitle: true,
                actions: [],
                leading: BackButton(
                  onPressed: () {
                    navigateToRep(LoginScreen(), context);
                  },
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                    ),
                    GestureDetector(
                      onDoubleTap: () {
                        constants.navigateTo(PartnerLogin(), context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                              'assets/svg/logoWithoutBackground.svg',
                              width: constants.screenWidth * 0.25,
                              height: constants.screenWidth * 0.25,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/EnglishName.svg',
                                color: Theme.of(context).primaryColor,
                                width: constants.screenWidth * 0.5,
                              ),
                              Container(
                                height: 5,
                              ),
                              SvgPicture.asset(
                                'assets/svg/AraicName.svg',
                                width: constants.screenWidth * 0.5,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                isEmail = EmailValidator.validate(value);
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
                          onTap: () async {
                            await FirebaseCustomAuth().SignIn(
                                isEmail
                                    ? emailController.text.trim()
                                    : "${emailController.text.trim()}@partner.com",
                                passwordController.text.trim());
                            if (auth.currentUser != null) {
                              navigateTo(HomePage(), context);
                            }
                          },
                          child: constants.longButton('تسجيل الدخول', context,
                              textColor: Colors.white,
                              buttonColor: as.primaryColor),
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
                                  color: Colors.black),
                            )),
                        Container(
                          width: 5,
                        ),
                        Text(
                          'عند المتابعة اوافق على',
                          style: TextStyle(color: Colors.black),
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
                  ],
                ),
              ));
        }),
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
