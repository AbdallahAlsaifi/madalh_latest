import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/auth/forgetPassword/resetPassword.dart';
import 'package:madalh/controllers/constants.dart';
import 'package:madalh/homePage.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';


import '../../services/authentication.dart';
import '../loginScreen.dart';
import 'authproviderForget.dart';

class OtpScreenForget extends StatefulWidget {
  final String verificationId;
  final phoneNum;
  final countryCode;

  const OtpScreenForget({
    super.key,
    required this.verificationId,
    required this.phoneNum,
    required this.countryCode,
  });

  @override
  State<OtpScreenForget> createState() => _OtpScreenForgetState();
}

class _OtpScreenForgetState extends State<OtpScreenForget> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProviderForget>(context, listen: true).isLoading;
    return SafeArea(
      child: Stack(

        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            body: ListView(
              children: [
                SafeArea(
                  child: isLoading == true
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                      : Center(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Container(
                              width: 200,
                              height: 200,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.shade50,
                              ),
                              child: SvgPicture.asset('assets/svg/passwordMen.svg')),
                          const SizedBox(height: 20),
                          const Text(
                            "تفعيل الرقم",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "الرجاء ادخال الرمز المرسل الى رقمك",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Pinput(
                            length: 6,
                            showCursor: true,
                            defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.purple.shade200,
                                ),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onCompleted: (value) {
                              setState(() {
                                otpCode = value;
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: FilledButton(
                              child: Text('تفعيل'),
                              onPressed: () {
                                if (otpCode != null) {
                                  verifyOtp(context, otpCode!);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "الرجاء ادخال رمز صحيح");
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // const Text(
                          //   "لم تتلقى اي رمز؟",
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.black38,
                          //   ),
                          // ),
                          // const SizedBox(height: 15),
                          // const Text(
                          //   "ارسال رمز جديد",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.purple,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  // Future<bool> linkUser(Credientials, context) async {
  //   try {
  //     await _auth.currentUser!.linkWithCredential(Credientials);
  //     await _firestore.collection('musers').doc(_auth.currentUser!.uid).update({
  //       'isActive': true,
  //       'pNumber': widget.phoneNum,
  //       'country': widget.countryCode,
  //     });
  //     navigateTo(HomePage(), context);
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     Fluttertoast.showToast(
  //         msg:
  //         ' حدث خطأ ما، يرجى المحاولة مجددا ربما تم حجب رقمك مؤقتا الرجاء المحاولة خلال 59 دقيقة او التواصل مع الدعم الفني');
  //     Fluttertoast.showToast(msg: '$e');
  //
  //     return false;
  //   }
  // }
  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProviderForget>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
       navigateTo(const ResetPassword(), context);

      },
    );
  }
}
