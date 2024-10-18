import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/theme.dart';

import '../pages/product_page.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product as ProductModel),
          ),
        );
      },
      child: Container(
        width: 215,
        height: 278,
        margin: EdgeInsets.only(right: defaultMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xffECEDEF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildProductImage(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category?.name ?? 'Kategori Tidak Tersedia',
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.name ?? 'Nama Produk Tidak Tersedia',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    '\$${product.price?.toString() ?? '0'}',
                    style: priceTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.galleries == null || product.galleries!.isEmpty) {
      return _buildPlaceholder('Tidak ada gambar');
    }

    return Image.network(
      product.galleries![1].url.toString(),
      width: 215,
      height: 150,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return _buildPlaceholder('Gagal memuat gambar');
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder('Memuat gambar...');
      },
    );
  }

  Widget _buildPlaceholder(String message) {
    return Container(
      width: 215,
      height: 150,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
