import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/models/nostr_event.dart';
import 'package:nostrrdr/core/services/logger_service.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';
import 'package:nostrrdr/core/services/nostr_relay_service.dart';
import 'package:nostrrdr/core/services/blossom_service.dart';
import 'package:nostrrdr/features/auth/repositories/auth_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SyncRepository {
  final AppDatabase _database;
  final AuthRepository _authRepository;
  final NostrRelayService _relayService;
  final BlossomService _blossomService;

  static const int _kindReadingProgress = 30001;
  static const int _kindDocumentMetadata = 1063;

  bool _isSyncing = false;

  SyncRepository(
    this._database,
    this._authRepository,
    this._relayService,
    this._blossomService,
  );

  Future<void> sync(String npub) async {
    if (_isSyncing) {
      LoggerService.debug('Sync already in progress, skipping');
      return;
    }

    _isSyncing = true;
    LoggerService.debug('Starting sync for npub: $npub');

    try {
      await _processUploadQueue();
      await _fetchAndReconcile(npub);
      LoggerService.debug('Sync complete');
    } catch (e, st) {
      LoggerService.error('Sync failed', e, st);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processUploadQueue() async {
    try {
      LoggerService.debug('Processing upload queue...');
      final docsNeedingUpload = await _database.getDocumentsNeedingUpload();

      if (docsNeedingUpload.isEmpty) {
        LoggerService.debug('No documents pending upload');
        return;
      }

      LoggerService.debug(
        'Found ${docsNeedingUpload.length} documents pending upload',
      );

      for (final doc in docsNeedingUpload) {
        await publishDocument(doc);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e, st) {
      LoggerService.error('Failed to process upload queue', e, st);
    }
  }

  Future<void> _fetchAndReconcile(String npub) async {
    try {
      LoggerService.debug('Fetching remote data...');

      // Fetch reading progress (Kind 30001)
      // Note: We might want to filter by time or get all. For now, getting recent.
      // In a real app, we'd probably want to use a since filter based on last sync.
      final hexPubkey = NostrKeyService.decodePublicKey(npub);
      LoggerService.debug('Decoded hex pubkey: $hexPubkey');

      final progressFilter = Filter(
        kinds: [_kindReadingProgress, _kindDocumentMetadata],
        authors: [hexPubkey],
        limit: 200, // Increased limit to cover both types
      );

      LoggerService.debug(
        'Querying events with filter: ${jsonEncode(progressFilter.toJson())}',
      );

      final events = await _relayService.queryEvents([progressFilter]);
      LoggerService.debug('Fetched ${events.length} events');

      final localDocs = await _database.getAllDocuments();
      await reconcileDocuments(localDocs, events);
    } catch (e, st) {
      LoggerService.error('Failed to fetch and reconcile', e, st);
    }
  }

  Future<void> publishProgress(
    int documentId,
    int lastPage,
    String documentTitle,
  ) async {
    try {
      final npub = await _authRepository.getNpub();
      if (npub == null) {
        LoggerService.warning('Cannot publish progress: not authenticated');
        return;
      }

      LoggerService.debug(
        'Publishing reading progress: doc=$documentId, page=$lastPage',
      );

      final document = await _database.getDocument(documentId);
      if (document == null) {
        LoggerService.warning('Document not found: $documentId');
        return;
      }

      // Convert npub to hex pubkey for event creation
      final hexPubkey = NostrKeyService.decodePublicKey(npub);

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final tags = [
        NostrTag.dTag(document.documentId),
        ['page', lastPage.toString()],
        ['title', documentTitle],
      ];

      final eventId = await compute(
        _computeEventId,
        _EventIdParams(_kindReadingProgress, hexPubkey, now, tags, ''),
      );

      final eventMap = {
        'id': eventId,
        'pubkey': hexPubkey,
        'created_at': now,
        'kind': _kindReadingProgress,
        'tags': tags,
        'content': '',
      };

      final sig = await _authRepository.sign(
        eventId,
        eventJson: jsonEncode(eventMap),
      );

      final event = NostrEvent(
        id: eventId,
        pubkey: hexPubkey,
        createdAt: now,
        kind: _kindReadingProgress,
        tags: tags,
        content: '',
        sig: sig,
      );

      LoggerService.debug('Reading progress event created: ${event.id}');

      await _relayService.publishEvent(event);
      await _database.updateLastSyncedAt(documentId, DateTime.now());

      LoggerService.debug('Reading progress published to relays');
    } catch (e, st) {
      LoggerService.error('Failed to publish progress', e, st);
    }
  }

  Future<void> publishDocument(Document document) async {
    try {
      final npub = await _authRepository.getNpub();
      if (npub == null) {
        LoggerService.warning('Cannot publish document: not authenticated');
        return;
      }

      LoggerService.debug('Publishing document: ${document.title}');

      // Convert npub to hex pubkey for event creation
      final hexPubkey = NostrKeyService.decodePublicKey(npub);

      final file = File(document.filePath);
      final blossomUrl = await _blossomService.uploadFile(file, npub);

      if (blossomUrl == null) {
        LoggerService.error('Failed to upload document to Blossom', null, null);

        await _database.updateUploadStatus(
          document.id,
          'failed',
          retryCount: document.uploadRetryCount + 1,
          lastAttempt: DateTime.now(),
        );
        return;
      }

      LoggerService.debug('Document uploaded to Blossom: $blossomUrl');

      // Create and publish metadata event
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final tags = [
        NostrTag.dTag(document.documentId),
        NostrTag.titleTag(document.title),
        ['url', blossomUrl],
        NostrTag.mTag('application/pdf'),
        ['total_pages', document.totalPages.toString()],
      ];

      final eventContent = jsonEncode({
        'title': document.title,
        'url': blossomUrl,
        'type': 'application/pdf',
      });

      final eventId = await compute(
        _computeEventId,
        _EventIdParams(
          _kindDocumentMetadata,
          hexPubkey,
          now,
          tags,
          eventContent,
        ),
      );

      final eventMap = {
        'id': eventId,
        'pubkey': hexPubkey,
        'created_at': now,
        'kind': _kindDocumentMetadata,
        'tags': tags,
        'content': eventContent,
      };

      final sig = await _authRepository.sign(
        eventId,
        eventJson: jsonEncode(eventMap),
      );

      final event = NostrEvent(
        id: eventId,
        pubkey: hexPubkey,
        createdAt: now,
        kind: _kindDocumentMetadata,
        tags: tags,
        content: eventContent,
        sig: sig,
      );

      LoggerService.debug('Document metadata event created: ${event.id}');

      await _relayService.publishEvent(event);
      await _database.updateLastSyncedAt(document.id, DateTime.now());
      // Mark as successfully uploaded
      await _database.updateUploadStatus(document.id, 'uploaded');

      LoggerService.debug('Document published to relays');
    } catch (e, st) {
      LoggerService.error('Failed to publish document', e, st);
      // Mark as failed for retry
      await _database.updateUploadStatus(
        document.id,
        'failed',
        retryCount: document.uploadRetryCount + 1,
        lastAttempt: DateTime.now(),
      );
    }
  }

  Future<List<Document>> fetchDocuments(String npub) async {
    try {
      LoggerService.debug('Fetching documents from local db for npub: $npub');

      final documents = await _database.getDocumentsByOwner(npub);

      LoggerService.debug(
        'Fetched ${documents.length} documents from local db',
      );

      return documents;
    } catch (e, st) {
      LoggerService.error('Failed to fetch documents', e, st);
      return [];
    }
  }

  Future<List<Document>> reconcileDocuments(
    List<Document> localDocs,
    List<NostrEvent> remoteEvents,
  ) async {
    try {
      LoggerService.debug(
        'Reconciling ${localDocs.length} local docs with ${remoteEvents.length} remote events',
      );

      final remoteDocMap = <String, NostrEvent>{};
      final remoteProgressMap = <String, NostrEvent>{};

      for (final event in remoteEvents) {
        final dTag = _extractDTag(event.tags);
        if (dTag != null) {
          if (event.kind == _kindDocumentMetadata) {
            // Keep the latest metadata event for each dTag
            final existing = remoteDocMap[dTag];
            if (existing == null || event.createdAt > existing.createdAt) {
              remoteDocMap[dTag] = event;
            }
          } else if (event.kind == _kindReadingProgress) {
            // Keep the latest progress event for each dTag
            final existing = remoteProgressMap[dTag];
            if (existing == null || event.createdAt > existing.createdAt) {
              remoteProgressMap[dTag] = event;
            }
          }
        }
      }

      final reconciled = <Document>[];
      final localDocIds = localDocs.map((d) => d.documentId).toSet();
      for (final localDoc in localDocs) {
        final remoteProgress = remoteProgressMap[localDoc.documentId];
        final remoteMetadata = remoteDocMap[localDoc.documentId];
        if (localDoc.downloadStatus == 'failed' ||
            localDoc.downloadStatus == 'pending') {
          if (remoteMetadata != null) {
            LoggerService.debug('Retrying download for: ${localDoc.title}');
            final hexPubkey = remoteMetadata.pubkey;
            final npub = NostrKeyService.encodePublicKey(hexPubkey);
            await _downloadAndImportDocument(
              remoteMetadata,
              remoteProgress,
              npub,
            );
            continue; // Skip progress update for now, _downloadAndImportDocument handles it
          }
        }

        if (remoteProgress == null) {
          reconciled.add(localDoc);
        } else {
          final remoteLastPage = _extractLastPage(remoteProgress.tags);
          if (remoteLastPage != null && remoteLastPage > localDoc.lastPage) {
            final updated = localDoc.copyWith(lastPage: remoteLastPage);
            reconciled.add(updated);
            await _database.updateLastPage(localDoc.id, remoteLastPage);
          } else {
            reconciled.add(localDoc);
          }
        }
      }

      for (final dTag in remoteDocMap.keys) {
        if (!localDocIds.contains(dTag)) {
          final metadataEvent = remoteDocMap[dTag]!;
          final hexPubkey = metadataEvent.pubkey;
          final npub = NostrKeyService.encodePublicKey(hexPubkey);
          await _downloadAndImportDocument(
            metadataEvent,
            remoteProgressMap[dTag],
            npub,
          );
        }
      }
      LoggerService.debug('Reconciliation complete');
      return reconciled;
    } catch (e, st) {
      LoggerService.error('Failed to reconcile documents', e, st);
      return localDocs;
    }
  }

  Future<void> _downloadAndImportDocument(
    NostrEvent metadataEvent,
    NostrEvent? progressEvent,
    String npub,
  ) async {
    try {
      final content = jsonDecode(metadataEvent.content);
      final url = content['url'] as String?;
      final title = content['title'] as String? ?? 'Untitled';
      final dTag = _extractDTag(metadataEvent.tags);

      if (url == null || dTag == null) {
        LoggerService.warning('Invalid metadata event: missing url or dTag');
        return;
      }

      LoggerService.debug('Found new remote document: $title ($dTag)');

      final dir = await getApplicationDocumentsDirectory();
      final filename = '${const Uuid().v4()}.pdf';
      final savePath = '${dir.path}/$filename';
      int lastPage = 0;
      if (progressEvent != null) {
        lastPage = _extractLastPage(progressEvent.tags) ?? 0;
      }

      final totalPages = _extractTotalPages(metadataEvent.tags) ?? 0;

      final existingDoc = await _database.getDocumentByDocumentId(dTag);
      int docId;

      if (existingDoc != null) {
        docId = existingDoc.id;
        await _database.updateDownloadStatus(docId, 'pending');

        if (totalPages > 0) {
          await _database.updateTotalPages(docId, totalPages);
        }
      } else {
        docId = await _database.addDocument(
          title: title,
          filePath: savePath,
          documentId: dTag,
          lastPage: lastPage,
          totalPages: totalPages,
          uploadStatus: 'uploaded',
          downloadStatus: 'pending',
          ownerNpub: npub,
          lastSyncedAt: DateTime.fromMillisecondsSinceEpoch(
            metadataEvent.createdAt * 1000,
          ),
        );
      }

      LoggerService.debug('Downloading from: $url');
      final file = await _blossomService.downloadFile(url, savePath);

      if (file != null) {
        LoggerService.debug('Document downloaded to: $savePath');
        await _database.updateDownloadStatus(docId, 'downloaded');
        LoggerService.debug('Document imported successfully');
      } else {
        LoggerService.error('Failed to download document: $url', null, null);
        await _database.updateDownloadStatus(docId, 'failed');
      }
    } catch (e, st) {
      LoggerService.error('Failed to download and import document', e, st);
    }
  }

  String? _extractDTag(List<List<String>> tags) {
    for (final tag in tags) {
      if (tag.length >= 2 && tag[0] == 'd') {
        return tag[1];
      }
    }
    return null;
  }

  int? _extractLastPage(List<List<String>> tags) {
    for (final tag in tags) {
      if (tag.length >= 2 && tag[0] == 'page') {
        return int.tryParse(tag[1]);
      }
    }
    return null;
  }

  int? _extractTotalPages(List<List<String>> tags) {
    for (final tag in tags) {
      if (tag.length >= 2 && tag[0] == 'total_pages') {
        return int.tryParse(tag[1]);
      }
    }
    return null;
  }

  Future<void> retryFailedUploads() async {
    try {
      LoggerService.debug('Starting retry of failed document uploads');

      final docsNeedingUpload = await _database.getDocumentsNeedingUpload();

      if (docsNeedingUpload.isEmpty) {
        LoggerService.debug('No documents need upload retry');
        return;
      }

      LoggerService.debug(
        'Found ${docsNeedingUpload.length} documents needing upload retry',
      );

      for (final doc in docsNeedingUpload) {
        LoggerService.debug('Retrying upload for: ${doc.title}');
        await publishDocument(doc);
      }

      LoggerService.debug('Retry cycle complete');
    } catch (e, st) {
      LoggerService.error('Failed to retry document uploads', e, st);
    }
  }
}

class _EventIdParams {
  final int kind;
  final String pubkey;
  final int createdAt;
  final List<List<String>> tags;
  final String content;

  _EventIdParams(
    this.kind,
    this.pubkey,
    this.createdAt,
    this.tags,
    this.content,
  );
}

String _computeEventId(_EventIdParams params) {
  return NostrEventBuilder.createEventId(
    params.kind,
    params.pubkey,
    params.createdAt,
    params.tags,
    params.content,
  );
}
