import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/services/thumbnail_service.dart';
import 'package:nostrrdr/features/home/repositories/local_library_repository.dart';

class MockThumbnailService extends Mock implements ThumbnailService {}

class MockAppDatabase extends Mock implements AppDatabase {}

Document _createMockDocument({
  int id = 1,
  String documentId = 'doc-1',
  String ownerNpub = 'test-npub',
  String title = 'Test PDF',
  String filePath = '/path/to/file.pdf',
  String fileHash = 'hash1',
  int lastPage = 0,
  int totalPages = 10,
  String? nostrEventId,
  String? nostrAuthor,
  required DateTime createdAt,
  required DateTime updatedAt,
  DateTime? lastSyncedAt,
  String? thumbnailPath,
  String uploadStatus = 'uploaded',
  int uploadRetryCount = 0,
  DateTime? lastUploadAttempt,
}) {
  return Document(
    id: id,
    documentId: documentId,
    ownerNpub: ownerNpub,
    title: title,
    filePath: filePath,
    fileHash: fileHash,
    lastPage: lastPage,
    totalPages: totalPages,
    nostrEventId: nostrEventId,
    nostrAuthor: nostrAuthor,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastSyncedAt: lastSyncedAt,
    thumbnailPath: thumbnailPath,
    uploadStatus: uploadStatus,
    downloadStatus: 'downloaded',
    uploadRetryCount: uploadRetryCount,
    lastUploadAttempt: lastUploadAttempt,
  );
}

void main() {
  group('LocalLibraryRepository', () {
    late MockAppDatabase mockDatabase;
    late MockThumbnailService mockThumbnailService;
    late LocalLibraryRepository repository;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockThumbnailService = MockThumbnailService();
      repository = LocalLibraryRepository(
        mockDatabase,
        thumbnailService: mockThumbnailService,
      );
    });

    // ... existing tests ...

    group('deleteDocument', () {
      test('deletes document and thumbnail', () async {
        final now = DateTime.now();
        final mockDocument = _createMockDocument(
          createdAt: now,
          updatedAt: now,
          thumbnailPath: '/path/to/thumb.png',
        );

        when(
          () => mockDatabase.getDocument(1),
        ).thenAnswer((_) async => mockDocument);
        when(() => mockDatabase.deleteDocument(1)).thenAnswer((_) async => 1);
        when(
          () => mockThumbnailService.deleteThumbnail(any()),
        ).thenAnswer((_) async {});

        await repository.deleteDocument(1);

        verify(() => mockDatabase.getDocument(1)).called(1);
        verify(() => mockDatabase.deleteDocument(1)).called(1);
        verify(
          () => mockThumbnailService.deleteThumbnail(mockDocument.documentId),
        ).called(1);
      });

      test('handles missing document gracefully', () async {
        when(() => mockDatabase.getDocument(999)).thenAnswer((_) async => null);
        when(() => mockDatabase.deleteDocument(999)).thenAnswer((_) async => 0);

        await repository.deleteDocument(999);

        verify(() => mockDatabase.getDocument(999)).called(1);
        verify(() => mockDatabase.deleteDocument(999)).called(1);
        verifyNever(() => mockThumbnailService.deleteThumbnail(any()));
      });
    });

    // ... other tests ...
  });
}
