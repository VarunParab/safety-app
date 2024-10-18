import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:safety_app/pages/main_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "",
      password = "",
      name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Registration function with email verification logic
  registration() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create the user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          // Send email verification
          await user.sendEmailVerification();

          // Store user data in Firestore
          await FirebaseFirestore.instance.collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': name,
            'email': email,
            'created_at': DateTime.now(),
          });

          // Show popup to verify email
          _showVerificationDialog(user);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showErrorDialog("Password should be at least 6 characters");
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog("Account Already Exists. Please log in.");
        }
      }
    }
  }

  // Show a dialog asking the user to verify their email
  Future<void> _showVerificationDialog(User user) async {
    bool isVerified = false;

    showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing the dialog
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(isVerified ? "Email Verified" : "Verify Your Email"),
              content: Text(isVerified
                  ? "Your email has been verified, you will be redirected shortly."
                  : "Please verify your email by clicking on the link sent to your email."),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (!isVerified) {
                      // Polling the verification status
                      await user.reload();
                      user = FirebaseAuth.instance.currentUser!;
                      if (user.emailVerified) {
                        setState(() {
                          isVerified = true;
                        });

                        // Delay for a while before redirecting
                        await Future.delayed(Duration(seconds: 2));

                        // Close the dialog
                        Navigator.of(context).pop();

                        // Navigate to the main screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainScreen(uid: user.uid)));
                      }
                    }
                  },
                  child: Text(isVerified ? "Proceed" : "Check Email"),
                )
              ],
            );
          });
        });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF283793),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Use min size to center vertically
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name Text Field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email Text Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Text Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Signup Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            name = nameController.text;
                            password = passwordController.text;
                          });
                          registration(); // Call registration function
                        }
                      },
                      child: Container(
                        width: 130,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFf95f3b),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have an account? Login
                  // Already have an account? Login
                  // Already have an account? Login
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white), // Keep this white
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0), // Adjust the left padding
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LogIn()));
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(color: Color(0xFFf95f3b),fontWeight: FontWeight.bold,fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
