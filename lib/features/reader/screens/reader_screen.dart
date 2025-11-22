import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nostrrdr/features/home/providers/documents_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: documentAsync.maybeWhen(
          data: (document) => Text(document?.title ?? 'PDF Reader'),
          orElse: () => const Text('PDF Reader'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Center(
          //     child: Text(
          //       syncStatus,
          //       style: theme.textTheme.labelSmall?.copyWith(
          //         color: theme.colorScheme.onSurfaceVariant,
          //       ),
          //     ),
          //   ),
          // ),
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
                  backgroundColor: theme.colorScheme.surface,
                  enableTextSelection: true,
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
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Page ${_currentPage + 1}/${document.totalPages}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: LinearProgressIndicator(
                            value: document.totalPages > 0
                                ? (_currentPage + 1) / document.totalPages
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
