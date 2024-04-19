import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madalh/partner/partnerClass.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  PersonalDetailsScreen({required this.doc});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  void _editPersonalDetails() {
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
                  'تعديل المعلومات الشخصية',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: fName,
                  decoration: InputDecoration(labelText: 'الأسم الأول'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lName,
                  decoration: InputDecoration(labelText: 'إسم العائلة'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: country,
                  decoration: InputDecoration(labelText: 'البلد'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: city,
                  decoration: InputDecoration(labelText: 'المدينة'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pNumber,
                  decoration: InputDecoration(labelText: 'رقم الهاتف'),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      PartnerClass.updateUserDoc(
                          widget.doc,
                          {
                            'fName': fName.text,
                            'lName': lName.text,
                            'country': country.text,
                            'city': city.text,
                            'pNumber': pNumber.text,
                          },
                          'personalD',
                          context);
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

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pNumber = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        fName.text = widget.doc['personalD']['fName'];
        lName.text = widget.doc['personalD']['lName'];
        country.text = widget.doc['personalD']['country'];
        city.text = widget.doc['personalD']['city'];
        pNumber.text = widget.doc['personalD']['pNumber'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('المعلومات الشخصية'),
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
                    'الإسم الأول: (${fName.text})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'الإسم الأخير: (${lName.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'البلد: (${country.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'لمدينة: (${city.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'رقم الهاتف: (${pNumber.text})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  _editPersonalDetails();
                },
                child: Text('تعديل المعلومات الشخصية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
