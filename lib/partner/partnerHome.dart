import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class PartnerHome extends StatefulWidget {
  final data;
  const PartnerHome({super.key, required this.data});

  @override
  State<PartnerHome> createState() => _PartnerHomeState();
}

class _PartnerHomeState extends State<PartnerHome> {
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
            _customCard('المستخديين', widget.data['allU'], screenWidth*0.45, Icons.perm_identity),
            _customCard('الفعالين', widget.data['allA'], screenWidth*0.45, Icons.check_box),
            _customCard('المشتركين', widget.data['allS'], screenWidth*0.45, Bootstrap.ticket),
            _customCard('المتطابقين', widget.data['allM'], screenWidth*0.45, Icons.people_alt_outlined),
            _customCard('البرومو كود', widget.data['userDoc']['promoCode'], screenWidth*0.91, Icons.qr_code, onPress: (){
              Clipboard.setData(ClipboardData(text: widget.data['userDoc']['promoCode']));
      
              // Show a snackbar to indicate that text has been copied
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم نسخ الكود بنجاح'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  _customCard(String title, String value, double screenWidth, IconData icon, {height, VoidCallback? onPress}){
    return GestureDetector(
      onTap: (){
        onPress!();
      },
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
