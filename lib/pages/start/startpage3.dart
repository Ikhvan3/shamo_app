import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

class StartPage3 extends StatelessWidget {
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
      backgroundColor: backgroundColor9,
      body: Column(
        children: [
          SizedBox(
            height: 110,
          ),
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/logo_scan.png',
                ),
                Container(
                  margin: EdgeInsets.only(top: 310),
                  height: 436,
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
                        height: 50,
                      ),
                      Text(
                        "Scan QR Code untuk Informasi Lengkap Sayuran Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Dengan memindai kode QR pada kemasan produk,\nAnda bisa mengetahui nutrisi dan manfaat sayuran secara lengkap",
                          textAlign: TextAlign.center,
                          style: subtitleTextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(false),
                          _buildIndicator(false),
                          _buildIndicator(true),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                        child: Text(
                          "Buat Profil",
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
                              horizontal: 110, vertical: 15),
                          backgroundColor: backgroundColor8,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 15,
                            color: HijauTuaTextColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 105, vertical: 15),
                          backgroundColor: backgroundColor3,
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
