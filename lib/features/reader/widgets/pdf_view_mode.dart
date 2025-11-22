import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nostrrdr/core/database/database.dart';

class PdfViewMode extends StatelessWidget {
  final Document document;
  final PdfViewerController controller;
  final int currentPage;
  final Function(int?) onPageChanged;

  const PdfViewMode({
    super.key,
    required this.document,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        PdfViewer.file(
          document.filePath,
          controller: controller,
          params: PdfViewerParams(
            backgroundColor: theme.colorScheme.surface,
            enableTextSelection: true,
            onPageChanged: onPageChanged,
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${currentPage + 1}/${document.totalPages}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: LinearProgressIndicator(
                      value: document.totalPages > 0
                          ? (currentPage + 1) / document.totalPages
                          : 0,
                      minHeight: 4.h,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
