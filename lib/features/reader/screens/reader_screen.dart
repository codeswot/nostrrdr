import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nostrrdr/features/home/providers/documents_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int documentId;

  const ReaderScreen({super.key, required this.documentId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late PdfViewerController _pdfController;
  int _currentPage = 0;
  Timer? _syncDebounceTimer;
  Timer? _readTimer;
  bool _hasUpdatedReadTime = false;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();

    // Start timer to update lastReadAt after 5 seconds
    _readTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasUpdatedReadTime) {
        _updateLastReadAt();
        _hasUpdatedReadTime = true;
      }
    });
  }

  @override
  void dispose() {
    _syncDebounceTimer?.cancel();
    _readTimer?.cancel();
    super.dispose();
  }

  Future<void> _updateLastReadAt() async {
    final repository = ref.read(localLibraryRepositoryProvider);
    await repository.updateLastReadAt(widget.documentId);
  }

  Future<void> _updateProgress(int? page) async {
    if (page == null) return;
    final repository = ref.read(localLibraryRepositoryProvider);
    await repository.updateProgress(widget.documentId, page);
  }

  void _debouncedSync(int page, String title) {
    _syncDebounceTimer?.cancel();
    _syncDebounceTimer = Timer(const Duration(seconds: 3), () {
      final syncNotifier = ref.read(syncStateProvider.notifier);
      syncNotifier.syncProgress(widget.documentId, page, title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentAsync = ref.watch(documentProvider(widget.documentId));
    final syncStatus = ref.watch(syncStatusProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: documentAsync.maybeWhen(
          data: (document) => Text(document?.title ?? 'PDF Reader'),
          orElse: () => const Text('PDF Reader'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                syncStatus,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: documentAsync.maybeWhen(
        data: (document) {
          if (document == null) {
            return Center(
              child: Text(
                'Document not found',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return Stack(
            children: [
              PdfViewer.file(
                document.filePath,
                controller: _pdfController,
                params: PdfViewerParams(
                  onPageChanged: (page) {
                    if (page != null) {
                      setState(() => _currentPage = page);
                      _updateProgress(page);
                      _debouncedSync(page, document.title);
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Page ${_currentPage + 1}/${document.totalPages}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: LinearProgressIndicator(
                            value: document.totalPages > 0
                                ? (_currentPage + 1) / document.totalPages
                                : 0,
                            minHeight: 4,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading document: $error',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
