import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // شعار التطبيق
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

                    // عنوان الشاشة
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // وصف الشاشة
                    Text(
                      'سجل دخولك للوصول إلى مهامك',
                      style: TextStyle(
                        fontSize: 16,
                        color: Get.theme.textTheme.bodyMedium!.color!
                            .withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // حقل البريد الإلكتروني
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'أدخل بريدك الإلكتروني',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        // التحقق من صحة البريد الإلكتروني
                        if (!GetUtils.isEmail(value)) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // حقل كلمة المرور
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'أدخل كلمة المرور',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // رابط نسيت كلمة المرور
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // TODO: تنفيذ إعادة تعيين كلمة المرور
                        },
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // زر تسجيل الدخول
                    Obx(
                      () => ElevatedButton(
                        onPressed:
                            _authController.isLoading
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await _authController
                                        .signInWithEmailAndPassword(
                                          _emailController.text.trim(),
                                          _passwordController.text,
                                        );

                                    if (success) {
                                      Get.offAllNamed(Routes.HOME);
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child:
                            _authController.isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Get.theme.colorScheme.onPrimary,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('جاري تسجيل الدخول...'),
                                  ],
                                )
                                : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // زر تسجيل الدخول باستخدام جوجل
                    ElevatedButton.icon(
                      onPressed: _authController.isLoading
                          ? null
                          : () async {
                              final success = await _authController.signInWithGoogle();
                              if (success) {
                                Get.offAllNamed(Routes.HOME);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // لون زر جوجل
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: _authController.isLoading
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                      label: _authController.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Get.theme.colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'جاري تسجيل الدخول...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : const Text(
                              'تسجيل الدخول باستخدام جوجل',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // رابط إنشاء حساب جديد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(
                            color: Get.theme.textTheme.bodyMedium!.color!
                                .withOpacity(0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: const Text('إنشاء حساب'),
                        ),
                      ],
                    ),

                    // عرض رسائل الخطأ
                    Obx(() {
                      if (_authController.error != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _authController.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
