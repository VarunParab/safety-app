import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String uid; // Adding UID parameter

  const Home({Key? key, required this.uid}) : super(key: key); // Updated constructor

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        // Display the UID or use it for other logic
        child: Text('Logged in user UID: ${widget.uid}'),
      ),
    );
  }
}
