import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class Cart extends StatefulWidget {
  final String token;
  const Cart({super.key, required this.token});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> cartItems = [];
  Set<int> selectedItems = {};
  bool isSelectionMode = false;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    final url = Uri.parse('https://api.buildhubware.com/api/v1.1/cart/');
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          cartItems = data['cart'];
          totalPrice = data['total_price'].toDouble();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to load cart')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  //NOT WORKING YET
  Future<void> _deleteSelectedItems() async {
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    for (var id in selectedItems) {
      final url = Uri.parse(
        'https://api.buildhubware.com/api/v1.1/cart/$id',
      ); //ask the backend dev for the correct endpoint
      try {
        final response = await http.delete(url, headers: headers);
        if (response.statusCode != 200 && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete item $id')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting item $id: $e')),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        cartItems.removeWhere((item) => selectedItems.contains(item['id']));
        selectedItems.clear();
        isSelectionMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            isSelectionMode ? Icons.checklist : Icons.select_all,
            color:
                isSelectionMode ? Color.fromRGBO(157, 0, 1, 1.0) : Colors.black,
          ),
          onPressed: () {
            setState(() {
              isSelectionMode = !isSelectionMode;
              selectedItems.clear();
            });
          },
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'My Cart',
              style: TextStyle(
                color: Color.fromRGBO(157, 0, 1, 1.0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '(${cartItems.length} items)',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
      body:
          cartItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            cartItems.map((cartItem) {
                              var product = cartItem['product'];
                              return Stack(
                                children: [
                                  CartItemWidget(
                                    name: product['menu'],
                                    description: product['description'],
                                    quantity: cartItem['quantity'],
                                    price: double.parse(product['price']),
                                    imageUrl: product['photo'],
                                    cartId: cartItem['id'],
                                    token: widget.token,
                                    onUpdate: _fetchCartData,
                                  ),
                                  if (isSelectionMode)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Checkbox(
                                        value: selectedItems.contains(
                                          cartItem['id'],
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedItems.add(cartItem['id']);
                                            } else {
                                              selectedItems.remove(
                                                cartItem['id'],
                                              );
                                            }
                                          });
                                        },
                                        activeColor: Color.fromRGBO(
                                          157,
                                          0,
                                          1,
                                          1.0,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              const Color.fromARGB(255, 170, 11, 0),
              Color.fromRGBO(157, 0, 1, 1.0),
              Color.fromRGBO(95, 1, 1, 1),
              Color.fromRGBO(37, 0, 0, 1),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₱ ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (isSelectionMode && selectedItems.isNotEmpty)
              TextButton(
                onPressed: _deleteSelectedItems,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(40, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text('Delete'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  // Add checkout function
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                    157,
                    0,
                    1,
                    1.0,
                  ), // Red fill
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Curved corners
                  ),
                ),
                child: const Text('Checkout'),
              ),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String imageUrl;
  final int cartId;
  final String token;
  final VoidCallback onUpdate;

  const CartItemWidget({
    super.key,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.cartId,
    required this.token,
    required this.onUpdate,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  Future<void> _updateQuantity(int newQuantity) async {
    if (newQuantity < 1) return;

    final url = Uri.parse(
      'https://api.buildhubware.com/api/v1.1/cart/${widget.cartId}',
    );
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'quantity': newQuantity});

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          quantity = newQuantity;
        });
        widget.onUpdate();
      } else {
        _showSnackbar('Failed to update quantity');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('Error: $e');
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * widget.price;

    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.toUpperCase(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '₱ ${widget.price.toStringAsFixed(2)} each'.toUpperCase(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(widget.description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: () => _updateQuantity(quantity - 1),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          padding: const EdgeInsets.all(1),
                          minimumSize: const Size(28, 28),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(157, 0, 1, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => _updateQuantity(quantity + 1),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(4),
                          minimumSize: const Size(28, 28),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Total', style: const TextStyle(fontSize: 14)),
                      Text(
                        ' ₱ ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(157, 0, 1, 1.0),
                          fontSize: 15,
                        ),
                      ),
                    ],
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
