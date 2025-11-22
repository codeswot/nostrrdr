import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get documentId => text().unique()();
  TextColumn get ownerNpub => text()();
  TextColumn get title => text()();
  TextColumn get filePath => text()();
  TextColumn get fileHash => text()();
  IntColumn get lastPage => integer().withDefault(const Constant(0))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get nostrEventId => text().nullable()();
  TextColumn get nostrAuthor => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  TextColumn get uploadStatus => text().withDefault(
    const Constant('pending'),
  )(); // pending, uploaded, failed
  TextColumn get downloadStatus => text().withDefault(
    const Constant('downloaded'),
  )(); // downloaded, pending, failed
  IntColumn get uploadRetryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUploadAttempt => dateTime().nullable()();
}

class Profiles extends Table {
  TextColumn get npub => text()();
  TextColumn get name => text().nullable()();
  TextColumn get about => text().nullable()();
  TextColumn get picture => text().nullable()();
  TextColumn get nip05 => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get refreshedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {npub};
}

@DriftDatabase(tables: [Documents, Profiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 2) {
        await m.addColumn(documents, documents.fileHash);
      }
      if (from < 4) {
        await m.addColumn(documents, documents.ownerNpub);
      }
      if (from < 6) {
        await m.addColumn(documents, documents.downloadStatus);
      }
      if (from < 7) {
        await m.createTable(profiles);
      }
      if (from < 8) {
        await m.addColumn(documents, documents.lastReadAt);
      }
    },
  );

  // ... existing Documents DAO methods ...

  Future<List<Document>> getDocumentsByOwner(String ownerNpub) =>
      (select(documents)
            ..where(
              (tbl) =>
                  tbl.ownerNpub.equals(ownerNpub) & tbl.filePath.like('%.pdf'),
            )
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.lastReadAt,
                mode: OrderingMode.desc,
                nulls: NullsOrder.last,
              ),
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  Stream<List<Document>> watchDocumentsByOwner(String ownerNpub) =>
      (select(documents)
            ..where(
              (tbl) =>
                  tbl.ownerNpub.equals(ownerNpub) & tbl.filePath.like('%.pdf'),
            )
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.lastReadAt,
                mode: OrderingMode.desc,
                nulls: NullsOrder.last,
              ),
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  Future<int> insertDocument(DocumentsCompanion document) =>
      into(documents).insert(document);

  Future<Document?> getDocument(int id) =>
      (select(documents)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<Document>> getAllDocuments() => select(documents).get();

  Future<Document?> getDocumentByDocumentId(String documentId) => (select(
    documents,
  )..where((tbl) => tbl.documentId.equals(documentId))).getSingleOrNull();

  Future<bool> updateDocument(DocumentsCompanion document) =>
      update(documents).replace(document);

  Future<int> deleteDocument(int id) =>
      (delete(documents)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateLastPage(int id, int lastPage) =>
      (update(documents)..where((tbl) => tbl.id.equals(id))).write(
        DocumentsCompanion(lastPage: Value(lastPage)),
      );

  Future<int> updateLastSyncedAt(int id, DateTime syncedAt) =>
      (update(documents)..where((tbl) => tbl.id.equals(id))).write(
        DocumentsCompanion(lastSyncedAt: Value(syncedAt)),
      );

  Future<int> updateLastReadAt(int id, DateTime readAt) =>
      (update(documents)..where((tbl) => tbl.id.equals(id))).write(
        DocumentsCompanion(lastReadAt: Value(readAt)),
      );

  Future<int> updateThumbnailPath(int id, String thumbnailPath) =>
      (update(documents)..where((tbl) => tbl.id.equals(id))).write(
        DocumentsCompanion(thumbnailPath: Value(thumbnailPath)),
      );

  Future<Document?> getDocumentByFileHash(String fileHash) => (select(
    documents,
  )..where((tbl) => tbl.fileHash.equals(fileHash))).getSingleOrNull();

  Future<List<Document>> getDocumentsByFileHash(String fileHash) =>
      (select(documents)..where((tbl) => tbl.fileHash.equals(fileHash))).get();

  Future<List<Document>> getDocumentsNeedingUpload() =>
      (select(documents)..where(
            (tbl) =>
                tbl.uploadStatus.isIn(['pending', 'failed']) &
                (tbl.uploadRetryCount.isSmallerThanValue(5)),
          ))
          .get();

  Future<int> updateUploadStatus(
    int id,
    String status, {
    int? retryCount,
    DateTime? lastAttempt,
  }) => (update(documents)..where((tbl) => tbl.id.equals(id))).write(
    DocumentsCompanion(
      uploadStatus: Value(status),
      uploadRetryCount: retryCount != null
          ? Value(retryCount)
          : const Value.absent(),
      lastUploadAttempt: lastAttempt != null
          ? Value(lastAttempt)
          : const Value.absent(),
    ),
  );
  Future<int> addDocument({
    required String title,
    required String filePath,
    required String documentId,
    required int lastPage,
    required String uploadStatus,
    required String ownerNpub,
    String downloadStatus = 'downloaded',
    required DateTime lastSyncedAt,
  }) {
    return into(documents).insert(
      DocumentsCompanion.insert(
        title: title,
        filePath: filePath,
        documentId: documentId,
        lastPage: Value(lastPage),
        uploadStatus: Value(uploadStatus),
        downloadStatus: Value(downloadStatus),
        lastSyncedAt: Value(lastSyncedAt),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ownerNpub: ownerNpub,
        fileHash: '', // TODO: Should be calculated
      ),
    );
  }

  Future<int> updateDownloadStatus(int id, String status) =>
      (update(documents)..where((tbl) => tbl.id.equals(id))).write(
        DocumentsCompanion(downloadStatus: Value(status)),
      );

  Future<List<Document>> getDocumentsNeedingDownload() => (select(
    documents,
  )..where((tbl) => tbl.downloadStatus.equals('pending'))).get();

  // Profiles DAO methods
  Future<Profile?> getProfile(String npub) => (select(
    profiles,
  )..where((tbl) => tbl.npub.equals(npub))).getSingleOrNull();

  Stream<Profile?> watchProfile(String npub) => (select(
    profiles,
  )..where((tbl) => tbl.npub.equals(npub))).watchSingleOrNull();

  Future<void> upsertProfile(ProfilesCompanion profile) =>
      into(profiles).insertOnConflictUpdate(profile);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));

    if (Platform.isAndroid) {
      return NativeDatabase.createInBackground(file);
    }
    return NativeDatabase(file);
  });
}
