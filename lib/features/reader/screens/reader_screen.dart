import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nostrrdr/features/home/providers/documents_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';
import 'package:nostrrdr/features/reader/widgets/reader_mode_view.dart';
import 'package:nostrrdr/features/reader/widgets/pdf_view_mode.dart';

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
            return ReaderModeView(
              isLoading: _isLoadingText,
              extractedText: _extractedText,
              onRetry: () => _extractText(document.filePath),
            );
          }

          return PdfViewMode(
            document: document,
            controller: _pdfController,
            currentPage: _currentPage,
            onPageChanged: (page) {
              if (page != null) {
                setState(() => _currentPage = page);
                _updateProgress(page);
                _debouncedSync(page, document.title);
              }
            },
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
