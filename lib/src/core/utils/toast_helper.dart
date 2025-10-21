import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Simple toast helper for showing messages
/// Sử dụng Fluttertoast cho cross-platform support
final class ToastHelper {
  ToastHelper._();

  /// Show a general toast message
  static void show(String message, {
    Toast? toastLength,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  /// Show a success toast message
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show an error toast message
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show a warning toast message
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange.shade600,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show an info toast message
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Cancel any current toast
  static void cancel() {
    Fluttertoast.cancel();
  }
}

