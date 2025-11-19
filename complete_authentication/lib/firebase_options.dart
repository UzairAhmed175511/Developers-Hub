import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCAi90joDJB0KpJF1tNXdcRZDp2Mw22_Mc",
    authDomain: "fluttermvvmauth.firebaseapp.com",
    projectId: "fluttermvvmauth",
    storageBucket: "fluttermvvmauth.firebasestorage.app",
    messagingSenderId: "164306165639",
    appId: "1:164306165639:web:cdf08eabbc6c5414cebd22",
    measurementId: "G-DYKE4TPN4E",
  );

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "YOUR_ANDROID_API_KEY",
    appId: "YOUR_ANDROID_APP_ID",
    messagingSenderId: "YOUR_ANDROID_MESSAGING_SENDER_ID",
    projectId: "fluttermvvmauth",
    storageBucket: "fluttermvvmauth.appspot.com",
  );

  // iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "YOUR_IOS_API_KEY",
    appId: "YOUR_IOS_APP_ID",
    messagingSenderId: "YOUR_IOS_MESSAGING_SENDER_ID",
    projectId: "fluttermvvmauth",
    storageBucket: "fluttermvvmauth.appspot.com",
    iosBundleId: "com.example.completeAuthentication",
    iosClientId: "YOUR_IOS_CLIENT_ID",
    androidClientId: "YOUR_ANDROID_CLIENT_ID",
    measurementId: "G-DYKE4TPN4E",
  );

  // macOS configuration (can reuse iOS config if same)
  static const FirebaseOptions macos = ios;

  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "YOUR_WINDOWS_API_KEY",
    appId: "YOUR_WINDOWS_APP_ID",
    messagingSenderId: "YOUR_WINDOWS_MESSAGING_SENDER_ID",
    projectId: "fluttermvvmauth",
    storageBucket: "fluttermvvmauth.appspot.com",
  );

  // Linux configuration (optional)
  static const FirebaseOptions linux = windows;

  /// Returns the appropriate FirebaseOptions depending on platform
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
