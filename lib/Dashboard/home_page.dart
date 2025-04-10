import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:activity2_api/Dashboard/sellers.dart';
import 'package:activity2_api/Dashboard/category.dart';
import 'package:activity2_api/Text-Style/text_syle.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  //Pages
  final List<Widget> _pages = [
    Center(child: Text("Best Sellers Page")),
    CategoryPage(),
    Sellers(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo/buildhubph_logo.png', height: 40),
                    SizedBox(width: 10),
                    Image.asset('assets/logo/BPI.png', height: 40),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      _buildNavBarItem("Best Sellers", 0),
                      _buildNavBarItem("Category", 1, isPrimary: true),
                      _buildNavBarItem("Sellers", 2),
                    ],
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }

  Widget _buildNavBarItem(String label, int index, {bool isPrimary = false}) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: Container(
        color: isSelected ? Colors.white : Colors.transparent,
        child: TextButton(
          onPressed: () => _onItemTapped(index),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: isSelected ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text(label, style: AppTextStyles.navTextStyle(isSelected)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
