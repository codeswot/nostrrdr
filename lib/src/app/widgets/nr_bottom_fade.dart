import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';

class NrBottomFade extends StatelessWidget {
  const NrBottomFade({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,

        height: 81.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              context.colors.surfaceVariant.withValues(alpha: 0),
              context.colors.surfaceVariant.withValues(alpha: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
