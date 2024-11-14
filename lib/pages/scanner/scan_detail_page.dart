// lib/views/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/theme.dart';

import '../../providers/scan_provider.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, _) {
        final product = provider.scannedProduct;
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Produk tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor1,
          appBar: AppBar(
            title: Text(product.name),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Produk
                _buildSection(
                  context,
                  'Informasi Produk',
                  Column(
                    children: [
                      _buildInfoRow('Kategori', product.category),
                      _buildInfoRow(
                          'Harga', '\$${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Kandungan Nutrisi
                _buildSection(
                  context,
                  'Kandungan Nutrisi',
                  Column(
                    children: product.nutrients.entries.map((e) {
                      return _buildInfoRow(e.key, e.value);
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),

                // Manfaat
                _buildSection(
                  context,
                  'Manfaat',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.benefits.map((benefit) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\•${benefit['title'] ?? ''}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              benefit['description'] ?? '',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Divider(),
            SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
