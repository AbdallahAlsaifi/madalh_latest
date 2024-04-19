import 'package:flutter/material.dart';

import '../controllers/constants.dart';

class ImageScreen extends StatefulWidget {
  final url;
  const ImageScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: Icon(Icons.arrow_back, color:  Colors.black,)),
        title: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: Text('رجوع', style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: InteractiveViewer(
        child: Container(
          width: screenWidth,height: screenHeight,child: Center(child: widget.url,),
        ),
      ),);
  }
}
