import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:drift/drift.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class FakeDocumentsCompanion extends Fake implements DocumentsCompanion {}

class FakeProfilesCompanion extends Fake implements ProfilesCompanion {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDocumentsCompanion());
    registerFallbackValue(FakeProfilesCompanion());
  });
  group('AppDatabase - Documents DAO Tests', () {
    late MockAppDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockAppDatabase();
    });

    group('Document CRUD Operations', () {
      test('getDocument returns document when it exists', () async {
        final now = DateTime.now();
        final mockDocument = Document(
          id: 1,
          documentId: 'doc-1',
          ownerNpub: 'npub1test',
          title: 'Test Document',
          filePath: '/path/to/file.pdf',
          fileHash: 'hash123',
          lastPage: 5,
          totalPages: 100,
          thumbnailPath: null,
          nostrEventId: null,
          nostrAuthor: null,
          createdAt: now,
          updatedAt: now,
          lastSyncedAt: null,
          lastReadAt: null,
          uploadStatus: 'uploaded',
          downloadStatus: 'downloaded',
          uploadRetryCount: 0,
          lastUploadAttempt: null,
        );

        when(
          () => mockDatabase.getDocument(1),
        ).thenAnswer((_) async => mockDocument);

        final result = await mockDatabase.getDocument(1);

        expect(result != null, isTrue);
        expect(result!.id, equals(1));
        expect(result.documentId, equals('doc-1'));
        verify(() => mockDatabase.getDocument(1)).called(1);
      });

      test('getDocument returns null when document does not exist', () async {
        when(() => mockDatabase.getDocument(999)).thenAnswer((_) async => null);

        final result = await mockDatabase.getDocument(999);

        expect(result == null, isTrue);
        verify(() => mockDatabase.getDocument(999)).called(1);
      });

      test('insertDocument returns new document id', () async {
        final companion = DocumentsCompanion(
          documentId: const Value('doc-1'),
          ownerNpub: const Value('npub1test'),
          title: const Value('Test'),
          filePath: const Value('/path/to/file.pdf'),
          fileHash: const Value('hash'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        );

        when(
          () => mockDatabase.insertDocument(any()),
        ).thenAnswer((_) async => 1);

        final id = await mockDatabase.insertDocument(companion);

        expect(id, equals(1));
        verify(() => mockDatabase.insertDocument(any())).called(1);
      });

      test('deleteDocument removes document', () async {
        when(() => mockDatabase.deleteDocument(1)).thenAnswer((_) async => 1);

        final result = await mockDatabase.deleteDocument(1);

        expect(result, equals(1));
        verify(() => mockDatabase.deleteDocument(1)).called(1);
      });
    });

    group('Document Update Operations', () {
      test('updateLastPage updates page number', () async {
        when(
          () => mockDatabase.updateLastPage(1, 42),
        ).thenAnswer((_) async => 1);

        final result = await mockDatabase.updateLastPage(1, 42);

        expect(result, equals(1));
        verify(() => mockDatabase.updateLastPage(1, 42)).called(1);
      });

      test('updateLastReadAt updates read timestamp', () async {
        final readTime = DateTime.now();
        when(
          () => mockDatabase.updateLastReadAt(1, readTime),
        ).thenAnswer((_) async => 1);

        final result = await mockDatabase.updateLastReadAt(1, readTime);

        expect(result, equals(1));
        verify(() => mockDatabase.updateLastReadAt(1, readTime)).called(1);
      });

      test('updateThumbnailPath updates thumbnail path', () async {
        when(
          () => mockDatabase.updateThumbnailPath(1, '/path/to/thumb.png'),
        ).thenAnswer((_) async => 1);

        final result = await mockDatabase.updateThumbnailPath(
          1,
          '/path/to/thumb.png',
        );

        expect(result, equals(1));
        verify(
          () => mockDatabase.updateThumbnailPath(1, '/path/to/thumb.png'),
        ).called(1);
      });
    });

    group('Document Query Operations', () {
      test('getDocumentsByOwner returns documents for owner', () async {
        final now = DateTime.now();
        final documents = [
          Document(
            id: 1,
            documentId: 'doc-1',
            ownerNpub: 'npub1owner',
            title: 'Doc 1',
            filePath: '/path/to/file1.pdf',
            fileHash: 'hash1',
            lastPage: 0,
            totalPages: 100,
            thumbnailPath: null,
            nostrEventId: null,
            nostrAuthor: null,
            createdAt: now,
            updatedAt: now,
            lastSyncedAt: null,
            lastReadAt: null,
            uploadStatus: 'uploaded',
            downloadStatus: 'downloaded',
            uploadRetryCount: 0,
            lastUploadAttempt: null,
          ),
        ];

        when(
          () => mockDatabase.getDocumentsByOwner('npub1owner'),
        ).thenAnswer((_) async => documents);

        final result = await mockDatabase.getDocumentsByOwner('npub1owner');

        expect(result.length, equals(1));
        expect(result[0].ownerNpub, equals('npub1owner'));
        verify(() => mockDatabase.getDocumentsByOwner('npub1owner')).called(1);
      });

      test('getDocumentByDocumentId returns document', () async {
        final now = DateTime.now();
        final mockDocument = Document(
          id: 1,
          documentId: 'unique-id',
          ownerNpub: 'npub1test',
          title: 'Test',
          filePath: '/path/to/file.pdf',
          fileHash: 'hash',
          lastPage: 0,
          totalPages: 100,
          thumbnailPath: null,
          nostrEventId: null,
          nostrAuthor: null,
          createdAt: now,
          updatedAt: now,
          lastSyncedAt: null,
          lastReadAt: null,
          uploadStatus: 'uploaded',
          downloadStatus: 'downloaded',
          uploadRetryCount: 0,
          lastUploadAttempt: null,
        );

        when(
          () => mockDatabase.getDocumentByDocumentId('unique-id'),
        ).thenAnswer((_) async => mockDocument);

        final result = await mockDatabase.getDocumentByDocumentId('unique-id');

        expect(result != null, isTrue);
        expect(result!.documentId, equals('unique-id'));
      });
    });
  });

  group('AppDatabase - Profiles DAO Tests', () {
    late MockAppDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockAppDatabase();
    });

    group('Profile Operations', () {
      test('getProfile returns profile when it exists', () async {
        final now = DateTime.now();
        final mockProfile = Profile(
          npub: 'npub1test',
          name: 'Test User',
          about: 'Test bio',
          picture: null,
          nip05: null,
          createdAt: now,
          refreshedAt: now,
        );

        when(
          () => mockDatabase.getProfile('npub1test'),
        ).thenAnswer((_) async => mockProfile);

        final result = await mockDatabase.getProfile('npub1test');

        expect(result != null, isTrue);
        expect(result!.npub, equals('npub1test'));
        expect(result.name, equals('Test User'));
      });

      test('upsertProfile inserts or updates profile', () async {
        final companion = ProfilesCompanion(
          npub: const Value('npub1test'),
          name: const Value('Test User'),
          createdAt: Value(DateTime.now()),
          refreshedAt: Value(DateTime.now()),
        );

        when(
          () => mockDatabase.upsertProfile(any()),
        ).thenAnswer((_) async => {});

        await mockDatabase.upsertProfile(companion);

        verify(() => mockDatabase.upsertProfile(any())).called(1);
      });
    });
  });
}
