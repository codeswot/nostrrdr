import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

@RoutePage()
class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 600.w, maxHeight: 600.h),
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter & Sort', style: context.textStyles.headlineSmall),
                IconButton(
                  onPressed: () => context.router.maybePop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            FilterOption(
              title: 'Sort By',
              options: const ['Recent', 'Title', 'Author'],
            ),
            SizedBox(height: 16.h),
            FilterOption(
              title: 'Status',
              options: const ['Reading', 'Completed', 'Plan to Read'],
            ),
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: () => context.router.maybePop(),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  const FilterOption({super.key, required this.title, required this.options});

  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textStyles.titleMedium),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              onSelected: (bool selected) {},
            );
          }).toList(),
        ),
      ],
    );
  }
}
