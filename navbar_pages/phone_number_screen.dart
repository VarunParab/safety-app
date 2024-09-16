import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumber extends StatefulWidget {
  final String uid;
  const PhoneNumber({Key? key, required this.uid}) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  List<Map<String, dynamic>> contactList = [];

  @override
  void initState() {
    super.initState();
    _loadPhoneNumbers();
  }

  Future<void> _loadPhoneNumbers() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        List<dynamic> contacts = userDoc['contacts'] ?? [];
        setState(() {
          contactList = contacts.map((contact) => {
            'name': contact['name'],
            'phone': contact['phone']
          }).toList();
        });
      }
    } catch (e) {
      print('Error loading contacts: $e');
    }
  }

  Future<void> _savePhoneNumber() async {
    if (phoneNumberController.text.isEmpty || contactNameController.text.isEmpty) {
      _showErrorDialog('Please fill out all fields');
      return;
    }

    try {
      // Add new contact to the list
      contactList.add({
        'name': contactNameController.text,
        'phone': phoneNumberController.text,
      });

      // Save updated contact list to Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'contacts': contactList,
      }, SetOptions(merge: true));

      // Clear the input fields
      phoneNumberController.clear();
      contactNameController.clear();

      // Show success message
      _showSuccessDialog('Contact added successfully!');

      // Fetch the updated contact list
      _loadPhoneNumbers();
    } catch (e) {
      print('Error saving contact: $e');
      _showErrorDialog('Failed to save contact.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: contactNameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePhoneNumber,
              child: const Text('Save Contact'),
            ),
            const SizedBox(height: 24),
            const Text('Saved Contacts:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(contactList[index]['name']),
                    subtitle: Text(contactList[index]['phone']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
