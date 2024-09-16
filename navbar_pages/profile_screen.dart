import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  final Map<String, dynamic>? userData;

  const ProfileScreen({Key? key, required this.uid, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userData?['name'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Email: ${userData?['email'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Phone: ${userData?['phone'] ?? 'N/A'}'),
            // Add other profile data as needed
          ],
        ),
      ),
    );
  }
}
