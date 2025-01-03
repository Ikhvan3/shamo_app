import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:provider/provider.dart';

import 'package:shamo_app/providers/auth_provider.dart';
import 'package:shamo_app/providers/cart_provider.dart';
import 'package:shamo_app/providers/transaction_provider.dart';
import 'package:shamo_app/theme.dart';
import 'package:shamo_app/widgets/checkout_card.dart';
import 'package:shamo_app/widgets/loading_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  String selectedPaymentMethod = 'cod'; // Default ke COD
  final TextEditingController addressController = TextEditingController();
  bool isAddressEntered = false;
  String savedAddress = '';

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor3,
          title: Text(
            'Tambah Alamat',
            style: subtitleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                style: subtitleTextStyle,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  hintStyle: subtitleTextStyle.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: backgroundColor1,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addressController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'Hapus',
                style: subtitleTextStyle.copyWith(
                  color: Colors.red,
                  fontWeight: medium,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  savedAddress = addressController.text;
                  isAddressEntered = savedAddress.isNotEmpty;
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Simpan',
                style: primaryTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    // Pada CheckoutPage, modifikasi method handleCheckout:

    handleCheckout() async {
      setState(() {
        isLoading = true;
      });

      if (cartProvider.carts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Keranjang kosong')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (!isAddressEntered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Silakan masukkan alamat pengiriman')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        if (selectedPaymentMethod == 'cod') {
          // Proses checkout COD
          Map<String, dynamic>? result = await transactionProvider.checkoutCOD(
              cartProvider.carts,
              cartProvider.totalPrice(),
              authProvider.user,
              savedAddress // gunakan alamat yang telah disimpan
              );

          if (result != null && result['status'] == 'success') {
            cartProvider.carts.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/checkout-success',
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal melakukan checkout COD')),
            );
          }
        } else {
          // Proses checkout digital (kode yang sudah ada)
          Map<String, dynamic>? checkoutResult =
              await transactionProvider.checkout(cartProvider.carts,
                  cartProvider.totalPrice(), authProvider.user, savedAddress);

          if (checkoutResult != null && checkoutResult['snap_token'] != null) {
            String snapToken = checkoutResult['snap_token'];

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MidtransSnap(
                  mode: MidtransEnvironment.sandbox,
                  token: snapToken,
                  midtransClientKey: 'SB-Mid-client-9IcCzu63pO9YgHmi',
                  onPageFinished: (url) => print("Page Finished: $url"),
                  onPageStarted: (url) => print("Page Started: $url"),
                  onResponse: (response) {
                    print("Payment Response: ${response.toJson()}");
                    if (response.transactionStatus == 'settlement' ||
                        response.transactionStatus == 'capture') {
                      cartProvider.carts.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/checkout-success',
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pembayaran gagal!')),
                      );
                    }
                  },
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error in handleCheckout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: primaryTextColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout Details',
          style: subtitleTextStyle,
        ),
      );
    }

    Widget addressDetails() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Alamat',
                  style: subtitleTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                TextButton(
                  onPressed: _showAddAddressDialog,
                  style: TextButton.styleFrom(
                    backgroundColor: backgroundColor8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(
                    'Tambah Alamat',
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (isAddressEntered) ...[
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/icon_store_location.png',
                        width: 40,
                      ),
                      Image.asset(
                        'assets/icon_line.png',
                        height: 30,
                      ),
                      Image.asset(
                        'assets/icon_your_addres.png',
                        width: 40,
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Toko',
                        style: subtitleTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: light,
                        ),
                      ),
                      Text(
                        'Semarang',
                        style: subtitleTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Text(
                        'Alamat Anda',
                        style: subtitleTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: light,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          savedAddress,
                          style: subtitleTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else
              Text(
                'Silakan tambah alamat pengiriman',
                style: subtitleTextStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      );
    }

    Widget paymentMethodSelection() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metode Pembayaran',
              style: subtitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            SizedBox(height: 12),
            RadioListTile<String>(
              title: Text('Cash on Delivery (COD)', style: subtitleTextStyle),
              value: 'cod',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Pembayaran Digital', style: subtitleTextStyle),
              value: 'digital',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      );
    }

    Widget content() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          // List Items (existing code)
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Items',
                  style: subtitleTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
                Column(
                  children: cartProvider.carts
                      .map((cart) => CheckoutCard(cart))
                      .toList(),
                ),
              ],
            ),
          ),

          // Address Input
          addressDetails(),

          // Payment Summary (existing code)
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor3,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Pembayaran',
                  style: subtitleTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Sayuran',
                      style: subtitleTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      '${cartProvider.totalItems()} Items',
                      style: subtitleTextStyle.copyWith(fontWeight: medium),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Harga Sayuran',
                      style: subtitleTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      'Rp${cartProvider.totalPrice()}',
                      style: subtitleTextStyle.copyWith(fontWeight: medium),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pengiriman',
                      style: subtitleTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      'Gratis',
                      style: subtitleTextStyle.copyWith(fontWeight: medium),
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Color(0xff2E3141)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: hijauTextStyle.copyWith(fontWeight: semiBold),
                    ),
                    Text(
                      'Rp${cartProvider.totalPrice()}',
                      style: hijauTextStyle.copyWith(fontWeight: semiBold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Method Selection
          paymentMethodSelection(),

          // Checkout Button
          SizedBox(height: defaultMargin),
          Divider(thickness: 1, color: Color(0xff2E3141)),
          isLoading
              ? Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: LoadingButton(),
                )
              : Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: defaultMargin),
                  child: TextButton(
                    onPressed: handleCheckout,
                    style: TextButton.styleFrom(
                      backgroundColor: backgroundColor8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Checkout Now',
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
