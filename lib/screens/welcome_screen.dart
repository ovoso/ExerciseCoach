import 'package:exercisecoach/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Stateless widget representing the Welcome screen
class WelcomeScreen extends StatelessWidget {
  final List levels = [
    "inactive",
    "Beginner",
  ];

  // Constructor for WelcomeScreen
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main container for the welcome screen
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row displaying the app name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "EXERCISE" text
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "EXERCISE",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 56,
                      color: Colors.white,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                // "COACH" text with different color
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "COACH ",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 56,
                      color: const Color(0xFF68B984),
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            // Main content area
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row displaying "Exercise, Made Fun" text
                  Row(
                    children: [
                      Text(
                        "Exercise, ",
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Made Fun",
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: const Color(0xFF68B984),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Description text
                  Text(
                    "We will help you reach your potential.\nFollow the next steps, to complete your information",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  // Padding for the bottom navigation
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, top: 40, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // "Skip Intro" text
                        Text(
                          "Skip Intro",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white30,
                          ),
                        ),
                        // "Next" button to navigate to the bottom navigation screen
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNav()));
                          },
                          child: Container(
                            width: 139,
                            height: 39,
                            decoration: BoxDecoration(
                              color: const Color(0xFF68B984)
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
