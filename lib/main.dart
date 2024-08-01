import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/auth/loginScreen.dart';
import 'package:madalh/auth/registerScreens.dart';
import 'package:madalh/controllers/questionsController.dart';
import 'package:madalh/controllers/scrollBehav.dart';
import 'package:madalh/controllers/systemController.dart';
import 'package:madalh/models/LQ.dart';
import 'package:madalh/partner/partnerMain.dart';
import 'package:madalh/service/Test.dart';
import 'package:madalh/homePage.dart';
import 'package:madalh/test.dart';
import 'package:madalh/view/congrats/congrats.dart';
import 'package:madalh/view/maintenance/maintenance.dart';
import 'package:madalh/view/matchScreen/matchProfile.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SimpleScreen.dart';
import 'auth/forgetPassword/authproviderForget.dart';
import 'auth/verifyPN.dart';
import 'controllers/constants.dart' as constants;
import 'controllers/homePageController.dart';
import 'controllers/matchScreenController.dart';
import 'controllers/paymentController.dart';
import 'controllers/requestsController.dart';
import 'extras/auth_provider.dart' as authP;
import 'firebase_options.dart';
import 'initialScreens/initialView.dart';
import 'initialScreens/initial_language.dart';
import 'package:madalh/questions/questions.dart';

import 'landingPages.dart';
import 'models/hoppiesmcq.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications',

  // description
  importance: Importance.max,
  playSound: true,
  showBadge: true,
  enableVibration: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  await NoScreenshot.instance.screenshotOff();
  // Stripe.publishableKey =
  //     'pk_test_51LCR7AKoEwOhE0oQLG2AhlpFcEnBEYcyThz37eoiaOP5C2lnwCS9Fm6OjuhhFZ768LSosBR6AWWaKlqSnmSUOZog00weaG3mso';
  Stripe.publishableKey =
      'pk_live_51LCR7AKoEwOhE0oQ8JMzwVl0G2pPHMmTNiAHgtp8dkN2zazEE1yKWL4FPIznBsPw3ecHs7Mqm3imxWMsJSc1UXsa00VfzNUMaO';
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Container(
            child: constants.loadingAnimation(),
          )),
        );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLandingPrefs = prefs.getBool('isLanding') ?? true;
    runApp(MyApp(
      isLanding: isLandingPrefs,
    ));
  });
}

class MyApp extends StatelessWidget {
  final bool isLanding;

  const MyApp({super.key, required this.isLanding});

  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      // offline: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Container(
      //         height: constants.screenHeight * 0.5,
      //         width: constants.screenWidth * 0.9,
      //         child: SvgPicture.asset('assets/svg/sad.svg')),
      //     Text('لا يتوفر لديك الإنترنت', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: constants.screenHeight*0.03),),
      //
      //     Icon(Bootstrap.wifi_off, color: Colors.red,size: constants.screenWidth*0.09,)
      //   ],
      // )),
      // ignore: avoid_print
      whenOffline: () => const Center(child: Text('No Internet 2')),
      // ignore: avoid_print
      whenOnline: () => const Center(
          child: Text(
        ('Connected to internet'),
      )),
      loadingWidget: Center(child: constants.loadingAnimation()),
      online: MultiProvider(
        providers: [
          ChangeNotifierProvider<AppService>(
            create: (context) => AppService(),
          ),
          ChangeNotifierProvider<QController>(
            create: (context) => QController(),
          ),
          ChangeNotifierProvider<PaymentNotifier>(
            create: (context) => PaymentNotifier(),
          ),
          ChangeNotifierProvider<RequestsController>(
            create: (context) => RequestsController(),
          ),
          ChangeNotifierProvider<MatchScreenController>(
            create: (context) => MatchScreenController(),
          ),
          ChangeNotifierProvider<authP.AuthProvider>(
            create: (context) => authP.AuthProvider(),
          ),
          ChangeNotifierProvider<AuthProviderForget>(
            create: (context) => AuthProviderForget(),
          ),
          ChangeNotifierProvider<HomePageController>(
            create: (context) => HomePageController(),
          ),
        ],
        child: Builder(builder: (context) {
          return Consumer<AppService>(
            builder: (_, AppServiceData, __) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MaDalah',
                  theme: ThemeData(
                      // primaryColor: AppServiceData.primaryColor,

                      useMaterial3: false,
                      dialogBackgroundColor: Colors.white,
                      primarySwatch: AppServiceData.systemThemeColor,
                      scaffoldBackgroundColor: Colors.white),
                  home: ScrollConfiguration(
                      behavior: NewScrollBehavior(),
                      child: isLanding == true
                          ? LandingPages()
                          : StreamBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.data['onMaintenance'] == true) {
                                  return maintenance();
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: constants.loadingAnimation(),
                                  );
                                } else {
                                  return StreamBuilder(
                                      stream: FirebaseAuth.instance
                                          .authStateChanges(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.active) {
                                          if (snapshot.hasData) {
                                            // return HMCQ();
                                            if (FirebaseAuth.instance
                                                    .currentUser!.email!
                                                    .split('@')[1] ==
                                                'partner.com') {
                                              return PartnerMain();
                                            } else {
                                              return HomePage();
                                            }
                                            // return  ? PartnerMain() : HomePage();
                                            // return congrats();
                                            // return testLast();
                                            // return congrats();
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text('${snapshot.error}'),
                                            );
                                          }
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: constants.loadingAnimation(),
                                          );
                                        }
                                        return LoginScreen();
                                      });
                                }
                              },
                              stream: FirebaseFirestore.instance
                                  .collection('AppSettings')
                                  .doc('appSettings')
                                  .snapshots(),
                            )),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// isFirstTime ? InitialView() :
