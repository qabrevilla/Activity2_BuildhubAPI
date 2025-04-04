import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'seller_product.dart';

class Sellers extends StatefulWidget {
  const Sellers({Key? key}) : super(key: key);

  @override
  State<Sellers> createState() => _SellersState();
}

class _SellersState extends State<Sellers> {
  List<dynamic> sellers = [];
  List<dynamic> filteredSellers = [];
  bool isLoading = true;
  String selectedFilter = "Nearby";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchSellers();
  }

  Future<void> fetchSellers() async {
    setState(() => isLoading = true);
    const url =
        'https://api.buildhubware.com/api/v1.1/sellers-company?page=1&limit=0&sellerCompanyLimit=10&lng&lat&globalSearch=true';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        sellers = json['response'] ?? [];
        filteredSellers = sellers;
      });
    } else {
      print('Failed to fetch sellers');
    }
    setState(() => isLoading = false);
  }

  void toggleFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void navigateToSeller(BuildContext context, dynamic seller) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
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

  void filterSellers(String query) {
    setState(() {
      searchQuery = query;
      filteredSellers =
          sellers.where((seller) {
            final name = seller['name'].toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) => filterSellers(query),
                  decoration: InputDecoration(
                    hintText: "Search Sellers",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.grey,
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
                          icon: const Icon(Icons.refresh, color: Colors.black),
                          onPressed: fetchSellers,
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterButton(
                        "Nearby",
                        selectedFilter == "Nearby",
                        () => toggleFilter("Nearby"),
                        icon: Icons.location_on,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFilterButton(
                        "Global",
                        selectedFilter == "Global",
                        () => toggleFilter("Global"),
                        icon: Icons.public,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading
              ? const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
              : filteredSellers.isEmpty
              ? const Expanded(
                child: Center(child: Text("No Sellers Available")),
              )
              : Expanded(
                child: ListView.builder(
                  itemCount: filteredSellers.length,
                  itemBuilder: (context, index) {
                    final seller = filteredSellers[index];
                    return GestureDetector(
                      onTap: () => navigateToSeller(context, seller),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (seller['logo'] != null &&
                                    seller['logo'].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: CachedNetworkImage(
                                      imageUrl: seller['logo'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
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
                                        child: CachedNetworkImage(
                                          imageUrl: product['photo'] ?? '',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
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
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    bool isChecked,
    VoidCallback onTap, {
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isChecked ? Color.fromRGBO(157, 0, 1, 1.0) : Colors.black,
                  width: 2,
                ),
              ),
              child: Center(
                child:
                    isChecked
                        ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(157, 0, 1, 1.0),
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 18, color: Color.fromRGBO(157, 0, 1, 1.0)),
          ],
        ),
      ),
    );
  }
}
