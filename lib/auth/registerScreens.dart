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
import 'package:madalh/auth/loginScreen.dart';
import 'package:madalh/auth/termsAndCondition.dart';
import 'package:madalh/auth/verifyPN.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/controllers/systemController.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../homePage.dart';

class registerScreens extends StatefulWidget {
  const registerScreens({Key? key}) : super(key: key);

  @override
  State<registerScreens> createState() => _registerScreensState();
}

class _registerScreensState extends State<registerScreens> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController usernameOrEmail = TextEditingController();
  TextEditingController bd = TextEditingController();
  TextEditingController pNumber = TextEditingController();
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();

  late PageController pageViewController = PageController(initialPage: 0);

  int resendToken1 = 0;

  DateTime birthDay = DateTime.now();
  bool isEmail = false;

  int endTime = DateTime
      .now()
      .millisecondsSinceEpoch + 1000 * 30;

  bool isTimerOn = true;

  bool isEmailOrUserNameOk = false;
  bool isPasswordOk = false;
  bool isNameOk = false;
  bool isBirthDayOk = false;
  bool isMobileNumberOk = false;

  final inActiveColor = Colors.grey.shade300;
  bool isLoading = false;

  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  bool trySignUp = false;

  int pageIndex = 0;
  List otp = [];
  // PhoneNumber? phoneNumber;
  GlobalKey<FormState> _formKey = GlobalKey();
  static String verifyId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  String gender = '';
  bool isFemale = false;
  bool isMale = false;

  @override
  void initState() {
    super.initState();


  }


  List<Widget> screens = [];

  CodeSent(String verificationId, int? forceResendingToken) async {
    setState(() {
      verifyId = verificationId;
      resendToken1 = forceResendingToken!;
    });
  }


  final CountdownController _controller =
  new CountdownController(autoStart: true);

  // Future<void> phoneSignIn() async {
  //   await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber!.completeNumber,
  //       codeSent: CodeSent,
  //       timeout: const Duration(seconds: 30),
  //       forceResendingToken: resendToken1,
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
  //       verificationFailed: (FirebaseAuthException error) {},
  //       codeAutoRetrievalTimeout: (String verificationId) {});
  // }

  Widget selectGender() {
    return Consumer<AppService>(builder: (context, AppServiceData, __) {
      return SingleChildScrollView(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.start,
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
                    'assets/svg/choiceMen.svg',
                    width: constants
                        .screenWidth * 0.25,
                    height: constants
                        .screenWidth * 0.25,) : SvgPicture.asset(
                    'assets/svg/choiceWomen.svg',
                    width: constants
                        .screenWidth * 0.25,
                    height: constants
                        .screenWidth * 0.25,),
                ),
              ],
            ),

            Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    constants.bigText('الجنس', context,
                        color: isFemale ? constants.peach1 : constants.azure1),
                    constants.bigText(' إختار', context,
                        color: isFemale ? constants.peach1 : constants.azure1),
                  ],
                )),
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
                        gender = 'm';
                      });
                      AppServiceData.changeSystemThemeToMale();
                    },
                    child: Container(
                      child: Center(
                          child: constants.smallText('ذكر', context,
                              color: Colors.white)),
                      width: constants.screenWidth * 0.32,
                      height: constants.screenWidth * 0.15,
                      decoration: BoxDecoration(
                          color: isMale ? constants.azure1 : constants.greyC,
                          borderRadius: BorderRadius.circular(45)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMale = false;
                        isFemale = true;
                        gender = 'f';
                      });
                      AppServiceData.changeSystemThemeToFemale();
                    },
                    child: Container(
                      child: Center(
                          child: constants.smallText('أنثى', context,
                              color: Colors.white)),
                      width: constants.screenWidth * 0.32,
                      height: constants.screenWidth * 0.15,
                      decoration: BoxDecoration(
                          color: isFemale ? constants.peach1 : constants.greyC,
                          borderRadius: BorderRadius.circular(45)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constants.screenHeight * 0.1,
            ),
            GestureDetector(
                onTap: () {
                  if (isFemale == true || isMale == true) {
                    pageViewController.animateToPage(
                        pageIndex + 1, duration: Duration(milliseconds: 150),
                        curve: Curves.bounceIn);
                    setState(() {
                      pageIndex += 1;
                    });
                  }
                },
                child: constants.longButton('المتابعة', context,
                    buttonColor: (isFemale == true || isMale == true)
                        ? constants.azure1
                        : inActiveColor)),
            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              GestureDetector(onTap: (){navigateTo(TermsAndConditions(), context);},child: Text(' شروط الإستخدام و الخصوصية', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),)),
              Container(width: 5,),
              Text('عند المتابعة اوافق على')
            ],)
          ],
        ),
      );
    });
  }



  Widget passwordForm() {
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
                child: Theme.of(context).primaryColor == constants.azure1 ? SvgPicture.asset(
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
          constants.CustomTextField(password, 'كلمة السر', context,
              textDirection: TextDirection.ltr, hintTextDirection: TextDirection.ltr),
          SizedBox(
            height: 15,
          ),
          constants.CustomTextField(
              passwordConfirmation, 'تاكيد كلمة السر', context,
              onChanged: (vlaue) {
                if ((vlaue == password.text) && (password.text.length >= 7)) {
                  setState(() {
                    isPasswordOk = true;
                  });
                } else {
                  setState(() {
                    isPasswordOk = false;
                  });
                }
              }, borderColor: isPasswordOk ? constants.azure1 : Colors.red,
          textDirection: TextDirection.ltr, hintTextDirection: TextDirection.ltr),
          SizedBox(
            height: 10,
          ),
          constants.smallText('تتكون من 7 احرف فما فوق', context,
              color: isPasswordOk ? Colors.green : Colors.redAccent),
          SizedBox(
            height: constants.screenWidth * 0.3,
          ),
          GestureDetector(
              onTap: () {
                if (isPasswordOk == true) {
                  pageViewController.animateToPage(
                      pageIndex + 1, duration: Duration(milliseconds: 150),
                      curve: Curves.bounceIn);
                  setState(() {
                    pageIndex += 1;
                  });
                }
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: isPasswordOk ? constants.azure1 : inActiveColor))
        ],
      ),
    );
  }

  Widget birthDayChooser(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: constants.screenWidth * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Theme.of(context).primaryColor == constants.maleSwatch ? SvgPicture.asset(
                  'assets/svg/datePickMen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,) : SvgPicture.asset(
                  'assets/svg/datePickWomen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,),
              ),
            ],
          ),
          constants.smallText('يرجى اختيار تاريخ ميلادك', context,
              color: constants.azure1),
          SizedBox(
            height: constants.screenWidth * 0.05,
          ),
          CalendarDatePicker(
              initialDate: DateTime(DateTime
                  .now()
                  .year - 72),
              firstDate: DateTime(DateTime
                  .now()
                  .year - 72),
              lastDate: DateTime(DateTime
                  .now()
                  .year - 15),
              onDateChanged: (v) {
                setState(() {
                  birthDay = v;
                  isBirthDayOk = true;
                });
              }),
          SizedBox(
            height: constants.screenWidth * 0.05,
          ),
          constants.smallText(
              'عمرك الان ${DateTime
                  .now()
                  .year - birthDay.year}', context,
              color: constants.azure1),
          GestureDetector(
              onTap: () async {
                if (isBirthDayOk==true) {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    bool tryToSignUp = await FirebaseCustomAuth().signUpUser(
                        fname: fname.text.trim().toLowerCase(),
                        lname: lname.text.trim().toLowerCase(),
                        context: context,
                        email: isEmail == true
                            ? usernameOrEmail.text.trim().toLowerCase()
                            : '${usernameOrEmail.text.trim()
                            .toLowerCase()}@user.madalh'
                            .toLowerCase(),
                        password: password.text.trim(),
                        username: isEmail == true
                            ? usernameOrEmail.text.trim().toLowerCase().split('@')[0]
                            : usernameOrEmail.text.trim().toLowerCase(),
                        pNumber: ' ',
                        gender: gender.toLowerCase(),
                        bd: birthDay,
                        country: ' ');

                    setState(() {
                      isLoading = false;
                    });

                  } on FirebaseAuthException catch (e) {
                    print(e);
                    Fluttertoast.showToast(msg: e.toString());

                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: isBirthDayOk ? constants.azure1 : inActiveColor))
        ],
      ),
    );
  }



  bool isValidEmailOrUsername(String input) {
    // Regular expression pattern to validate email addresses
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    // Regular expression pattern to validate usernames without spaces or unknown characters
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

    // Check if the input matches the email or username pattern
    if (emailRegex.hasMatch(input) || usernameRegex.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }
  Widget emailOrUsername() {
    return SingleChildScrollView(
      child: Consumer<AppService>(
        builder: (context, data, _) {
          return Column(
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
                      'assets/svg/fieldMen.svg',
                      width: constants
                          .screenWidth * 0.25,
                      height: constants
                          .screenWidth * 0.25,) : SvgPicture.asset(
                      'assets/svg/fieldWomen.svg',
                      width: constants
                          .screenWidth * 0.25,
                      height: constants
                          .screenWidth * 0.25,),
                  ),
                ],
              ),
              constants.smallText('الإيميل او اسم مستخدم', context, color: Colors.redAccent),
              constants.CustomTextField(
                usernameOrEmail,
                'الإيميل او اسم مستخدم',
                context,
                obsecure: false,
                  textDirection: TextDirection.ltr, hintTextDirection: TextDirection.ltr
              ),

              SizedBox(
                height: constants.screenWidth * 0.3,
              ),
              GestureDetector(
                  onTap: () async{
                    bool x = await data.checkUserName(usernameOrEmail.text);
                    if (x == true) {
                      bool xx = isValidEmailOrUsername(usernameOrEmail.text);
                      if(xx == true){
                        setState(() {
                          isEmail = EmailValidator.validate(usernameOrEmail.text);
                        });
                        pageViewController.animateToPage(
                            pageIndex + 1, duration: Duration(milliseconds: 150),
                            curve: Curves.bounceIn);
                        setState(() {
                          pageIndex += 1;
                        });
                      }else{
                        Fluttertoast.showToast(msg: 'لا يمكنك إستخدام اسم المستخدم او الايمل');
                      }
                    }else{
                      Fluttertoast.showToast(msg: 'لا يمكنك إستخدام اسم المستخدم او الايمل');
                    }
                  },
                  child: constants.longButton('المتابعة', context,
                      buttonColor:
                      Theme.of(context).primaryColor))
            ],
          );
        }
      ),
    );
  }

  Widget FandLName() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Theme.of(context).primaryColor == constants.maleSwatch ? SvgPicture.asset(
                  'assets/svg/fieldMen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,) : SvgPicture.asset(
                  'assets/svg/fieldWomen.svg',
                  width: constants
                      .screenWidth * 0.25,
                  height: constants
                      .screenWidth * 0.25,),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            constants.smallText('إختياري', context, color: Colors.redAccent),
          ],),
          constants.CustomTextField(
              fname,
              'الإسم الأول',
              obsecure: false,
              context, onChanged: (fnamevalue) {
            if (fname.text.isNotEmpty && lname.text.isNotEmpty) {
              setState(() {
                isNameOk = true;
              });
            } else {
              setState(() {
                isNameOk = false;
              });
            }
          }),
          SizedBox(
            height: 10,
          ),
          constants.CustomTextField(
              lname,
              'الإسم الأخير',
              obsecure: false,
              context, onChanged: (lnamevalue) {
            if (fname.text.isNotEmpty && lname.text.isNotEmpty) {
              setState(() {
                isNameOk = true;
              });
            } else {
              setState(() {
                isNameOk = false;
              });
            }
          }),
          SizedBox(
            height: constants.screenWidth * 0.3,
          ),
          GestureDetector(
              onTap: () {
                pageViewController.animateToPage(
                    pageIndex + 1, duration: Duration(milliseconds: 150),
                    curve: Curves.bounceIn);
                setState(() {
                  pageIndex += 1;
                });
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: Theme.of(context).primaryColor))
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LoadingOverlay(
          isLoading: isLoading,
          color: Colors.white,
          progressIndicator: LoadingAnimationWidget.flickr(
              leftDotColor: constants.peach1,
              rightDotColor: constants.azure1,
              size: constants.screenWidth * 0.2),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(

              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: BackButton(
                  onPressed: () {

                    if (pageIndex == 0) {
                      navigateTo(LoginScreen(), context);
                    } else {
                      pageViewController.animateToPage(
                          pageIndex - 1, duration: Duration(milliseconds: 150),
                          curve: Curves.bounceIn);
                      setState(() {
                        pageIndex -= 1;
                      });
                    }
                  },
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: SvgPicture.asset(
                  'assets/svg/AraicName.svg',
                  width: constants
                      .screenWidth * 0.1,
                  height: constants
                      .screenWidth * 0.1,color: Theme.of(context).primaryColor,),
                centerTitle: true,
              ),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageViewController,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                children: [selectGender(),
                  emailOrUsername(),
                  passwordForm(),
                  FandLName(),
                  birthDayChooser(context),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
