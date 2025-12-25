import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/core/utils/layout_utils.dart';

/// A factory for creating platform-adaptive routes based on the device type.
///
/// This factory determines whether to show content in a full-screen route (mobile)
/// or a dialog route (desktop/tablet) based on the current device's screen type.
abstract class AdaptiveRouteFactory {
  /// Builds a [Route] that is adaptive to the device screen size.
  ///
  /// If the device is a mobile device, it builds an [AdaptivePageRoute].
  /// Otherwise it builds a [DialogRoute].
  ///
  /// The [AutoRoutePage] is used to build the page.
  static Route<T> providePageOrDialogRoute<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    // Check if we are on a mobile screen size.
    final bool isMobile = getScreenType(context) == ScreenType.mobile;

    if (isMobile) {
      return AdaptivePageRoute<T>(context: context, page: page);
    }

    // On larger screens (tablet/desktop), show as a dialog.
    return DialogRoute<T>(
      context: context,
      builder: (_) => child,
      settings: page,
      barrierColor: Colors.black54,
      useSafeArea: false,
    );
  }

  static Route<T> provideBottomSheetOrDialogRoute<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    final bool isMobile = getScreenType(context) == ScreenType.mobile;

    if (isMobile) {
      return ModalBottomSheetRoute(
        builder: (_) => child,
        isScrollControlled: true,
        modalBarrierColor: Colors.black54,
        useSafeArea: true,
        settings: page,
      );
    }

    return DialogRoute<T>(
      context: context,
      builder: (_) => Padding(padding: EdgeInsets.all(24.w), child: child),
      settings: page,
      barrierColor: Colors.black54,
      useSafeArea: false,
    );
  }
}

class AdaptivePageRoute<T> extends PageRouteBuilder<T> {
  AdaptivePageRoute({required this.context, required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            page.buildPage(context),
        allowSnapshotting: page.allowSnapshotting,
        settings: page,
        maintainState: page.maintainState,
        fullscreenDialog: page.fullscreenDialog,
        opaque: page.opaque,
      );

  final BuildContext context;
  final AutoRoutePage<T> page;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Theme.of(context).pageTransitionsTheme.buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
