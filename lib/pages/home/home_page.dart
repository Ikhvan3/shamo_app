import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/models/user_model.dart';
import 'package:shamo_app/providers/product_provider.dart';
import 'package:shamo_app/theme.dart';
import 'package:shamo_app/widgets/product_card.dart';
import 'package:shamo_app/widgets/product_tile.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  final bool showShowcase;
  const HomePage({Key? key, this.showShowcase = false}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey _searchShowcaseKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.showShowcase) {
          ShowCaseWidget.of(context).startShowCase([_searchShowcaseKey]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    Widget header() {
      AuthProvider authProvider = Provider.of<AuthProvider>(context);

      // Tambahkan kondisi untuk pengecekan login
      Widget headerContent = authProvider.isLoggedIn
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    'Hallo, ${authProvider.user.name}',
                    style: transparentColorText.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(
                    child: Icon(
                      Icons.shopping_cart,
                      size: 32,
                      color: backgroundColor8,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    'Hallo, Guest',
                    style: transparentColorText.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(
                    child: Icon(
                      Icons.shopping_cart,
                      size: 32,
                      color: backgroundColor8,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ],
            );

      return Container(
        margin: EdgeInsets.only(
          top: 20,
          left: defaultMargin,
          right: 20,
        ),
        child: headerContent,
      );
    }

    Widget searchField() {
      return Showcase(
        key: _searchShowcaseKey,

        description: 'Cari sayuran favorit Anda di sini!',
        showArrow: true, // Tampilkan panah
        overlayColor: Colors.blue, // Warna overlay
        overlayOpacity: 0.6, // Opacity overlay
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: 25,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor7,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                query = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari sayuran...',
              border: InputBorder.none,
              hintStyle: subtitleTextStyle,
              icon: Icon(Icons.search, color: subtitleTextStyle.color),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: subtitleTextStyle.color),
                      onPressed: () {
                        setState(() {
                          query = '';
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
            ),
            style: primaryTextStyle,
          ),
        ),
      );
    }

    Widget categories() {
      if (query.isNotEmpty) {
        return SizedBox(); // Sembunyikan kategori saat ada query pencarian
      }
      List<String> categoryList = [
        'Semua Sayuran',
        'Daun',
        'Buah',
        'Umbi',
        'Kacang',
      ];

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 5,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: backgroundstarting,
            ),
            height: 145,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 40,
                          ),
                          child: Text(
                            "Sayuran segar",
                            style: primaryTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 5,
                          ),
                          child: Text(
                            "Siap untuk Anda!",
                            style: primaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width:
                          165, // Menambahkan lebar tetap untuk menempatkan gambar
                    ),
                  ],
                ),
                Positioned(
                  right: 30,
                  bottom: 30, // Menempatkan gambar di posisi yang diinginkan
                  child: Transform.scale(
                    scale: 1.9, // Mengatur skala gambar
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 74, 74, 74)
                                .withOpacity(
                                    0.2), // Warna bayangan dengan transparansi
                            blurRadius: 8, // Radius blur bayangan
                            offset: Offset(
                                2, 2), // Posisi bayangan (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/image_bgtomat.png",
                        height:
                            85, // Menyesuaikan tinggi gambar dengan container
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 5,
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
                              setState(() {
                                productProvider.setSelectedCategory(category);
                              });
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
          ),
        ],
      );
    }

    Widget popularProductsTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
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

    Widget filteredProducts() {
      if (productProvider.products.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      // Filter produk berdasarkan kategori dan query
      List filtered = productProvider.products.where((product) {
        bool matchesCategory =
            productProvider.selectedCategory == 'Semua Sayuran' ||
                product.category?.name?.toLowerCase() ==
                    productProvider.selectedCategory.toLowerCase();
        bool matchesQuery = query.isEmpty ||
            product.name!.toLowerCase().contains(query.toLowerCase());

        return matchesCategory && matchesQuery;
      }).toList();

      // Jika hasil filter kosong, tampilkan pesan
      if (filtered.isEmpty) {
        return Center(
          child: Text(
            'Produk tidak ditemukan.',
            style: primaryTextStyle,
          ),
        );
      }

      // Tampilkan daftar produk hasil filter
      return Container(
        margin: EdgeInsets.only(top: 14),
        child: Column(
          children: filtered.map((product) => ProductTile(product)).toList(),
        ),
      );
    }

    Widget content() {
      if (query.isNotEmpty ||
          productProvider.selectedCategory != 'Semua Sayuran') {
        return filteredProducts();
      }

      // Jika "Semua Sayuran" dan tidak ada query, tampilkan layout lengkap
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

    return ShowCaseWidget(
      builder: (context) => ListView(
        children: [
          header(),
          searchField(),
          categories(),
          content(),
        ],
      ),
    );
  }
}
