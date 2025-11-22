import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReaderModeView extends StatelessWidget {
  final bool isLoading;
  final String? extractedText;
  final VoidCallback onRetry;

  const ReaderModeView({
    super.key,
    required this.isLoading,
    required this.extractedText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (extractedText == null || extractedText!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.text_fields, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No text found or extraction failed.'),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: SelectableText(
        extractedText!,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
