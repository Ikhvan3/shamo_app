import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

import '../home/home_page.dart';

class StartPage3 extends StatefulWidget {
  @override
  State<StartPage3> createState() => _StartPage3State();
}

class _StartPage3State extends State<StartPage3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durasi animasi
    );

    // Definisikan animasi linear untuk garis biru
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Mulai animasi ketika halaman dimuat
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget _buildIndicator3() {
      // Tambahkan pengecekan saat membangun animasi
      if (!_controller.isAnimating && !_controller.isCompleted) {
        return SizedBox(
          width: 25, // Lebar default
          height: 4,
          child: Container(color: transparentColor),
        );
      }

      return AnimatedBuilder(
        animation: _lineAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 25 * _lineAnimation.value,
            height: 4,
          );
        },
      );
    }

    Widget _buildIndicator1() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        width: 7, // Panjang total garis putih
        height: 4,
      );
    }

    Widget _buildIndicator2() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        width: 7, // Panjang total garis putih
        height: 4,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.5),
                  child: Image.asset(
                    'assets/logo_scan.png',
                    width: size.width * 1,
                    height: size.height * 1,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // margin: EdgeInsets.only(top: 350),
                    height: size.height * 0.6,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                      color: backgroundColor7,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.04),
                        Text(
                          "Scan QR Code untuk Informasi Lengkap Sayuran Anda",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Dengan memindai kode QR pada kemasan produk,\nAnda bisa mengetahui nutrisi dan manfaat sayuran secara lengkap",
                            textAlign: TextAlign.center,
                            style: subtitleTextStyle.copyWith(
                              fontWeight: semiBold,
                              fontSize: size.width * 0.030,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildIndicator1(),
                            _buildIndicator2(),
                            _buildIndicator3(),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign-up');
                          },
                          child: Text(
                            "Buat Profil",
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              color: backgroundColor7,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.3,
                                vertical: size.height * 0.02),
                            backgroundColor: backgroundColor8,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  showShowcase: true, // Tambahkan parameter ini
                                ),
                              ),
                            );
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
                                horizontal: size.width * 0.3,
                                vertical: size.height * 0.02),
                            backgroundColor: backgroundColor3,
                          ),
                        ),
                      ],
                    ),
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

class LinePainter extends CustomPainter {
  final double progress;

  LinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor8
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
