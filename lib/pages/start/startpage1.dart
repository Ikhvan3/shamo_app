import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

class StartPage1 extends StatefulWidget {
  const StartPage1({Key? key}) : super(key: key);
  @override
  State<StartPage1> createState() => _StartPage1State();
}

class _StartPage1State extends State<StartPage1>
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
    // Mendapatkan ukuran layar
    final size = MediaQuery.of(context).size;

    Widget _buildIndicator1() {
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

    Widget _buildIndicator3() {
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
          SizedBox(
            height: size.height * 0.15,
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
                      SizedBox(height: 30),
                      Text(
                        "Solusi sehat untuk kebutuhan sayuran segar Anda.",
                        textAlign: TextAlign.center,
                        style: subtitleTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 75,
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
