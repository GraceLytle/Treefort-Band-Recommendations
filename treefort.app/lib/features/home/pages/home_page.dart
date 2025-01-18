import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/shared/footer.dart';
import 'package:flutter_application_2/features/shared/main_menu.dart';
import 'package:flutter_application_2/features/home/components/carousel_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Set the logo size based on breakpoints
    double logoWidth = screenWidth > 1200
        ? 280
        : screenWidth > 800
            ? 260
            : 220;

    // Set the main font size based on breakpoints
    double baseFontSize = screenWidth > 1200
        ? 42
        : screenWidth > 800
            ? 36
            : 28;

    // Set the sub font size based on breakpoints
    double subFontSize = screenWidth > 1200
        ? 20
        : screenWidth > 800
            ? 18
            : 14;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FBF4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Menu bar widget
            const ResponsiveMenuBar(),
            Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Festival logo
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Image.asset(
                        'lib/resources/treefort_logo.png',
                        width: logoWidth,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hot Artists Carousel
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Hot Artists',
                          style: TextStyle(
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ArtistsCarousel(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Band Rec Survey subtitle and button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Want to figure out which acts to see? Get customized recommendations!',
                            style: TextStyle(fontSize: baseFontSize * 0.8),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF94C973),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/survey');
                          },
                          child: Text(
                            'Set Music Preferences',
                            style: TextStyle(
                                fontSize: baseFontSize * 0.75,
                                color: const Color(0xFFF5FBF4)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
            // Use the shared Footer widget
            const Footer(),
          ],
        ),
      ),
    );
  }
}
