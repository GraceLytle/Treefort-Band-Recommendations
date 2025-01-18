import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'dart:html' as html;

/// Mixins with the "with" Keyword
/// Dart allows classes to use mixins,code functionality that you can share
/// across multiple classes without using inheritance.
class AuthProvider with ChangeNotifier {
  /// The "late" keyword allows you to declare a non-nullable variable that is
  /// initialized after it's declaration.
  late Auth0Web auth0;

  /// Dart's null safety ensures that variables cannot be null unless explicitly
  /// declared as nullable using a question mark (?). This helps prevent null
  /// reference exceptions at runtime.
  Credentials? credentials;

  AuthProvider(String domain, String clientId) {
    ///  In Dart you can instantiate objects without using the new keyword
    auth0 = Auth0Web(domain, clientId);
    initializeCredentials();
  }

  /// Dart's async and await keywords simplify asynchronous programming
  Future<void> initializeCredentials() async {
    try {
      await _loadCredentials();
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  /// Dart does not have explicit access modifiers like public, private, or protected.
  /// Instead, it uses an underscore (_) prefix to indicate that
  /// a variable or method is private to its library.
  Future<void> _loadCredentials() async {
    try {
      credentials = await auth0.onLoad();

      /// The "notifyListeners()" method is provided by the "ChangeNotifier" mixin,
      /// allowing us to update any widgets listening to this provider.
      notifyListeners();

      /// Clear the URL after loading credentials
      html.window.history.replaceState(null, 'Flutter App', '/');
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<void> login(String redirectUrl) async {
    try {
      await auth0.loginWithRedirect(
          redirectUrl: redirectUrl,

          /// Dart supports set literals using curly braces {}.
          /// The type of the collection can be inferred from the context.
          scopes: {'openid', 'profile', 'email'});
      credentials = await auth0.onLoad();
      notifyListeners();
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> logout(String logoutReturnUrl) async {
    try {
      await auth0.logout(returnToUrl: logoutReturnUrl);
      credentials = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
