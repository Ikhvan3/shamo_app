import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

class StartPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildIndicator(bool isActive) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        height: 4,
        width: isActive ? 25 : 7,
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      body: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/image_start1.png',
                  width: 600,
                ),
                Container(
                  margin: EdgeInsets.only(top: 360),
                  height: 376,
                  width: 397,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    color: backgroundColor7,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "Selamat Datang di\nVeggieFresh!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Solusi sehat untuk kebutuhan sayuran segar Anda.",
                        textAlign: TextAlign.center,
                        style: subtitleTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(true),
                          _buildIndicator(false),
                          _buildIndicator(false),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/start2');
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 15,
                            color: backgroundColor7,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: backgroundColor8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}