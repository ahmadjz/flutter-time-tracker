import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:time_tracker_null_safety/Services/auth.dart';

class SignInManager {
  SignInManager({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  Future<UserProgram?> _signIn(
      Future<UserProgram?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<UserProgram?> signInAnonymously() async =>
      _signIn(auth.signInAnonymously);

  Future<UserProgram?> signInWithGoogle() async {
    _signIn(auth.signInWithGoogle);
  }

  Future<UserProgram?> signInWithFacebook() async {
    _signIn(auth.signInWithFacebook);
  }
}
