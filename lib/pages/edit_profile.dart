import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/theme.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    PreferredSizeWidget header() {
      return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Color.fromARGB(255, 94, 94, 94),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: primaryTextColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: subtitleTextStyle,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.check,
                color: backgroundColor8,
              ),
            ),
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: subtitleTextStyle,
              decoration: InputDecoration(
                hintText: user.name,
                hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: subtitleColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: subtitleTextStyle,
              decoration: InputDecoration(
                hintText: '@${user.username}',
                hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: subtitleColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: subtitleTextStyle,
              decoration: InputDecoration(
                hintText: user.email,
                hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: subtitleColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    user.profilePhotoUrl.toString(),
                  ),
                ),
              ),
            ),
            nameInput(),
            usernameInput(),
            emailInput(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
      resizeToAvoidBottomInset: false,
    );
  }
}
