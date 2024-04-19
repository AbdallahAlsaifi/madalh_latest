import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';

enum PaymentStatus { initial, processing, success, error }

class PaymentNotifier extends ChangeNotifier {
  PaymentStatus _paymentStatus = PaymentStatus.initial;
  String userMail = FirebaseAuth.instance.currentUser!.email!;

  PaymentStatus get paymentStatus => _paymentStatus;

  Future<String> initPayment({
    required String email,
    required double amount,
  }) async {
    String result = 'error';
    try {
      // 1. Create a payment intent on the server

      final response = await http.post(
          Uri.parse(
              'https://us-central1-madalh.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = json.decode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'MaDalah',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      ));
      await Stripe.instance.presentPaymentSheet();
      //TODO: IF CORRECT

      result = 'true';
    } catch (errorr) {
      if (errorr is StripeException) {
        //TODO:IF STRIPE ERROR
        print("+++++" + errorr.error.localizedMessage.toString());
        _paymentStatus = PaymentStatus.error;
        notifyListeners();
        result = "false";
      } else {
        //TODO:IF ERROR
        _paymentStatus = PaymentStatus.error;
        notifyListeners();
        result = "false";
        print(errorr);
      }
    }
    return result;
  }

  initiatePayment({ context, amount, matches, messages ,String gender = 'm'}) async {
    _paymentStatus = PaymentStatus.processing;
    notifyListeners();

    String x = await initPayment(
      email: userMail,
      amount: amount,
    );

    if (x == 'true') {
      if (gender != 'm') {
        await FirebaseFirestore.instance
            .collection('musers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'fmatches': matches,
          'isSubscribed': true,
          'subscriptionDate': DateTime.now(),
          'messages': messages,
          'bundleMatches': matches,
          'bundleMessages': messages,

        });
      } else {
        await FirebaseFirestore.instance
            .collection('musers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'matches': matches,
          'isSubscribed': true,
          'subscriptionDate': DateTime.now(),
          'bundleMatches': matches,
        });
      }
      _paymentStatus = PaymentStatus.success;

      notifyListeners();
      // Dialogs.materialDialog(
      //     color: Colors.white,
      //     msg: 'تم إكمال العملية بنحاج',
      //     title: '',
      //     lottieBuilder: Lottie.asset(
      //       'assets/success.json',
      //       fit: BoxFit.contain,
      //     ),
      //     context: context,
      //     actions: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           FilledButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: Text('حسنا')),
      //         ],
      //       )
      //     ]);
    } else {
      _paymentStatus = PaymentStatus.error;
      notifyListeners();
      // Dialogs.materialDialog(
      //     color: Colors.white,
      //     msg: 'حدث خطأ ما تسبب في عدم إكمال العملية، يرجى المحاولة مجددا',
      //     title: '',
      //     lottieBuilder: Lottie.asset(
      //       'assets/error.json',
      //       fit: BoxFit.contain,
      //     ),
      //     context: context,
      //     actions: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           FilledButton(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               child: Text('حسنا')),
      //         ],
      //       )
      //     ]);
    }
  }
}
