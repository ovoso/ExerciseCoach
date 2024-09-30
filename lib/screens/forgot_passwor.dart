import 'package:exercisecoach/widgets/customized_button.dart';
import 'package:flutter/material.dart';
import '../widgets/customized_textfield.dart';

// Stateful widget for the Forgot Password screen
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Controller to manage the text input for the email field
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Container to fill the height of the screen
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                    },
                  ),
                ),
              ),
              // Title text
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              // Description text
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Don't worry, it happens to the best of us. We will send you a link to reset your password.",
                  style: TextStyle(
                    color: Color(0xff8391A1),
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Email input field
              CustomizedTextfield(
                myController: _emailController,
                hintText: "Enter your Email",
                isPassword: false,
              ),
              // Send Code button
              CustomizedButton(
                buttonText: "Send Code",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Spacer to push the content to the top
              const Spacer(
                flex: 1,
              ),
              // Row with a text and a link to the login page
              Padding(
                padding: const EdgeInsets.fromLTRB(68, 8, 8, 8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Remember Password?",
                        style: TextStyle(
                          color: Color(0xff1E232C),
                          fontSize: 15,
                        )),
                    InkWell(
                      onTap: () {},
                      child: const Text("  Login",
                          style: TextStyle(
                            color: Color(0xff35C2C1),
                            fontSize: 15,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
