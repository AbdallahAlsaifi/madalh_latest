import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:uuid/uuid.dart';

import '../../controllers/scrollBehav.dart';

class supportScreen extends StatefulWidget {
  String? customCollection;
   supportScreen({Key? key, this.customCollection}) : super(key: key);

  @override
  State<supportScreen> createState() => _supportScreenState();
}

class _supportScreenState extends State<supportScreen> {
  TextEditingController chatMsgController = TextEditingController();



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  sendMsg()async{
    try{
      setState(() {
        isLoading = true;
      });
      String MsgUid = Uuid().v1();
      _firestore
          .collection(widget.customCollection == null ? 'musers' : widget.customCollection!)
          .doc(_auth.currentUser!.uid)
          .collection(
          'support${_auth.currentUser!.uid}').doc(MsgUid).set({
        "msgUid":MsgUid,
        "text":chatMsgController.text,
        "date":DateTime.now(),
        "uid": _auth.currentUser!.uid,
        "userSaw": true,
        "adminSaw":false,
      });
      chatMsgController.clear();
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }


  Widget Msg(String uid, String text, date) {
    Widget finalMsg = Container();
    List<Widget> MsgBox = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                margin: const EdgeInsets.all(10),
                constraints:
                    BoxConstraints(maxWidth: constants.screenWidth * 0.4),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  date.toDate().toString().split('.')[0],
                  style:  TextStyle(color: Colors.grey, fontSize: constants.screenWidth*0.03),
                ),
              )
            ],
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                margin: const EdgeInsets.all(10),
                constraints:
                BoxConstraints(maxWidth: constants.screenWidth * 0.4),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  date.toDate().toString().split('.')[0],
                  style:  TextStyle(color: Colors.grey, fontSize: constants.screenWidth*0.03),
                ),
              )
            ],
          ),
        ],
      ),
    ];
    if (uid == _auth.currentUser!.uid) {

        finalMsg = MsgBox[0];

    } else {

        finalMsg = MsgBox[1];

    }
    return finalMsg;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.7,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).primaryColor,
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Bootstrap.headset,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
          title: Text(
            'الدعم الفني',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                    child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> items = snapshot.data!.docs;
                  return ScrollConfiguration(
                    behavior: NewScrollBehavior(),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Msg(items[index]['uid'], items[index]['text'],
                            items[index]['date']);
                      },
                      itemCount: items.length,
                      shrinkWrap: true,
                    ),
                  );
                }
                return const Center(child: Text('ليس هناك محادثات'));
              },
              stream: widget.customCollection == null ? _firestore
                  .collection('musers')
                  .doc(_auth.currentUser!.uid)
                  .collection(
                      'support${_auth.currentUser!.uid}').orderBy('date', descending: false)
                  .snapshots() : _firestore
                  .collection(widget.customCollection!)
                  .doc(_auth.currentUser!.uid)
                  .collection(
                  'support${_auth.currentUser!.uid}').orderBy('date', descending: false)
                  .snapshots(),
            ))),
            Container(
              padding: EdgeInsets.all(5),
              width: constants.screenWidth,
              child: FittedBox(
                child: Row(
                  children: [
                    constants.CustomTextField(
                        chatMsgController, 'اضف رسالتك', context,
                        obsecure: false),
                    Container(
                      width: 5,
                    ),
                    FilledButton(onPressed: () { 
                      if(chatMsgController.text.length > 3){
                        if(isLoading == false){
                          sendMsg();
                        }
                      }else{
                        Fluttertoast.showToast(msg: 'ليس هناك شيئ لإرساله');
                      }
                    } , child: Text('أرسل'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
