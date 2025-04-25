import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  final String token;
  const Orders({super.key, required this.token});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
