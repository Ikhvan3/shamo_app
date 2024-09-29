import 'package:flutter/material.dart';

import '../../theme.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Wishlist Page',
        style: TextStyle(
          color: secondaryTextColor,
        ),
      ),
    );
  }
}
