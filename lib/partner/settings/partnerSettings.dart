import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/auth/loginScreen.dart';
import 'package:madalh/controllers/constants.dart';
import 'package:madalh/partner/settings/personalDetails.dart';

import 'bankDetails.dart';

class PartnerSettings extends StatefulWidget {
  final doc;
  const PartnerSettings({super.key, required this.doc});

  @override
  State<PartnerSettings> createState() => _PartnerSettingsState();
}

class _PartnerSettingsState extends State<PartnerSettings> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _showChangePasswordDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext contextz) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('تغيير كلمة السر', style: TextStyle(fontWeight: FontWeight.bold),),
              TextField(
                controller: _oldpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "كلمة السر الحالية",
                ),
              ),TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "كلمة السر الجديدة",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(contextz).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  _changePassword(_passwordController.text.trim(), _oldpasswordController.text.trim());
                  Navigator.of(contextz).pop();
                },
                child: Text("Change"),
              ),
            ],
          ),

        );
      },
    );
  }

  Future<void> _changePassword(String newPassword, String oldPassword) async {
    try {
      User user = _auth.currentUser!;
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email!, password: oldPassword);
      await user.updatePassword(newPassword);
      // Password changed successfully
      MsgDialog(context,"تم تغيير كلمة السر بنجاح");
      _passwordController.clear();
      _oldpasswordController.clear();
    } catch (error) {
      // Error occurred while changing password
      MsgDialog(context,"حدث خطأ ما يمكنك المحاولة لاحقا: تاكد من كلمة السر الحالية");
      _passwordController.clear();
      _oldpasswordController.clear();

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            _customCard('إجمالي المستحقات', '\$${widget.doc['totalEarnings'].toStringAsFixed(2)}', screenWidth*0.90, Icons.monetization_on),
            _customCard('المعلومات البنكية', '', screenWidth*0.90, Bootstrap.bank, onPress: (){
              navigateTo(BankDetailsScreen(doc: widget.doc,), context);
            }),
            _customCard('معلومات التواصل', '', screenWidth*0.90, Bootstrap.info, onPress: (){
              navigateTo(PersonalDetailsScreen(doc: widget.doc,), context);
            }),
            _customCard('تغيير كلمة السر', "", screenWidth*0.90, Icons.password, onPress: (){
              _showChangePasswordDialog();
            }),
            _customCard('تسجيل الخروج', '', screenWidth*0.90, Icons.logout, onPress: ()async{
             await FirebaseAuth.instance.signOut();
            }),

          ],
        ),
      ),
    );
  }

  _customCard(String title, String value, double screenWidth, IconData icon, {height, VoidCallback? onPress}){
    return GestureDetector(
      onTap: onPress,
      child: Card(
        elevation: 3,
        child: Container(
          width: screenWidth,
          height: height ?? 160,
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(icon, size: 27,),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),

            ],),
          ),
        ),
      ),
    );
  }
}
