import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/controllers/systemController.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../main.dart';
import '../../homePage.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {



  int resendToken1 = 0;


  TextEditingController pNumber = TextEditingController();
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();


  final CountdownController _controller =
  CountdownController(autoStart: true);

  late PageController pageViewController = PageController(initialPage: 0);


  bool isLoading = false;
  bool isTimerOn = true;
  bool isPasswordOk = false;

  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  List otp = [];
  PhoneNumber? phoneNumber;
  GlobalKey<FormState> _formKey = GlobalKey();
  static String verifyId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget OTPVerify() {
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
                child: Theme.of(context).primaryColor == constants.maleSwatch ? SvgPicture.asset(
                  'assets/svg/passwordMen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,) : SvgPicture.asset(
                  'assets/svg/passwordWomen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,),
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
                            ..onTap = () async {
                              setState(() {
                                isTimerOn = true;
                              });
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                timeout: const Duration(seconds: 60),
                                phoneNumber: phoneNumber!.completeNumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {
                                  Fluttertoast.showToast(
                                      msg: e.message.toString());
                                },
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  setState(() {
                                    verifyId = verificationId;
                                    resendToken1 = resendToken!;
                                  });


                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
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
              onTap: () async {
                // print();
                setState(() {
                  isLoading = true;
                });
                try {
                  PhoneAuthCredential cred = PhoneAuthProvider.credential(
                      verificationId: verifyId,
                      smsCode: pin1.text +
                          pin2.text +
                          pin3.text +
                          pin4.text +
                          pin5.text +
                          pin6.text);
                  await FirebaseAuth.instance.signInWithCredential(cred);
                  pageViewController.animateToPage(2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutQuart);
                  setState(() {
                    isLoading = false;
                  });

                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString().split(']')[1]);

                  setState(() {
                    isLoading = false;
                  });
                }
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
                child: Theme.of(context).primaryColor == constants.maleSwatch ? SvgPicture.asset(
                  'assets/svg/phoneVerifyMen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,) : SvgPicture.asset(
                  'assets/svg/phoneVerifyWomen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,),
              ),
            ],
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
                //TODO: Send OTP


                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      timeout: const Duration(seconds: 120),
                      phoneNumber: phoneNumber!.completeNumber,
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {
                        Fluttertoast.showToast(msg: e.message.toString());
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        setState(() {
                          verifyId = verificationId;
                          resendToken1 = resendToken!;
                        });

                        pageViewController.animateToPage(1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutQuart);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'الرجاء التأكد من رقم الهاتف');

                    setState(() {
                      isLoading = false;
                    });
                  }

              },
              child: constants.longButton('المتابعة', context,
                  buttonColor:  phoneNumber != null ? Theme.of(context).primaryColor : Colors.grey))
        ],
      ),
    );
  }
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('إستعادة كلمة السر'),),
        body: PageView(
          controller: pageViewController,
          physics: const NeverScrollableScrollPhysics(),
          children: [pNumberField(),OTPVerify()],
        ),
      ),
    );
  }
}
