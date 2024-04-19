import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;

class messagesScreen extends StatefulWidget {
  const messagesScreen({Key? key}) : super(key: key);

  @override
  State<messagesScreen> createState() => _messagesScreenState();
}

class _messagesScreenState extends State<messagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendQuestion(BuildContext context, docId) {
    showDialog(
      context: context,
      builder: (x) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                constants.smallText('إرسال رسالة للمستخدم', context,
                    color: Colors.red),
                constants.UserInfo(text: 'ترسل لمرة واحدة فقط'),
                Container(
                    padding: EdgeInsets.all(3),
                    width: constants.screenWidth * 0.8,
                    child: TextField(
                        controller: controller,
                        minLines: 3,
                        maxLines: 6,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            label: Text(
                              'الرسالة',
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder())))
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent)),
                    child: Text("الغاء"),
                    onPressed: () {
                      Navigator.of(x).pop();
                    },
                  ),
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    child: Text("إرسال"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('messages')
                          .doc(docId)
                          .update({'question': controller.text, 'status': 1});
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  void _sendAnswer(BuildContext context, docId) {
    showDialog(
      context: context,
      builder: (x) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                constants.smallText('إرسال رد على الرسالة', context,
                    color: Colors.red),
                constants.UserInfo(text: 'ترسل لمرة واحدة فقط'),
                Container(
                    padding: EdgeInsets.all(3),
                    width: constants.screenWidth * 0.8,
                    child: TextField(
                        controller: controller,
                        minLines: 3,
                        maxLines: 6,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            label: Text(
                              'الرد',
                              textDirection: TextDirection.rtl,
                            ),
                            border: OutlineInputBorder())))
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent)),
                    child: Text("الغاء"),
                    onPressed: () {
                      Navigator.of(x).pop();
                    },
                  ),
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                    child: Text("إرسال"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('messages')
                          .doc(docId)
                          .update({'answer': controller.text, 'status': 3});
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  msgContainers(int status, List<QueryDocumentSnapshot> ds, int index) {
    if (status == 0) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Bootstrap.chat_fill,
                color: Colors.red,
              ),
              Text(
                'لقد تم رفض الرسالة',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 1) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار موافقة الإدارة'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 2) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Bootstrap.chat_fill,
                color: Colors.orange,
              ),
              Text(
                'محاولة أخرى',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        children: [
          constants.UserInfo(
              text: 'لقد تم رفض رسالتك و اعطائك محاولة أخرى',
              iconColor: Colors.red,
              textColor: Colors.red),
          Container(
            height: 15,
          ),
          FilledButton(
              onPressed: () {
                _sendQuestion(context, ds[index].id);
              },
              child: Text('رسالة جديدة')),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 3) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار رد المستخدم'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 4) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار رد المستخدم'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 5) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار رد المستخدم'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 6) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('تم إستلام الرد'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار موافقة الإدارة'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    }
  }

  msgContainers2(int status, List ds, int index) {
    if (status == 0) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Bootstrap.chat_fill,
                color: Colors.red,
              ),
              Text(
                'لقد تم رفض الرسالة',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 1) {
      return Container();
    } else if (status == 2) {
      return Container();
    } else if (status == 3) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار موافقة الإدارة على ردك'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 4) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Bootstrap.chat_fill,
                color: Colors.orange,
              ),
              Text(
                'محاولة أخرى',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        children: [
          constants.UserInfo(
              text: 'لقد تم رفض ردك و اعطائك محاولة أخرى',
              iconColor: Colors.red,
              textColor: Colors.red),
          Container(
            height: 15,
          ),
          FilledButton(
              onPressed: () {
                _sendAnswer(context, ds[index].id);
              },
              child: Text('رد جديدة')),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 5) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('لديك رسالة جديدة'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          FilledButton(
              onPressed: () {
                _sendAnswer(context, ds[index].id);
              },
              child: Text('رد جديدة')),
          Container(
            height: 15,
          ),
        ],
      );
    } else if (status == 6) {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('تم إستلام الرد'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    } else {
      return ExpansionTileCard(
        title: Container(
          width: constants.screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Bootstrap.chat_fill),
              Text('بإنتظار موافقة الإدارة'),
            ],
          ),
        ),
        children: [
          Container(
            height: 15,
          ),
          Text(
            'الرسالة',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Text('${ds[index]['question']}'),
          Text('الإجابة',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          Text('${ds[index]['answer']}'),
          Container(
            height: 15,
          ),
        ],
      );
    }
  }

  String gender = 'f';

  getData() async {
    var snap =
        await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();
    setState(() {
      gender = snap.data()!['gender'];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return gender == 'f' ? SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: constants.smallText('الرسائل', context),
          centerTitle: true,
        ),
        body: Column(

          children: [
            ExpansionTileCard(
              title: Icon(Icons.info),
              children: [
                Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '''يحق لكل أنثى أن ترسل رسالة لمرة واحدة لكل ملف و عليه سيترتب وصول إجابة من الطرف الآخر بعد موافقة الإدارة على السؤال من اجل التأكد بأن الرسالة لا يحتوي على:  
                       1. الفاظ بذية
                        2. طريقة تواصل خارجية 
                        3. سؤال أو إجابة غير لائقة''',
                        textDirection: TextDirection.rtl,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: constants.screenHeight * 0.01,
            ),
            StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .where('senId', isEqualTo: _auth.currentUser!.uid).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                List<QueryDocumentSnapshot> ds = snapshot.data.docs;
                return Expanded(
                  child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                    return msgContainers(ds[index]['status'], ds, index);
                  },itemCount: ds.length,shrinkWrap: true,),
                );
              },
            ) ,
          ],
        ),
      ),
    ) : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: constants.smallText('الرسائل', context),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTileCard(
                title: Icon(Icons.info),
                children: [
                  Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '''يحق لكل أنثى أن ترسل رسالة لمرة واحدة لكل ملف و عليه سيترتب وصول إجابة من الطرف الآخر بعد موافقة الإدارة على السؤال من اجل التأكد بأن الرسالة لا يحتوي على:  
                         1. الفاظ بذية
                          2. طريقة تواصل خارجية 
                          3. سؤال أو إجابة غير لائقة''',
                          textDirection: TextDirection.rtl,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: constants.screenHeight * 0.1,
              ),
              StreamBuilder(
                stream: _firestore
                    .collection('messages')
                    .where('recId', isEqualTo: _auth.currentUser!.uid).snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<QueryDocumentSnapshot> ds = snapshot.data.docs;
                  if(snapshot.hasError){
                    return Center(child: constants.smallText('ليس لديك رسائل', context,color: Colors.redAccent),);
                  }else if(snapshot.hasData){
                    return Center(child: constants.smallText('ليس لديك رسائل', context, color: Colors.redAccent),);
                  }else{
                    return Expanded(
                      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                        return msgContainers2(ds[index]['status'], ds, index);
                      },itemCount: ds.length,shrinkWrap: true,),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
