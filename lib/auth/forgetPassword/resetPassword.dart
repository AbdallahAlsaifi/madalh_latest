import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/controllers/constants.dart' as constants;

import '../../controllers/constants.dart';
import '../../main.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isPasswordOk = false;
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
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
          constants.CustomTextField(password, 'كلمة السر', context),
          SizedBox(
            height: 15,
          ),
          constants.CustomTextField(
              passwordConfirmation, 'تاكيد كلمة السر', context,
              onChanged: (vlaue) {
            if (vlaue == password.text && password.text.length >= 7) {
              setState(() {
                isPasswordOk = true;
              });
            } else {
              setState(() {
                isPasswordOk = false;
              });
            }
          }, borderColor: isPasswordOk ? constants.azure1 : Colors.red),
          SizedBox(
            height: 10,
          ),
          constants.smallText('تتكون من 7 احرف فما فوق', context,
              color: isPasswordOk ? Colors.green : Colors.redAccent),
          SizedBox(
            height: constants.screenWidth * 0.3,
          ),
          GestureDetector(
              onTap: () async {
                if (isPasswordOk == true) {
                  try {
                    await FirebaseAuth.instance.currentUser!
                        .updatePassword(passwordConfirmation.text.trim())
                        .then((value) => navigateTo(
                            const MyApp(
                              isLanding: false,

                            ),
                            context));
                  } on FirebaseException catch (e) {
                    Fluttertoast.showToast(
                        msg: 'حدث خطأ ما، يرجى المحاولة مرة أخرى');
                  }
                }
              },
              child: constants.longButton('المتابعة', context,
                  buttonColor: isPasswordOk
                      ? Theme.of(context).primaryColor
                      : constants.greyC))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: passwordForm(),
    );
  }
}
