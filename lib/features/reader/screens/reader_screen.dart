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

  bool _isReaderMode = true;
  String? _extractedText;
  bool _isLoadingText = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger text extraction when document is available
    final documentAsync = ref.watch(documentProvider(widget.documentId));
    documentAsync.whenData((document) {
      if (document != null && _extractedText == null && !_isLoadingText) {
        _extractText(document.filePath);
      }
    });
  }

  Future<void> _extractText(String filePath) async {
    setState(() => _isLoadingText = true);
    try {
      final document = await PdfDocument.openFile(filePath);
      final buffer = StringBuffer();

      for (int i = 0; i < document.pages.length; i++) {
        final page = document.pages[i];
        final text = await page.loadText();
        buffer.writeln(text.fullText);
        buffer.writeln();
      }

      if (mounted) {
        setState(() {
          _extractedText = buffer.toString();
          _isLoadingText = false;
        });
      }
    } catch (e) {
      debugPrint('Error extracting text: $e');
      if (mounted) {
        setState(() => _isLoadingText = false);
      }
    }
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
          IconButton(
            onPressed: () {
              setState(() {
                _isReaderMode = !_isReaderMode;
              });
            },
            icon: Icon(_isReaderMode ? Icons.picture_as_pdf : Icons.article),
            tooltip: _isReaderMode
                ? 'Switch to PDF View'
                : 'Switch to Reader Mode',
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

          if (_isReaderMode) {
            if (_isLoadingText) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_extractedText == null || _extractedText!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.text_fields, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No text found or extraction failed.'),
                    TextButton(
                      onPressed: () => _extractText(document.filePath),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: SelectableText(
                _extractedText!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  fontSize: 16.sp,
                ),
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
