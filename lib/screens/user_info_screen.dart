import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات المستخدم'),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body: Obx(() {
        final String? userId = authController.user?.uid;

        if (userId == null) {
          return const Center(child: Text('المستخدم غير مسجل الدخول'));
        }

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text('لم يتم العثور على بيانات المستخدم'),
              );
            }

            final userData =
                snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final String name = userData['name'] ?? 'غير متوفر';
            final String email = userData['email'] ?? 'غير متوفر';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('الاسم: $name'),
                          leading: const Icon(Icons.person),
                        ),
                        ListTile(
                          title: Text('البريد الإلكتروني: $email'),
                          leading: const Icon(Icons.email),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.CHANGE_PASSWORD);
                    },
                    child: const Text('تغيير كلمة المرور'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await authController.signOut();
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: const Text('تسجيل الخروج'),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
