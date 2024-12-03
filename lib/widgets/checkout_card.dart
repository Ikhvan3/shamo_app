import 'package:flutter/material.dart';
import 'package:shamo_app/models/cart_model.dart';
import 'package:shamo_app/theme.dart';

class CheckoutCard extends StatelessWidget {
  final CartModel cart;
  CheckoutCard(this.cart);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: primaryTextColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (cart.product!.galleries!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cart.product!.galleries![0].url!,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return Image.asset(
                    'assets/image_shoes.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          else
            Image.asset(
              'assets/image_shoes.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product!.name!,
                  style: subtitleTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '\Rp${cart.product!.price}',
                  style: priceTextStyle2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            '${cart.quantity} Items',
            style:
                subtitleTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
          )
        ],
      ),
    );
  }
}
