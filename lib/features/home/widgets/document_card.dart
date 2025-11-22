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

    // Update database if we got a new thumbnail path
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
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
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
                          // Show existing thumbnail while validating
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.file(
                              File(document.thumbnailPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 48,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 48,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        // Fallback to PDF icon
                        return Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 48,
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
                                size: 32,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Download Failed',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
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
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('Retry'),
                      ),
                    )
                  else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: document.totalPages > 0
                            ? (document.lastPage + 1) / document.totalPages
                            : 0,
                        minHeight: 4,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Page ${document.lastPage + 1}/${document.totalPages}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
