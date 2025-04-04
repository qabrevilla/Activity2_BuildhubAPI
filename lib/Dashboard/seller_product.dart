import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:activity2_api/Dashboard/quickview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class SellerProduct extends StatefulWidget {
  final dynamic seller;

  const SellerProduct({Key? key, required this.seller}) : super(key: key);

  @override
  _SellerProductState createState() => _SellerProductState();
}

class _SellerProductState extends State<SellerProduct> {
  late List<dynamic> products;
  late List<dynamic> filteredProducts;
  TextEditingController searchController = TextEditingController();
  String? selectedCategory = 'All';
  String? selectedSort = 'Highest Price';

  @override
  void initState() {
    super.initState();
    products = widget.seller['products'] ?? [];
    filteredProducts = products;
  }

  Future<List<dynamic>> fetchSellerProducts() async {
    final url =
        'https://api.buildhubware.com/api/v1.1/sellers-company?page=1&limit=0&sellerCompanyLimit=10&lng&lat&globalSearch=true';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['products'] ?? [];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts =
          products
              .where(
                (product) => product['menu'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Seller Products",
          style: TextStyle(
            color: Color.fromRGBO(157, 0, 1, 1.0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[900]),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.seller['logo'] != null &&
                      widget.seller['logo'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: widget.seller['logo'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(Icons.error, size: 40),
                        ),
                      ),
                    ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.seller['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.seller['emailAddress'] ?? 'No Email',
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.seller['address'] ?? 'No Address',
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              if (widget.seller['logo'] != null &&
                  widget.seller['logo'].isNotEmpty)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.seller['logo'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const CircularProgressIndicator(),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error, size: 50),
                      ),
                    ),
                  ),
                ),

              TextField(
                controller: searchController,
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  hintText: "Search Here..",
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
                        onPressed: () {},
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
                  Text(
                    "Filter By Category:",
                    style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                  ),
                  const SizedBox(width: 240),
                  Text(
                    "Sort By:",
                    style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: Text(
                        "All",
                        style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                      ),
                      isExpanded: true,
                      items:
                          <String>[
                            'All',
                            'Steel Bars',
                            'Cement',
                            'Paint',
                            'Aggreagate',
                            'Lights',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedSort,
                      hint: Text(
                        "Highest Price",
                        style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                      ),
                      isExpanded: true,
                      items:
                          <String>['Highest Price', 'Lowest Price'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSort = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  var product = filteredProducts[index];
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product['photo'] ?? '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error, size: 50),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (product['menu'] ?? 'No Name').toUpperCase(),
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "₱ ${NumberFormat('#,##0').format(product['id'])}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: 175,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder:
                                      (context) => FractionallySizedBox(
                                        heightFactor: 0.90,
                                        child: QuickView(product: product),
                                      ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  157,
                                  0,
                                  1,
                                  1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text(
                                "QUICK VIEW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
