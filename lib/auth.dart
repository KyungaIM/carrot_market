// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'common/util/auth/auth_util.dart';

/// A mock authentication service.
class DaangnAuth extends ChangeNotifier {
  bool _signedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  DaangnAuth(){
    _authSubscription = _auth.authStateChanges().listen((User? user){
      _signedIn = user != null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  /// Signs out the current user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _auth.signOut();
    _signedIn = false;
    notifyListeners();
  }

  /// Signs in a user.
  Future<bool> signIn() async {
    User? user = await signInWithGoogle();
    if(user == null) false;

    await Future<void>.delayed(const Duration(milliseconds: 200));
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = this.signedIn;
    final bool signingIn = state.matchedLocation == '/signin';

    if (!signedIn && !signingIn) {
      return '/signin';
    }
    else if (signedIn && signingIn) {
      return '/';
    }

    return null;
  }
}

/// An inherited notifier to host [DaangnAuth] for the subtree.
class DaangnAuthScope extends InheritedNotifier<DaangnAuth> {
  /// Creates a [DaangnAuthScope].
  const DaangnAuthScope({
    required DaangnAuth super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [DaangnAuth] above the context.
  static DaangnAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DaangnAuthScope>()!
      .notifier!;
}