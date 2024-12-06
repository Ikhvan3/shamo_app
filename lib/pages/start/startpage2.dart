import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

class StartPage2 extends StatefulWidget {
  @override
  State<StartPage2> createState() => _StartPage2State();
}

class _StartPage2State extends State<StartPage2> {
  bool isFirstActive = false;
  bool isSecondActive = true;
  bool isThirdActive = false;
  @override
  Widget build(BuildContext context) {
    Widget _buildIndicator(bool isActive) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
            height: 220,
          ),
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/image_start2.png',
                  width: 700,
                ),
                Container(
                  margin: EdgeInsets.only(top: 260),
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
                        "Pengiriman Sayuran ke\nRumah Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Pesan sayuran dari mana saja dan\ndapatkan pengiriman ke rumah Anda.",
                        textAlign: TextAlign.center,
                        style: subtitleTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(isFirstActive),
                          _buildIndicator(isSecondActive),
                          _buildIndicator(isThirdActive),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Update state indikator sebelum navigasi
                          setState(() {
                            isSecondActive = false;
                            isThirdActive = true;
                          });

                          // Tambak delay untuk memastikan animasi terlihat
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.pushNamed(context, '/start3');
                          });
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 15,
                            color: backgroundColor7,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 130, vertical: 15),
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
