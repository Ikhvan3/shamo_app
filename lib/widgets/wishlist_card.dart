import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shamo_app/theme.dart';

class WishListCard extends StatelessWidget {
  const WishListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 14,
        left: 12,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12,
        ),
        color: backgroundColor4,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/image_shoes.png',
              width: 60,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terrex Urban Low',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  '\$143,98',
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/button_wishlist_blue.png',
            width: 34,
          ),
        ],
      ),
    );
  }
}
