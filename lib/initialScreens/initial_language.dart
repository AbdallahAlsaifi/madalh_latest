import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;

class InitialLanguage extends StatelessWidget {
  const InitialLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Center(child: Text('Welcome'),)
        ],)
      ),
    );
  }
}
