import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import './firebase_options.dart';
import './bindings/app_bindings.dart';
import './routes/app_pages.dart';
import './utils/theme_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  // Initialize flutter_local_notifications
const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
        'ic_launcher',
      ); // replace app_icon with your app's icon name
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // تهيئة GetStorage للتخزين المحلي
  await GetStorage.init();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تهيئة ThemeService قبل بناء الواجهة
  final themeService = ThemeService();
  Get.put(themeService, permanent: true);

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'تطبيق قائمة المهام',
      debugShowCheckedModeBanner: false,
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: themeService.theme,
      // إضافة دعم اللغة العربية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
      locale: const Locale('ar', 'SA'),
      // ضبط الاتجاه من اليمين إلى اليسار
      textDirection: TextDirection.rtl,
      // إضافة مسارات التطبيق
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}
