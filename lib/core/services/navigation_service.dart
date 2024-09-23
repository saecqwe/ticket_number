import 'package:flutter/material.dart';

class NavigationService {
  // The global navigator key allows access to navigation methods without needing the BuildContext
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Pushes a new route onto the stack
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  /// Replaces the current route with a new one
  Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pops the current route off the stack
  void goBack<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  /// Pushes a new route and removes all the previous routes from the stack (for logout scenarios, etc.)
  Future<dynamic> navigateAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  // Method to navigate back to the home screen
  void navigateToHome() {
    navigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/home', // Assuming your home route is '/'
      (route) => false, // This clears all previous routes
    );
    // navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}

// Instance of NavigationService that you can use globally
final NavigationService navigationService = NavigationService();
