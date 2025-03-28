import 'package:flutter/material.dart';

class QuickView extends StatefulWidget {
  final dynamic product;

  const QuickView({Key? key, required this.product}) : super(key: key);

  @override
  _QuickViewState createState() => _QuickViewState();
}

class _QuickViewState extends State<QuickView> {
  int quantity = 600; // Default quantity

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Set modal height
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Row for X button & Drag Handle
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

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.product['photo'] ?? '',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 100),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Product Name
                  Text(
                    widget.product['menu'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Product Price
                  Text(
                    "₱ ${widget.product['id']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(157, 0, 1, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Product Description
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

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        [600, 800, 1200, -1].map((value) {
                          return _buildBoxyTextButton(
                            text: value == -1 ? "Custom" : value.toString(),
                            isSelected: quantity == value,
                            onTap: () {
                              setState(() {
                                quantity = value == -1 ? 0 : value;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Quantity Adjustment (-, value, +)
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

                      // Quantity Value Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
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
                        // Implement Add to Cart Functionality Here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(157, 0, 1, 1.0),
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

  // X Button
  Widget _buildButtonX({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle, // Circular button
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

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
          border: Border.all(color: Colors.black, width: 1), // Black outline
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  Widget _buildBoxyTextButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
