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
  final TextEditingController otpController = TextEditingController();

  List<Map<String, dynamic>> contactList = [];
  String verificationId = '';
  bool otpSent = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
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
          contactList = contacts
              .map((contact) => {
            'name': contact['name'],
            'phone': contact['phone']
          })
              .toList();
        });
      }
    } catch (e) {
      print('Error loading contacts: $e');
    }
  }

  Future<void> _sendOTP() async {
    if (phoneNumberController.text.isEmpty) {
      _showErrorDialog('Please enter a phone number');
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phoneNumberController.text}', // Adjust for your country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification scenario (might not trigger OTP screen)
          await FirebaseAuth.instance.signInWithCredential(credential);
          _savePhoneNumber();
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorDialog(e.message ?? 'Verification failed');
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
            otpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verId) {
          setState(() {
            verificationId = verId;
          });
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
      _showErrorDialog('Failed to send OTP');
    }
  }

  Future<void> _verifyOTP() async {
    if (otpController.text.isEmpty) {
      _showErrorDialog('Please enter the OTP');
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _savePhoneNumber();
    } catch (e) {
      print('Error verifying OTP: $e');
      _showErrorDialog('Invalid OTP');
    }
  }

  Future<void> _savePhoneNumber() async {
    if (contactNameController.text.isEmpty) {
      _showErrorDialog('Please enter a contact name');
      return;
    }

    try {
      contactList.add({
        'name': contactNameController.text,
        'phone': phoneNumberController.text,
      });

      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'contacts': contactList,
      }, SetOptions(merge: true));

      phoneNumberController.clear();
      contactNameController.clear();
      otpController.clear();

      setState(() {
        otpSent = false;
      });

      _showSuccessDialog('Contact added successfully!');
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!otpSent) ...[
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
                onPressed: _sendOTP,
                child: const Text('Send OTP'),
              ),
            ] else ...[
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP'),
              ),
            ],
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
