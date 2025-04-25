import 'package:flutter/material.dart';
import 'package:activity2_api/Cart/cart_page.dart';
import 'package:activity2_api/Profile/profile_page.dart';
import 'package:activity2_api/Orders/orders_page.dart';
import 'package:activity2_api/Dashboard/home_page.dart';

class MainScreen extends StatefulWidget {
  final String token;

  const MainScreen({super.key, required this.token});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Home(token: widget.token), // Pass token to each page if needed
      Orders(token: widget.token),
      Cart(token: widget.token),
      ProfilePage(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Orders'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(157, 0, 1, 1.0),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
