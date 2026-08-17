// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// ⚠️ ملف إعدادات مؤقت (placeholder).
///
/// يجب استبدال القيم أدناه بإعدادات مشروع Firebase الحقيقي الخاص بك.
/// أسهل طريقة: ثبّت أدوات FlutterFire ثم نفّذ داخل مجلد المشروع:
///
///   dart pub global activate flutterfire_cli
///   flutterfire configure
///
/// هذا الأمر سيتصل بحسابك في Firebase (سيطلب تسجيل دخول تفاعلي في المتصفح)
/// وسيعيد كتابة هذا الملف تلقائياً بالقيم الصحيحة. راجع README.md لمزيد
/// من التفاصيل.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return web;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_API_KEY',
    appId: 'REPLACE_WITH_YOUR_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    authDomain: 'REPLACE_WITH_YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
  );
}
