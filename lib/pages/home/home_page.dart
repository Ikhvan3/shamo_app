import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/models/user_model.dart';
import 'package:shamo_app/providers/product_provider.dart';
import 'package:shamo_app/theme.dart';
import 'package:shamo_app/widgets/product_card.dart';
import 'package:shamo_app/widgets/product_tile.dart';

import '../../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, ${user.name}',
                    style: transparentColorText.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: subtitleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    user.profilePhotoUrl.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget categories() {
      List<String> categoryList = [
        'Semua Sayuran',
        'Daun',
        'Buah',
        'Umbi',
        'Kacang',
      ];

      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: defaultMargin,
              ),
              ...categoryList
                  .map((category) => GestureDetector(
                        onTap: () {
                          Provider.of<ProductProvider>(context, listen: false)
                              .setSelectedCategory(category);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.only(
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Provider.of<ProductProvider>(context)
                                        .selectedCategory ==
                                    category
                                ? backgroundColor8
                                : backgroundColor7,
                          ),
                          child: Text(
                            category,
                            style: Provider.of<ProductProvider>(context)
                                        .selectedCategory ==
                                    category
                                ? primaryTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: medium,
                                  )
                                : subtitleTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: medium,
                                  ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      );
    }

    Widget popularProductsTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          'Sayuran Terlaris',
          style: transparentColorText.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
      );
    }

    Widget popularProducts() {
      if (productProvider.products.isEmpty) {
        // Jika data masih kosong, tampilkan CircularProgressIndicator
        return Center(child: CircularProgressIndicator());
      }

      return Container(
        margin: EdgeInsets.only(top: 14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: defaultMargin),
              Row(
                children: productProvider.products
                    .map((product) => ProductCard(product))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    Widget newArrivalTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          'Sayuran Baru',
          style: transparentColorText.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
      );
    }

    // Widget newArrivals() {
    //   return Container(
    //     margin: EdgeInsets.only(
    //       top: 14,
    //     ),
    //     child: Column(
    //       children: productProvider.products
    //           .map((product) => ProductTile(product))
    //           .toList(),
    //     ),
    //   );
    // }

    Widget filteredProducts() {
      if (productProvider.products.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return Container(
        margin: EdgeInsets.only(top: 14),
        child: Column(
          children: productProvider.products
              .map((product) => ProductTile(product))
              .toList(),
        ),
      );
    }

    Widget content() {
      // Jika kategori yang dipilih bukan "Semua Sayuran", tampilkan hanya ProductTile
      if (productProvider.selectedCategory != 'Semua Sayuran') {
        return filteredProducts();
      }

      // Jika "Semua Sayuran", tampilkan layout lengkap
      return Column(
        children: [
          popularProductsTitle(),
          popularProducts(),
          newArrivalTitle(),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Column(
              children: productProvider.products
                  .map((product) => ProductTile(product))
                  .toList(),
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        header(),
        categories(),
        content(),
      ],
    );
  }
}
