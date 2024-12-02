import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../theme.dart';
import '../widgets/checkout_card.dart';

class ViewMyOrderPage extends StatelessWidget {
  const ViewMyOrderPage({super.key, required this.orders});

  final List<OrderModel> orders; // Menerima daftar pesanan

  @override
  Widget build(BuildContext context) {
    // Menambahkan pengecekan untuk null
    if (orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryTextColor,
          centerTitle: true,
          title: Text('Order Details', style: subtitleTextStyle),
        ),
        body: Center(
          child: Text(
            'No orders found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Jika ada pesanan, tampilkan daftar pesanan
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text('Order Details', style: subtitleTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: ListView.builder(
          itemCount: orders.length, // Menampilkan daftar pesanan
          itemBuilder: (context, index) {
            final order = orders[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order ID
                      Text('Order ID: ${order.orderId}',
                          style: subtitleTextStyle),
                      SizedBox(height: 10),
                      // List of items in the order
                      Text('Items:', style: subtitleTextStyle),
                      SizedBox(height: 10),
                      // List of cart items in the order
                      Column(
                        children: order.items.map((cartItem) {
                          return CheckoutCard(
                              cartItem); // Reusing the CheckoutCard widget
                        }).toList(),
                      ),
                      // Total price
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: subtitleTextStyle),
                          Text('Rp${order.totalPrice}', style: priceTextStyle),
                        ],
                      ),
                      SizedBox(height: 5),
                      // Order status
                      Text('Status: ${order.status}', style: subtitleTextStyle),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
