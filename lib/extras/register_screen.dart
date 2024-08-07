import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../auth/loginScreen.dart';
import '../services/authentication.dart';
import 'auth_provider.dart' as authP;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

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
    debugPrint(fpn);
    String psStart = '+970';
    String ilStart = '+972';

    // ///

    // String ilN = ilStart + fpn;
    // String psN = psStart + fpn;
    // debugPrint(ilN);
    // debugPrint(psN);
    debugPrint(selectedCountry.phoneCode);
    // debugPrint(('+' + ilStart));

    // ///
    bool result = true;
    var users = await FirebaseFirestore.instance.collection('musers').get();
    List usersDocs = users.docs;
    if (('+' + selectedCountry.phoneCode) == (ilStart) ||
        ('+' + selectedCountry.phoneCode) == (psStart)) {
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
        if (doc['pNumber'] == "+${selectedCountry.phoneCode}$fpn") {
          setState(() {
            result = false;
          });
        }
      }
    }
    return result;
  }

  bool loadingOn = false;
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Consumer<authP.AuthProvider>(builder: (_, authpro, __) {
      return LoadingOverlay(
        isLoading: authpro.isLoading,
        progressIndicator: constants.loadingAnimation(),
        color: Colors.white,
        child: Stack(
          children: [
            SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.shade50,
                          ),
                          child: SvgPicture.asset(
                              'assets/svg/phoneVerifyWomen.svg'),
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
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                              child: Text("تأكيد"),
                              onPressed: () async {
                                authpro.setIsLoading(1);
                                bool x = await checkNumber();
                                if (x == true) {
                                  try {
                                    sendPhoneNumber();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                  // Fluttertoast.showToast(msg: 'الرقم جديد');
                                } else {
                                  authpro.setIsLoading(0);
                                  Fluttertoast.showToast(
                                      msg: 'الرقم مسجل بحساب آخر');
                                }
                              }),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.redAccent)),
                  onPressed: () async {
                    await FirebaseCustomAuth().SignOut().then((value) =>
                        constants.navigateTo(const LoginScreen(), context));
                  },
                  child: Text('الخروج'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void sendPhoneNumber() {
    final ap = Provider.of<authP.AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber",
        selectedCountry.countryCode);
  }
}
