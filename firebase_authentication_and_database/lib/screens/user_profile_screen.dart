import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/responsive.dart';

class UserProfileScreen extends StatelessWidget {
  final String uid; // <-- ADD THIS

  const UserProfileScreen({super.key, required this.uid}); // <-- ADD THIS

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Container(
          width: Responsive.isWeb(context) ? 500 : size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid) // <-- USE THE PASSED UID
                .snapshots(),
            builder: (context, snapshot) {
              // 🔄 Loading Indicator
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // ❌ Error Handling
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // ❌ Document does not exist
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text(
                    'User data not found',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              // ✅ Data Loaded
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final name = userData['name'] ?? '';
              final email = userData['email'] ?? '';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: Responsive.isMobile(context) ? 50 : 60,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      name.isNotEmpty ? name[0] : email[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context) ? 36 : 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 14 : 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
