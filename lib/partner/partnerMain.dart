import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/partner/partnerClass.dart';
import 'package:madalh/partner/partnerHome.dart';
import 'package:madalh/partner/settings/partnerSettings.dart';
import 'package:madalh/view/supportScreen/supportScreen.dart';

class PartnerMain extends StatefulWidget {
  const PartnerMain({super.key});

  @override
  State<PartnerMain> createState() => _PartnerMainState();
}

class _PartnerMainState extends State<PartnerMain> {
  PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 150), curve: Curves.easeOutQuad);
  }

  @override
  void initState() {
    // TODO: implement initState
    initPartner();
    super.initState();
  }

  Map data = {};

  initPartner() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mapData = await PartnerClass.getAllData();
      setState(() {
        data = mapData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: null,
          actions: [
            GestureDetector(
              onTap: () {
                navigateTo(
                    supportScreen(
                      customCollection: 'pusers',
                    ),
                    context);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Icon(
                  Bootstrap.headset,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
          title: Text(
            'شريكنا',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              _onItemTapped(index);
            },
            children: [
              PartnerHome(
                data: data.isEmpty ? {
                  'allU':'0',
                  'allA':'0',
                  'allS':'0',
                  'allM':'0',
                } : data,
              ),
              PartnerSettings(doc: data['userDoc'],)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}
