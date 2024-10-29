// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDYokBIQmU9FYJE6ud0D55teUu_ASPcN-w',
    appId: '1:418227783139:web:21b8094da97b38f0278cd6',
    messagingSenderId: '418227783139',
    projectId: 'developer-hub-b44ce',
    authDomain: 'developer-hub-b44ce.firebaseapp.com',
    storageBucket: 'developer-hub-b44ce.appspot.com',
    measurementId: 'G-3WBQGZ2W12',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBClKzZ6fyQV0-UUcnbZcSwnelfI4WHjOs',
    appId: '1:418227783139:android:a83f00b1558b97d6278cd6',
    messagingSenderId: '418227783139',
    projectId: 'developer-hub-b44ce',
    storageBucket: 'developer-hub-b44ce.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDYokBIQmU9FYJE6ud0D55teUu_ASPcN-w',
    appId: '1:418227783139:web:3b06ff106407cba8278cd6',
    messagingSenderId: '418227783139',
    projectId: 'developer-hub-b44ce',
    authDomain: 'developer-hub-b44ce.firebaseapp.com',
    storageBucket: 'developer-hub-b44ce.appspot.com',
    measurementId: 'G-5M0EJT6EZ0',
  );
}
