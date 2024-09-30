import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

// Stateful widget for the introductory page with a carousel slider
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _controller = CarouselController(); // Controller for the carousel slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Carousel slider for displaying introductory images and text
          CarouselSlider(
            items: [
              _buildCarouselItem(
                'assets/images/image3.jpg',
                'Get fit and healthy',
                'Track your workouts and stay motivated to reach your fitness goals.',
              ),
              _buildCarouselItem(
                'assets/images/emely.jpg',
                'Join a community',
                'Connect with other fitness enthusiasts and share your progress.',
              ),
              _buildCarouselItem(
                'assets/images/image2.png',
                'Challenge yourself',
                'Compete with others and see how you stack up against the competition.',
              ),
            ],
            carouselController: _controller, // Controller for the carousel slider
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {}, // Callback for page change
            ),
          ),
          // Positioned buttons for navigation to login and sign-up screens
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Login button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set the background color for the button
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)), // Set the padding
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 20)), // Set the text style
                    fixedSize: MaterialStateProperty.all<Size>(const Size(25, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))), // Set the shape
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                // Sign-up button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blueGrey), // Set the background color for the button
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)), // Set the padding
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 23)), // Set the text style
                    fixedSize: MaterialStateProperty.all<Size>(const Size(20, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))), // Set the shape
                  ),
                  child: const Text('Sign up', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build individual carousel items
  Widget _buildCarouselItem(String imagePath, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Title text
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF68B984),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Subtitle text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
