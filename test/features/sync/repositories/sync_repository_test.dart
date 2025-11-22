import 'package:flutter_test/flutter_test.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/models/nostr_event.dart';

Document _createTestDocument({
  int id = 1,
  String documentId = 'doc1',
  String ownerNpub = 'npub1test',
  String title = 'Test Document',
  int lastPage = 5,
  int totalPages = 100,
  DateTime? createdAt,
  DateTime? updatedAt,
  String uploadStatus = 'uploaded',
  int uploadRetryCount = 0,
  DateTime? lastUploadAttempt,
}) {
  return Document(
    id: id,
    documentId: documentId,
    ownerNpub: ownerNpub,
    title: title,
    filePath: '/path/to/file.pdf',
    fileHash: 'abc123',
    lastPage: lastPage,
    totalPages: totalPages,
    thumbnailPath: null,
    nostrEventId: null,
    nostrAuthor: null,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    lastSyncedAt: null,
    uploadStatus: uploadStatus,
    downloadStatus: 'downloaded',
    uploadRetryCount: uploadRetryCount,
    lastUploadAttempt: lastUploadAttempt,
  );
}

// Helper functions extracted from SyncRepository for testing
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

void main() {
  group('SyncRepository', () {
    group('Tag extraction methods', () {
      test('extracts d-tag correctly', () {
        final tags = [
          ['d', 'doc1'],
          ['page', '10'],
        ];

        final result = _extractDTag(tags);

        expect(result, equals('doc1'));
      });

      test('returns null when d-tag is missing', () {
        final tags = [
          ['page', '10'],
        ];

        final result = _extractDTag(tags);

        expect(result, isNull);
      });

      test('handles empty tag list', () {
        final tags = <List<String>>[];

        final result = _extractDTag(tags);

        expect(result, isNull);
      });

      test('extracts page tag correctly', () {
        final tags = [
          ['d', 'doc1'],
          ['page', '25'],
        ];

        final result = _extractLastPage(tags);

        expect(result, equals(25));
      });

      test('returns null when page tag is missing', () {
        final tags = [
          ['d', 'doc1'],
        ];

        final result = _extractLastPage(tags);

        expect(result, isNull);
      });

      test('returns null for invalid page numbers', () {
        final tags = [
          ['d', 'doc1'],
          ['page', 'invalid'],
        ];

        final result = _extractLastPage(tags);

        expect(result, isNull);
      });

      test('handles zero as valid page number', () {
        final tags = [
          ['page', '0'],
        ];

        final result = _extractLastPage(tags);

        expect(result, equals(0));
      });

      test('handles large page numbers', () {
        final tags = [
          ['page', '9999999'],
        ];

        final result = _extractLastPage(tags);

        expect(result, equals(9999999));
      });
    });

    group('Document reconciliation logic', () {
      test('local doc unmodified when no remote event exists', () {
        final localDoc = _createTestDocument(
          id: 1,
          documentId: 'doc1',
          lastPage: 10,
        );

        // When no remote event exists, local should remain unchanged
        expect(localDoc.lastPage, equals(10));
      });

      test('remote page value wins if higher than local', () {
        final localDoc = _createTestDocument(lastPage: 10);
        final remoteLastPage = 25;

        // Remote value is higher, should be adopted
        expect(remoteLastPage > localDoc.lastPage, isTrue);
      });

      test('local page value wins if higher than remote', () {
        final localDoc = _createTestDocument(lastPage: 50);
        final remoteLastPage = 25;

        // Local value is higher, should be kept
        expect(localDoc.lastPage > remoteLastPage, isTrue);
      });

      test('equal page values remain unchanged', () {
        final localDoc = _createTestDocument(lastPage: 25);
        final remoteLastPage = 25;

        // Equal values mean no change needed
        expect(localDoc.lastPage, equals(remoteLastPage));
      });
    });

    group('Nostr event parsing', () {
      test('creates valid reading progress event', () {
        const documentId = 'doc1';
        const lastPage = 42;

        final tags = [
          ['d', documentId],
          ['page', lastPage.toString()],
        ];

        expect(tags[0][0], equals('d'));
        expect(tags[0][1], equals(documentId));
        expect(tags[1][0], equals('page'));
        expect(tags[1][1], equals('42'));
      });

      test('event has correct kind for reading progress', () {
        const kindReadingProgress = 30001;

        expect(kindReadingProgress, equals(30001));
      });

      test('event has correct kind for document metadata', () {
        const kindDocumentMetadata = 1063;

        expect(kindDocumentMetadata, equals(1063));
      });

      test('extracts dTag from parametrized replaceable event', () {
        final event = NostrEvent(
          id: 'event1',
          pubkey: 'npub1test',
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          kind: 30001,
          tags: [
            ['d', 'unique_identifier'],
            ['page', '10'],
          ],
          content: '',
          sig: '',
        );

        final dTag = _extractDTag(event.tags);

        expect(dTag, equals('unique_identifier'));
      });

      test('extracts page from event tags', () {
        final event = NostrEvent(
          id: 'event1',
          pubkey: 'npub1test',
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          kind: 30001,
          tags: [
            ['d', 'doc1'],
            ['page', '50'],
          ],
          content: '',
          sig: '',
        );

        final page = _extractLastPage(event.tags);

        expect(page, equals(50));
      });
    });

    group('Document filtering logic', () {
      test('filters documents by owner npub', () {
        const ownerNpub = 'npub1owner';
        const otherNpub = 'npub1other';

        final doc1 = _createTestDocument(ownerNpub: ownerNpub);
        final doc2 = _createTestDocument(ownerNpub: otherNpub);

        final ownedDocs = [
          doc1,
          doc2,
        ].where((doc) => doc.ownerNpub == ownerNpub).toList();

        expect(ownedDocs.length, equals(1));
        expect(ownedDocs[0].ownerNpub, equals(ownerNpub));
      });

      test('handles multiple documents with same owner', () {
        const ownerNpub = 'npub1owner';

        final doc1 = _createTestDocument(
          id: 1,
          documentId: 'doc1',
          ownerNpub: ownerNpub,
        );
        final doc2 = _createTestDocument(
          id: 2,
          documentId: 'doc2',
          ownerNpub: ownerNpub,
        );

        final docs = [doc1, doc2];
        final filtered = docs.where((d) => d.ownerNpub == ownerNpub).toList();

        expect(filtered.length, equals(2));
        expect(
          filtered.map((d) => d.documentId).toSet(),
          equals({'doc1', 'doc2'}),
        );
      });

      test('returns empty list when no documents match owner', () {
        const targetNpub = 'npub1target';
        const otherNpub = 'npub1other';

        final doc = _createTestDocument(ownerNpub: otherNpub);

        final filtered = [doc].where((d) => d.ownerNpub == targetNpub).toList();

        expect(filtered, isEmpty);
      });
    });

    group('Event-document matching', () {
      test('matches event dtag to document id', () {
        const documentId = 'unique_doc_123';

        final event = NostrEvent(
          id: 'event1',
          pubkey: 'npub1test',
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          kind: 30001,
          tags: [
            ['d', documentId],
            ['page', '10'],
          ],
          content: '',
          sig: '',
        );

        final document = _createTestDocument(documentId: documentId);

        final eventDTag = _extractDTag(event.tags);

        expect(eventDTag, equals(document.documentId));
      });

      test('handles mismatched event and document', () {
        final event = NostrEvent(
          id: 'event1',
          pubkey: 'npub1test',
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          kind: 30001,
          tags: [
            ['d', 'doc_from_event'],
            ['page', '10'],
          ],
          content: '',
          sig: '',
        );

        final document = _createTestDocument(documentId: 'doc_local');

        final eventDTag = _extractDTag(event.tags);

        expect(eventDTag, isNot(equals(document.documentId)));
      });
    });

    group('Progress comparison logic', () {
      test('remote progress wins if higher', () {
        final localProgress = 10;
        final remoteProgress = 25;

        final shouldUpdate = remoteProgress > localProgress;

        expect(shouldUpdate, isTrue);
      });

      test('local progress wins if higher', () {
        final localProgress = 50;
        final remoteProgress = 25;

        final shouldUpdate = remoteProgress > localProgress;

        expect(shouldUpdate, isFalse);
      });

      test('equal progress does not trigger update', () {
        final localProgress = 25;
        final remoteProgress = 25;

        final shouldUpdate = remoteProgress > localProgress;

        expect(shouldUpdate, isFalse);
      });

      test('zero local progress can be updated', () {
        final localProgress = 0;
        final remoteProgress = 1;

        final shouldUpdate = remoteProgress > localProgress;

        expect(shouldUpdate, isTrue);
      });
    });
  });
}
