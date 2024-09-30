import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:exercisecoach/widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/customized_button.dart';
import 'forgot_passwor.dart';
// import 'package:exercisecoach/screens/home_view_screen.dart';
import 'package:exercisecoach/screens/welcome_screen.dart';

// Stateful widget for the login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to manage text input for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button to navigate to the previous screen
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_sharp),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  // Welcome message
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Welcome Back! Glad \nto see you again",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  // Email input field
                  CustomizedTextfield(
                    myController: _emailController,
                    hintText: "Enter your Email",
                    isPassword: false,
                  ),
                  // Password input field
                  CustomizedTextfield(
                    myController: _passwordController,
                    hintText: "Enter your Password",
                    isPassword: true,
                  ),
                  // Forgot Password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()));
                        },
                        child: const Text("Forgot Password?",
                            style: TextStyle(
                              color: Color(0xff6A707C),
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                  // Login button
                  CustomizedButton(
                    buttonText: "Login",
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      try {
                        // Attempt to log in the user with email and password
                        await FirebaseAuthService().login(
                            _emailController.text.trim(),
                            _passwordController.text.trim());
                        // Check if the user is successfully logged in
                        if (FirebaseAuth.instance.currentUser != null) {
                          if (!mounted) return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()));
                        }
                      } on FirebaseException catch (e) {
                        debugPrint("error is ${e.message}");
                        // Show an error dialog if the login fails
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: const Text(
                                    " Invalid Username or password. Please register again or make sure that username and password is correct"),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Register Now"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const SignUpScreen()));
                                    },
                                  )
                                ]));
                      }
                    },
                  ),
                  // Separator for alternative login methods
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.grey,
                        ),
                        const Text("Or Login with"),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  // Buttons for alternative login methods (Facebook, Google, Apple)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            )),
                        Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.google,
                            ),
                            onPressed: () async {
                              await FirebaseAuthService().logininwithgoogle();
                              // Check if the user is successfully logged in with Google
                              if (FirebaseAuth.instance.currentUser != null) {
                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomeScreen()));
                              } else {
                                throw Exception("Error");
                              }
                            },
                          ),
                        ),
                        Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.apple,
                              ),
                              onPressed: () {},
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 140,
                  ),
                  // Link to the registration page
                  const Padding(
                    padding: EdgeInsets.fromLTRB(48, 8, 8, 8.0),
                    child: Row(
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(
                              color: Color(0xff1E232C),
                              fontSize: 15,
                            )),
                        Text("  Register Now",
                            style: TextStyle(
                              color: Color(0xff35C2C1),
                              fontSize: 15,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
