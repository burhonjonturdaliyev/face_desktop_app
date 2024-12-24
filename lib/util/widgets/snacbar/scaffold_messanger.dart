import 'package:flutter/material.dart';
class ScaffoldMessengerUtil {
  static bool _isSnackBarVisible = false;

  static void _resetSnackBarFlag() {
    _isSnackBarVisible = false;
  }

  static void showSnackBar(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color backgroundColor = Colors.black26,
        TextStyle textStyle = const TextStyle(color: Colors.white),
      }) {
    if (_isSnackBarVisible) return;

    _isSnackBarVisible = true;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        width: 400,
        content: Text(
          message,
          style: textStyle,
        ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    ).closed.then((_) => _resetSnackBarFlag());
  }

  static void showErrorSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.error,
      textStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  static void showLoadingSnackBar(BuildContext context, String message) {
    if (_isSnackBarVisible) return;

    _isSnackBarVisible = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 200,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    ).closed.then((_) => _resetSnackBarFlag());
  }

  static void showSuccessSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}
