import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/pages/product_page.dart';
import 'package:shamo_app/theme.dart';

import '../helpers/image_url_helper.dart';
import '../pages/product_page.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  ProductTile(this.product);

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
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ImageHelper.loadImage(
                'storage/gallery/JH7NHZWmIvtqCdrvG4rQqZdPH3dzXLlaRVZLttCZ.png',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category!.name!,
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    product.name!,
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '\$${product.price}',
                    style: priceTextStyle.copyWith(
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

  // // lib/widgets/product_tile.dart
  // Widget _buildProductImage() {
  //   if (product.galleries == null || product.galleries!.isEmpty) {
  //     return _buildPlaceholder('Tidak ada gambar');
  //   }

  //   String imageUrl = product.galleries![0].getImageUrl();
  //   print('Loading image from URL: $imageUrl'); // Untuk debugging

  //   return Image.network(
  //     imageUrl,
  //     width: 120,
  //     height: 120,
  //     fit: BoxFit.cover,
  //     errorBuilder: (context, error, stackTrace) {
  //       print('Error loading image: $error');
  //       return _buildPlaceholder('Gagal memuat gambar');
  //     },
  //     loadingBuilder: (context, child, loadingProgress) {
  //       if (loadingProgress == null) return child;
  //       return Center(
  //         child: CircularProgressIndicator(
  //           value: loadingProgress.expectedTotalBytes != null
  //               ? loadingProgress.cumulativeBytesLoaded /
  //                   loadingProgress.expectedTotalBytes!
  //               : null,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildPlaceholder(String message) {
  //   return Container(
  //     width: 215,
  //     height: 150,
  //     color: Colors.grey[300],
  //     child: Center(
  //       child: Text(
  //         message,
  //         style: TextStyle(color: Colors.grey[600]),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }
}
