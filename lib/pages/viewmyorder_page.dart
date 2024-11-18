import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../theme.dart';
import '../widgets/checkout_card.dart';

class ViewMyOrderPage extends StatelessWidget {
  const ViewMyOrderPage({super.key, required OrderModel order});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as OrderModel?;

    // Menambahkan pengecekan untuk null
    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryTextColor,
          centerTitle: true,
          title: Text('Order Details', style: subtitleTextStyle),
        ),
        body: Center(
          child: Text(
            'Order not found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Jika order tidak null, tampilkan detail order
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text('Order Details', style: subtitleTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: [
            // Order ID
            Text('Order ID: ${order.orderId}', style: subtitleTextStyle),
            SizedBox(height: 20),
            // List of items in the order
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  CartModel cart = order.items[index];
                  return CheckoutCard(cart); // Reusing the CheckoutCard widget
                },
              ),
            ),
            // Total price
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: subtitleTextStyle),
                  Text('\Rp${order.totalPrice}', style: priceTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
