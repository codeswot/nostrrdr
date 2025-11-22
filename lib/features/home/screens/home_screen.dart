import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/core/exceptions/duplicate_document_exception.dart';
import 'package:nostrrdr/core/services/file_picker_service.dart';
import 'package:nostrrdr/core/services/logger_service.dart' as log;
import 'package:nostrrdr/core/services/pdf_service.dart';
import 'package:nostrrdr/core/services/toast_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/home/providers/documents_provider.dart';
import 'package:nostrrdr/features/home/widgets/document_card.dart';
import 'package:nostrrdr/features/home/widgets/empty_library_view.dart';
import 'package:nostrrdr/features/home/widgets/library_error_view.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final npub = ref.read(currentNpubProvider);
      if (npub != null) {
        ref.read(syncStateProvider.notifier).syncAllDocuments(npub);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(documentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context.pushNamed('profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
      body: documentsAsync.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        data: (documents) {
          return RefreshIndicator(
            onRefresh: () async {
              final npub = ref.read(currentNpubProvider);
              if (npub != null) {
                await ref
                    .read(syncStateProvider.notifier)
                    .syncAllDocuments(npub);
              }
            },
            child: documents.isEmpty
                ? const EmptyLibraryView()
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return DocumentCard(document: doc);
                    },
                  ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (error, stack) {
          log.LoggerService.error('Failed to load documents', error, stack);
          return const LibraryErrorView();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDocument(context, ref),
        tooltip: 'Add document',
        child: const Icon(Icons.add),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Future<void> _addDocument(BuildContext context, WidgetRef ref) async {
    try {
      final filePath = await FilePickerService().pickPdfFile();
      if (filePath == null) return;

      if (!context.mounted) return;

      final title = _extractFileName(filePath);

      final pdfService = PdfService();
      final pageCount = await pdfService.getPageCount(filePath);

      final currentNpub = ref.read(currentNpubProvider);
      if (currentNpub == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(localLibraryRepositoryProvider);
      final document = await repository.addDocument(
        title: title,
        filePath: filePath,
        totalPages: pageCount,
        ownerNpub: currentNpub,
      );

      final syncNotifier = ref.read(syncStateProvider.notifier);
      syncNotifier.syncDocument(document);

      if (context.mounted) {
        ToastService.showSuccess(
          context,
          'Added "$title" to library',
          description: 'Syncing to relays...',
        );
      }
    } on DuplicateDocumentException catch (e) {
      log.LoggerService.warning('Duplicate document attempted: ${e.message}');
      if (context.mounted) {
        ToastService.showWarning(
          context,
          'Duplicate Document',
          description: 'This document is already in your library',
        );
      }
    } catch (e, stackTrace) {
      log.LoggerService.error('Error adding document', e, stackTrace);
      if (context.mounted) {
        ToastService.showError(
          context,
          'Failed to add document',
          description: 'Please try again later',
        );
      }
    }
  }

  String _extractFileName(String filePath) {
    return filePath.split('/').last.replaceAll('.pdf', '');
  }
}
