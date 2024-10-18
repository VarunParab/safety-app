// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final String uid;
//   final Map<String, dynamic> userData;
//
//   const ProfileScreen({Key? key, required this.uid, required this.userData})
//       : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   TextEditingController _passwordController = TextEditingController();
//
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize with passed userData
//     _nameController = TextEditingController(text: widget.userData['name']);
//     _emailController = TextEditingController(text: widget.userData['email']);
//     _phoneController = TextEditingController(text: widget.userData['phone']);
//   }
//
//   Future<void> _updateUserData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       User? user = _auth.currentUser;
//
//       if (user != null) {
//         await _firestore.collection('users').doc(widget.uid).update({
//           'name': _nameController.text,
//           'email': _emailController.text,
//           'phone': _phoneController.text,
//         });
//
//         if (_passwordController.text.isNotEmpty) {
//           await user.updatePassword(_passwordController.text);
//         }
//
//         if (user.email != _emailController.text) {
//           await user.updateEmail(_emailController.text);
//         }
//
//         Get.snackbar('Success', 'Profile updated successfully');
//       }
//     } catch (e) {
//       print('Failed to update user data: $e');
//       Get.snackbar('Error', 'Failed to update profile');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         automaticallyImplyLeading: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(labelText: 'Phone'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'New Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _updateUserData,
//               child: const Text('Update Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;

  const ProfileScreen({Key? key, required this.uid, required this.userData})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
  }

  Future<void> _updateUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(widget.uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });

        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }

        if (user.email != _emailController.text) {
          await user.updateEmail(_emailController.text);
        }

        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      print('Failed to update user data: $e');
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Update your Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _updateUserData,
                //icon: const Icon(Icons.update),
                label: const Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                  Theme.of(context).colorScheme.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
