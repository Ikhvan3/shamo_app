import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../theme.dart';
import '../widgets/order_card.dart';

class ViewMyOrderPage extends StatefulWidget {
  final List<OrderModel> orders; // Tambahkan parameter orders

  const ViewMyOrderPage({Key? key, required this.orders}) : super(key: key);

  @override
  State<ViewMyOrderPage> createState() => _ViewMyOrderPageState();
}

class _ViewMyOrderPageState extends State<ViewMyOrderPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text('Order Details', style: subtitleTextStyle),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}
