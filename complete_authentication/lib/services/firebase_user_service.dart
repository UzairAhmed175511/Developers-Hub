import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

class FirebaseUserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email ?? '');
  }

  Stream<UserModel?> get user =>
      _auth.authStateChanges().map(_userFromFirebase);

  // Store web confirmation result
  ConfirmationResult? _webConfirmationResult;

  // =======================
  // Email/Password Methods
  // =======================

  Future<UserModel?> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(result.user);
  }

  Future<UserModel?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(result.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // =======================
  // Phone / OTP Methods
  // =======================

  Future<void> verifyPhone(
    String phoneNumber,
    void Function(String verificationId, int? resendToken) codeSent,
    void Function(String error) onFailed,
  ) async {
    if (kIsWeb) {
      try {
        _webConfirmationResult = await _auth.signInWithPhoneNumber(
          phoneNumber,
          RecaptchaVerifier(
            auth: FirebaseAuthPlatform.instance, // required for web
            container: 'recaptcha-container', // must exist in index.html
            size: RecaptchaVerifierSize.normal,
            theme: RecaptchaVerifierTheme.light,
          ),
        );
        codeSent('', null); // Web doesn't require verificationId
      } on FirebaseAuthException catch (e) {
        onFailed(e.message ?? 'Phone verification failed');
      }
    } else {
      // Mobile (Android/iOS)
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onFailed(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<UserModel?> signInWithOTP({
    String? verificationId,
    required String smsCode,
  }) async {
    if (kIsWeb) {
      if (_webConfirmationResult == null) {
        throw Exception('No OTP request in progress');
      }
      final userCredential = await _webConfirmationResult!.confirm(smsCode);
      return _userFromFirebase(userCredential.user);
    } else {
      if (verificationId == null) {
        throw Exception('verificationId required for mobile OTP login');
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final result = await _auth.signInWithCredential(credential);
      return _userFromFirebase(result.user);
    }
  }

  // =======================
  // Logout
  // =======================

  Future<void> logout() async {
    await _auth.signOut();
  }
}
