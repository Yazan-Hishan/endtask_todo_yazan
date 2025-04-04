// ملاحظة: هذا ملف مثال فقط. في التطبيق الحقيقي، يجب استخدام الملف الذي تم إنشاؤه بواسطة Firebase CLI
// يمكنك إضافة هذا الملف بنفسك باستخدام الأمر: flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// خيارات التكوين الافتراضية لتطبيق Firebase الخاص بك.
///
/// مثال للاستخدام في main.dart:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCXmjVeZP5cMf3DVlslEyr5P4bH0o_djBQ',
    appId: '1:785786762137:web:2cb78c0268879275225908',
    messagingSenderId: '785786762137',
    projectId: 'device-streaming-00007ff8',
    authDomain: 'device-streaming-00007ff8.firebaseapp.com',
    storageBucket: 'device-streaming-00007ff8.firebasestorage.app',
  );

  // تعديل هذه القيم بقيم التكوين الخاصة بك

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAL-Fz8Dtgu1bK1KBmP9sdAeMaL6MgPuJk',
    appId: '1:785786762137:android:8684a7042b862c8c225908',
    messagingSenderId: '785786762137',
    projectId: 'device-streaming-00007ff8',
    storageBucket: 'device-streaming-00007ff8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH5WQqh7E5erB6Girdm3UqYbxnEP1_kGU',
    appId: '1:785786762137:ios:065c292052417894225908',
    messagingSenderId: '785786762137',
    projectId: 'device-streaming-00007ff8',
    storageBucket: 'device-streaming-00007ff8.firebasestorage.app',
    iosBundleId: 'com.example.endtaskTodoYazan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAH5WQqh7E5erB6Girdm3UqYbxnEP1_kGU',
    appId: '1:785786762137:ios:065c292052417894225908',
    messagingSenderId: '785786762137',
    projectId: 'device-streaming-00007ff8',
    storageBucket: 'device-streaming-00007ff8.firebasestorage.app',
    iosBundleId: 'com.example.endtaskTodoYazan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCXmjVeZP5cMf3DVlslEyr5P4bH0o_djBQ',
    appId: '1:785786762137:web:dcac1b354d47d48e225908',
    messagingSenderId: '785786762137',
    projectId: 'device-streaming-00007ff8',
    authDomain: 'device-streaming-00007ff8.firebaseapp.com',
    storageBucket: 'device-streaming-00007ff8.firebasestorage.app',
  );

}