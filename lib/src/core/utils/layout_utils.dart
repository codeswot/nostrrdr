import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns true if the current platform is a desktop device (Windows, Linux, macOS) or Web.
bool get isDesktop {
  return kIsWeb ||
      [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

/// Returns the design size for ScreenUtil based on the platform and current constraints.
///
/// On desktop/web, it uses the current window size (constraints) to prevent scaling (1:1 mapping).
/// On mobile, it uses the standard design draft size (390x844).
Size getDesignSize(BoxConstraints constraints) {
  if (isDesktop) {
    return Size(
      constraints.maxWidth > 0 ? constraints.maxWidth : 1440,
      constraints.maxHeight > 0 ? constraints.maxHeight : 900,
    );
  }
  return const Size(390, 844);
}
