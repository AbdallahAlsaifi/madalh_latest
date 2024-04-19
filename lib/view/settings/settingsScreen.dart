import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:madalh/controllers/constants.dart' as constants;

import 'package:share_plus/share_plus.dart' as share;


import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../auth/loginScreen.dart';
import '../../auth/termsAndCondition.dart';
import '../../controllers/constants.dart';
import '../../controllers/homePageController.dart';
import '../../homePage.dart';
import '../../services/authentication.dart';
import '../paymentScreen/femalePaymentScreen.dart';
import '../paymentScreen/paymentScreen.dart';
import '../supportScreen/supportScreen.dart';
import 'ourMsg.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserEmailOrPassword();
    getShareData();
  }

  late String emailOrUsername;
  late bool isEmail;

  var shareData = {};

  // var UserData = {};

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _controller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  String gender = '';

  getShareData() async {
    var snap = await FirebaseFirestore.instance
        .collection('share')
        .doc('shareData')
        .get();
    var snap2 = await FirebaseFirestore.instance
        .collection('musers')
        .doc(_auth.currentUser!.uid)
        .get();

    setState(() {
      shareData = snap.data()!;
      gender = snap2.data()!['gender'];
    });
  }

  checkUserEmailOrPassword() async {
    String x = _auth.currentUser!.email!.split('@')[1];
    String username = _auth.currentUser!.email!.split('@')[0];
    String xx = x.split('.')[0];
    if (xx == 'user') {
      setState(() {
        isEmail = false;
        emailOrUsername = username;
      });
    } else {
      setState(() {
        isEmail = true;
        emailOrUsername = _auth.currentUser!.email!;
      });
    }
  }



  void _showWhy3Dialog(BuildContext context, dialog1option, dialog2option) {
    showDialog(
      context: context,
      builder: (x) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'هل أنت متأكد من تعطيل حسابك؟',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red)),
                    onPressed: () {
                      Navigator.of(x).pop();
                    },
                    child: Text('لا')),
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    onPressed: () async {
                      final uid = Uuid().v1();
                      await _firestore
                          .collection('disabledAccounts')
                          .doc(uid)
                          .set({
                        'dialog1': dialog1option,
                        'dialog2': dialog2option,
                        'date': DateTime.now()
                      });
                      await _firestore
                          .collection('musers')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'isDisabledAccount': true,
                      });
                      await FirebaseCustomAuth().SignOut().then((value) =>
                          constants.navigateTo(const LoginScreen(), context));
                      Fluttertoast.showToast(
                          msg:
                              'تم تعطيل حسابك بنجاح ولكن دائما مرحب بك للعودة على نفس الحساب');
                      Navigator.of(x).pop();
                    },
                    child: Text('نعم'))
              ],
            )
          ],
        );
      },
    );
  }

  void _showWhy2Dialog(BuildContext context, int dialogOneOption) {
    showDialog(
      context: context,
      builder: (x) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'هل وجدت شريكك المناسب؟',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red)),
                    onPressed: () {
                      Navigator.of(x).pop();
                      _showWhy3Dialog(context, dialogOneOption, 0);
                    },
                    child: Text('لا')),
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    onPressed: () {
                      Navigator.of(x).pop();
                      _showWhy3Dialog(context, dialogOneOption, 1);
                    },
                    child: Text('نعم'))
              ],
            )
          ],
        );
      },
    );
  }

  void _showWhyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (x) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'هل أنت سعيد بالتجربة؟',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red)),
                    onPressed: () {
                      Navigator.of(x).pop();
                      _showWhy2Dialog(context, 0);
                    },
                    child: Text('لا')),
                FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    onPressed: () {
                      Navigator.of(x).pop();
                      _showWhy2Dialog(context, 1);
                    },
                    child: Text('نعم'))
              ],
            )
          ],
        );
      },
    );
  }

  shareFunction() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      share.Share.share(
        "${shareData['subject']} \n\n ${shareData['androidLink']}",
        subject: shareData['title'],
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      share.Share.share(
        "${shareData['subject']} \n\n ${shareData['iosLink']}",
        subject: shareData['title'],
      );
    }
  }

  Future<bool> _changeUsernameFunction(String x) async {
    String appEmail = '$x@user.madalh';
    bool result = false;
    try {
      await _auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: _auth.currentUser!.email!,
              password: _passwordController.text.trim()));
      await _auth.currentUser!.updateEmail(appEmail);
      await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .update({"username": x, "email": appEmail});
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  Future<bool> _changeEmailFunction(String x) async {
    bool result = false;
    try {
      await _auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: _auth.currentUser!.email!,
              password: _passwordController.text.trim()));
      await _auth.currentUser!.updateEmail(x);
      await _firestore
          .collection('musers')
          .doc(_auth.currentUser!.uid)
          .update({"username": x.split('@')[0], "email": x});
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  Future<bool> _changePasswordFunction() async {
    bool result = false;
    try {
      await _auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: _auth.currentUser!.email!,
              password: _controller.text.trim()));
      await _auth.currentUser!.updatePassword(_password2Controller.text.trim());

      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  void _changeUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialog) {
        bool isLoading = false;

        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: isLoading == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: constants.loadingAnimation(),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        constants.smallText('إسم المستخدم الحالي', context,
                            color: Colors.redAccent),
                        constants.smallText(emailOrUsername, context,
                            color: Colors.redAccent),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _controller, 'اسم مستخدم جديد', context,
                                obsecure: false)),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _passwordController, 'كلمة السر', context,
                                obsecure: true)),
                      ],
                    ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: Text("الغاء"),
                      onPressed: () {
                        _controller.clear();
                        _passwordController.clear();
                        _password2Controller.clear();
                        Navigator.of(dialog).pop();
                      },
                    ),
                    FilledButton(
                      child: Text("تغيير"),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          if (_passwordController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            bool x = await _changeUsernameFunction(
                              _controller.text.trim(),
                            );
                            if (x == true) {
                              setState(() {
                                isLoading = false;
                              });
                              _controller.clear();
                              _passwordController.clear();
                              _password2Controller.clear();
                              Navigator.of(dialog).pop();
                              Fluttertoast.showToast(
                                  msg: 'تم تغيير إسم المستخدم بنجاح');
                              navigateTo(
                                  HomePage(
                                    index: 4,
                                  ),
                                  context);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(
                                  msg: 'الرجاء المحاولة مرة أخرى');
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'الرجاء تعبئة الحقول المطلوبة');
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _changeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialog) {
        bool isLoading = false;

        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: isLoading == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: constants.loadingAnimation(),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        constants.smallText('إلإيميل الحالي', context,
                            color: Colors.redAccent),
                        constants.smallText(emailOrUsername, context,
                            color: Colors.redAccent),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _controller, 'ايميل جديد', context,
                                obsecure: false)),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _passwordController, 'كلمة السر', context,
                                obsecure: true)),
                      ],
                    ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: Text("الغاء"),
                      onPressed: () {
                        _controller.clear();
                        _passwordController.clear();
                        _password2Controller.clear();
                        Navigator.of(dialog).pop();
                      },
                    ),
                    FilledButton(
                      child: Text("تغيير"),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          if (_passwordController.text.isNotEmpty) {
                            if (EmailValidator.validate(
                                    _controller.text.trim()) ==
                                true) {
                              setState(() {
                                isLoading = true;
                              });
                              bool x = await _changeEmailFunction(
                                _controller.text.trim(),
                              );
                              if (x == true) {
                                setState(() {
                                  isLoading = false;
                                });
                                _controller.clear();
                                _passwordController.clear();
                                _password2Controller.clear();
                                Navigator.of(dialog).pop();
                                Fluttertoast.showToast(msg: 'تم التغيير بنجاح');
                                navigateTo(
                                    HomePage(
                                      index: 4,
                                    ),
                                    context);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: 'الرجاء المحاولة مرة أخرى');
                              }
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'الرجاء تعبئة الحقول المطلوبة');
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _changePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialog) {
        bool isLoading = false;

        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: isLoading == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: constants.loadingAnimation(),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                            child: constants.CustomTextField(
                                _controller, 'كلمة السر الحالية', context,
                                obsecure: true)),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _passwordController,
                                'كلمة السر الجديدة',
                                context,
                                obsecure: true)),
                        SizedBox(
                          height: constants.screenHeight * 0.03,
                        ),
                        FittedBox(
                            child: constants.CustomTextField(
                                _password2Controller,
                                'تاكيد كلمة السر',
                                context,
                                obsecure: true)),
                      ],
                    ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: Text("الغاء"),
                      onPressed: () {
                        _controller.clear();
                        _passwordController.clear();
                        _password2Controller.clear();
                        Navigator.of(dialog).pop();
                      },
                    ),
                    FilledButton(
                      child: Text("تغيير"),
                      onPressed: () async {
                        if (_password2Controller.text.trim() ==
                            _passwordController.text.trim()) {
                          setState(() {
                            isLoading = true;
                          });
                          bool x = await _changePasswordFunction();
                          if (x == true) {
                            _controller.clear();
                            _passwordController.clear();
                            _password2Controller.clear();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(dialog).pop();
                            Fluttertoast.showToast(
                                msg: 'تم تغيير كلمة السر بنجاح');

                            navigateTo(
                                HomePage(
                                  index: 4,
                                ),
                                context);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'الرجاء التأكد من كلمة المرور الأصلية او كلمة المرور الجديدة أن تتكون اكثر من 7 ارقام او احرف');
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'الرجاء تعبئة الحقول المطلوبة');
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
            margin: const EdgeInsets.all(8),
            width: constants.screenWidth * 0.9,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(45)),
            child: Column(
              children: [
                Row(
                  key: CouchKeys.Key6,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (gender == 'm') {
                          navigateTo(MaleBundleScreen(), context);
                        } else {
                          navigateTo(FemaleBundleScreen(), context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Bootstrap.cart4,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('musers')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        //TODO: get User Matches count from DB
                        if (gender == 'm') {
                          if (snapshot.hasData) {
                            return constants.smallText(
                              '${snapshot.data['matches'] ?? 0}',
                              context,
                            );
                          } else if (snapshot.hasError) {
                            return constants.bigText(
                              '0',
                              context,
                            );
                          }
                        } else {
                          if (snapshot.hasData) {
                            return constants.smallText(
                              '${snapshot.data['fmatches'] ?? 0}',
                              context,
                            );
                          } else if (snapshot.hasError) {
                            return constants.bigText(
                              '0',
                              context,
                            );
                          }
                        }

                        return constants.bigText('0', context,
                            color: Colors.redAccent);
                      },
                    ),
                    gender == 'm'
                        ? constants.smallText(
                            'التطابقات المتوفرة',
                            context,
                          )
                        : constants.smallText(
                            'النكزات المتوفرة',
                            context,
                          )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: constants.screenHeight,
            child: isEmail
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Column(
                      //   children: [Icon(Icons.arrow_upward_outlined), Icon(Icons.arrow_downward_outlined)],
                      // ),
                      GestureDetector(
                        onTap: () {
                          _changeEmailDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('الإيميل')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.envelope),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _changePasswordDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('كلمة السر')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.fingerprint),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => shareFunction(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('دعوة الأصدقاء')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.share),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateTo(supportScreen(), context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('الدعم الفني')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.headset),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constants.screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              constants.navigateTo(
                                  TermsAndConditions(), context);
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Bootstrap.shield_check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  'شروط الإستخدام و الخصوصية',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () =>
                                  constants.navigateTo(OurMsg(), context),
                              child: Column(
                                children: [
                                  Icon(
                                    Bootstrap.envelope_paper,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    'رسالتنا',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: constants.screenHeight * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                // ratingDialog();
                                await FirebaseCustomAuth().SignOut().then(
                                    (value) => constants.navigateTo(
                                        const LoginScreen(), context));
                                // var snap = await _firestore.collection('questions').where('order', isGreaterThanOrEqualTo: 1).get();
                                // var docs = snap.docs;
                                // for(var doc in docs){
                                //   await _firestore.collection('questions').doc(doc.id).update({
                                //     'infoBadge':''
                                //   });
                                // }
                              },
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  constants.longButtonWithIcon(
                                      ' تسجيل خروج  ', context,
                                      buttonColor: Colors.red,
                                      icon: Icon(
                                        Bootstrap.arrow_return_left,
                                        color: Colors.white,
                                      )),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () => _showWhyDialog(context),
                                      ))
                                ],
                              )),
                        ],
                      ),
                      constants.UserInfo(
                          text: 'هنا تستطيع التحكم بإعدادات حسابك'),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _changeUsernameDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('اسم المستخدم')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.person),
                          ),
                        ),
                      ),
                      // Column(
                      //   children: [Icon(Icons.arrow_upward_outlined), Icon(Icons.arrow_downward_outlined)],
                      // ),

                      GestureDetector(
                        onTap: () => _changePasswordDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('كلمة السر')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.fingerprint),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => shareFunction(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('دعوة الأصدقاء')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.share),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateTo(supportScreen(), context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constants.screenWidth,
                          height: constants.screenHeight * 0.1,
                          child: ListTile(
                            title: Center(child: Text('الدعم الفني')),
                            leading: Icon(Icons.arrow_back_ios),
                            trailing: Icon(Bootstrap.headset),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constants.screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              constants.navigateTo(
                                  TermsAndConditions(), context);
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Bootstrap.shield_check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  'شروط الإستخدام و الخصوصية',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () =>
                                  constants.navigateTo(OurMsg(), context),
                              child: Column(
                                children: [
                                  Icon(
                                    Bootstrap.envelope_paper,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    'رسالتنا',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: constants.screenHeight * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // ratingDialog();
                              await FirebaseCustomAuth().SignOut().then(
                                  (value) => constants.navigateTo(
                                      const LoginScreen(), context));
                              // var snap = await _firestore.collection('questions').get();
                              // snap.docs.forEach((doc) async{
                              //   if(doc['isMultiple'] == true){
                              //     await doc.reference.update({
                              //       'minAnswers' : 2
                              //     });
                              //   }else{
                              //     await doc.reference.update({
                              //       'minAnswers' : 1
                              //     });
                              //   }
                              // });

                              // var qcat = await _firestore
                              //     .collection('questions')
                              //     .doc('qCat')
                              //     .get();
                              // List qcatList = qcat.data()!['qcat'];
                              // List   pqcatList = qcat.data()!['pqcat'];
                              // var qcatsnap = await _firestore
                              //     .collection('questions')
                              //     .where('category', whereIn: qcatList)
                              //     .get();
                              // var pqcatsnap = await _firestore
                              //     .collection('questions')
                              //     .where('category', whereIn: pqcatList)
                              //     .get();
                              // List<QueryDocumentSnapshot> qcatquestionsList =
                              //     qcatsnap.docs;
                              // List<QueryDocumentSnapshot> pqcatquestionsList =
                              //     pqcatsnap.docs;
                              // qcatquestionsList.forEach((element) async {
                              //   String partnerField = 'partner';
                              //
                              //   DocumentReference oldDocumentRef =
                              //       element.reference;
                              //
                              //   var oldData = await oldDocumentRef.get();
                              //
                              //   var oldData2 = oldData.data();
                              //   final uid = Uuid().v1();
                              //   DocumentReference newDocumentRef =
                              //       FirebaseFirestore.instance
                              //           .collection('questions')
                              //           .doc(uid);
                              //   newDocumentRef.set(oldData2);
                              //   await newDocumentRef.update({
                              //     partnerField:true,
                              //     'category':pqcatList[3]
                              //   });

                              // });

                              // matching3();
                              // var snap = await _firestore.collection('questions').get();
                              // var qcatsnap = await _firestore.collection('questions').get();
                              // var usersSnap = await _firestore.collection('answers').get();
                              // List<QueryDocumentSnapshot<Map<String, dynamic>>> allquestionDocs = snap.docs;
                              // List<QueryDocumentSnapshot<Map<String, dynamic>>> allUsersDocs = usersSnap.docs;
                              //
                              //
                              //   allUsersDocs.forEach((userDoc) async{
                              //    var snapx = await userDoc.reference.collection('answers').get();
                              //    List<QueryDocumentSnapshot> snapXlist = snapx.docs;
                              //    snapXlist.forEach((aelement) async{
                              //      if(aelement['type'] == 4){
                              //        await aelement.reference.update(
                              //            {'status': 2});
                              //      }else{
                              //        await aelement.reference.update(
                              //            {'status': 1});
                              //      }
                              //    });
                              //   });
                            },
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                constants.longButtonWithIcon(
                                  ' تسجيل خروج  ',
                                  context,
                                  buttonColor: Colors.red,
                                  icon: Icon(
                                    Bootstrap.arrow_return_left,
                                    color: Colors.white,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () => _showWhyDialog(context),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      constants.UserInfo(
                          text: 'هنا تستطيع التحكم بإعدادات حسابك'),
                    ],
                  ),
          ),
        ],
      ),
    ));
  }

  returnMultipleListsForEachCategory(categories, answersDocs) {
    List allCategoriesLists = [];
    categories.forEach((category) {
      List tempList = [];
      answersDocs.forEach((answerDoc) {
        if (answerDoc.get('cat').toString().trim() == category.trim()) {
          tempList.add(answerDoc);
        }
      });
      allCategoriesLists.add({category: tempList});
    });

    print(allCategoriesLists);
  }

  matching2() async {
    final batch = _firestore.batch();
    print('### Started ###');
    var categorySnap =
        await _firestore.collection('questions').doc('qCat').get();
    List qcat = categorySnap.data()!['qcat'];
    List pqcat = categorySnap.data()!['pqcat'];
    int qcatlength = qcat.length;
    int pqcatlength = pqcat.length;
    double qcatPercentage = 100 / qcatlength;
    double pqcatPercentage = 100 / pqcatlength;

    var answersDocumentsSnap = await _firestore.collection('answers').get();
    List<QueryDocumentSnapshot> answersDocs = answersDocumentsSnap.docs;

    for (var userDoc in answersDocs) {
      /// user 1 loop
      if (userDoc['isCompleteProfile'] == true) {
        print('### userDoc ${userDoc.id} ###');
        Map selfAnswers = {};
        Map partnerPref = {};

        var userAnswerssnap =
            await userDoc.reference.collection('answers').get();
        List<QueryDocumentSnapshot> answersDocs1 = userAnswerssnap.docs;
        for (var cat in qcat) {
          selfAnswers[cat] = [];
          for (var answerDoc in answersDocs1) {
            print(answerDoc.data());
            if (answerDoc['cat'] == cat) {
              List x = selfAnswers[cat];
              x.add(answerDoc);
              selfAnswers[cat] = x;
            }
          }
        }

        for (var cat in pqcat) {
          partnerPref[cat] = [];
          for (var answerDoc in answersDocs1) {
            if (answerDoc['cat'] == cat) {
              List x = partnerPref[cat];
              x.add(answerDoc);
              partnerPref[cat] = x;
            }
          }
        }

        Map selfQandA = extractQuestions(selfAnswers);
        Map partnerQandA = extractQuestions(partnerPref);

        /// user 2 loop
        for (var userDoc1 in answersDocs) {
          /// user 1 loop
          if (userDoc1['isCompleteProfile'] == true) {
            print('### userDoc ${userDoc1.id} ###');
            Map selfAnswers1 = {};
            Map partnerPref1 = {};

            var userAnswerssnap =
                await userDoc1.reference.collection('answers').get();
            List<QueryDocumentSnapshot> answersDocs2 = userAnswerssnap.docs;
            for (var cat in qcat) {
              selfAnswers1[cat] = [];
              for (var answerDoc in answersDocs2) {
                if (answerDoc['cat'] == cat) {
                  List x = selfAnswers1[cat];
                  x.add(answerDoc);
                  selfAnswers1[cat] = x;
                }
              }
            }

            for (var cat in pqcat) {
              partnerPref1[cat] = [];
              for (var answerDoc in answersDocs2) {
                if (answerDoc['cat'] == cat) {
                  List x = partnerPref1[cat];
                  x.add(answerDoc);
                  partnerPref1[cat] = x;
                }
              }
            }

            Map selfQandA1 = extractQuestions(selfAnswers1);
            Map partnerQandA1 = extractQuestions(partnerPref1);
            Map selfQandA = extractQuestions(selfAnswers);
            Map partnerQandA = extractQuestions(partnerPref);

            List xx = extractData(selfQandA1);
            List<Map<String, dynamic>> data1 = extractData(partnerQandA1);
            List<Map<String, dynamic>> data2 = extractData(selfQandA1);
            List<Map<String, dynamic>> data3 = extractData2(data1);

            /// user 2 partner
            List<Map<String, dynamic>> data4 = extractData2(data2);

            /// user 2 self
            List<Map<String, dynamic>> data6 = extractData(partnerQandA);
            List<Map<String, dynamic>> data7 = extractData(selfQandA);
            List<Map<String, dynamic>> data8 = extractData2(data6);

            /// user 1 partner
            List<Map<String, dynamic>> data9 = extractData2(data7);

            /// user 1 self

            // double similarity = calculateSimilarity(data3, data4);
            List last1Partner = groupMapsByCategory(data8);
            List last1Self = groupMapsByCategory(data9);

            /// ///////////////////////////////////// ///
            List last2Self = groupMapsByCategory(data4);
            List last2Partner = groupMapsByCategory(data3);

            List questions1 = [];
            List answers1 = [];
            List type1 = [];
            List questions2 = [];
            List answers2 = [];
            List type2 = [];

            String catx = 'الجانب الديني للشريك';
            print(last2Partner[0]);
            print(last2Self[0]);
            for (String testCat in pqcat) {
              if (catx.contains(testCat) == true) {
                for (int i = 0; i < last2Partner.length; i++) {
                  for (int j = 0; j < last2Partner[i].length; j++) {
                    if (last2Partner[i][j]['C'].trim() == testCat) {
                      questions1.add(last2Partner[i][j]['Q']);
                      answers1.add(last2Partner[i][j]['A']);
                      type1.add(last2Partner[i][j]['T']);
                    }
                  }
                }
              }
            }
            for (String testCat in qcat) {
              if (catx.contains(testCat) == true) {
                for (int i = 0; i < last2Self.length; i++) {
                  for (int j = 0; j < last2Self[i].length; j++) {
                    if (last2Self[i][j]['C'].trim() == testCat) {
                      questions2.add(last2Self[i][j]['Q']);
                      answers2.add(last2Self[i][j]['A']);
                      type2.add(last2Self[i][j]['T']);
                    }
                  }
                }
              }
            }

            // for(int i = 0; i<questions1.length; i++){
            //   print('Q: ${questions1[i]} A: ${answers1[i]} T: ${type1[i]}');
            // }
            //
            // for(int i = 0; i<questions2.length; i++){
            //   print('Q: ${questions2[i]} A: ${answers2[i]}  T: ${type2[i]}');
            // }
            double percentage = calculateSimilarity(
                answers1, type1, questions1, answers2, type2, questions2);
            print('####### percentage: $percentage');
          }

          /// end of user 1 loop
        }
      }

      /// end of user 1 loop
    }
  }

  /// end of matching 2 function
  ///
  ///
  sortMultipleListAccordingToOneList(
    List questions1,
    List answers1,
    List type1,
    List questions2,
    List answers2,
    List type2,
  ) {
    List stringList = questions1;
    List stringList2 = answers1;
    List intList = type1;
    List xstringList = questions2;
    List xstringList2 = answers2;
    List xintList = type2;

    stringList.sort(); // Sort the string list
    xstringList.sort(); // Sort the string list

    for (int i = 0; i < stringList.length; i++) {
      int newIndex = stringList.indexOf(stringList[i]);
      intList[i] = intList[newIndex];
      stringList2[i] = stringList2[newIndex];
    }
    for (int i = 0; i < xstringList.length; i++) {
      int newIndex = xstringList.indexOf(xstringList[i]);
      xintList[i] = xintList[newIndex];
      xstringList2[i] = xstringList2[newIndex];
    }
    return [
      stringList,
      stringList2,
      intList,
      xstringList,
      xstringList2,
      xintList,
    ];
  }

  double calculateSimilarity(
      List<dynamic> partnerNeedAnswer,
      List<dynamic> type1,
      List<dynamic> question1,
      List<dynamic> selfFillAnswer,
      List<dynamic> type2,
      List<dynamic> question2) {
    double totalPoints = 0;
    double earnedPoints = 0;
    double categoryPercentage = 0;
    List x = sortMultipleListAccordingToOneList(
        question1, partnerNeedAnswer, type1, question2, selfFillAnswer, type2);
    List newQList = x[0];
    List newAList = x[1];
    List newTList = x[2];
    List newQList1 = x[3];
    List newAList1 = x[4];
    List newTList1 = x[5];
    for (int i = 0; i < newQList.length; i++) {
      print(
          'Question:${newQList[i]}  Partner Need Answer: ${newAList[i]}  T: ${newTList[i]}');
    }
    for (int i = 0; i < newQList1.length; i++) {
      print(
          'Question:${newQList1[i]} self Fill Answer: ${newAList1[i]}  T: ${newTList1[i]}');
    }

    return categoryPercentage;
  }

  double calculateMatchPercentage(selfAnswers, partnerAnswers) {
    double totalPercentage = 0;
    int numLists = selfAnswers.length;

    for (int i = 0; i < numLists; i++) {
      List<Map<String, dynamic>> selfList = selfAnswers[i];
      List<Map<String, dynamic>> partnerList = partnerAnswers[i];

      // Make sure both lists have the same length
      int numQuestions = selfList.length;
      if (numQuestions != partnerList.length) {
        throw Exception('Lists have different lengths');
      }

      // Calculate percentage for this list
      double listPercentage = 0;
      for (int j = 0; j < numQuestions; j++) {
        Map<String, dynamic> selfAnswer = selfList[j];
        Map<String, dynamic> partnerAnswer = partnerList[j];

        if (selfAnswer['c'] != partnerAnswer['c']) {
          throw Exception('Lists have different categories');
        }

        int type = selfAnswer['t'];
        if (type == 0 || type == 1) {
          // Double answer
          double selfValue = selfAnswer['a'];
          double partnerValue = partnerAnswer['a'];
          double diff = (selfValue - partnerValue).abs();
          listPercentage += 1 - diff / 10; // 10 is the max difference allowed
        } else if (type == 2 || type == 5 || type == 6 || type == 7) {
          // List of strings answer
          List<String> selfValue = List<String>.from(selfAnswer['a']);
          List<String> partnerValue = List<String>.from(partnerAnswer['a']);
          int commonValues =
              selfValue.toSet().intersection(partnerValue.toSet()).length;
          listPercentage += commonValues / selfValue.length;
        } else if (type == 3) {
          // Timestamp answer
          // This type is ignored
        } else {
          throw Exception('Unknown answer type: $type');
        }
      }

      // Add list percentage to total percentage
      listPercentage /= numQuestions; // Normalize by number of questions
      totalPercentage += listPercentage;
    }

    // Divide total percentage by number of lists
    return totalPercentage / numLists;
  }

  Map<String, dynamic> extractQuestions(input) {
    Map<String, dynamic> result = {};
    input.forEach((cat, snaps) {
      List<Map<String, dynamic>> catList = [];
      snaps.forEach((snap) {
        Map<String, dynamic> snapData = snap.data()!;
        String question = snapData['question'];
        dynamic answer = snapData['answer'];
        int type = snapData['type'];
        catList.add({
          'question': question,
          'answer': answer,
          'type': type,
        });
      });
      result[cat] = catList;
    });
    return result;
  }

  List<Map<String, dynamic>> sortMaps(List<Map<String, dynamic>> input) {
    var sortedKeys = input[0].keys.toList()..sort();

    input.sort((a, b) {
      for (var key in sortedKeys) {
        var cmp = a[key].toString().compareTo(b[key].toString());
        if (cmp != 0) {
          return cmp;
        }
      }
      return 0;
    });

    return input;
  }

  // double calculateSimilarity(List<Map<String, dynamic>> data1, List<Map<String, dynamic>> data2) {
  //   int totalMaps = 0;
  //   int totalSimilarMaps = 0;
  //   int totalMatches = 0;
  //
  //   for (var map1 in data1) {
  //     for (var map2 in data2) {
  //       if (map1["type"] == map2["type"]) {
  //         totalMaps++;
  //         bool matchFound = false;
  //
  //         for (var item1 in map1["A"]) {
  //           for (var item2 in map2["A"]) {
  //             if (item1["Q"] == item2["Q"] && item1["A"] == item2["A"]) {
  //               totalMatches++;
  //               matchFound = true;
  //               break;
  //             }
  //           }
  //           if (matchFound) break;
  //         }
  //
  //         if (matchFound) {
  //           totalSimilarMaps++;
  //         }
  //       }
  //     }
  //   }
  //
  //   if (totalMaps == 0) {
  //     return 0.0;
  //   }
  //
  //   double similarityPercentage = (totalSimilarMaps / totalMaps) * 100.0;
  //   return similarityPercentage;
  // }
  Map<String, dynamic>? findAnswer(Map<String, dynamic> selfAnswers,
      String category, Map<String, dynamic> preference) {
    if (selfAnswers.containsKey(category.trim())) {
      return selfAnswers[category.trim()].firstWhere(
          (a) => a['question'] == preference['question'],
          orElse: () => null);
    } else {
      return null;
    }
  }

  List<Map<String, dynamic>> extractData(Map data) {
    List<Map<String, dynamic>> extractedData = [];

    data.forEach((key, value) {
      List<Map<String, dynamic>> temp = [];

      value.forEach((item) {
        Map<String, dynamic> map = {};

        item.forEach((k, v) {
          map[k.substring(0, 1)] = v;
        });

        temp.add(map);
      });

      Map<String, dynamic> finalMap = {key: temp};
      extractedData.add(finalMap);
    });

    return extractedData;
  }

  List<Map<String, dynamic>> extractData2(List<Map<String, dynamic>> input) {
    List<Map<String, dynamic>> output = [];

    for (var map in input) {
      List<Map<String, dynamic>> subList = map.values.first;
      String cat = map.keys.first;

      for (var subMap in subList) {
        String question = subMap['q'];
        dynamic answer = subMap['a'];
        int type = subMap['t'];

        output.add({'Q': question, 'A': answer, 'T': type, 'C': cat});
      }
    }

    return output;
  }

  // findQuestionToCompare(Map x, Map y){
  //   x.forEach((key1, value1) {
  //     y.forEach((key2, value2) {
  //       List x = value1;
  //       x.firstWhere((element) => )
  //     });
  //   });
  // }
  List<List<Map<String, dynamic>>> groupMapsByCategory(
      List<Map<String, dynamic>> input) {
    Map<dynamic, List<Map<String, dynamic>>> map = {};

    for (var i = 0; i < input.length; i++) {
      Map<String, dynamic> item = input[i];
      var category = item['C'];

      if (!map.containsKey(category)) {
        map[category] = [];
      }

      map[category]!.add(item);
    }

    return map.values.toList();
  }

  Map<String, double> compareAnswers(selfAnswers, partnerPreferences) {
    Map<String, double> results = {};

    // Loop through each category in the partnerPreferences
    partnerPreferences.forEach((category, preferences) {
      double totalPoints = 0;
      double earnedPoints = 0;

      // Loop through each preference in the category
      preferences.forEach((preference) {
        // Find the corresponding answer in selfAnswers
        var answer = findAnswer(selfAnswers, category, preference);
        // If there is a corresponding answer, calculate the earned points
        if (answer != null &&
            answer['answer'] != null &&
            preference['answer'] != null) {
          switch (preference['type']) {
            case 0:
            case 1:
              // For double type, calculate the points based on the difference between the two values
              var selfValue = answer['answer'] is String
                  ? double.tryParse(answer['answer'])
                  : answer['answer'];
              var partnerValue = preference['answer'] is String
                  ? double.tryParse(preference['answer'][0])
                  : preference['answer'][0];
              if (selfValue != null && partnerValue != null) {
                var diff = (selfValue - partnerValue).abs();
                var maxDiff = preference['type'] == 0
                    ? 20.0
                    : 10.0; // Max difference for height is 20cm and for weight is 10kg
                var points = diff <= maxDiff ? (1 - diff / maxDiff) : 0;
                totalPoints += 1;
                earnedPoints += points;
              }
              break;

            case 2:
            case 5:
            case 6:
            case 7:
              // For list of strings type, calculate the points based on the number of matching items
              var selfList = answer['answer'] is List
                  ? answer['answer']
                  : [answer['answer']];
              var partnerList = preference['answer'] is List
                  ? preference['answer']
                  : [preference['answer'][0]];
              var matches =
                  selfList.where((item) => partnerList.contains(item)).length;
              var points = matches / partnerList.length;
              totalPoints += 1;
              earnedPoints += points;
              break;

            case 3:
              // For timestamp type, calculate the points based on the difference in days between the two timestamps
              var selfTimestamp = answer['answer'] is Timestamp
                  ? answer['answer']
                  : Timestamp.fromDate(DateTime.parse(answer['answer']));
              var partnerTimestamp =
                  Timestamp.fromDate(DateTime.parse(preference['answer'][0]));
              var diff = partnerTimestamp
                  .toDate()
                  .difference(selfTimestamp.toDate())
                  .inDays;
              var maxDiff = 365.0; // Max difference is 1 year
              var points = diff <= maxDiff ? (1 - diff / maxDiff) : 0;
              totalPoints += 1;
              earnedPoints += points;
              break;

            default:
              break;
          }
        }
      });

      // Calculate the percentage of earned points
      double categoryPercentage =
          totalPoints > 0 ? (earnedPoints / totalPoints * 100) : 0;
      results[category] = categoryPercentage;
    });

    return results;
  }

  compareTwoMaps(Map qcat, Map pqcat, percentageForCategory, x) async {
    /// qcat is what I am {'cat':[ans,ans,ans]}
    /// pqcat is what I want my partner to be {'cat':[ans,ans,ans]}
    //  var allQuestionsSnap = await _firestore.collection('questions').where('order', isEqualTo: 1).get();
    //  List<QueryDocumentSnapshot> allQuestionsDocs = allQuestionsSnap.docs;
    //  List<double> percentageCollections = [];
    //  List<QueryDocumentSnapshot> allWhatNeededPartnerDocs = [];
    //  pqcat.forEach((key, docs) {
    //    double catPercentage = 0.0;
    //    docs.forEach((pqcatDocLoop){
    //      QueryDocumentSnapshot? x = findDocumentByField(qcat, 'question', pqcatDocLoop['question'],);
    //      if(x!['question'] == pqcatDocLoop!['question']){
    //        print('### X ### ');
    //        print(x!['question']);
    //        print(x!['answer']);
    //        print('### pqcatDocLoop ### ');
    //        print(pqcatDocLoop!['question']);
    //        print(pqcatDocLoop!['answer']);
    //      }
    //    });
    //  });

    Map<String, dynamic> extractedData = extractUserAnswers(qcat, pqcat);
    Map<String, dynamic> userAnswers = extractedData['userAnswers'];
    Map<String, dynamic> partnerPreferences =
        extractedData['partnerPreferences'];

    calculateMatchingPercentage(userAnswers, partnerPreferences, x);
  }

  QueryDocumentSnapshot<Object?>? findDocumentByField(
      Map map, String fieldName, dynamic fieldValue) {
    for (var entry in map.entries) {
      for (var doc in entry.value) {
        if (doc[fieldName] == fieldValue) {
          return doc;
        }
      }
    }
    return null;
  }

  double calculateMatchingPercentage(Map<String, dynamic> user1Answers,
      Map<String, dynamic> user2Answers, List categories) {
    double totalPercentage = 0.0;
    for (var category in categories) {
      double categoryPercentage = 100.0 / categories.length;
      List<dynamic> user1CategoryAnswers = user1Answers[category];
      List<dynamic> user2CategoryAnswers = user2Answers[category];
      double categoryMatchingPercentage = 0.0;
      if (user1CategoryAnswers != null && user2CategoryAnswers != null) {
        for (int i = 0; i < user1CategoryAnswers.length; i++) {
          if (user1CategoryAnswers[i] is int) {
            if (user1CategoryAnswers[i] == user2CategoryAnswers[i]) {
              categoryMatchingPercentage +=
                  (categoryPercentage / user1CategoryAnswers.length);
            }
          } else if (user1CategoryAnswers[i] is List<String>) {
            List<String> user1AnswerList = user1CategoryAnswers[i];
            List<String> user2AnswerList = user2CategoryAnswers[i];
            int matchingAnswers = 0;
            for (String answer in user1AnswerList) {
              if (user2AnswerList.contains(answer)) {
                matchingAnswers++;
              }
            }
            categoryMatchingPercentage +=
                ((matchingAnswers / user1AnswerList.length) *
                    (categoryPercentage / user1CategoryAnswers.length));
          } else if (user1CategoryAnswers[i] is String) {
            if (user1CategoryAnswers[i] == user2CategoryAnswers[i]) {
              categoryMatchingPercentage +=
                  (categoryPercentage / user1CategoryAnswers.length);
            }
          }
        }
      }
      totalPercentage += categoryMatchingPercentage;
    }
    print(totalPercentage);
    return totalPercentage;
  }

  Map<String, dynamic> extractUserAnswers(Map data1, Map data2) {
    Map<String, dynamic> userAnswers = {};
    Map<String, dynamic> partnerPreferences = {};

    data1.forEach((key, value) {
      if (key.contains('للشريك')) {
        partnerPreferences[key] = value.map((doc) => doc.data()).toList();
      } else {
        userAnswers[key] = value.map((doc) => doc.data()).toList();
      }
    });
    data2.forEach((key, value) {
      if (key.contains('للشريك')) {
        partnerPreferences[key] = value.map((doc) => doc.data()).toList();
      } else {
        userAnswers[key] = value.map((doc) => doc.data()).toList();
      }
    });

    return {
      'userAnswers': userAnswers,
      'partnerPreferences': partnerPreferences,
    };
  }

  QueryDocumentSnapshot<Object?>? findDocumentById(Map map, String id) {
    for (var entry in map.entries) {
      var docList = entry.value;
      for (var doc in docList) {
        if (doc.id == id) {
          return doc;
        }
      }
    }
    return null;
  }

// compareTwoMaps(Map<String, List<Map<String, dynamic>>> qcat, Map<String, List<Map<String, dynamic>>> pqcat, double percentageForCategory){
//   /// qcat is {'cat':[ans,ans,ans]}
//   /// pqcat is {'cat':[ans,ans,ans]}
//
//   qcat.forEach((key2, value2) {
//     List<Map<String, dynamic>> pqcatx = [];
//     List<Map<String, dynamic>> qcatx = value2;
//     pqcat.forEach((key, value) {
//       if(key2.toString().contains(key)){
//         pqcatx = value;
//       }
//     });
//
//     double similarityScore = 0.0;
//     int totalQuestions = qcatx.length + pqcatx.length;
//
//     for(var i in pqcatx){
//
//       for(var j in qcatx){
//         if(i['question'] == j['question'] && i['answer'] == j['answer']){
//           similarityScore += percentageForCategory/qcat.length;
//         }
//       }
//
//     }
//
//     print('Similarity score for category $key2: $similarityScore');
//
//   });
//
// }
}
