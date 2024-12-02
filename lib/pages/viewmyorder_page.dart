import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/order_card.dart';
import '../theme.dart';

class ViewMyOrderPage extends StatefulWidget {
  const ViewMyOrderPage({Key? key}) : super(key: key);

  @override
  State<ViewMyOrderPage> createState() => _ViewMyOrderPageState();
}

class _ViewMyOrderPageState extends State<ViewMyOrderPage> {
  @override
  @override
  void initState() {
    super.initState();

    // Dapatkan pengguna saat ini dari AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser =
        authProvider.user; // Asumsikan ada properti user di AuthProvider

    // Panggil fetchTransactions dengan currentUser
    Provider.of<TransactionProvider>(context, listen: false)
        .fetchTransactions(currentUser: currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text('Order Details', style: subtitleTextStyle),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                'No orders found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return OrderCard(order: transaction);
              },
            ),
    );
  }
}
