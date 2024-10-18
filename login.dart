import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safety_app/pages/forgotpassword.dart';
import 'package:safety_app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/pages/main_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  Future<void> userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the UID of the logged-in user
      String uid = userCredential.user!.uid;

      // Check if the user data exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        // User data doesn't exist in Firestore, show error and sign out
        await FirebaseAuth.instance.signOut();
        _showSignUpDialog(context, 'Account does not exist, please sign up.');
      } else {
        // Update the user's last login time if the document exists
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          "lastLogin": FieldValue.serverTimestamp(),
        });

        // Navigate to Home and pass the UID
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(uid: uid)),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.code}');
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _showErrorDialog(context, 'Wrong Credential');
      } else {
        _showErrorDialog(context, "Wrong Credentials");
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSignUpDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Not Found'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF283793),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 150),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset(
                //   "images/redoval.png",
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height / 2.9,
                //   fit: BoxFit.cover,
                // ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Welcome\nBack",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontFamily: 'Pacifico'),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4c59a5),
                      borderRadius: BorderRadius.circular(22)),
                  child: TextFormField(
                    controller: useremailcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter E-Mail';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: 'Your Email',
                        hintStyle: TextStyle(color: Colors.white60)),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4c59a5),
                      borderRadius: BorderRadius.circular(22)),
                  child: TextFormField(
                    controller: userpasswordcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white60)),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 24.0),
                    alignment: Alignment.bottomRight,
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color(0xFFf95f3b), fontSize: 18.0,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        email = useremailcontroller.text;
                        password = userpasswordcontroller.text;
                      });
                      userLogin();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFf95f3b),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New User?",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          " Signup",
                          style: TextStyle(
                              color: Color(0xFFf95f3b),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
