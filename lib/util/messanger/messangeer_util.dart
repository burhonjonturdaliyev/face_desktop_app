import 'package:flutter/material.dart';

class MessengerUtil {
  static void showSuccess(BuildContext context, String message) {
    _showMessage(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showMessage(context, message, Colors.red);
  }

  static void _showMessage(BuildContext context, String message, Color color) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        width: 500,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }
}