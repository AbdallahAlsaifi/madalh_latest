import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../services/authentication.dart';
import '../loginScreen.dart';
import 'authproviderForget.dart';

class RegisterScreenForget extends StatefulWidget {
  const RegisterScreenForget({super.key});

  @override
  State<RegisterScreenForget> createState() => _RegisterScreenForgetState();
}

class _RegisterScreenForgetState extends State<RegisterScreenForget> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "970",
    countryCode: "PS",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Palestine",
    example: "Palestine",
    displayName: "Palestine",
    displayNameNoCountryCode: "PS",
    e164Key: "",
  );

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkNumber() async {
    String fpn = phoneController.text.trim();

    String psStart = '+970';
    String ilStart = '+972';

    ///

    final completeNum = '+' + selectedCountry.phoneCode + fpn;

    ///
    bool result = true;
    var users = await FirebaseFirestore.instance.collection('musers').get();
    List usersDocs = users.docs;
    for (var doc in usersDocs) {
      if (doc['pNumber'] == completeNum) {
        setState(() {
          result = false;
        });
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('نسيت كلمة السر'),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple.shade50,
                        ),
                        child:
                            SvgPicture.asset('assets/svg/phoneVerifyWomen.svg'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "تسجيل رقم الهاتف",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "أضف رقم الهاتف و سوف نرسل لك رمز سري",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.purple,
                        controller: phoneController,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          setState(() {
                            phoneController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "رقم هاتفك",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length > 9
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.purple,
                        controller: emailController,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          setState(() {
                            emailController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "البريد الإلكتروني",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                            child: Text("تسجيل الدخول"),
                            onPressed: () async {
                              forgotPassword(email: emailController.text);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future forgotPassword({required String email}) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Question',
        desc: err.message.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      // throw Exception(err.message.toString());
    } catch (err) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Question',
        desc: err.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      // throw Exception(err.toString());
    }
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProviderForget>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber",
        selectedCountry.countryCode);
  }
}
