import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/auth/registerScreens.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/customTheme.dart';
import 'package:madalh/view/notAddedForNow/dashboardScreen.dart';
import 'package:madalh/view/matchScreen/matchScreen.dart';
import 'package:madalh/view/notifications/notificationScreen.dart';
import 'package:madalh/view/profileScreen/profileScreen.dart';
import 'package:madalh/view/settings/settingsScreen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'auth/verifyPN.dart';
import 'controllers/homePageController.dart';
import 'controllers/systemController.dart';
import 'extras/register_screen.dart';
import 'questions/questions.dart';

class HomePage extends StatefulWidget {
  final index;
  final isFirstTime;
  final showCongrats;

  const HomePage(
      {Key? key,
      this.index = 0,
      this.isFirstTime = false,
      this.showCongrats = false})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  // late PageController pageController;
  AppUpdateInfo? _updateInfo;
  bool isActive = false;
  late bool showCongrats;
  List<Widget> screens = [
    MatchScreen(),
    NotificationScreen(),
    ProfileScreen(),
    SettingsScreen()
  ];
  Future<void> showCongratsDialog(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('AppSettings').doc('appSettings').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final message =
                  snapshot.data!['congratsMsg'] ?? 'مبروك اقتربت من إكمال ملفك';

              return AlertDialog(
                content: Container(
                  width: constants.screenWidth * 0.95,
                  height: constants.screenHeight * 0.9,
                  child: Scaffold(
                    bottomNavigationBar: Container(
                        width: constants.screenWidth,
                        height: constants.screenHeight * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    pageIndex = 2;
                                  });
                                },
                                child: Text('المتابعة')),
                          ],
                        )),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset('assets/videos/party1.gif'),
                          Container(
                            width: constants.screenWidth * 0.9,
                            height: constants.screenHeight * 0.2,
                            child: Image.asset(
                              'assets/videos/party3.gif',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: constants.smallText(message, context,
                                    color: Colors.red),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: constants.loadingAnimation(),
              );
            }
          },
        );
      },
    );
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).then((_) {
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    });
  }

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  // GlobalKey matchScreen1 = GlobalKey();
  // GlobalKey matchScreen2 = GlobalKey();
  // GlobalKey matchScreen3 = GlobalKey();
  // GlobalKey matchScreenMatches = GlobalKey();
  // GlobalKey matchScreenPokes = GlobalKey();
  // GlobalKey matchScreenRequests = GlobalKey();
  // GlobalKey notificationsScreen1 = GlobalKey();
  // GlobalKey notificationsScreen2 = GlobalKey();
  // GlobalKey notificationsScreen3 = GlobalKey();
  // GlobalKey profileScreen = GlobalKey();
  // GlobalKey settingsScreen = GlobalKey();
  // GlobalKey specialKey = GlobalKey();

  int countTrue(List list) {
    return list.where((item) => item.isChosen == true).length;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ratingDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      int loginCount = await prefs.getInt('loginCount') ?? 0;

      loginCount += 1;

      if (loginCount % 10 == 0) {
        showDialog(
          context: context,
          builder: (BuildContext x) {
            List<String> options = [
              'تم المدله بنجاح ولا يوجد نصيب ',
              'تمت المدله وطلبه بنجاح و الحمد الله  شكرا لكم '
            ];
            int rate = -1;
            TextEditingController _controller = TextEditingController();
            List<MCAnswers> chips =
                options.map((e) => MCAnswers(AnswerText: e)).toList();
            String question = 'هل تمت المدله؟';
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          try {
                            await _firestore
                                .collection('Ratings')
                                .doc(_auth.currentUser!.uid)
                                .set({
                              'rate': null,
                              'comment': null,
                              'choice': 'ليس بعد',
                              'date': DateTime.now(),
                            });

                            Navigator.of(x).pop();
                          } catch (e) {
                            Navigator.of(x).pop();
                          }
                        },
                        child: Text(' ليس بعد',
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.redAccent)),
                      ),
                      FilledButton(
                        onPressed: () async {
                          if (countTrue(chips) > 0 && rate >= 0) {
                            try {
                              await _firestore
                                  .collection('Ratings')
                                  .doc(_auth.currentUser!.uid)
                                  .set({
                                'rate': rate,
                                'comment': _controller.text,
                                'choice': chips
                                    .map((e) => e.isChosen == true)
                                    .toString(),
                                'date': DateTime.now(),
                              });
                              Fluttertoast.showToast(msg: 'تم إرسال التقييم');
                              Navigator.of(x).pop();
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'حدث خطأ ما، يرجى المحاولة مجدداً');
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'لا يوجد تقييم لإرساله');
                          }
                        },
                        child: Text('تقييم',
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green)),
                      )
                    ],
                  )
                ],
                content: Container(
                  width: constants.screenWidth * 0.9,
                  height: constants.screenWidth * 0.82,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmojiFeedback(
                        onChanged: (x) {
                          setState(() {
                            rate = x;
                          });
                        },
                        customLabels: const [
                          'سيء',
                          'مقبول',
                          'جيد',
                          'جيد جداً',
                          'ممتاز',
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          constants.smallText(question, context),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: chips
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      e.isChosen = true;
                                    });
                                    chips.forEach((element) {
                                      if (element != e) {
                                        element.isChosen = false;
                                      }
                                    });
                                  },
                                  child: Chip(
                                    padding: EdgeInsets.all(3),
                                    label: FittedBox(
                                      child: Text(
                                        e.AnswerText,
                                        maxLines: 3,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: e.isChosen
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ))
                            .toList(),
                      ),
                      TextField(
                        maxLength: 100,
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }

      await prefs.setInt('loginCount', loginCount);
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(milliseconds: 100), () {
      updateLogin().then((_) {
        Future.delayed(Duration(milliseconds: 150), () {
          setState(() {
            pageIndex = widget.index;
            showCongrats = widget.showCongrats;
          });
        }).then((_) {
          if (showCongrats == true) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              showCongratsDialog(context);
            });
          }
        });
      });
    });
    userActive();
    setIsLoadingToFalse();
    checkForUpdate();

    super.initState();
  }

  String gender = 'm';

  userActive() async {
    var snap = await FirebaseFirestore.instance
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      gender = snap.data()!['gender'];
      isActive = snap.data()!['isActive'];
    });
///TODO:UNCOMMENT
    // if (isActive == true) {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     checkForCoach();
    //     Future.delayed(Duration(milliseconds: 150), () {
    //       ratingDialog();
    //     });
    //   });
    // } else {}
  }

  checkForCoach() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = await prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime == true) {
      _showTutorialCoachmark();
    }
  }

  updateLogin() async {
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('musers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'lastLoginDate': DateTime.now(), 'token': token});
  }

  Color bottomNavigationBarIconBackgroundColor() {
    Color mainColor = Theme.of(context).primaryColor;
    if (pageIndex == 0) {
      setState(() {
        mainColor = Colors.redAccent;
      });
    } else if (pageIndex == 1) {
      setState(() {
        mainColor = Colors.amber;
      });
    } else if (pageIndex == 2) {
      setState(() {
        mainColor = Theme.of(context).primaryColor;
      });
    } else if (pageIndex == 3) {
      setState(() {
        mainColor = Colors.grey;
      });
    } else if (pageIndex == 4) {
      setState(() {
        mainColor = Colors.grey;
      });
    }
    return mainColor;
  }

  Paint gradientPaint = Paint()
    ..shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
      colors: [Colors.red, Colors.yellow, Colors.green],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 200.0));

  void _showTutorialCoachmark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      textSkip: 'تخطي',
      hideSkip: true,
      targets: targets,
      pulseEnable: false,
      colorShadow: Theme.of(context).primaryColor,
      onClickTarget: (target) {},
      // hideSkip: true,
      alignSkip: Alignment.topRight,
      onFinish: () {},
    )..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "matches-key1",
        keyTarget: CouchKeys.Key1,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'هنا تستطيع إيجاد التطابقات بينك و بين شريكك الآخر',
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key2",
        keyTarget: CouchKeys.Key2,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'هنا تستطيع إيجاد النكزات الصادرة و الواردة',
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key3",
        keyTarget: CouchKeys.Key3,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'هنا تستطيع إيجاد الطلبات و متابعة حالاتها',
                onNext: () {
                  setState(() {
                    pageIndex = 1;
                  });
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key4",
        keyTarget: CouchKeys.Key4,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'هنا تستطيع إيجاد الإشعارات الخاصة بك',
                onNext: () {
                  setState(() {
                    pageIndex = 2;
                  });
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key5",
        keyTarget: CouchKeys.Key5,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text:
                    'من هنا، هذا هو ملفك الذي عليه سيترتب إيجاد شريكك. عليك تعبئة الملف بالكامل لكي نستطيع البحث عن شريكك المناسب',
                onNext: () {
                  setState(() {
                    pageIndex = 3;
                  });
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key6",
        keyTarget: CouchKeys.Key6,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text:
                    ' هذه النكزات او التطابقات لكي تستطيع إستخدامها مجانا يوميا يسمح لك بعدد محدود و عند الإشتراك من هنا تستطيع ان تزيد حدودك اليومية و من هنا تتحكم بمعلومات حسابك',
                onNext: () {
                  setState(() {
                    pageIndex = 2;
                  });
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "matches-key5",
        keyTarget: CouchKeys.Key5,
        color: Colors.black,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text:
                    'و الأن عليك ملئ ملفك بالكامل كي تستطيع الحصول على كافة خدماتنا مجانا',
                onNext: () async {
                  controller.next();
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstTime', false);
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
    ];
  }

  bool _isLoading = true;

  setIsLoadingToFalse() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AppService>(
            create: (context) => AppService(),
          ),
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: constants.screenHeight * 0.10,
              title: SvgPicture.asset(
                'assets/svg/AraicName.svg',
                width: constants.screenWidth * 0.1,
                height: constants.screenWidth * 0.1,
                color: Colors.white,
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(constants.screenWidth * 0.1),
                        bottomRight:
                            Radius.circular(constants.screenWidth * 0.1)),
                    gradient: Provider.of<AppService>(context, listen: false)
                        .systemGradient),
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 55,
              index: pageIndex,
              backgroundColor: Colors.white,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              buttonBackgroundColor: bottomNavigationBarIconBackgroundColor(),
              animationDuration: Duration(milliseconds: 200),
              onTap: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              items: [
                // Icon(
                //   Bootstrap.columns_gap,
                //   color: Colors.white,
                // ),
                LayoutBuilder(
                  builder: (BuildContext, BoxConstraints) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('musers')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('matches')
                          .where('saw', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<QueryDocumentSnapshot> ds = snapshot.data!.docs;
                        int count = 0;
                        for (var document in ds) {
                          var similarity =
                              double.tryParse(document['Similarity']);
                          if (similarity != null && similarity > 39) {
                            count++;
                          }
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length == 0) {
                            return Icon(
                              Bootstrap.heart,
                              color: Colors.white,
                            );
                          } else {
                            return badges.Badge(
                              badgeContent: Text(
                                '${count}',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(
                                Bootstrap.heart,
                                color: Colors.white,
                              ),
                            );
                          }
                        } else if (!snapshot.hasData) {
                          return Icon(
                            Bootstrap.heart,
                            color: Colors.white,
                          );
                        } else if (snapshot.hasError) {
                          return Icon(
                            Bootstrap.heart,
                            color: Colors.white,
                          );
                        } else {
                          return Icon(
                            Bootstrap.heart,
                            color: Colors.white,
                          );
                        }
                      },
                    );
                  },
                ),
                LayoutBuilder(builder: (BuildContext, BoxConstraints) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('musers')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('notifications')
                        .where('saw', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length == 0) {
                          return Icon(
                            Bootstrap.bell,
                            color: Colors.white,
                          );
                        } else {
                          return badges.Badge(
                            badgeContent: Text(
                              '${snapshot.data!.docs.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(
                              Bootstrap.bell,
                              color: Colors.white,
                            ),
                          );
                        }
                      } else {
                        return Icon(
                          Bootstrap.bell,
                          color: Colors.white,
                        );
                      }
                    },
                  );
                }),
                Icon(
                  Bootstrap.person,
                  color: Colors.white,
                ),
                Icon(
                  Bootstrap.gear,
                  color: Colors.white,
                ),
              ],
            ),
            body: Consumer<AppService>(builder: (_, AppServiceValue, __) {
              return StreamBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  bool x = snapshot.data['isActive'];
                  return x == true
                      ? Consumer<HomePageController>(builder: (_, vva, __) {
                          return PageView(
                            controller: vva.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [screens[pageIndex]],
                          );
                        })
                      : RegisterScreen();
                },
                stream: constants.firestore
                    .collection('musers')
                    .doc(constants.auth.currentUser!.uid)
                    .snapshots(),
              );
            })),
      ),
    ));
  }
}

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = " ",
    this.next = "التالي",
    this.onSkip,
    this.onNext,
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    widget.onSkip;
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isFirstTime', false);
                  },
                  child: Text(widget.skip),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text(widget.next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CouchKeys {
  static final Key1 = GlobalKey(
    debugLabel: 'key1',
  );
  static final Key2 = GlobalKey(debugLabel: 'key2');
  static final Key3 = GlobalKey(debugLabel: 'key3');
  static final Key4 = GlobalKey(debugLabel: 'key4');
  static final Key5 = GlobalKey(debugLabel: 'key5');
  static final Key6 = GlobalKey(debugLabel: 'key6');
  static final Key7 = GlobalKey(debugLabel: 'key7');
  static final Key8 = GlobalKey(debugLabel: 'key8');
}
