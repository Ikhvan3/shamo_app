import 'package:flutter/material.dart';
import 'package:shamo_app/theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget cartButton() {
      return FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {},
        backgroundColor: secondaryColor,
        child: Image.asset(
          'assets/icon_cart.png',
          width: 20,
        ),
      );
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomAppBar(
          color: backgroundColor4,
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  // Aksi ketika icon home diklik
                  print('Home clicked');
                },
                child: Image.asset(
                  'assets/icon_home.png',
                  width: 21,
                ),
              ),
              InkWell(
                onTap: () {
                  // Aksi ketika icon chat diklik
                  print('Chat clicked');
                },
                child: Image.asset(
                  'assets/icon_chat.png',
                  width: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Aksi ketika icon wishlist diklik
                  print('Wishlist clicked');
                },
                child: Image.asset(
                  'assets/icon_whislist.png',
                  width: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  // Aksi ketika icon profile diklik
                  print('Profile clicked');
                },
                child: Image.asset(
                  'assets/icon_profile.png',
                  width: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      floatingActionButton: cartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: Center(
        child: Text('Main Page'),
      ),
    );
  }
}
