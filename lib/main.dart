import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/pages/cart_page.dart';
import 'package:shamo_app/pages/checkout_page.dart';
import 'package:shamo_app/pages/checkout_success_page.dart';

import 'package:shamo_app/pages/edit_profile.dart';
import 'package:shamo_app/pages/home/main_page.dart';

import 'package:shamo_app/pages/sign_in_page.dart';
import 'package:shamo_app/pages/splash_page.dart';
import 'package:shamo_app/providers/auth_provider.dart';
import 'package:shamo_app/providers/cart_provider.dart';
import 'package:shamo_app/providers/page_provider.dart';
import 'package:shamo_app/providers/product_provider.dart';
import 'package:shamo_app/providers/transaction_provider.dart';
import 'package:shamo_app/providers/wishlist_provider.dart';
import 'firebase_options.dart';
import 'pages/sign_up_page.dart';
import 'providers/scan_provider.dart';

void main(List<String> args) async {
  // HttpOverrides.global = MyHttpOverrides();
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform, // Gunakan options dari firebase_options.dart
    );

    runApp(const MyApp());
  } catch (e) {
    print('Error during initialization: $e');
  }

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!\n${details.exception}',
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScannerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home': (context) => MainPage(),
          '/edit-profile': (context) => EditProfilePage(),
          '/cart': (context) => CartPage(),
          '/checkout': (context) => CheckoutPage(),
          '/checkout-success': (context) => CheckoutSuccessPage(),
        },
      ),
    );
  }
}
