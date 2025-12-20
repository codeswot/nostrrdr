import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:toastification/toastification.dart';
import 'package:nostrrdr/src/core/utils/layout_utils.dart';

extension ToastExtension on BuildContext {
  void showSuccessToast({required String title, String? description}) {
    _showToast(
      title: title,
      description: description,
      type: ToastificationType.success,
      primaryColor: colors.forestGreen,
    );
  }

  void showErrorToast({required String title, String? description}) {
    _showToast(
      title: title,
      description: description,
      type: ToastificationType.error,
      primaryColor: colors.roseRed,
    );
  }

  void showInfoToast({required String title, String? description}) {
    _showToast(
      title: title,
      description: description,
      type: ToastificationType.info,
      primaryColor: colors.oceanBlue,
    );
  }

  void showWarningToast({required String title, String? description}) {
    _showToast(
      title: title,
      description: description,
      type: ToastificationType.warning,
      primaryColor: colors.sunYellow,
    );
  }

  void _showToast({
    required String title,
    String? description,
    required ToastificationType type,
    required Color primaryColor,
  }) {
    toastification.show(
      context: this,
      type: type,
      style: ToastificationStyle.flat,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      description: description != null ? Text(description) : null,
      alignment: getScreenType(this) == ScreenType.mobile
          ? Alignment.topCenter
          : Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.r),
      showProgressBar: true,
      dragToClose: true,
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
  }
}
