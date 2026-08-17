// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// إعدادات مشروع Firebase الحقيقي (bahah-ed88e) لمنصة الويب.
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
    apiKey: 'AIzaSyB0PZPB4eTwF2_FSDw129sxt9z7J92lb3w',
    appId: '1:465977234729:web:ef31ca754cebe48cee1338',
    messagingSenderId: '465977234729',
    projectId: 'bahah-ed88e',
    authDomain: 'bahah-ed88e.firebaseapp.com',
    storageBucket: 'bahah-ed88e.firebasestorage.app',
  );
}
