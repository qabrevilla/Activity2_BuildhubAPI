import 'package:flutter/material.dart';
import 'package:activity2_api/Starting-Screen/splash_screen.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromRGBO(157, 0, 1, 1.0)),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Red Profile Box
                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(157, 0, 1, 1.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/profile/aldwin.jpg',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Aldwin Joseph B. Revilla',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'quabrevilla@tip.edu.ph (Verified)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Type: Buyer',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Account Information Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Text(
                        'ACCOUNT',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'MY PROFILE',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'EMAIL ADDRESS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'CHANGE PASSWORD',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Text(
                        'LOCATION',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ADDRESS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Text(
                        'HELP AND SUPPORT',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'CONTACT US',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'FAQS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'BLOGS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {
                          // Show the confirmation dialog before navigating
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(fontSize: 20),
                                ),
                                content: const Text(
                                  'Are you sure do you want to log out?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Dismiss the dialog and do nothing
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog and navigate to the SplashScreen
                                      Navigator.of(
                                        context,
                                      ).pop(); // Close the dialog
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SplashScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: Color.fromRGBO(157, 0, 1, 1.0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(157, 0, 1, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Disable my account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(157, 0, 1, 1.0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
