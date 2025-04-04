import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Simulate some loading process
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to Home if user is logged in, otherwise navigate to Login
      Get.offAllNamed(FirebaseAuth.instance.currentUser != null ? Routes.HOME : Routes.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              'تطبيق قائمة المهام',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
