import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../authentication_client.dart';

abstract class AuthException implements Exception {
  const AuthException(this.error);

  final Object error;
}

class SignUpWithEmailPasswordFailure extends AuthException {
  const SignUpWithEmailPasswordFailure(super.error);
}

class LogInWithGoogleCanceled extends AuthException {
  const LogInWithGoogleCanceled(super.error);
}

class LogInWithGoogleFailure extends AuthException {
  const LogInWithGoogleFailure(super.error);
}

class LogInWithEmailPasswordFailure extends AuthException {
  const LogInWithEmailPasswordFailure(super.error);
}

class LogOutFailure extends AuthException {
  const LogOutFailure(super.error);
}

class AuthenticationClient {
  AuthenticationClient({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser?.toUser;
    });
  }

  Future<void> signUpWithEmailPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error, stackTrace) {
      // TODO: Handle errors
      Error.throwWithStackTrace(
          SignUpWithEmailPasswordFailure(error), stackTrace);
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleCanceled(
          Exception('Sign in with Google canceled'),
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  Future<void> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          LogInWithEmailPasswordFailure(error), stackTrace);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _googleSignIn.disconnect(),
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }
}

extension on User {
  UserModel get toUser {
    return UserModel(
      id: uid,
      email: email,
      name: displayName,
    );
  }
}
