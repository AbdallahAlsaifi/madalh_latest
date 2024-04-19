import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/homePage.dart';
import 'package:madalh/view/paymentScreen/paypal/paymentConstants.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:provider/provider.dart';

import '../../controllers/paymentController.dart';
import '../../controllers/systemController.dart';

class FemaleBundleScreen extends StatefulWidget {
  final bool isError;
  final bool isSuccess;
  final bool isNoMatches;

  FemaleBundleScreen({
    Key? key,
    this.isError = true,
    this.isSuccess = true,
    this.isNoMatches = true,
  }) : super(key: key);

  @override
  State<FemaleBundleScreen> createState() => _FemaleBundleScreenState();
}

class _FemaleBundleScreenState extends State<FemaleBundleScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var BundleData = {};
  int BundleLength = 0;
  bool isSuccess = false;
  bool isError = false;

  getData() async {
    var snap = await _firestore.collection('AppSettings').doc('mBundles').get();
    setState(() {
      BundleData = snap.data()!;
      BundleLength = BundleData.length;
      dialogFlag = widget.isNoMatches;
    });
  }

  bool dialogFlag = true;

  void _showDialog(BuildContext context) {
    if (!dialogFlag) {
      setState(() {
        dialogFlag = true;
      });
      showDialog(
        context: context,
        builder: (x) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/completeProfileMenColor.svg',
                    width: constants.screenWidth * 0.8,
                  ),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    displayFullTextOnTap: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'عزيزي المستخدم لتستطيع النكز على الملفات حيث يتجاوز التطابق فيها 65% يجب عليك الإشتراك',
                        textAlign: TextAlign.end,
                        speed: Duration(milliseconds: 60),
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: Text("حسنا"),
                      onPressed: () {
                        Navigator.of(x).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData().then((_) {
      setTrue();
    });

    super.initState();
  }

  setTrue() {
    setState(() {
      isError = widget.isError;
      isSuccess = widget.isSuccess;
    });
    print('########');
    print(isError);
    print(isSuccess);
  }

  _errorDialog(context) {
    if (!isError) {
      setState(() {
        isError = true;
      });
      Dialogs.materialDialog(
          color: Colors.white,
          msg: 'حدث خطأ ما تسبب في عدم إكمال العملية، يرجى المحاولة مجددا',
          title: '',
          lottieBuilder: Lottie.asset(
            'assets/error.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: () {
                      setState(() {
                        isError = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('حسنا')),
              ],
            )
          ]);
    }
  }

  _successDialog(context) {
    if (!isSuccess) {
      setState(() {
        isSuccess = true;
      });
      Dialogs.materialDialog(
          color: Colors.white,
          msg: 'تم إكمال العملية بنحاج',
          title: '',
          lottieBuilder: Lottie.asset(
            'assets/success.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('حسنا')),
              ],
            )
          ]);
    }
  }

  _buildPaymentStatusWidget(PaymentNotifier data) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            height: constants.screenHeight * 0.7,
            child: Swiper(
              layout: SwiperLayout.TINDER,
              itemWidth: constants.screenWidth * 0.9,
              itemHeight: constants.screenHeight * 0.7,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(
                    constants.screenWidth * 0.05,
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                constants.smallText(' نكزات يومية', context,
                                    color: Colors.redAccent),
                                constants.smallText(
                                    BundleData['bundle${index + 1}']['fmatches']
                                        .toString(),
                                    color: Colors.redAccent,
                                    context),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                constants.smallText(' رسائل يومية', context,
                                    color: Colors.redAccent),
                                constants.smallText(
                                    BundleData['bundle${index + 1}']['messages']
                                        .toString(),
                                    color: Colors.redAccent,
                                    context),
                              ],
                            ),
                          ),
                          Divider(),
                          Wrap(
                            children: [
                              constants.UserInfo(
                                  text: BundleData['bundle${index + 1}']
                                      ['desc'])
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Bootstrap.check_circle,
                                  color: Colors.green,
                                  size: constants.screenWidth * 0.1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('دفع آمن'),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Bootstrap.check_circle,
                                  color: Colors.green,
                                  size: constants.screenWidth * 0.1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('أفضل الأسعار'),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Bootstrap.check_circle,
                                  color: Colors.green,
                                  size: constants.screenWidth * 0.1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('خصوصية تامة'),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Bootstrap.clock,
                                  color: Colors.green,
                                  size: constants.screenWidth * 0.1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('يوم'),
                                    Text(' 30 '),
                                    Text('لمدة'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.redAccent)),
                                  onPressed: () {},
                                  child: Text(
                                    '${BundleData['bundle${index + 1}']['price'].toString()} \$',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FilledButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.green)),
                                  onPressed: ()  {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>

                                          PaypalCheckout(
                                            sandboxMode: sandBoxMode,
                                            clientId: ck,
                                            secretKey: sk,
                                            returnURL: "appers.org",
                                            cancelURL: "appers.org",
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": '${BundleData['bundle${index + 1}']['offerPrice']}',
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": '${BundleData['bundle${index + 1}']['offerPrice']}',
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description": "${BundleData['bundle${index + 1}']['desc']}",
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "Bundle",
                                                      "quantity": 1,
                                                      "price": '${BundleData['bundle${index + 1}']['offerPrice']}',
                                                      "currency": "USD"
                                                    }
                                                  ],
                                                  // shipping address is Optional
                                                  // "shipping_address": {
                                                  //   "recipient_name": "Raman Singh",
                                                  //   "line1": "Delhi",
                                                  //   "line2": "",
                                                  //   "city": "Delhi",
                                                  //   "country_code": "IN",
                                                  //   "postal_code": "11001",
                                                  //   "phone": "+00000000",
                                                  //   "state": "Texas"
                                                  // },
                                                }
                                              }
                                            ],
                                            note: "PAYMENT_NOTE",
                                            onSuccess: (Map params) async {
                                              print("onSuccess: $params");
                                              await FirebaseFirestore.instance
                                                  .collection('musers')
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .update({
                                                'fmatches': BundleData['bundle${index + 1}']['fmatches'],
                                                'isSubscribed': true,
                                                'subscriptionDate': DateTime.now(),
                                                'messages': BundleData['bundle${index + 1}']['messages'],
                                                'bundleMatches': BundleData['bundle${index + 1}']['fmatches'],
                                                'bundleMessages': BundleData['bundle${index + 1}']['messages']

                                              });
                                              _successDialog(context);
                                            },
                                            onError: (error) {
                                              print("onError: $error");
                                              Navigator.pop(context);
                                              _errorDialog(context);
                                            },
                                            onCancel: () {
                                              print('cancelled:');
                                            },
                                          ),

                                    ));
                                    /// Change to paypal

                                    // await data.initiatePayment(
                                    //   context: context,
                                    //   matches: BundleData['bundle${index + 1}']
                                    //       ['fmatches'],
                                    //   gender: 'f',
                                    //   amount: BundleData['bundle${index + 1}']
                                    //               ['offerPrice']
                                    //           .toDouble() *
                                    //       100,
                                    //   messages: BundleData['bundle${index + 1}']
                                    //       ['messages'],
                                    // );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '${BundleData['bundle${index + 1}']['offerPrice'].toString()} \$',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '  إشتراك  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: constants.screenHeight * 0.1,
                          width: constants.screenWidth * 0.1,
                          child: Center(
                            child: constants.smallText('%', context),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: BundleLength,
              pagination: const SwiperPagination(
                  builder: SwiperPagination.dots, margin: EdgeInsets.all(10)),
              // control: const SwiperControl( ).
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _showDialog(context);
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: constants.screenWidth * 0.1,
            margin: EdgeInsets.only(left: constants.screenWidth * 0.1),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: constants.screenHeight * 0.10,
        title: constants.smallText('العروض', context),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(constants.screenWidth * 0.1),
                  bottomRight: Radius.circular(constants.screenWidth * 0.1)),
              gradient: Theme.of(context).primaryColor == constants.femaleSwatch
                  ? constants.femaleG
                  : constants.maleG),
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PaymentNotifier>(
            create: (context) => PaymentNotifier(),
          ),
        ],
        child: Consumer<PaymentNotifier>(builder: (__, data, _) {
          switch (data.paymentStatus) {
            case PaymentStatus.initial:
              return _buildPaymentStatusWidget(data);
            case PaymentStatus.processing:
              return Center(
                child: constants.loadingAnimation(),
              );
            case PaymentStatus.success:
              return _buildPaymentStatusWidget(data);

            case PaymentStatus.error:
              return _buildPaymentStatusWidget(data);

            default:
              return Container();
          }
        }),
      ),
    );
  }
}
