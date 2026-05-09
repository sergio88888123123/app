// Archivo de ejemplo para que el proyecto tenga la estructura completa.
// Para una conexión real, ejecuta en la raíz del proyecto:
// dart pub global activate flutterfire_cli
// flutterfire configure
// Ese comando reemplazará este archivo con la configuración real de Firebase.

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
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_WEB',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    authDomain: 'REEMPLAZAR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_ANDROID',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_IOS',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
    iosBundleId: 'com.example.piCatalogoPeliculas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_MACOS',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
    iosBundleId: 'com.example.piCatalogoPeliculas',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_WINDOWS',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    authDomain: 'REEMPLAZAR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID_LINUX',
    messagingSenderId: 'REEMPLAZAR_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
  );
}
