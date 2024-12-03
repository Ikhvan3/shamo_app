import 'package:flutter/material.dart';

import 'startpage1.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          StartPage1(
              onNext: () => _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease)),
          Page2(
              onNext: () => _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease)),
          Page3(),
        ],
      ),
    );
  }
}
