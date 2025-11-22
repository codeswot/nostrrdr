import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/providers/database_provider.dart';
import 'package:nostrrdr/core/services/blossom_service.dart';
import 'package:nostrrdr/core/services/nostr_relay_service.dart';
import 'package:nostrrdr/core/services/upload_retry_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/sync/repositories/sync_repository.dart';

final nostrRelayServiceProvider = Provider<NostrRelayService>((ref) {
  return NostrRelayService();
});

final blossomServiceProvider = Provider<BlossomService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return BlossomService(authRepository);
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final relayService = ref.watch(nostrRelayServiceProvider);
  final blossomService = ref.watch(blossomServiceProvider);
  return SyncRepository(database, authRepository, relayService, blossomService);
});

final uploadRetryServiceProvider = Provider<UploadRetryService>((ref) {
  final syncRepository = ref.watch(syncRepositoryProvider);
  return UploadRetryService(syncRepository);
});

enum SyncState { idle, syncing, success, error }

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncRepository _syncRepository;

  SyncNotifier(this._syncRepository) : super(SyncState.idle);

  Future<void> syncProgress(
    int documentId,
    int lastPage,
    String documentTitle,
  ) async {
    state = SyncState.syncing;
    try {
      await _syncRepository.publishProgress(
        documentId,
        lastPage,
        documentTitle,
      );
      state = SyncState.success;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && state == SyncState.success) {
          state = SyncState.idle;
        }
      });
    } catch (e) {
      state = SyncState.error;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && state == SyncState.error) {
          state = SyncState.idle;
        }
      });
    }
  }

  Future<void> syncDocument(Document document) async {
    state = SyncState.syncing;
    try {
      await _syncRepository.publishDocument(document);
      state = SyncState.success;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && state == SyncState.success) {
          state = SyncState.idle;
        }
      });
    } catch (e) {
      state = SyncState.error;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && state == SyncState.error) {
          state = SyncState.idle;
        }
      });
    }
  }

  Future<void> syncAllDocuments(String npub) async {
    state = SyncState.syncing;
    try {
      await _syncRepository.sync(npub);

      // No need to invalidate documentsProvider manually as it's now a StreamProvider

      state = SyncState.success;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && state == SyncState.success) {
          state = SyncState.idle;
        }
      });
    } catch (e) {
      state = SyncState.error;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && state == SyncState.error) {
          state = SyncState.idle;
        }
      });
    }
  }
}

final syncStateProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final syncRepository = ref.watch(syncRepositoryProvider);
  return SyncNotifier(syncRepository);
});

final syncStatusProvider = Provider<String>((ref) {
  final syncState = ref.watch(syncStateProvider);
  return switch (syncState) {
    SyncState.idle => 'Ready',
    SyncState.syncing => 'Syncing...',
    SyncState.success => 'Synced',
    SyncState.error => 'Sync failed',
  };
});
