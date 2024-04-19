import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as constants;

class requestScreen extends StatefulWidget {
  final gender;
  final reqSent;
  final reqRec;
  final requestContainer;

  const requestScreen(
      {Key? key,
      required this.gender,
      required this.reqRec,
      required this.reqSent,
      required this.requestContainer})
      : super(key: key);

  @override
  State<requestScreen> createState() => _requestScreenState();
}

class _requestScreenState extends State<requestScreen> {
  List ReqSent = [];
  List ReqRec = [];

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      setState(() {
        ReqSent = widget.reqSent;
        ReqRec = widget.reqRec;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.gender == 'm'
          ? SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExpansionTileCard(title: Icon(Icons.info), children: [
                      constants.UserInfo(text: 'هنا تجد الطلبات'),
                      constants.UserInfo(text: 'تم القبول و ارسال المعلومات و سيتم اخفائها خلال 4 ايام', iconColor: Colors.green,textColor: Colors.green),
                      constants.UserInfo(text: 'يتم ارسال سؤال و الإجابة عليه قبل الموافقة', iconColor: Colors.orange,textColor: Colors.orange),
                      constants.UserInfo(text: 'طلب مرفوض',iconColor: Colors.red,textColor: Colors.red),
                    ],),
                    ReqSent.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                stream: ReqSent[index].reference.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return widget.requestContainer(
                                      index, snapshot.data['recResType']);
                                },
                              );
                            },
                            itemCount: ReqSent.length,
                            shrinkWrap: true,
                          )
                        : Center(
                          child: constants.smallText(
                              'لم تطلب اي معلومات  لحد الأن', context,color: Colors.red),
                        )
                  ]),
            )
          : SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExpansionTileCard(title: Icon(Icons.info), children: [
                      constants.UserInfo(text: 'هنا تجد الطلبات '),
                      constants.UserInfo(text: 'تم القبول و ارسال المعلومات و سيتم اخفائها خلال 4 ايام', iconColor: Colors.green,textColor: Colors.green),
                      constants.UserInfo(text: 'يتم ارسال سؤال و الإجابة عليه قبل الموافقة', iconColor: Colors.orange,textColor: Colors.orange),
                      constants.UserInfo(text: 'طلب مرفوض',iconColor: Colors.red,textColor: Colors.red),
                    ],),
                    ReqRec.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                stream: ReqRec[index].reference.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return widget.requestContainer(
                                      index, snapshot.data['recResType']);
                                },
                              );
                            },
                            itemCount: ReqRec.length,
                            shrinkWrap: true,
                          )
                        : constants.smallText(
                            'لم يصلك اي طلب معلومات  لحد الأن', context)
                  ]),
            ),
    );
  }
}
