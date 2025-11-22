import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/providers/database_provider.dart';
import 'package:nostrrdr/core/services/toast_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/home/providers/documents_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentCard extends ConsumerWidget {
  final Document document;

  const DocumentCard({super.key, required this.document});

  Future<String?> _validateAndUpdateThumbnail(WidgetRef ref) async {
    final thumbnailService = ref.read(thumbnailServiceProvider);
    final database = ref.read(databaseProvider);

    final validatedPath = await thumbnailService.validateAndRegenerateThumbnail(
      currentThumbnailPath: document.thumbnailPath,
      pdfPath: document.filePath,
      documentId: document.documentId,
    );

    if (validatedPath != null && validatedPath != document.thumbnailPath) {
      await database.updateThumbnailPath(document.id, validatedPath);
    }

    return validatedPath;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDownloading = document.downloadStatus == 'pending';
    final isFailed = document.downloadStatus == 'failed';

    return GestureDetector(
      onTap: isDownloading || isFailed
          ? null
          : () => context.pushNamed(
              'reader',
              pathParameters: {'documentId': document.id.toString()},
            ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.colorScheme.primaryContainer),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FutureBuilder<String?>(
                      future: _validateAndUpdateThumbnail(ref),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            document.thumbnailPath != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                            child: Image.file(
                              File(document.thumbnailPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 48.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                            child: Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 48.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 48.sp,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                    if (isDownloading)
                      Container(
                        color: Colors.black26,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    if (isFailed)
                      Container(
                        color: Colors.black26,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error,
                                color: theme.colorScheme.error,
                                size: 32.sp,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Download Failed',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Divider(color: theme.colorScheme.primaryContainer),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    document.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  if (isFailed)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          final npub = ref.read(currentNpubProvider);
                          if (npub != null) {
                            ToastService.showInfo(
                              context,
                              'Retrying download...',
                            );
                            await ref
                                .read(syncStateProvider.notifier)
                                .syncAllDocuments(npub);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 32.h),
                        ),
                        child: Text('Retry', style: TextStyle(fontSize: 12.sp)),
                      ),
                    )
                  else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: LinearProgressIndicator(
                        value: document.totalPages > 0
                            ? (document.lastPage + 1) / document.totalPages
                            : 0,
                        minHeight: 4.h,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Chip(
                      label: Text(
                        'Page ${document.lastPage + 1}/${document.totalPages}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
