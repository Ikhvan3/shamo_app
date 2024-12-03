import 'package:flutter/material.dart';

class StartPage1 extends StatelessWidget {
  final VoidCallback onNext;

  const StartPage1({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Selamat Datang di FreshVeggies!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Solusi sehat untuk kebutuhan sayuran segar Anda.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onNext,
            child: Text("Next"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
