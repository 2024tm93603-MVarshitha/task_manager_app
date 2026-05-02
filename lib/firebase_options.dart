import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('This platform is not supported.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGDWy29DpsQ4FT2AM60bwQzPfqtFloYY4',
    appId: '1:779936594073:android:35cd70300db5796d126008',
    messagingSenderId: '779936594073',
    projectId: 'taskmanagerapp-b311c',
    storageBucket: 'taskmanagerapp-b311c.firebasestorage.app',
  );
}