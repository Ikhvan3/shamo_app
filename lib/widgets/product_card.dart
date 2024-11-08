import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/image_url_helper.dart';
import '../models/product_model.dart';
import '../pages/product_page.dart';
import '../theme.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  String _getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    print('Original URL from database: $url'); // Debug print

    // Hapus 'public/' jika ada
    url = url.replaceAll('public/', '');

    // Hapus 'storage/' dari awal URL jika ada
    url = url.replaceAll('storage/', '');

    // Hapus double slashes jika ada
    final finalUrl =
        'http://192.168.1.10:8000/storage/$url'.replaceAll('//', '/');

    print('Final URL: $finalUrl'); // Debug print
    return finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product),
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
            ImageHelper.loadImage(
              'storage/gallery/V31OUXxetfRZ9Mlz85U0q1ENqxowb8KnH7V4ZGTt.png',
              width: 200,
              height: 150,
            ),
            // CachedNetworkImage(
            //   imageUrl: _getValidImageUrl(product.galleries?.isNotEmpty == true
            //       ? product.galleries![0].url
            //       : ''),
            //   httpHeaders: const {
            //     'Accept': 'application/json',
            //   },
            //   fit: BoxFit.cover,
            //   height: 120,
            //   width: 215,
            //   progressIndicatorBuilder: (context, url, progress) {
            //     print('Loading image from URL: $url'); // Tambahkan ini
            //     return Center(
            //       child: CircularProgressIndicator(value: progress.progress),
            //     );
            //   },
            //   errorWidget: (context, url, error) {
            //     print('Error loading image: $error');
            //     print('Attempted URL: $url');
            //     return Container(
            //       height: 120,
            //       width: 215,
            //       color: Colors.grey[300],
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Icon(Icons.error, color: Colors.red),
            //           SizedBox(height: 4),
            //           Text(
            //             'Gambar tidak tersedia',
            //             style: TextStyle(fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
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
}
