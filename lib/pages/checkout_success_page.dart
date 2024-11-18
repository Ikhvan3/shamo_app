import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/theme.dart';

import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'viewmyorder_page.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);

    // Assume the order has been placed and add to OrderProvider
    OrderModel order = OrderModel(
      orderId: 'ORD123',
      items: cartProvider.carts,
      totalPrice: cartProvider.totalPrice(),
      status: 'settlement',
      paymentMethod: 'Midtrans',
      orderDate: DateTime.now(),
      deliveryAddress: 'Semarang', // Replace with real address
    );
    orderProvider.addOrder(order); // Store the order after successful payment

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text(
          'Checkout Success',
          style: subtitleTextStyle,
        ),
        elevation: 0,
      );
    }

    Widget content() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon_cart_empty.png',
              width: 80,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You made a transaction',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Stay at home while we\n prepare your dream shoes',
              style: subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(top: defaultMargin),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                style: TextButton.styleFrom(
                  backgroundColor: backgroundColor8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Order Other Shoes',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(
                top: 12,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewMyOrderPage(
                          order: order), // Navigate to View Order page
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 136, 136, 136),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View My Order',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
