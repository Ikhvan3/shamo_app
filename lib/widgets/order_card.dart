import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme.dart';
import '../widgets/checkout_card.dart';

class OrderCard extends StatelessWidget {
  final TransactionModel order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Items:',
              style: subtitleTextStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              children: order.items!.map((item) {
                return CheckoutCard(item);
              }).toList(),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: subtitleTextStyle),
                Text(
                  'Rp ${order.totalPrice!.toStringAsFixed(0)}',
                  style: priceTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${order.status}',
              style: subtitleTextStyle.copyWith(
                color: order.status == 'settlement' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
