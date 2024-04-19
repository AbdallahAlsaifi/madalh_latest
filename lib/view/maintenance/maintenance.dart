import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:madalh/controllers/constants.dart' as cons;
import 'package:madalh/homePage.dart';

class maintenance extends StatefulWidget {
  const maintenance({Key? key}) : super(key: key);

  @override
  State<maintenance> createState() => _maintenanceState();
}

class _maintenanceState extends State<maintenance> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: cons.screenHeight*0.1,),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          'assets/svg/logoWithoutBackground.svg',
                          width: cons.screenWidth * 0.25,
                          height: cons.screenWidth * 0.25,
                        ),
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/EnglishName.svg',
                            width: cons.screenWidth * 0.5,
                          ),
                          Container(
                            height: 5,
                          ),
                          SvgPicture.asset(
                            'assets/svg/AraicName.svg',
                            width: cons.screenWidth * 0.5,
                          ),
                        ],
                      )
                    ],
                  ),
                  Container( padding: EdgeInsets.all(5),width: cons.screenWidth,
                      height: cons.screenHeight*0.5 ,child: Image.asset('assets/videos/maintenance.gif')),

                ],
              ),
              AnimatedTextKit(totalRepeatCount: 10, animatedTexts: [
                TypewriterAnimatedText('البرنامج تحت الصيانة',
                    textAlign: TextAlign.center,
                    cursor: ' ',
                    textStyle: TextStyle(fontSize: cons.screenWidth * 0.08),
                    speed: Duration(milliseconds: 50)),TypewriterAnimatedText('نحن نعمل بأقصى جهد ',
                    textAlign: TextAlign.center,
                    cursor: ' ',
                    textStyle: TextStyle(fontSize: cons.screenWidth * 0.08),
                    speed: Duration(milliseconds: 50)),
                TypewriterAnimatedText('لنقدم لكم أفضل تجربة',
                    textAlign: TextAlign.center,
                    cursor: ' ',
                    textStyle: TextStyle(fontSize: cons.screenWidth * 0.08),
                    speed: Duration(milliseconds: 50)),
                TypewriterAnimatedText('سيصلك إشعار عند عودتنا',
                    textAlign: TextAlign.center,
                    cursor: ' ',
                    textStyle: TextStyle(fontSize: cons.screenWidth * 0.08),
                    speed: Duration(milliseconds: 50)),
                TypewriterAnimatedText('شكرا لتفهمكم',
                    textAlign: TextAlign.center,
                    cursor: ' ',
                    textStyle: TextStyle(fontSize: cons.screenWidth * 0.08),
                    speed: Duration(milliseconds: 50))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
