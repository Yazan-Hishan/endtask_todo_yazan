import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firebase_service.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();

  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _error = RxString('');
  String? get error => _error.value.isEmpty ? null : _error.value;

  bool get isLoggedIn => _firebaseService.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    // الاستماع لتغييرات حالة المصادقة
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user.value = user;
      print(
        "Auth state changed: User is ${user != null ? 'logged in' : 'logged out'}",
      );
    });
  }

  // تسجيل المستخدم باستخدام البريد الإلكتروني وكلمة المرور
  Future<bool> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = await _firebaseService.registerWithEmailAndPassword(
        email,
        password,
      );

      if (user != null) {
        // Store the user's name in Firebase
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _error.value = 'حدث خطأ في التسجيل: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = await _firebaseService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (user != null) {
        _user.value = FirebaseAuth.instance.currentUser; // Update _user
        print("Login successful for user: ${user.uid}");
        return true;
      } else {
        _error.value =
            'فشل تسجيل الدخول. يرجى التحقق من البريد الإلكتروني وكلمة المرور.';
        return false;
      }
    } catch (e) {
      _error.value = 'حدث خطأ في تسجيل الدخول: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _firebaseService.signOut();
      // أضفنا طباعة للتأكد من تنفيذ تسجيل الخروج بشكل صحيح
      print('User signed out successfully');
    } catch (e) {
      _error.value = 'حدث خطأ في تسجيل الخروج: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  // مسح رسالة الخطأ
  void clearError() {
    _error.value = '';
  }

  // تسجيل الدخول باستخدام حساب جوجل
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _error.value = 'تم إلغاء تسجيل الدخول بواسطة جوجل';
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        _user.value = FirebaseAuth.instance.currentUser; // Update _user
        // Store the user's name in Firebase
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': googleUser.displayName,
          'email': googleUser.email,
        });
        print("Google Sign-In successful for user: ${userCredential.user!.uid}");
        return true;
      } else {
        _error.value = 'فشل تسجيل الدخول باستخدام جوجل';
        return false;
      }
    } catch (e) {
      _error.value = 'حدث خطأ في تسجيل الدخول باستخدام جوجل: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _firebaseService.changePassword(oldPassword, newPassword);
      Get.snackbar(
        'تم تغيير كلمة المرور بنجاح',
        'الرجاء تسجيل الدخول مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      _error.value = 'حدث خطأ في تغيير كلمة المرور: $e';
      Get.snackbar(
        'خطأ',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
