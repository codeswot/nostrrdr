import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/widgets/nr_app_bar.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NrAppBar.sliver(
      title: 'Nostrrdr',
      actions: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: context.colors.surface,
        ).animate().fadeIn(),
      ],
      useStylish: true,
    );
  }
}
