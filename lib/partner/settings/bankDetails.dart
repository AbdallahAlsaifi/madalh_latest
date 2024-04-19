import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madalh/partner/partnerClass.dart';

class BankDetailsScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  BankDetailsScreen({required this.doc});
  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  void _editBankDetails() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext contextx) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column( 
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعديل المعلومات البنكية',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: oName,
                  decoration: InputDecoration(labelText: 'معلومات صاحب الحساب'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: iban,
                  decoration: InputDecoration(labelText: 'رقم الحساب'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: bName,
                  decoration: InputDecoration(labelText: 'اسم البنك'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: bbName,
                  decoration: InputDecoration(labelText: 'معلومات الفرع'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: sCode,
                  decoration: InputDecoration(labelText: 'سويفت كود'),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      PartnerClass.updateUserDoc(widget.doc, {
                        'oName':oName.text,
                        'iban':iban.text,
                        'bName':bName.text,
                        'bbName':bbName.text,
                        'sCode':sCode.text,
            
                      }, 'bankD', context);
                      Navigator.pop(contextx); // Close the bottom sheet
                    },
                    child: Text('حفظ'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController oName = TextEditingController();
  TextEditingController sCode = TextEditingController();
  TextEditingController bbName = TextEditingController();
  TextEditingController iban = TextEditingController();
  TextEditingController bName = TextEditingController();

  
 @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_) {
     setState(() {
       oName.text = widget.doc['bankD']['oName'];
       sCode.text = widget.doc['bankD']['sCode'];
       bbName.text = widget.doc['bankD']['bbName'];
       iban.text = widget.doc['bankD']['iban'];
       bName.text = widget.doc['bankD']['bName'];
     });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Bank Details'),
      ),
      body: Padding( 
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'إسم صاحب الحساب: (${oName.text})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'رقم الحساب: (${iban.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'إسم البنك: (${bName.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'معلومات الفرع: (${bbName.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'سويفت كود: (${sCode.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  _editBankDetails();
                },
                child: Text('تعديل المعلومات البنكية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}