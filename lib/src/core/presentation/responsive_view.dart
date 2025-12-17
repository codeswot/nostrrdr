import 'package:flutter/material.dart';
import 'package:nostrrdr/src/core/utils/layout_utils.dart';

/// A base class for creating responsive views.
///
/// Subclasses must implement [buildMobile] and [buildDesktop].
/// [buildTablet] is optional and allows for specific tablet layouts;
/// if not implemented, it defaults to [buildDesktop].
abstract class ResponsiveView extends StatelessWidget {
  const ResponsiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return buildMobile(context);
      case ScreenType.tablet:
        return buildTablet(context);
      case ScreenType.desktop:
        return buildDesktop(context);
    }
  }

  Widget buildMobile(BuildContext context);
  Widget buildDesktop(BuildContext context);

  /// Defaults to calling [buildDesktop].
  Widget buildTablet(BuildContext context) => buildDesktop(context);
}
