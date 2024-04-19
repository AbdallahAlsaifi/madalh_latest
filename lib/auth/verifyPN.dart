import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/exportConstants.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../homePage.dart';

class verifyPhonenumber extends StatefulWidget {
  const verifyPhonenumber({Key? key}) : super(key: key);

  @override
  State<verifyPhonenumber> createState() => _verifyPhonenumberState();
}

class _verifyPhonenumberState extends State<verifyPhonenumber> {
  TextEditingController pNumber = TextEditingController();
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  bool isTimerOn = true;
  bool isLoading = true;

  static String verifyId = '';
  int resendToken1 = 0;

  String phoneN = '';
  String verifiId = '';
  PhoneNumber? phoneNumber;

  final CountdownController _controller =
      new CountdownController(autoStart: true);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      timeout: Duration(seconds: 58),
      phoneNumber: phoneNo,
      verificationCompleted: (cred) async {
        await _auth.currentUser!.linkWithCredential(cred);
      },
      verificationFailed: (e) {
        Fluttertoast.showToast(msg: 'حدث خطأ ما، يرجى المحاولة مجددا');
        print(e);
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          verifiId = verificationId;
          resendToken1 = resendToken!;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          verifiId = verificationId;
        });
      },
    );
  }

  Future<bool> linkUser(Credientials, context) async {
    try {
      await _auth.currentUser!.linkWithCredential(Credientials);
      await _firestore.collection('musers').doc(_auth.currentUser!.uid).update({
        'isActive': true,
        'pNumber': phoneNumber!.completeNumber,
        'country': phoneNumber!.countryISOCode,
      });
      navigateTo(HomePage(), context);
      return true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg:
              ' حدث خطأ ما، يرجى المحاولة مجددا ربما تم حجب رقمك مؤقتا الرجاء المحاولة خلال 59 دقيقة او التواصل مع الدعم الفني');
      Fluttertoast.showToast(msg: '$e');

      return false;
    }
  }

  verifyOtp(String Otp, context) async {
    AuthCredential Credientials =
        PhoneAuthProvider.credential(verificationId: verifiId, smsCode: Otp);
    bool x = await linkUser(Credientials, context);
  }

  Widget OTPVerify(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: constants.screenHeight * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Theme.of(context).primaryColor == constants.maleSwatch
                    ? SvgPicture.asset(
                        'assets/svg/passwordMen.svg',
                        width: constants.screenWidth * 0.25,
                        height: constants.screenWidth * 0.25,
                      )
                    : SvgPicture.asset(
                        'assets/svg/passwordWomen.svg',
                        width: constants.screenWidth * 0.25,
                        height: constants.screenWidth * 0.25,
                      ),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.all(15),
              child: constants.smallText(
                'يرجى ادخال الرمز السري',
                context,
                color: constants.azure1,
              )),
          SizedBox(
            height: constants.screenWidth * 0.15,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      autofocus: true,
                      controller: pin1,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constants.screenWidth * 0.03,
                  ),
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      controller: pin2,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constants.screenWidth * 0.03,
                  ),
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      controller: pin3,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constants.screenWidth * 0.03,
                  ),
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      controller: pin4,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constants.screenWidth * 0.03,
                  ),
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      controller: pin5,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constants.screenWidth * 0.03,
                  ),
                  Container(
                    width: constants.screenWidth * 0.2,
                    height: constants.screenWidth * 0.2,
                    child: TextFormField(
                      controller: pin6,
                      decoration: InputDecoration(hintText: "0"),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: isTimerOn
                ? Countdown(
                    controller: _controller,
                    seconds: 60,
                    build: (BuildContext context, double time) =>
                        Text('${time.toStringAsFixed(0)} s'),
                    interval: const Duration(milliseconds: 100),
                    onFinished: () {
                      _controller.pause();
                      setState(() {
                        isTimerOn = false;
                      });
                    },
                  )
                : RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Code didn't send ?",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                isTimerOn = true;
                              });
                              phoneAuthentication(phoneNumber!.completeNumber);
                            },
                          text: ' Resend',
                          style: TextStyle(color: constants.azure1)),
                    ]),
                  ),
          ),
          SizedBox(
            height: constants.screenWidth * 0.3,
          ),
          GestureDetector(
              onTap: () {
                verifyOtp(
                    pin1.text +
                        pin2.text +
                        pin3.text +
                        pin4.text +
                        pin5.text +
                        pin6.text,
                    context);
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: constants.azure1))
        ],
      ),
    );
  }

  Widget pNumberField() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: constants.screenHeight * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Theme.of(context).primaryColor == constants.maleSwatch
                    ? SvgPicture.asset(
                        'assets/svg/phoneVerifyMen.svg',
                        width: constants.screenWidth * 0.25,
                        height: constants.screenWidth * 0.25,
                      )
                    : SvgPicture.asset(
                        'assets/svg/phoneVerifyWomen.svg',
                        width: constants.screenWidth * 0.25,
                        height: constants.screenWidth * 0.25,
                      ),
              ),
            ],
          ),
          constants.smallText('تأكيد رقم الهاتف', context,
              color: Colors.redAccent),
          SizedBox(
            height: constants.screenHeight * 0.05,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                labelStyle: TextStyle(fontSize: constants.screenWidth * 0.06),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'PS',
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              invalidNumberMessage: 'الرجاء إدخال رقم صحيح',
              onChanged: (phone) {
                setState(() {
                  phoneNumber = phone;
                });
              },
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(
            height: constants.screenWidth * 0.3,
          ),
          GestureDetector(
              onTap: () async {
                bool x =
                    await checkNumber(phoneNumber!, phoneNumber!.countryCode);
                if (x == true) {
                  phoneAuthentication(phoneNumber!.completeNumber);
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.bounceIn);
                  setState(() {
                    pageIndex = 1;
                  });
                } else {
                  Fluttertoast.showToast(msg: 'الرقم مسجل بحساب آخر');
                }
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: constants.azure1))
        ],
      ),
    );
  }

  int pageIndex = 0;

  Future<bool> checkNumber(PhoneNumber ph, countryCode) async {
    String fpn = ph.number;
    print(fpn);
    String psStart = '+970';
    String ilStart = '+972';
    bool result = true;
    var users = await FirebaseFirestore.instance.collection('musers').get();
    List usersDocs = users.docs;
    if (countryCode == ilStart || countryCode == psStart) {
      String ilN = ilStart + fpn;
      String psN = psStart + fpn;
      for (var doc in usersDocs) {
        if (doc['pNumber'] == ilN || doc['pNumber'] == psN) {
          setState(() {
            result = false;
          });
        }
      }
    } else {
      for (var doc in usersDocs) {
        if (doc['pNumber'] == ph.completeNumber) {
          setState(() {
            result = false;
          });
        }
      }
    }
    return result;
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                  resizeToAvoidBottomInset: false,
                  extendBodyBehindAppBar: false,
                  appBar: AppBar(
                    leading: pageIndex == 1
                        ? BackButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.bounceIn);
                              setState(() {
                                pageIndex = 0;
                              });
                            },
                          )
                        : Container(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: SvgPicture.asset(
                      'assets/svg/AraicName.svg',
                      width: constants.screenWidth * 0.1,
                      height: constants.screenWidth * 0.1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  body: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [pNumberField(), OTPVerify(context)],
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent)),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    child: Text('الخروج'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
