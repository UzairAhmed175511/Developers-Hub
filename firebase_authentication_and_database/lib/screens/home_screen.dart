import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import 'user_profile_screen.dart';
import '../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: Responsive.isWeb(context) ? 500 : double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: Responsive.isMobile(context) ? 50 : 60,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  user?.displayName != null && user!.displayName!.isNotEmpty
                      ? user.displayName![0]
                      : user!.email![0].toUpperCase(),
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 36 : 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? user!.email!,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user!.email!,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                        // Pass the logged-in user's UID
                        uid: context.read<AuthProvider>().user!.uid,
                      ),
                    ),
                  );
                },
                child: const Text('View Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
