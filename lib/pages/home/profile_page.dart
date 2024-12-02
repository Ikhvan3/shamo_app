import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/pages/sign_in_page.dart';

import '../../models/user_model.dart';

import '../../providers/auth_provider.dart' as local_auth;
import '../../theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<local_auth.AuthProvider>(
      builder: (context, authProvider, child) {
        UserModel user = authProvider.user;

        return Scaffold(
          body: Column(
            children: [
              _buildHeader(context, user, authProvider),
              _buildContent(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserModel user,
      local_auth.AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(defaultMargin),
      color: primaryTextColor,
      child: SafeArea(
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/icon_profile.png',

                // width: 64,
                // height: 64, // Tambahkan height untuk memastikan aspect ratio
                // fit: BoxFit.cover, // Pastikan gambar terisi dengan baik
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, ${user.name}',
                    style: subtitleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    '@${user.name}',
                    style: subtitleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () => _handleLogout(context, authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        decoration: BoxDecoration(color: backgroundColor1),
        child: ListView(
          // Ganti Column dengan ListView untuk scrolling
          children: [
            SizedBox(height: 20),
            Text(
              'Akun',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            _buildMenuItem('Edit Profile', () {
              Navigator.pushNamed(context, '/edit-profile');
            }),
            _buildMenuItem('Your Order', () {
              Navigator.pushNamed(
                context,
                '/view-order',
              );
            }),
            _buildMenuItem('Help', () {}),
            SizedBox(height: 30),
            Text(
              'General',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            _buildMenuItem('Privacy & Policy', () {}),
            _buildMenuItem('Term of Service', () {}),
            _buildMenuItem('Rate App', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: subtitleTextStyle.copyWith(fontSize: 13),
            ),
            Icon(Icons.chevron_right, color: subtitleColor),
          ],
        ),
      ),
    );
  }

  // void _handleOrderTap(BuildContext context) async {
  //   try {
  //     // Dapatkan user saat ini
  //     User? currentUser = FirebaseAuth.instance.currentUser;

  //     // Query pesanan berdasarkan user ID
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('transactions')
  //         .where('userId', isEqualTo: currentUser)
  //         .orderBy('timestamp', descending: true)
  //         .get();

  //     // Cek apakah ada pesanan
  //     if (querySnapshot.docs.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Tidak ada pesanan')),
  //       );
  //       return;
  //     }

  //     // Navigasi ke halaman daftar pesanan dengan membawa data
  //     Navigator.pushNamed(
  //       context,
  //       '/view-order',
  //       arguments: querySnapshot.docs
  //           .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
  //           .toList(),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Gagal mengambil pesanan: ${e.toString()}')),
  //     );
  //   }
  // }

  Future<void> _handleLogout(
      BuildContext context, local_auth.AuthProvider authProvider) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout'),
            content: Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        await authProvider.logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat logout')),
        );
      }
    }
  }
}
