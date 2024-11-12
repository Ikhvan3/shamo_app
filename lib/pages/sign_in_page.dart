import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/theme.dart';
import 'package:shamo_app/widgets/loading_button.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

TextEditingController emailController = TextEditingController(text: '');

TextEditingController passwordController = TextEditingController(text: '');

bool isLoading = false;

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future<void> handleSignIn() async {
      setState(() {
        isLoading = true;
      });

      try {
        bool loginBerhasil = await authProvider.login(
          email: emailController.text,
          password: passwordController.text,
        );

        if (loginBerhasil) {
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: alertColor,
              content: Text(
                'Gagal Login! Periksa email dan password Anda.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } catch (e) {
        print('Detailed error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Error saat login: ${e.toString()}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: utamaTextStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Sign In to Continue',
              style: utamaTextStyle,
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 70,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: primaryTextColor,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_email.png',
                      width: 17,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: TextFormField(
                      style: subtitleTextStyle,
                      controller: emailController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Your Email Address',
                        hintStyle: secondaryTextStyle,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: primaryTextColor,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_password.png',
                      width: 17,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      style: subtitleTextStyle,
                      controller: passwordController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Your Password',
                        hintStyle: secondaryTextStyle,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget signInButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: TextButton(
          onPressed: handleSignIn,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
          child: Text(
            'Sign In',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dont\'t have an account? ',
              style: subtitleTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text(
                'Sign Up',
                style: hijauTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor1,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              emailInput(),
              passwordInput(),
              isLoading ? LoadingButton() : signInButton(),
              Spacer(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }
}
