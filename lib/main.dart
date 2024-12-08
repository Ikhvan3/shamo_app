import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/pages/cart_page.dart';
import 'package:shamo_app/pages/checkout_page.dart';
import 'package:shamo_app/pages/checkout_success_page.dart';
import 'package:shamo_app/pages/edit_profile.dart';
import 'package:shamo_app/pages/home/chat_page.dart';
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

import 'pages/start/startpage1.dart';
import 'pages/start/startpage2.dart';
import 'pages/start/startpage3.dart';
import 'pages/viewmyorder_page.dart';

import 'providers/scan_provider.dart';
import 'services/wishlist_service.dart';

void main(List<String> args) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
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
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<CartProvider, AuthProvider>(
          create: (context) => AuthProvider(
            cartProvider: Provider.of<CartProvider>(context, listen: false),
          ),
          update: (context, cart, auth) {
            auth ??= AuthProvider(cartProvider: cart);
            return auth;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, WishlistProvider>(
          create: (context) => WishlistProvider(
            wishlistService: WishlistService(),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
          update: (context, auth, wishlist) {
            wishlist ??= WishlistProvider(
              wishlistService: WishlistService(),
              authProvider: auth,
            );
            // Update user in WishlistProvider
            wishlist.setUser(auth.user);
            return wishlist;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
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
          '/start1': (context) => StartPage1(),
          '/start2': (context) => StartPage2(),
          '/start3': (context) => StartPage3(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home': (context) => MainPage(),
          '/edit-profile': (context) => EditProfilePage(),
          '/cart': (context) => CartPage(),
          '/chat': (context) => ChatPage(),
          '/checkout': (context) => CheckoutPage(),
          '/checkout-success': (context) => CheckoutSuccessPage(),
          '/view-order': (context) => const ViewMyOrderPage(),
        },
      ),
    );
  }
}
