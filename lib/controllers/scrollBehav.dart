import 'package:flutter/cupertino.dart';
import 'package:madalh/controllers/systemController.dart';
import 'package:provider/provider.dart';

class NewScrollBehavior extends ScrollBehavior {

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    Consumer<AppService>(
      builder: (_, ___,__) {
        return child;
      }
    );
    return child;
  }
}