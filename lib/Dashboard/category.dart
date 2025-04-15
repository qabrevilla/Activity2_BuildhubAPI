import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  final List<String> imgList = [
    'assets/partners/atlanta.png',
    'assets/partners/centurypeak.png',
    'assets/partners/dn.png',
    'assets/partners/dost.png',
    'assets/partners/exzzon.png',
    'assets/partners/lalamove.png',
    'assets/partners/paynamics.png',
    'assets/partners/silka.png',
    'assets/partners/tkl.png',
    'assets/partners/transportify.png',
    'assets/partners/union.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(157, 0, 1, 1.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Our Brand Partners',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'We are grateful to work with these incredible',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Center(
                    child: Text(
                      'brands',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Carousel slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 100,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 1),
                      autoPlayAnimationDuration: Duration(milliseconds: 300),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      viewportFraction: 0.6,
                    ),

                    items:
                        imgList
                            .map(
                              (item) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(item, fit: BoxFit.contain),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            // Container for the grid view
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(6, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/place the image'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
