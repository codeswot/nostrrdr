import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
}

enum ScreenType { mobile, tablet, desktop }

bool get isDesktop {
  return kIsWeb ||
      [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < Breakpoints.mobile) return ScreenType.mobile;
  if (width < Breakpoints.tablet) return ScreenType.tablet;
  return ScreenType.desktop;
}

Size getDesignSize(BoxConstraints constraints) {
  if (isDesktop) {
    return Size(
      constraints.maxWidth > 0 ? constraints.maxWidth : 1440,
      constraints.maxHeight > 0 ? constraints.maxHeight : 900,
    );
  }
  return const Size(390, 844);
}
