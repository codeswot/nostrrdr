import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/exceptions/duplicate_document_exception.dart';
import 'package:nostrrdr/core/services/file_hash_service.dart';
import 'package:nostrrdr/core/services/thumbnail_service.dart';
import 'package:uuid/uuid.dart';

class LocalLibraryRepository {
  final AppDatabase _database;
  final ThumbnailService _thumbnailService;

  LocalLibraryRepository(this._database, {ThumbnailService? thumbnailService})
    : _thumbnailService = thumbnailService ?? ThumbnailService();

  Future<Document> addDocument({
    required String title,
    required String filePath,
    required int totalPages,
    required String ownerNpub,
  }) async {
    final fileHash = await FileHashService.calculateFileHash(filePath);

    final existingDocument = await _database.getDocumentByFileHash(fileHash);
    if (existingDocument != null) {
      throw DuplicateDocumentException(
        'Document already exists in library',
        existingDocumentId: existingDocument.documentId,
      );
    }

    final documentId = const Uuid().v4();
    final now = DateTime.now();
    final appDocDir = await getApplicationDocumentsDirectory();
    final documentsDir = Directory(p.join(appDocDir.path, 'documents'));

    if (!await documentsDir.exists()) {
      await documentsDir.create(recursive: true);
    }

    final sourceFile = File(filePath);
    final fileName = p.basename(filePath);
    final destPath = p.join(documentsDir.path, documentId, fileName);
    final destDir = Directory(p.dirname(destPath));

    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }

    await sourceFile.copy(destPath);

    final thumbnailPath = await _thumbnailService.generateThumbnail(
      destPath,
      documentId,
    );

    final companion = DocumentsCompanion(
      documentId: Value(documentId),
      ownerNpub: Value(ownerNpub),
      title: Value(title),
      filePath: Value(destPath),
      fileHash: Value(fileHash),
      totalPages: Value(totalPages),
      lastPage: Value(0),
      thumbnailPath: Value(thumbnailPath),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final id = await _database.insertDocument(companion);
    final document = await _database.getDocument(id);

    if (document == null) {
      throw Exception('Failed to create document');
    }

    return document;
  }

  Future<List<Document>> getDocuments(String ownerNpub) =>
      _database.getDocumentsByOwner(ownerNpub);

  Stream<List<Document>> watchDocuments(String ownerNpub) =>
      _database.watchDocumentsByOwner(ownerNpub);

  Future<Document?> getDocument(int id) => _database.getDocument(id);

  Future<Document?> getDocumentByDocumentId(String documentId) =>
      _database.getDocumentByDocumentId(documentId);

  Future<void> updateProgress(int id, int lastPage) async {
    await _database.updateLastPage(id, lastPage);
  }

  Future<void> updateLastReadAt(int id) async {
    await _database.updateLastReadAt(id, DateTime.now());
  }

  Future<void> deleteDocument(int id) async {
    final document = await _database.getDocument(id);
    if (document != null) {
      final file = File(document.filePath);
      if (await file.exists()) {
        await file.delete();
      }

      final dir = file.parent;
      if (await dir.exists() && dir.listSync().isEmpty) {
        await dir.delete();
      }

      if (document.thumbnailPath != null) {
        await _thumbnailService.deleteThumbnail(document.documentId);
      }
    }

    await _database.deleteDocument(id);
  }

  Future<void> updateSyncedAt(int id) async {
    await _database.updateLastSyncedAt(id, DateTime.now());
  }

  Future<int> removeDuplicates() async {
    final allDocuments = await _database.getAllDocuments();
    final Map<String, List<Document>> duplicateMap = {};

    for (final doc in allDocuments) {
      final hash = doc.fileHash;
      duplicateMap.putIfAbsent(hash, () => []).add(doc);
    }

    int removedCount = 0;

    for (final duplicates in duplicateMap.values) {
      if (duplicates.length > 1) {
        duplicates.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        for (int i = 1; i < duplicates.length; i++) {
          await deleteDocument(duplicates[i].id);
          removedCount++;
        }
      }
    }

    return removedCount;
  }
}
