import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class UserProgram {
  UserProgram(
      {required this.photoUrl, required this.displayName, required this.uid});
  final String? uid;
  final String? photoUrl;
  final String? displayName;
}

abstract class AuthBase {
  Stream<UserProgram?> get onAuthStateChanged;
  UserProgram? currentUser();
  Future<UserProgram?> signInAnonymously();
  Future<UserProgram?> signInWithGoogle();
  Future<UserProgram?> signInWithFacebook();
  Future<UserProgram?> signInWithEmailAndPassword(
      String email, String password);
  Future<UserProgram?> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  UserProgram? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserProgram(
        uid: user.uid, displayName: user.displayName, photoUrl: user.photoURL);
  }

  @override
  Stream<UserProgram?> get onAuthStateChanged {
    return FirebaseAuth.instance.authStateChanges().map(_userFromFirebase);
    //another way of writing it map((User)=> _userFromFirebase(firebaseUser
  }

  @override
  UserProgram? currentUser() {
    final user = FirebaseAuth.instance.currentUser!;
    return _userFromFirebase(user);
  }

  @override
  Future<UserProgram?> signInAnonymously() async {
    final authResult = await FirebaseAuth.instance.signInAnonymously();

    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserProgram?> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserProgram?> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserProgram?> signInWithFacebook() async {
    final facebooklogin = FacebookLogin();
    final FacebookLoginResult? result = await facebooklogin.logIn(
      permissions: [
        FacebookPermission.publicProfile,
      ],
    );
    if (result != null) {
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        FacebookAuthProvider.credential(result.accessToken!.token),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<UserProgram?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
          message: "Missing Google Auth Token",
        );
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebooklogin = FacebookLogin();
    await facebooklogin.logOut();
    await FirebaseAuth.instance.signOut();
  }
}
