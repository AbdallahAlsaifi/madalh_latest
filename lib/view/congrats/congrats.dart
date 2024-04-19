import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as cons;
import 'package:madalh/homePage.dart';

class congrats extends StatefulWidget {
  const congrats({Key? key}) : super(key: key);

  @override
  State<congrats> createState() => _congratsState();
}

class _congratsState extends State<congrats> {




  getCongrats()async{
    var snap = await cons.firestore.collection('AppSettings').doc('appSettings').get();
    setState(() {
      message = snap.data()!['congratsMsg'];
    });
  }
  String message = '';

  @override
  void initState() {
    // TODO: implement initState
    getCongrats();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: cons.screenWidth, height: cons.screenHeight * 0.2, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: (){
             Navigator.of(context).pop();
            },
            child: cons.longButton('المتابعة', context,
                buttonColor: Theme
                    .of(context)
                    .primaryColor),
          ),
        ],
      ),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/videos/party1.gif'),
            Container(
              width: cons.screenWidth *0.9,
              height: cons.screenHeight * 0.2,
              child: Image.asset('assets/videos/party3.gif', fit: BoxFit.cover,),),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cons.smallText(message, context, color: Colors.red),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
