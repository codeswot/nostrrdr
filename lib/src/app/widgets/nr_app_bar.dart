import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

class NrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NrAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticImplyLeading = true,
    this.automaticallyImplyActions = true,
    this.centerTitle = true,
    this.useStylish = false,
  }) : _isSliver = false,
       _expandedHeight = 0,
       _floating = false,
       _pinned = true;

  const NrAppBar.sliver({
    super.key,
    required this.title,
    double expandedHeight = 40,
    bool floating = false,
    bool pinned = true,
    this.actions,
    this.leading,
    this.automaticImplyLeading = true,
    this.centerTitle = true,
    this.automaticallyImplyActions = true,
    this.useStylish = false,
  }) : _isSliver = true,
       _expandedHeight = expandedHeight,
       _floating = floating,
       _pinned = pinned;

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool _isSliver;
  final bool? automaticImplyLeading;
  final bool? automaticallyImplyActions;
  final bool? centerTitle;
  final bool useStylish;

  // Sliver-specific properties
  final double _expandedHeight;
  final bool _floating;
  final bool _pinned;

  static const _blurSigma = 1.7;
  static final _whiteColor = Colors.white;
  static final _transparentColor = Colors.transparent;
  static final _actionPadding = EdgeInsets.symmetric(horizontal: 16.w);

  static final _fadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      _whiteColor,
      _whiteColor,
      Color(0xE6FFFFFF),
      Color(0xB3FFFFFF),
      Color(0x80FFFFFF),
      Color(0x4DFFFFFF),
      Color(0x1AFFFFFF),
      Colors.transparent,
    ],
    stops: [0.0, 0.2, 0.4, 0.55, 0.7, 0.85, 0.95, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    final systemOverlayStyle = context.themeMode == ThemeMode.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    final blurredFlexibleSpace = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurSigma.r, sigmaY: _blurSigma.r),
        child: ShaderMask(
          shaderCallback: (rect) => _fadeGradient.createShader(rect),
          blendMode: BlendMode.dstIn,
          child: Container(
            color: context.theme.appBarTheme.backgroundColor,
            child: _isSliver ? const FlexibleSpaceBar() : null,
          ),
        ),
      ),
    );

    if (_isSliver) {
      return SliverAppBar(
        expandedHeight: (_expandedHeight + kToolbarHeight).h,
        floating: _floating,
        pinned: _pinned,
        elevation: 0,
        backgroundColor: _transparentColor,
        automaticallyImplyLeading: automaticImplyLeading ?? true,
        automaticallyImplyActions: automaticallyImplyActions ?? true,
        leading: leading,
        actions: actions,
        title: Text(
          title,
          style: useStylish
              ? GoogleFonts.caveat(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: context.theme.appBarTheme.foregroundColor,
                )
              : context.textStyles.titleLarge.copyWith(
                  color: context.theme.appBarTheme.foregroundColor,
                ),
        ).animate().fadeIn(),
        actionsPadding: _actionPadding,
        centerTitle: centerTitle,
        systemOverlayStyle: systemOverlayStyle,
        surfaceTintColor: _transparentColor,
        leadingWidth: 40.r,
        flexibleSpace: blurredFlexibleSpace,
      );
    }

    return AppBar(
      title: Text(
        title,
        style: useStylish
            ? GoogleFonts.caveat(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: context.theme.appBarTheme.foregroundColor,
              )
            : context.textStyles.titleLarge.copyWith(
                color: context.theme.appBarTheme.foregroundColor,
              ),
      ).animate().fadeIn(),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticImplyLeading ?? true,
      automaticallyImplyActions: automaticallyImplyActions ?? true,
      actionsPadding: _actionPadding,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: _transparentColor,
      surfaceTintColor: _transparentColor,
      systemOverlayStyle: systemOverlayStyle,
      flexibleSpace: blurredFlexibleSpace,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight((kToolbarHeight + 20).h);
}
