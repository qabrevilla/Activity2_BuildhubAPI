import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class QuickView extends StatefulWidget {
  final dynamic product;

  const QuickView({Key? key, required this.product}) : super(key: key);

  @override
  _QuickViewState createState() => _QuickViewState();
}

class _QuickViewState extends State<QuickView> {
  int quantity = 600;
  TextEditingController _customQuantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButtonX(
                icon: Icons.close,
                onTap: () => Navigator.pop(context),
              ),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 10),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.product['photo'] ?? '',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.error, size: 100),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.product['menu'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₱ ${NumberFormat('#,##0').format(widget.product['id'])}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(157, 0, 1, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['description'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Quantity",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        [600, 800, 1200, -1].map((value) {
                          return _buildTextButton(
                            text: value == -1 ? "Custom" : value.toString(),
                            isSelected: quantity == value,
                            onTap: () {
                              setState(() {
                                quantity = value == -1 ? 0 : value;
                              });
                              if (value == -1) {
                                _showCustomQuantityDialog();
                              }
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButtonQuantity(
                        icon: Icons.remove,
                        onTap: () {
                          setState(() {
                            if (quantity > 1) quantity -= 1;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(157, 0, 1, 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildButtonQuantity(
                        icon: Icons.add,
                        onTap: () {
                          setState(() {
                            quantity += 1;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add to Cart functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(157, 0, 1, 1.0),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show Custom Quantity
  void _showCustomQuantityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Custom Quantity',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'You can input your desired quantity here',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _customQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
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
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  quantity = int.tryParse(_customQuantityController.text) ?? 0;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(color: Color.fromRGBO(157, 0, 1, 1.0)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Close Button
  Widget _buildButtonX({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  // Quantity Adjustment Button
  Widget _buildButtonQuantity({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  // Quantity Selector Button
  Widget _buildTextButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
