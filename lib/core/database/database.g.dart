// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _ownerNpubMeta = const VerificationMeta(
    'ownerNpub',
  );
  @override
  late final GeneratedColumn<String> ownerNpub = GeneratedColumn<String>(
    'owner_npub',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPageMeta = const VerificationMeta(
    'lastPage',
  );
  @override
  late final GeneratedColumn<int> lastPage = GeneratedColumn<int>(
    'last_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nostrEventIdMeta = const VerificationMeta(
    'nostrEventId',
  );
  @override
  late final GeneratedColumn<String> nostrEventId = GeneratedColumn<String>(
    'nostr_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nostrAuthorMeta = const VerificationMeta(
    'nostrAuthor',
  );
  @override
  late final GeneratedColumn<String> nostrAuthor = GeneratedColumn<String>(
    'nostr_author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadStatusMeta = const VerificationMeta(
    'uploadStatus',
  );
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _downloadStatusMeta = const VerificationMeta(
    'downloadStatus',
  );
  @override
  late final GeneratedColumn<String> downloadStatus = GeneratedColumn<String>(
    'download_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('downloaded'),
  );
  static const VerificationMeta _uploadRetryCountMeta = const VerificationMeta(
    'uploadRetryCount',
  );
  @override
  late final GeneratedColumn<int> uploadRetryCount = GeneratedColumn<int>(
    'upload_retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUploadAttemptMeta = const VerificationMeta(
    'lastUploadAttempt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUploadAttempt =
      GeneratedColumn<DateTime>(
        'last_upload_attempt',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    ownerNpub,
    title,
    filePath,
    fileHash,
    lastPage,
    totalPages,
    thumbnailPath,
    nostrEventId,
    nostrAuthor,
    createdAt,
    updatedAt,
    lastSyncedAt,
    lastReadAt,
    uploadStatus,
    downloadStatus,
    uploadRetryCount,
    lastUploadAttempt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('owner_npub')) {
      context.handle(
        _ownerNpubMeta,
        ownerNpub.isAcceptableOrUnknown(data['owner_npub']!, _ownerNpubMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerNpubMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('last_page')) {
      context.handle(
        _lastPageMeta,
        lastPage.isAcceptableOrUnknown(data['last_page']!, _lastPageMeta),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('nostr_event_id')) {
      context.handle(
        _nostrEventIdMeta,
        nostrEventId.isAcceptableOrUnknown(
          data['nostr_event_id']!,
          _nostrEventIdMeta,
        ),
      );
    }
    if (data.containsKey('nostr_author')) {
      context.handle(
        _nostrAuthorMeta,
        nostrAuthor.isAcceptableOrUnknown(
          data['nostr_author']!,
          _nostrAuthorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('upload_status')) {
      context.handle(
        _uploadStatusMeta,
        uploadStatus.isAcceptableOrUnknown(
          data['upload_status']!,
          _uploadStatusMeta,
        ),
      );
    }
    if (data.containsKey('download_status')) {
      context.handle(
        _downloadStatusMeta,
        downloadStatus.isAcceptableOrUnknown(
          data['download_status']!,
          _downloadStatusMeta,
        ),
      );
    }
    if (data.containsKey('upload_retry_count')) {
      context.handle(
        _uploadRetryCountMeta,
        uploadRetryCount.isAcceptableOrUnknown(
          data['upload_retry_count']!,
          _uploadRetryCountMeta,
        ),
      );
    }
    if (data.containsKey('last_upload_attempt')) {
      context.handle(
        _lastUploadAttemptMeta,
        lastUploadAttempt.isAcceptableOrUnknown(
          data['last_upload_attempt']!,
          _lastUploadAttemptMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      ownerNpub: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_npub'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      lastPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_page'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      nostrEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nostr_event_id'],
      ),
      nostrAuthor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nostr_author'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      ),
      uploadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_status'],
      )!,
      downloadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_status'],
      )!,
      uploadRetryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}upload_retry_count'],
      )!,
      lastUploadAttempt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_upload_attempt'],
      ),
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final String documentId;
  final String ownerNpub;
  final String title;
  final String filePath;
  final String fileHash;
  final int lastPage;
  final int totalPages;
  final String? thumbnailPath;
  final String? nostrEventId;
  final String? nostrAuthor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final DateTime? lastReadAt;
  final String uploadStatus;
  final String downloadStatus;
  final int uploadRetryCount;
  final DateTime? lastUploadAttempt;
  const Document({
    required this.id,
    required this.documentId,
    required this.ownerNpub,
    required this.title,
    required this.filePath,
    required this.fileHash,
    required this.lastPage,
    required this.totalPages,
    this.thumbnailPath,
    this.nostrEventId,
    this.nostrAuthor,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.lastReadAt,
    required this.uploadStatus,
    required this.downloadStatus,
    required this.uploadRetryCount,
    this.lastUploadAttempt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<String>(documentId);
    map['owner_npub'] = Variable<String>(ownerNpub);
    map['title'] = Variable<String>(title);
    map['file_path'] = Variable<String>(filePath);
    map['file_hash'] = Variable<String>(fileHash);
    map['last_page'] = Variable<int>(lastPage);
    map['total_pages'] = Variable<int>(totalPages);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || nostrEventId != null) {
      map['nostr_event_id'] = Variable<String>(nostrEventId);
    }
    if (!nullToAbsent || nostrAuthor != null) {
      map['nostr_author'] = Variable<String>(nostrAuthor);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['download_status'] = Variable<String>(downloadStatus);
    map['upload_retry_count'] = Variable<int>(uploadRetryCount);
    if (!nullToAbsent || lastUploadAttempt != null) {
      map['last_upload_attempt'] = Variable<DateTime>(lastUploadAttempt);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      documentId: Value(documentId),
      ownerNpub: Value(ownerNpub),
      title: Value(title),
      filePath: Value(filePath),
      fileHash: Value(fileHash),
      lastPage: Value(lastPage),
      totalPages: Value(totalPages),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      nostrEventId: nostrEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(nostrEventId),
      nostrAuthor: nostrAuthor == null && nullToAbsent
          ? const Value.absent()
          : Value(nostrAuthor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      uploadStatus: Value(uploadStatus),
      downloadStatus: Value(downloadStatus),
      uploadRetryCount: Value(uploadRetryCount),
      lastUploadAttempt: lastUploadAttempt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUploadAttempt),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      ownerNpub: serializer.fromJson<String>(json['ownerNpub']),
      title: serializer.fromJson<String>(json['title']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      lastPage: serializer.fromJson<int>(json['lastPage']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      nostrEventId: serializer.fromJson<String?>(json['nostrEventId']),
      nostrAuthor: serializer.fromJson<String?>(json['nostrAuthor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      downloadStatus: serializer.fromJson<String>(json['downloadStatus']),
      uploadRetryCount: serializer.fromJson<int>(json['uploadRetryCount']),
      lastUploadAttempt: serializer.fromJson<DateTime?>(
        json['lastUploadAttempt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<String>(documentId),
      'ownerNpub': serializer.toJson<String>(ownerNpub),
      'title': serializer.toJson<String>(title),
      'filePath': serializer.toJson<String>(filePath),
      'fileHash': serializer.toJson<String>(fileHash),
      'lastPage': serializer.toJson<int>(lastPage),
      'totalPages': serializer.toJson<int>(totalPages),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'nostrEventId': serializer.toJson<String?>(nostrEventId),
      'nostrAuthor': serializer.toJson<String?>(nostrAuthor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'downloadStatus': serializer.toJson<String>(downloadStatus),
      'uploadRetryCount': serializer.toJson<int>(uploadRetryCount),
      'lastUploadAttempt': serializer.toJson<DateTime?>(lastUploadAttempt),
    };
  }

  Document copyWith({
    int? id,
    String? documentId,
    String? ownerNpub,
    String? title,
    String? filePath,
    String? fileHash,
    int? lastPage,
    int? totalPages,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> nostrEventId = const Value.absent(),
    Value<String?> nostrAuthor = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> lastReadAt = const Value.absent(),
    String? uploadStatus,
    String? downloadStatus,
    int? uploadRetryCount,
    Value<DateTime?> lastUploadAttempt = const Value.absent(),
  }) => Document(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    ownerNpub: ownerNpub ?? this.ownerNpub,
    title: title ?? this.title,
    filePath: filePath ?? this.filePath,
    fileHash: fileHash ?? this.fileHash,
    lastPage: lastPage ?? this.lastPage,
    totalPages: totalPages ?? this.totalPages,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    nostrEventId: nostrEventId.present ? nostrEventId.value : this.nostrEventId,
    nostrAuthor: nostrAuthor.present ? nostrAuthor.value : this.nostrAuthor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    downloadStatus: downloadStatus ?? this.downloadStatus,
    uploadRetryCount: uploadRetryCount ?? this.uploadRetryCount,
    lastUploadAttempt: lastUploadAttempt.present
        ? lastUploadAttempt.value
        : this.lastUploadAttempt,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      ownerNpub: data.ownerNpub.present ? data.ownerNpub.value : this.ownerNpub,
      title: data.title.present ? data.title.value : this.title,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      lastPage: data.lastPage.present ? data.lastPage.value : this.lastPage,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      nostrEventId: data.nostrEventId.present
          ? data.nostrEventId.value
          : this.nostrEventId,
      nostrAuthor: data.nostrAuthor.present
          ? data.nostrAuthor.value
          : this.nostrAuthor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      downloadStatus: data.downloadStatus.present
          ? data.downloadStatus.value
          : this.downloadStatus,
      uploadRetryCount: data.uploadRetryCount.present
          ? data.uploadRetryCount.value
          : this.uploadRetryCount,
      lastUploadAttempt: data.lastUploadAttempt.present
          ? data.lastUploadAttempt.value
          : this.lastUploadAttempt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('ownerNpub: $ownerNpub, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('lastPage: $lastPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('nostrEventId: $nostrEventId, ')
          ..write('nostrAuthor: $nostrAuthor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('uploadRetryCount: $uploadRetryCount, ')
          ..write('lastUploadAttempt: $lastUploadAttempt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    ownerNpub,
    title,
    filePath,
    fileHash,
    lastPage,
    totalPages,
    thumbnailPath,
    nostrEventId,
    nostrAuthor,
    createdAt,
    updatedAt,
    lastSyncedAt,
    lastReadAt,
    uploadStatus,
    downloadStatus,
    uploadRetryCount,
    lastUploadAttempt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.ownerNpub == this.ownerNpub &&
          other.title == this.title &&
          other.filePath == this.filePath &&
          other.fileHash == this.fileHash &&
          other.lastPage == this.lastPage &&
          other.totalPages == this.totalPages &&
          other.thumbnailPath == this.thumbnailPath &&
          other.nostrEventId == this.nostrEventId &&
          other.nostrAuthor == this.nostrAuthor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastReadAt == this.lastReadAt &&
          other.uploadStatus == this.uploadStatus &&
          other.downloadStatus == this.downloadStatus &&
          other.uploadRetryCount == this.uploadRetryCount &&
          other.lastUploadAttempt == this.lastUploadAttempt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<String> documentId;
  final Value<String> ownerNpub;
  final Value<String> title;
  final Value<String> filePath;
  final Value<String> fileHash;
  final Value<int> lastPage;
  final Value<int> totalPages;
  final Value<String?> thumbnailPath;
  final Value<String?> nostrEventId;
  final Value<String?> nostrAuthor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> lastReadAt;
  final Value<String> uploadStatus;
  final Value<String> downloadStatus;
  final Value<int> uploadRetryCount;
  final Value<DateTime?> lastUploadAttempt;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.ownerNpub = const Value.absent(),
    this.title = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.lastPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.nostrEventId = const Value.absent(),
    this.nostrAuthor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.uploadRetryCount = const Value.absent(),
    this.lastUploadAttempt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String documentId,
    required String ownerNpub,
    required String title,
    required String filePath,
    required String fileHash,
    this.lastPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.nostrEventId = const Value.absent(),
    this.nostrAuthor = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastSyncedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.uploadRetryCount = const Value.absent(),
    this.lastUploadAttempt = const Value.absent(),
  }) : documentId = Value(documentId),
       ownerNpub = Value(ownerNpub),
       title = Value(title),
       filePath = Value(filePath),
       fileHash = Value(fileHash),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<String>? documentId,
    Expression<String>? ownerNpub,
    Expression<String>? title,
    Expression<String>? filePath,
    Expression<String>? fileHash,
    Expression<int>? lastPage,
    Expression<int>? totalPages,
    Expression<String>? thumbnailPath,
    Expression<String>? nostrEventId,
    Expression<String>? nostrAuthor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? lastReadAt,
    Expression<String>? uploadStatus,
    Expression<String>? downloadStatus,
    Expression<int>? uploadRetryCount,
    Expression<DateTime>? lastUploadAttempt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (ownerNpub != null) 'owner_npub': ownerNpub,
      if (title != null) 'title': title,
      if (filePath != null) 'file_path': filePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (lastPage != null) 'last_page': lastPage,
      if (totalPages != null) 'total_pages': totalPages,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (nostrEventId != null) 'nostr_event_id': nostrEventId,
      if (nostrAuthor != null) 'nostr_author': nostrAuthor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (uploadRetryCount != null) 'upload_retry_count': uploadRetryCount,
      if (lastUploadAttempt != null) 'last_upload_attempt': lastUploadAttempt,
    });
  }

  DocumentsCompanion copyWith({
    Value<int>? id,
    Value<String>? documentId,
    Value<String>? ownerNpub,
    Value<String>? title,
    Value<String>? filePath,
    Value<String>? fileHash,
    Value<int>? lastPage,
    Value<int>? totalPages,
    Value<String?>? thumbnailPath,
    Value<String?>? nostrEventId,
    Value<String?>? nostrAuthor,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? lastReadAt,
    Value<String>? uploadStatus,
    Value<String>? downloadStatus,
    Value<int>? uploadRetryCount,
    Value<DateTime?>? lastUploadAttempt,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      ownerNpub: ownerNpub ?? this.ownerNpub,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      lastPage: lastPage ?? this.lastPage,
      totalPages: totalPages ?? this.totalPages,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      nostrEventId: nostrEventId ?? this.nostrEventId,
      nostrAuthor: nostrAuthor ?? this.nostrAuthor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      uploadRetryCount: uploadRetryCount ?? this.uploadRetryCount,
      lastUploadAttempt: lastUploadAttempt ?? this.lastUploadAttempt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (ownerNpub.present) {
      map['owner_npub'] = Variable<String>(ownerNpub.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (lastPage.present) {
      map['last_page'] = Variable<int>(lastPage.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (nostrEventId.present) {
      map['nostr_event_id'] = Variable<String>(nostrEventId.value);
    }
    if (nostrAuthor.present) {
      map['nostr_author'] = Variable<String>(nostrAuthor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (downloadStatus.present) {
      map['download_status'] = Variable<String>(downloadStatus.value);
    }
    if (uploadRetryCount.present) {
      map['upload_retry_count'] = Variable<int>(uploadRetryCount.value);
    }
    if (lastUploadAttempt.present) {
      map['last_upload_attempt'] = Variable<DateTime>(lastUploadAttempt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('ownerNpub: $ownerNpub, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('lastPage: $lastPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('nostrEventId: $nostrEventId, ')
          ..write('nostrAuthor: $nostrAuthor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('uploadRetryCount: $uploadRetryCount, ')
          ..write('lastUploadAttempt: $lastUploadAttempt')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _npubMeta = const VerificationMeta('npub');
  @override
  late final GeneratedColumn<String> npub = GeneratedColumn<String>(
    'npub',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aboutMeta = const VerificationMeta('about');
  @override
  late final GeneratedColumn<String> about = GeneratedColumn<String>(
    'about',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pictureMeta = const VerificationMeta(
    'picture',
  );
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
    'picture',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nip05Meta = const VerificationMeta('nip05');
  @override
  late final GeneratedColumn<String> nip05 = GeneratedColumn<String>(
    'nip05',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshedAtMeta = const VerificationMeta(
    'refreshedAt',
  );
  @override
  late final GeneratedColumn<DateTime> refreshedAt = GeneratedColumn<DateTime>(
    'refreshed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    npub,
    name,
    about,
    picture,
    nip05,
    createdAt,
    refreshedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('npub')) {
      context.handle(
        _npubMeta,
        npub.isAcceptableOrUnknown(data['npub']!, _npubMeta),
      );
    } else if (isInserting) {
      context.missing(_npubMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('about')) {
      context.handle(
        _aboutMeta,
        about.isAcceptableOrUnknown(data['about']!, _aboutMeta),
      );
    }
    if (data.containsKey('picture')) {
      context.handle(
        _pictureMeta,
        picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta),
      );
    }
    if (data.containsKey('nip05')) {
      context.handle(
        _nip05Meta,
        nip05.isAcceptableOrUnknown(data['nip05']!, _nip05Meta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('refreshed_at')) {
      context.handle(
        _refreshedAtMeta,
        refreshedAt.isAcceptableOrUnknown(
          data['refreshed_at']!,
          _refreshedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {npub};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      npub: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}npub'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      about: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}about'],
      ),
      picture: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picture'],
      ),
      nip05: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nip05'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      refreshedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}refreshed_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String npub;
  final String? name;
  final String? about;
  final String? picture;
  final String? nip05;
  final DateTime createdAt;
  final DateTime refreshedAt;
  const Profile({
    required this.npub,
    this.name,
    this.about,
    this.picture,
    this.nip05,
    required this.createdAt,
    required this.refreshedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['npub'] = Variable<String>(npub);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || about != null) {
      map['about'] = Variable<String>(about);
    }
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
    }
    if (!nullToAbsent || nip05 != null) {
      map['nip05'] = Variable<String>(nip05);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['refreshed_at'] = Variable<DateTime>(refreshedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      npub: Value(npub),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      about: about == null && nullToAbsent
          ? const Value.absent()
          : Value(about),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      nip05: nip05 == null && nullToAbsent
          ? const Value.absent()
          : Value(nip05),
      createdAt: Value(createdAt),
      refreshedAt: Value(refreshedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      npub: serializer.fromJson<String>(json['npub']),
      name: serializer.fromJson<String?>(json['name']),
      about: serializer.fromJson<String?>(json['about']),
      picture: serializer.fromJson<String?>(json['picture']),
      nip05: serializer.fromJson<String?>(json['nip05']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      refreshedAt: serializer.fromJson<DateTime>(json['refreshedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'npub': serializer.toJson<String>(npub),
      'name': serializer.toJson<String?>(name),
      'about': serializer.toJson<String?>(about),
      'picture': serializer.toJson<String?>(picture),
      'nip05': serializer.toJson<String?>(nip05),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'refreshedAt': serializer.toJson<DateTime>(refreshedAt),
    };
  }

  Profile copyWith({
    String? npub,
    Value<String?> name = const Value.absent(),
    Value<String?> about = const Value.absent(),
    Value<String?> picture = const Value.absent(),
    Value<String?> nip05 = const Value.absent(),
    DateTime? createdAt,
    DateTime? refreshedAt,
  }) => Profile(
    npub: npub ?? this.npub,
    name: name.present ? name.value : this.name,
    about: about.present ? about.value : this.about,
    picture: picture.present ? picture.value : this.picture,
    nip05: nip05.present ? nip05.value : this.nip05,
    createdAt: createdAt ?? this.createdAt,
    refreshedAt: refreshedAt ?? this.refreshedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      npub: data.npub.present ? data.npub.value : this.npub,
      name: data.name.present ? data.name.value : this.name,
      about: data.about.present ? data.about.value : this.about,
      picture: data.picture.present ? data.picture.value : this.picture,
      nip05: data.nip05.present ? data.nip05.value : this.nip05,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      refreshedAt: data.refreshedAt.present
          ? data.refreshedAt.value
          : this.refreshedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('npub: $npub, ')
          ..write('name: $name, ')
          ..write('about: $about, ')
          ..write('picture: $picture, ')
          ..write('nip05: $nip05, ')
          ..write('createdAt: $createdAt, ')
          ..write('refreshedAt: $refreshedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(npub, name, about, picture, nip05, createdAt, refreshedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.npub == this.npub &&
          other.name == this.name &&
          other.about == this.about &&
          other.picture == this.picture &&
          other.nip05 == this.nip05 &&
          other.createdAt == this.createdAt &&
          other.refreshedAt == this.refreshedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> npub;
  final Value<String?> name;
  final Value<String?> about;
  final Value<String?> picture;
  final Value<String?> nip05;
  final Value<DateTime> createdAt;
  final Value<DateTime> refreshedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.npub = const Value.absent(),
    this.name = const Value.absent(),
    this.about = const Value.absent(),
    this.picture = const Value.absent(),
    this.nip05 = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.refreshedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String npub,
    this.name = const Value.absent(),
    this.about = const Value.absent(),
    this.picture = const Value.absent(),
    this.nip05 = const Value.absent(),
    required DateTime createdAt,
    required DateTime refreshedAt,
    this.rowid = const Value.absent(),
  }) : npub = Value(npub),
       createdAt = Value(createdAt),
       refreshedAt = Value(refreshedAt);
  static Insertable<Profile> custom({
    Expression<String>? npub,
    Expression<String>? name,
    Expression<String>? about,
    Expression<String>? picture,
    Expression<String>? nip05,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? refreshedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (npub != null) 'npub': npub,
      if (name != null) 'name': name,
      if (about != null) 'about': about,
      if (picture != null) 'picture': picture,
      if (nip05 != null) 'nip05': nip05,
      if (createdAt != null) 'created_at': createdAt,
      if (refreshedAt != null) 'refreshed_at': refreshedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? npub,
    Value<String?>? name,
    Value<String?>? about,
    Value<String?>? picture,
    Value<String?>? nip05,
    Value<DateTime>? createdAt,
    Value<DateTime>? refreshedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      npub: npub ?? this.npub,
      name: name ?? this.name,
      about: about ?? this.about,
      picture: picture ?? this.picture,
      nip05: nip05 ?? this.nip05,
      createdAt: createdAt ?? this.createdAt,
      refreshedAt: refreshedAt ?? this.refreshedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (npub.present) {
      map['npub'] = Variable<String>(npub.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (about.present) {
      map['about'] = Variable<String>(about.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (nip05.present) {
      map['nip05'] = Variable<String>(nip05.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (refreshedAt.present) {
      map['refreshed_at'] = Variable<DateTime>(refreshedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('npub: $npub, ')
          ..write('name: $name, ')
          ..write('about: $about, ')
          ..write('picture: $picture, ')
          ..write('nip05: $nip05, ')
          ..write('createdAt: $createdAt, ')
          ..write('refreshedAt: $refreshedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [documents, profiles];
}

typedef $$DocumentsTableCreateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      required String documentId,
      required String ownerNpub,
      required String title,
      required String filePath,
      required String fileHash,
      Value<int> lastPage,
      Value<int> totalPages,
      Value<String?> thumbnailPath,
      Value<String?> nostrEventId,
      Value<String?> nostrAuthor,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> lastReadAt,
      Value<String> uploadStatus,
      Value<String> downloadStatus,
      Value<int> uploadRetryCount,
      Value<DateTime?> lastUploadAttempt,
    });
typedef $$DocumentsTableUpdateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      Value<String> documentId,
      Value<String> ownerNpub,
      Value<String> title,
      Value<String> filePath,
      Value<String> fileHash,
      Value<int> lastPage,
      Value<int> totalPages,
      Value<String?> thumbnailPath,
      Value<String?> nostrEventId,
      Value<String?> nostrAuthor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> lastReadAt,
      Value<String> uploadStatus,
      Value<String> downloadStatus,
      Value<int> uploadRetryCount,
      Value<DateTime?> lastUploadAttempt,
    });

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerNpub => $composableBuilder(
    column: $table.ownerNpub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nostrEventId => $composableBuilder(
    column: $table.nostrEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nostrAuthor => $composableBuilder(
    column: $table.nostrAuthor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadRetryCount => $composableBuilder(
    column: $table.uploadRetryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUploadAttempt => $composableBuilder(
    column: $table.lastUploadAttempt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerNpub => $composableBuilder(
    column: $table.ownerNpub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nostrEventId => $composableBuilder(
    column: $table.nostrEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nostrAuthor => $composableBuilder(
    column: $table.nostrAuthor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadRetryCount => $composableBuilder(
    column: $table.uploadRetryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUploadAttempt => $composableBuilder(
    column: $table.lastUploadAttempt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerNpub =>
      $composableBuilder(column: $table.ownerNpub, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get lastPage =>
      $composableBuilder(column: $table.lastPage, builder: (column) => column);

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nostrEventId => $composableBuilder(
    column: $table.nostrEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nostrAuthor => $composableBuilder(
    column: $table.nostrAuthor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uploadRetryCount => $composableBuilder(
    column: $table.uploadRetryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUploadAttempt => $composableBuilder(
    column: $table.lastUploadAttempt,
    builder: (column) => column,
  );
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
          Document,
          PrefetchHooks Function()
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<String> ownerNpub = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<int> lastPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> nostrEventId = const Value.absent(),
                Value<String?> nostrAuthor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String> downloadStatus = const Value.absent(),
                Value<int> uploadRetryCount = const Value.absent(),
                Value<DateTime?> lastUploadAttempt = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                documentId: documentId,
                ownerNpub: ownerNpub,
                title: title,
                filePath: filePath,
                fileHash: fileHash,
                lastPage: lastPage,
                totalPages: totalPages,
                thumbnailPath: thumbnailPath,
                nostrEventId: nostrEventId,
                nostrAuthor: nostrAuthor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
                lastReadAt: lastReadAt,
                uploadStatus: uploadStatus,
                downloadStatus: downloadStatus,
                uploadRetryCount: uploadRetryCount,
                lastUploadAttempt: lastUploadAttempt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String documentId,
                required String ownerNpub,
                required String title,
                required String filePath,
                required String fileHash,
                Value<int> lastPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> nostrEventId = const Value.absent(),
                Value<String?> nostrAuthor = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String> downloadStatus = const Value.absent(),
                Value<int> uploadRetryCount = const Value.absent(),
                Value<DateTime?> lastUploadAttempt = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                documentId: documentId,
                ownerNpub: ownerNpub,
                title: title,
                filePath: filePath,
                fileHash: fileHash,
                lastPage: lastPage,
                totalPages: totalPages,
                thumbnailPath: thumbnailPath,
                nostrEventId: nostrEventId,
                nostrAuthor: nostrAuthor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
                lastReadAt: lastReadAt,
                uploadStatus: uploadStatus,
                downloadStatus: downloadStatus,
                uploadRetryCount: uploadRetryCount,
                lastUploadAttempt: lastUploadAttempt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
      Document,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String npub,
      Value<String?> name,
      Value<String?> about,
      Value<String?> picture,
      Value<String?> nip05,
      required DateTime createdAt,
      required DateTime refreshedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> npub,
      Value<String?> name,
      Value<String?> about,
      Value<String?> picture,
      Value<String?> nip05,
      Value<DateTime> createdAt,
      Value<DateTime> refreshedAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get npub => $composableBuilder(
    column: $table.npub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get picture => $composableBuilder(
    column: $table.picture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nip05 => $composableBuilder(
    column: $table.nip05,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get npub => $composableBuilder(
    column: $table.npub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get picture => $composableBuilder(
    column: $table.picture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nip05 => $composableBuilder(
    column: $table.nip05,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get npub =>
      $composableBuilder(column: $table.npub, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get about =>
      $composableBuilder(column: $table.about, builder: (column) => column);

  GeneratedColumn<String> get picture =>
      $composableBuilder(column: $table.picture, builder: (column) => column);

  GeneratedColumn<String> get nip05 =>
      $composableBuilder(column: $table.nip05, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> npub = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> about = const Value.absent(),
                Value<String?> picture = const Value.absent(),
                Value<String?> nip05 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> refreshedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                npub: npub,
                name: name,
                about: about,
                picture: picture,
                nip05: nip05,
                createdAt: createdAt,
                refreshedAt: refreshedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String npub,
                Value<String?> name = const Value.absent(),
                Value<String?> about = const Value.absent(),
                Value<String?> picture = const Value.absent(),
                Value<String?> nip05 = const Value.absent(),
                required DateTime createdAt,
                required DateTime refreshedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                npub: npub,
                name: name,
                about: about,
                picture: picture,
                nip05: nip05,
                createdAt: createdAt,
                refreshedAt: refreshedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
}
