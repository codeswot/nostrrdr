import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void showSuccess(
    BuildContext context,
    String title, {
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.success,
      title: title,
      description: description,
    );
  }

  static void showError(
    BuildContext context,
    String title, {
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.error,
      title: title,
      description: description,
    );
  }

  static void showInfo(
    BuildContext context,
    String title, {
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.info,
      title: title,
      description: description,
    );
  }

  static void showWarning(
    BuildContext context,
    String title, {
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.warning,
      title: title,
      description: description,
    );
  }

  static void _show(
    BuildContext context, {
    required ToastificationType type,
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
