// Archivo de configuración de Firebase.
//
// IMPORTANTE:
// Este archivo debe reemplazarse con el generado por el comando:
// flutterfire configure
//
// Se incluye una estructura de ejemplo para que el proyecto muestre claramente
// dónde se inicializa Firebase. Los valores reales dependen de tu proyecto
// creado en Firebase Console.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'Firebase no está configurado para esta plataforma. Ejecuta flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TU_API_KEY_WEB',
    appId: 'TU_APP_ID_WEB',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    authDomain: 'TU_PROJECT_ID.firebaseapp.com',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_ANDROID',
    appId: 'TU_APP_ID_ANDROID',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_IOS',
    appId: 'TU_APP_ID_IOS',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
    iosBundleId: 'com.example.appActividad37Firebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TU_API_KEY_MACOS',
    appId: 'TU_APP_ID_MACOS',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
    iosBundleId: 'com.example.appActividad37Firebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'TU_API_KEY_WINDOWS',
    appId: 'TU_APP_ID_WINDOWS',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    authDomain: 'TU_PROJECT_ID.firebaseapp.com',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );
}
