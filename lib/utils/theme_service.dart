import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // متغير لتتبع حالة الثيم
  final RxBool _isDarkMode = false.obs;

  ThemeService() {
    _isDarkMode.value = _loadThemeFromBox();
  }

  // حفظ حالة الثيم (فاتح/داكن) في التخزين المحلي
  _saveThemeToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
    _isDarkMode.value = isDarkMode;
  }

  // قراءة حالة الثيم من التخزين المحلي
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // الحصول على الثيم الحالي
  ThemeMode get theme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // الحصول على قيمة Rx للثيم
  RxBool get rxIsDarkMode => _isDarkMode;

  // تبديل حالة الثيم
  void switchTheme() {
    final isDarkMode = _isDarkMode.value;
    _isDarkMode.value = !isDarkMode;
    Get.changeThemeMode(!isDarkMode ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(!isDarkMode);

    // إرسال حدث لتحديث الواجهة
    print("Theme changed to: ${!isDarkMode ? 'dark' : 'light'}");
    Get.forceAppUpdate();

    // محاولة لإجبار تحديث كل المكونات
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.appUpdate();
    });
  }

  // ألوان الوضع الفاتح
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E88E5), // أزرق هادئ
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1E88E5), // أزرق هادئ
      secondary: const Color(0xFFFFC107), // أصفر ذهبي
      surface: Colors.white,
      background: const Color(0xFFF5F5F5), // رمادي فاتح جدًا
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: const Color(0xFF333333), // رمادي غامق
      onBackground: const Color(0xFF333333), // رمادي غامق
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // رمادي فاتح جدًا
    cardColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Color(0xFF757575), // رمادي متوسط
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: const Color(0xFF333333),
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: const Color(0xFF333333),
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: const Color(0xFF333333)),
      bodyMedium: TextStyle(color: const Color(0xFF333333)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E88E5), // أزرق هادئ
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E88E5), // أزرق هادئ
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1E88E5), // أزرق هادئ
        side: const BorderSide(color: Color(0xFF1E88E5)), // أزرق هادئ
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1E88E5), // أزرق هادئ
      foregroundColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF1E88E5); // أزرق هادئ
        }
        return null;
      }),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF1E88E5),
          width: 2,
        ), // أزرق هادئ
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // ألوان الوضع الداكن
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF42A5F5), // أزرق ناعم
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF42A5F5), // أزرق ناعم
      secondary: const Color(0xFFFFD54F), // أصفر ذهبي فاتح
      surface: const Color(0xFF1E1E1E), // رمادي غامق
      background: const Color(0xFF121212), // أسود مائل إلى الرمادي الغامق جدًا
      error: Colors.red.shade700,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: const Color(0xFFEEEEEE), // رمادي فاتح جدًا
      onBackground: const Color(0xFFEEEEEE), // رمادي فاتح جدًا
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(
      0xFF121212,
    ), // أسود مائل إلى الرمادي الغامق جدًا
    cardColor: const Color(0xFF1E1E1E), // رمادي غامق
    iconTheme: const IconThemeData(
      color: Color(0xFFBDBDBD), // رمادي فاتح
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: const Color(0xFFEEEEEE),
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: const Color(0xFFEEEEEE),
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: const Color(0xFFEEEEEE)),
      bodyMedium: TextStyle(color: const Color(0xFFEEEEEE)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A), // رمادي غامق
      foregroundColor: Color(0xFFEEEEEE), // رمادي فاتح جدًا
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF42A5F5), // أزرق ناعم
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF42A5F5), // أزرق ناعم
        side: const BorderSide(color: Color(0xFF42A5F5)), // أزرق ناعم
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF42A5F5), // أزرق ناعم
      foregroundColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF42A5F5); // أزرق ناعم
        }
        return null;
      }),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E), // رمادي غامق
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E), // رمادي غامق
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF42A5F5),
          width: 2,
        ), // أزرق ناعم
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
