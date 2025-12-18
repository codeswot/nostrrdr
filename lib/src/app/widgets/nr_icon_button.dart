import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';

class NrIconButton extends StatelessWidget {
  const NrIconButton({
    super.key,
    required this.icon,
    this.type = NrIconButtonType.neutral,
    this.size = 20,
    this.color,
    this.onTap,
    this.padding,
  });

  final IconData icon;
  final NrIconButtonType type;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: type.isNeutral
              ? BorderRadius.circular(8.r)
              : BorderRadius.only(
                  topLeft: type.isLeading
                      ? Radius.circular(8.r)
                      : Radius.circular(2.r),
                  bottomLeft: type.isLeading
                      ? Radius.circular(8.r)
                      : Radius.circular(2.r),
                  topRight: type.isTrailing
                      ? Radius.circular(8.r)
                      : Radius.circular(2.r),
                  bottomRight: type.isTrailing
                      ? Radius.circular(8.r)
                      : Radius.circular(2.r),
                ),
          color: context.colors.surface.withValues(alpha: 0.5),
          border: Border.all(color: context.colors.surfaceVariant),
        ),
        child: Icon(
          icon,
          color: color ?? context.colors.onSurface,
          size: size.w,
        ),
      ),
    );
  }
}

enum NrIconButtonType {
  leading,
  trailing,
  neutral;

  bool get isLeading => this == NrIconButtonType.leading;
  bool get isTrailing => this == NrIconButtonType.trailing;
  bool get isNeutral => this == NrIconButtonType.neutral;
}
