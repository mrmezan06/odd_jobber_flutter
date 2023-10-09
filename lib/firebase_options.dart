// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB7OcosalrDMRd6aYKjrZHMs6mOyJERdrk',
    appId: '1:295118304537:web:bd60ecd16831691ae58188',
    messagingSenderId: '295118304537',
    projectId: 'odd-jobber',
    authDomain: 'odd-jobber.firebaseapp.com',
    storageBucket: 'odd-jobber.appspot.com',
    measurementId: 'G-NZJQF14HLD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB02Yl5HQ3nnFQqlfU32HSe7tu2_C_d0hk',
    appId: '1:295118304537:android:2df1a2f72e260f39e58188',
    messagingSenderId: '295118304537',
    projectId: 'odd-jobber',
    storageBucket: 'odd-jobber.appspot.com',
  );
}
