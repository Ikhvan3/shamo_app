import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/page_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../theme.dart';
import '../../widgets/wishlist_card.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget header() {
      return AppBar(
        backgroundColor: primaryTextColor,
        centerTitle: true,
        title: Text(
          'Sayuran Favorit',
          style: subtitleTextStyle,
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget emptyWishlist() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image_wishlist.png',
                width: 74,
              ),
              SizedBox(height: 23),
              Text(
                'You don\'t have favorite items?',
                style: subtitleTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Let\'s find your favorite items',
                style: subtitleTextStyle,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  pageProvider.currentIndex = 0;
                },
                style: TextButton.styleFrom(
                  backgroundColor: backgroundColor8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Explore Store',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<ProductModel>>(
        stream: wishlistProvider.loadWishlist,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return emptyWishlist();
          }

          return Expanded(
            child: Container(
              color: backgroundColor1,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                children: snapshot.data!.map((product) {
                  print('Creating WishListCard for: ${product.name}');
                  return WishListCard(product);
                }).toList(),
              ),
            ),
          );
        },
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
