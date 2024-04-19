import 'package:flutter/cupertino.dart';

class HomePageController with ChangeNotifier{
  HomePageController();

  final PageController pageController = PageController();
  setPageController(int index, Duration duration){
    pageController.animateToPage(index, duration: duration, curve: Curves.bounceIn);
    notifyListeners();
  }
}