import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'seller_product.dart';

class Sellers extends StatelessWidget {
  //All statefull, future builder, login display response api, cache network
  const Sellers({Key? key}) : super(key: key);

  // Fetching API
  Future<List<dynamic>> fetchSellers() async {
    const url =
        'https://api.buildhubware.com/api/v1.1/sellers-company?page=1&limit=0&sellerCompanyLimit=10&lng&lat&globalSearch=true';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['response'] ?? [];
    } else {
      print('Failed to fetch sellers');
      return [];
    }
  }

  // Navigate to seller details screen with slide transition
  void navigateToSeller(BuildContext context, dynamic seller) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from the right
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: SellerProduct(seller: seller),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: fetchSellers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load sellers"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Sellers Available"));
          }

          final sellers = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Focus(
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;

                      return TextField(
                        decoration: InputDecoration(
                          hintText: "Search Sellers",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color:
                                  isFocused
                                      ? Color.fromRGBO(157, 0, 1, 1.0)
                                      : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(157, 0, 1, 1.0),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // List of Sellers
              Expanded(
                child: ListView.builder(
                  itemCount: sellers.length,
                  itemBuilder: (context, index) {
                    final seller = sellers[index];
                    return GestureDetector(
                      onTap: () => navigateToSeller(context, seller),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Seller Logo
                                if (seller['logo'] != null &&
                                    seller['logo'].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Image.network(
                                      seller['logo'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                // Seller Name & Address
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seller['name'] ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Color.fromRGBO(
                                              157,
                                              0,
                                              1,
                                              1.0,
                                            ),
                                            size: 14,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              seller['address'] ?? 'No Address',
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                  157,
                                                  0,
                                                  1,
                                                  1.0,
                                                ),
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Seller Products List
                            if (seller['products'] != null &&
                                seller['products'].isNotEmpty)
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: seller['products'].length,
                                  itemBuilder: (context, productIndex) {
                                    final product =
                                        seller['products'][productIndex];
                                    return GestureDetector(
                                      onTap:
                                          () =>
                                              navigateToSeller(context, seller),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Image.network(
                                          //CachedNetworkImage
                                          product['photo'] ?? '',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
