import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/pages/cart_page.dart';
import 'package:shamo_app/pages/detail_chat_page.dart';
import 'package:shamo_app/providers/cart_provider.dart';
import 'package:shamo_app/providers/wishlist_provider.dart';
import 'package:shamo_app/theme.dart';

import '../providers/auth_provider.dart';

class ProductPage extends StatefulWidget {
  final ProductModel product;
  ProductPage(this.product);
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isInWishlist = false;
  @override
  void initState() {
    super.initState();

    // Pastikan user sudah di-set di WishlistProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWishlistStatus();
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      WishlistProvider wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);

      // Set user ke wishlist provider
      wishlistProvider.setUser(authProvider.user);
    });
  }

  // Method untuk memeriksa status wishlist
  void _checkWishlistStatus() async {
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    bool isInWishlist = await wishlistProvider.isWishlist(widget.product);
    setState(() {
      _isInWishlist = isInWishlist;
    });
  }

  List images = [
    'assets/image_shoes.png',
    'assets/image_shoes.png',
    'assets/image_shoes.png',
  ];

  List familiarShoes = [
    'assets/image_bayam.png',
    'assets/image_buncis.png',
    'assets/image_cabai.png',
    'assets/image_kacangpanjang.png',
    'assets/image_kentang.png',
    'assets/image_sawi.png',
    'assets/image_terong.png',
    'assets/image_wortel.png',
  ];

  int currentIndex = 0;

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: backgroundColor3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: MediaQuery.of(dialogContext).size.width - (2 * defaultMargin),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.close,
                    color: primaryTextColor,
                  ),
                ),
              ),
              Image.asset(
                'assets/icon_success.png',
                width: 100,
              ),
              SizedBox(height: 12),
              Text(
                'Success!',
                style: primaryTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Item added successfully',
                style: secondaryTextStyle,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 154,
                height: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.pushNamed(context, '/cart');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: backgroundColor8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View My Cart',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: backgroundColor3,
        title: Text(
          'Login Required',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        content: Text(
          'Please login to add items to cart',
          style: secondaryTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.pushNamed(context, '/sign-in');
            },
            child: Text(
              'Login',
              style: primaryTextStyle.copyWith(
                color: primaryColor,
                fontWeight: medium,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Cancel',
              style: secondaryTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    Widget indicator(int index) {
      return Container(
        width: currentIndex == index ? 16 : 4,
        height: 4,
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? backgroundColor8 : Color(0xffC4C4C4),
        ),
      );
    }

    Widget familiarShoesCard(String imageUrl) {
      return Container(
        width: 54,
        height: 54,
        margin: EdgeInsets.only(
          right: 16,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageUrl),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    Widget header() {
      int index = -1;

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.chevron_left,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ));
                  },
                  child: Icon(
                    Icons.shopping_bag,
                    color: backgroundColor8,
                  ),
                ),
              ],
            ),
          ),
          CarouselSlider(
            items: widget.product.galleries!
                .map(
                  (image) => Image.network(
                    image.url!,
                    width: MediaQuery.of(context).size.width,
                    height: 310,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.galleries!.map((e) {
              index++;
              return indicator(index);
            }).toList(),
          ),
        ],
      );
    }

    Widget content(WishlistProvider wishlistProvider) {
      int index = -1;
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 17,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          color: backgroundColor1,
        ),
        child: Column(
          children: [
            // NOTE : HEADER
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
                right: defaultMargin,
                left: defaultMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name!,
                          style: subtitleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        Text(
                          widget.product.category!.name!,
                          style: secondaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await wishlistProvider.toggleWishlist(widget.product);

                      // Update state lokal sesuai status di provider
                      setState(() {
                        _isInWishlist = wishlistProvider
                            .isProductInWishlist(widget.product);
                      });

                      // Tampilkan snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:
                              _isInWishlist ? secondaryColor : alertColor,
                          content: Text(
                            _isInWishlist
                                ? 'Has been added to the Wishlist'
                                : 'Has been removed from the Wishlist',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      // Gunakan variabel lokal _isInWishlist
                      _isInWishlist
                          ? 'assets/button_wishlist_blue.png'
                          : 'assets/button_wishlist.png',
                      width: 46,
                    ),
                  ),
                ],
              ),
            ),

            // NOTE : PRICE
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 20,
                left: defaultMargin,
                right: defaultMargin,
              ),
              padding: EdgeInsets.all(
                16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: backgroundColor8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga mulai dari',
                    style: primaryTextStyle,
                  ),
                  Text(
                    '\Rp${widget.product.price}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi',
                    style: subtitleTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.product.description!,
                    style: subtitleTextStyle.copyWith(
                      fontWeight: light,
                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),

            //NOTE : FAMILIAR SHOES
            SizedBox(
              height: 80,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin,
                    ),
                    child: Text(
                      'Sayuran Serupa',
                      style: subtitleTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: familiarShoes.map((image) {
                        index++;
                        return Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? defaultMargin : 0),
                          child: familiarShoesCard(image),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      );
    }

    Widget buttonchat() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailChatPage(widget.product),
            ),
          );
        },
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/button_chat.png'),
            ),
          ),
        ),
      );
    }

    Widget addToCartButton(
        CartProvider cartProvider, AuthProvider authProvider) {
      return Expanded(
        child: Container(
          height: 54,
          child: TextButton(
            onPressed: () async {
              try {
                // Pastikan user sudah login
                if (authProvider.user != null) {
                  await cartProvider.addCart(widget.product);
                  showSuccessDialog();
                } else {
                  // Tampilkan dialog untuk login jika belum login
                  showLoginRequiredDialog();
                }
              } catch (e) {
                // Tampilkan error jika gagal menambahkan ke cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: alertColor,
                    content: Text(
                      'Failed to add product to cart',
                      style: primaryTextStyle.copyWith(
                        color: backgroundColor1,
                      ),
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: backgroundColor8,
            ),
            child: Text(
              'Add to Cart',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      );
    }

    return Consumer3<WishlistProvider, CartProvider, AuthProvider>(
      builder: (context, wishlistProvider, cartProvider, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              header(),
              content(wishlistProvider),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                buttonchat(),
                SizedBox(
                  width: 20,
                ),
                addToCartButton(cartProvider, authProvider),
              ],
            ),
          ),
        );
      },
    );
  }
}
