// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalUserScopesTable extends LocalUserScopes
    with TableInfo<$LocalUserScopesTable, LocalUserScopeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserScopesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_scopes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserScopeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserScopeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserScopeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalUserScopesTable createAlias(String alias) {
    return $LocalUserScopesTable(attachedDatabase, alias);
  }
}

class LocalUserScopeRow extends DataClass
    implements Insertable<LocalUserScopeRow> {
  final String id;
  final int createdAt;
  final int updatedAt;
  const LocalUserScopeRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LocalUserScopesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserScopesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalUserScopeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserScopeRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LocalUserScopeRow copyWith({String? id, int? createdAt, int? updatedAt}) =>
      LocalUserScopeRow(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalUserScopeRow copyWithCompanion(LocalUserScopesCompanion data) {
    return LocalUserScopeRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserScopeRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserScopeRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalUserScopesCompanion extends UpdateCompanion<LocalUserScopeRow> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LocalUserScopesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserScopesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalUserScopeRow> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserScopesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserScopesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserScopesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceConversationsTable extends SourceConversations
    with TableInfo<$SourceConversationsTable, SourceConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceRevisionMeta = const VerificationMeta(
    'sourceRevision',
  );
  @override
  late final GeneratedColumn<int> sourceRevision = GeneratedColumn<int>(
    'source_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    content,
    sourceUrl,
    sourceRevision,
    createdAt,
    updatedAt,
    isDeleted,
    isArchived,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('source_revision')) {
      context.handle(
        _sourceRevisionMeta,
        sourceRevision.isAcceptableOrUnknown(
          data['source_revision']!,
          _sourceRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRevisionMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceConversationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceConversationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      sourceRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_revision'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $SourceConversationsTable createAlias(String alias) {
    return $SourceConversationsTable(attachedDatabase, alias);
  }
}

class SourceConversationRow extends DataClass
    implements Insertable<SourceConversationRow> {
  final String id;
  final String userId;
  final String content;

  /// Original http(s) page when Capture fetched webpage text; null for paste.
  final String? sourceUrl;
  final int sourceRevision;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final bool isArchived;
  final int syncStatus;
  const SourceConversationRow({
    required this.id,
    required this.userId,
    required this.content,
    this.sourceUrl,
    required this.sourceRevision,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.isArchived,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['source_revision'] = Variable<int>(sourceRevision);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  SourceConversationsCompanion toCompanion(bool nullToAbsent) {
    return SourceConversationsCompanion(
      id: Value(id),
      userId: Value(userId),
      content: Value(content),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      sourceRevision: Value(sourceRevision),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      isArchived: Value(isArchived),
      syncStatus: Value(syncStatus),
    );
  }

  factory SourceConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceConversationRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      content: serializer.fromJson<String>(json['content']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      sourceRevision: serializer.fromJson<int>(json['sourceRevision']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'content': serializer.toJson<String>(content),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'sourceRevision': serializer.toJson<int>(sourceRevision),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'isArchived': serializer.toJson<bool>(isArchived),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  SourceConversationRow copyWith({
    String? id,
    String? userId,
    String? content,
    Value<String?> sourceUrl = const Value.absent(),
    int? sourceRevision,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    bool? isArchived,
    int? syncStatus,
  }) => SourceConversationRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    content: content ?? this.content,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    sourceRevision: sourceRevision ?? this.sourceRevision,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    isArchived: isArchived ?? this.isArchived,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  SourceConversationRow copyWithCompanion(SourceConversationsCompanion data) {
    return SourceConversationRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      content: data.content.present ? data.content.value : this.content,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      sourceRevision: data.sourceRevision.present
          ? data.sourceRevision.value
          : this.sourceRevision,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceConversationRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    content,
    sourceUrl,
    sourceRevision,
    createdAt,
    updatedAt,
    isDeleted,
    isArchived,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceConversationRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.content == this.content &&
          other.sourceUrl == this.sourceUrl &&
          other.sourceRevision == this.sourceRevision &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.isArchived == this.isArchived &&
          other.syncStatus == this.syncStatus);
}

class SourceConversationsCompanion
    extends UpdateCompanion<SourceConversationRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> content;
  final Value<String?> sourceUrl;
  final Value<int> sourceRevision;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> isArchived;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const SourceConversationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceConversationsCompanion.insert({
    required String id,
    required String userId,
    required String content,
    this.sourceUrl = const Value.absent(),
    required int sourceRevision,
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       content = Value(content),
       sourceRevision = Value(sourceRevision),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SourceConversationRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? content,
    Expression<String>? sourceUrl,
    Expression<int>? sourceRevision,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? isArchived,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (content != null) 'content': content,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (sourceRevision != null) 'source_revision': sourceRevision,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isArchived != null) 'is_archived': isArchived,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? content,
    Value<String?>? sourceUrl,
    Value<int>? sourceRevision,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? isArchived,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return SourceConversationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isArchived: isArchived ?? this.isArchived,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (sourceRevision.present) {
      map['source_revision'] = Variable<int>(sourceRevision.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceConversationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('content: $content, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isArchived: $isArchived, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerItemsTable extends LedgerItems
    with TableInfo<$LedgerItemsTable, LedgerItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindDisplayNameSnapshotMeta =
      const VerificationMeta('kindDisplayNameSnapshot');
  @override
  late final GeneratedColumn<String> kindDisplayNameSnapshot =
      GeneratedColumn<String>(
        'kind_display_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    kind,
    statement,
    status,
    owner,
    dueDate,
    note,
    kindDisplayNameSnapshot,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    } else if (isInserting) {
      context.missing(_statementMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('kind_display_name_snapshot')) {
      context.handle(
        _kindDisplayNameSnapshotMeta,
        kindDisplayNameSnapshot.isAcceptableOrUnknown(
          data['kind_display_name_snapshot']!,
          _kindDisplayNameSnapshotMeta,
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      statement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      kindDisplayNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_display_name_snapshot'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $LedgerItemsTable createAlias(String alias) {
    return $LedgerItemsTable(attachedDatabase, alias);
  }
}

class LedgerItemRow extends DataClass implements Insertable<LedgerItemRow> {
  final String id;
  final String userId;
  final String kind;
  final String statement;
  final String status;
  final String? owner;
  final int? dueDate;
  final String? note;
  final String kindDisplayNameSnapshot;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const LedgerItemRow({
    required this.id,
    required this.userId,
    required this.kind,
    required this.statement,
    required this.status,
    this.owner,
    this.dueDate,
    this.note,
    required this.kindDisplayNameSnapshot,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['kind'] = Variable<String>(kind);
    map['statement'] = Variable<String>(statement);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String>(owner);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['kind_display_name_snapshot'] = Variable<String>(
      kindDisplayNameSnapshot,
    );
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  LedgerItemsCompanion toCompanion(bool nullToAbsent) {
    return LedgerItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      kind: Value(kind),
      statement: Value(statement),
      status: Value(status),
      owner: owner == null && nullToAbsent
          ? const Value.absent()
          : Value(owner),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      kindDisplayNameSnapshot: Value(kindDisplayNameSnapshot),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory LedgerItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerItemRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      kind: serializer.fromJson<String>(json['kind']),
      statement: serializer.fromJson<String>(json['statement']),
      status: serializer.fromJson<String>(json['status']),
      owner: serializer.fromJson<String?>(json['owner']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      note: serializer.fromJson<String?>(json['note']),
      kindDisplayNameSnapshot: serializer.fromJson<String>(
        json['kindDisplayNameSnapshot'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'kind': serializer.toJson<String>(kind),
      'statement': serializer.toJson<String>(statement),
      'status': serializer.toJson<String>(status),
      'owner': serializer.toJson<String?>(owner),
      'dueDate': serializer.toJson<int?>(dueDate),
      'note': serializer.toJson<String?>(note),
      'kindDisplayNameSnapshot': serializer.toJson<String>(
        kindDisplayNameSnapshot,
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  LedgerItemRow copyWith({
    String? id,
    String? userId,
    String? kind,
    String? statement,
    String? status,
    Value<String?> owner = const Value.absent(),
    Value<int?> dueDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? kindDisplayNameSnapshot,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => LedgerItemRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    kind: kind ?? this.kind,
    statement: statement ?? this.statement,
    status: status ?? this.status,
    owner: owner.present ? owner.value : this.owner,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    note: note.present ? note.value : this.note,
    kindDisplayNameSnapshot:
        kindDisplayNameSnapshot ?? this.kindDisplayNameSnapshot,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LedgerItemRow copyWithCompanion(LedgerItemsCompanion data) {
    return LedgerItemRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      kind: data.kind.present ? data.kind.value : this.kind,
      statement: data.statement.present ? data.statement.value : this.statement,
      status: data.status.present ? data.status.value : this.status,
      owner: data.owner.present ? data.owner.value : this.owner,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      note: data.note.present ? data.note.value : this.note,
      kindDisplayNameSnapshot: data.kindDisplayNameSnapshot.present
          ? data.kindDisplayNameSnapshot.value
          : this.kindDisplayNameSnapshot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerItemRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('statement: $statement, ')
          ..write('status: $status, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('kindDisplayNameSnapshot: $kindDisplayNameSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    kind,
    statement,
    status,
    owner,
    dueDate,
    note,
    kindDisplayNameSnapshot,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerItemRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.kind == this.kind &&
          other.statement == this.statement &&
          other.status == this.status &&
          other.owner == this.owner &&
          other.dueDate == this.dueDate &&
          other.note == this.note &&
          other.kindDisplayNameSnapshot == this.kindDisplayNameSnapshot &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class LedgerItemsCompanion extends UpdateCompanion<LedgerItemRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> kind;
  final Value<String> statement;
  final Value<String> status;
  final Value<String?> owner;
  final Value<int?> dueDate;
  final Value<String?> note;
  final Value<String> kindDisplayNameSnapshot;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const LedgerItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.kind = const Value.absent(),
    this.statement = const Value.absent(),
    this.status = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    this.kindDisplayNameSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerItemsCompanion.insert({
    required String id,
    required String userId,
    required String kind,
    required String statement,
    required String status,
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    this.kindDisplayNameSnapshot = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       kind = Value(kind),
       statement = Value(statement),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LedgerItemRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? kind,
    Expression<String>? statement,
    Expression<String>? status,
    Expression<String>? owner,
    Expression<int>? dueDate,
    Expression<String>? note,
    Expression<String>? kindDisplayNameSnapshot,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (kind != null) 'kind': kind,
      if (statement != null) 'statement': statement,
      if (status != null) 'status': status,
      if (owner != null) 'owner': owner,
      if (dueDate != null) 'due_date': dueDate,
      if (note != null) 'note': note,
      if (kindDisplayNameSnapshot != null)
        'kind_display_name_snapshot': kindDisplayNameSnapshot,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? kind,
    Value<String>? statement,
    Value<String>? status,
    Value<String?>? owner,
    Value<int?>? dueDate,
    Value<String?>? note,
    Value<String>? kindDisplayNameSnapshot,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return LedgerItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kind: kind ?? this.kind,
      statement: statement ?? this.statement,
      status: status ?? this.status,
      owner: owner ?? this.owner,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      kindDisplayNameSnapshot:
          kindDisplayNameSnapshot ?? this.kindDisplayNameSnapshot,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (kindDisplayNameSnapshot.present) {
      map['kind_display_name_snapshot'] = Variable<String>(
        kindDisplayNameSnapshot.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('statement: $statement, ')
          ..write('status: $status, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('kindDisplayNameSnapshot: $kindDisplayNameSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceTable extends Evidence
    with TableInfo<$EvidenceTable, EvidenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ledgerItemIdMeta = const VerificationMeta(
    'ledgerItemId',
  );
  @override
  late final GeneratedColumn<String> ledgerItemId = GeneratedColumn<String>(
    'ledger_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConversationIdMeta =
      const VerificationMeta('sourceConversationId');
  @override
  late final GeneratedColumn<String> sourceConversationId =
      GeneratedColumn<String>(
        'source_conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceRevisionMeta = const VerificationMeta(
    'sourceRevision',
  );
  @override
  late final GeneratedColumn<int> sourceRevision = GeneratedColumn<int>(
    'source_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteStartMeta = const VerificationMeta(
    'quoteStart',
  );
  @override
  late final GeneratedColumn<int> quoteStart = GeneratedColumn<int>(
    'quote_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteEndMeta = const VerificationMeta(
    'quoteEnd',
  );
  @override
  late final GeneratedColumn<int> quoteEnd = GeneratedColumn<int>(
    'quote_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteSnippetMeta = const VerificationMeta(
    'quoteSnippet',
  );
  @override
  late final GeneratedColumn<String> quoteSnippet = GeneratedColumn<String>(
    'quote_snippet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ledgerItemId,
    sourceConversationId,
    sourceRevision,
    quoteStart,
    quoteEnd,
    quoteSnippet,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ledger_item_id')) {
      context.handle(
        _ledgerItemIdMeta,
        ledgerItemId.isAcceptableOrUnknown(
          data['ledger_item_id']!,
          _ledgerItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ledgerItemIdMeta);
    }
    if (data.containsKey('source_conversation_id')) {
      context.handle(
        _sourceConversationIdMeta,
        sourceConversationId.isAcceptableOrUnknown(
          data['source_conversation_id']!,
          _sourceConversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceConversationIdMeta);
    }
    if (data.containsKey('source_revision')) {
      context.handle(
        _sourceRevisionMeta,
        sourceRevision.isAcceptableOrUnknown(
          data['source_revision']!,
          _sourceRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRevisionMeta);
    }
    if (data.containsKey('quote_start')) {
      context.handle(
        _quoteStartMeta,
        quoteStart.isAcceptableOrUnknown(data['quote_start']!, _quoteStartMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteStartMeta);
    }
    if (data.containsKey('quote_end')) {
      context.handle(
        _quoteEndMeta,
        quoteEnd.isAcceptableOrUnknown(data['quote_end']!, _quoteEndMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteEndMeta);
    }
    if (data.containsKey('quote_snippet')) {
      context.handle(
        _quoteSnippetMeta,
        quoteSnippet.isAcceptableOrUnknown(
          data['quote_snippet']!,
          _quoteSnippetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quoteSnippetMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ledgerItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ledger_item_id'],
      )!,
      sourceConversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation_id'],
      )!,
      sourceRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_revision'],
      )!,
      quoteStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_start'],
      )!,
      quoteEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_end'],
      )!,
      quoteSnippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_snippet'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $EvidenceTable createAlias(String alias) {
    return $EvidenceTable(attachedDatabase, alias);
  }
}

class EvidenceRow extends DataClass implements Insertable<EvidenceRow> {
  final String id;
  final String ledgerItemId;
  final String sourceConversationId;
  final int sourceRevision;
  final int quoteStart;
  final int quoteEnd;
  final String quoteSnippet;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const EvidenceRow({
    required this.id,
    required this.ledgerItemId,
    required this.sourceConversationId,
    required this.sourceRevision,
    required this.quoteStart,
    required this.quoteEnd,
    required this.quoteSnippet,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ledger_item_id'] = Variable<String>(ledgerItemId);
    map['source_conversation_id'] = Variable<String>(sourceConversationId);
    map['source_revision'] = Variable<int>(sourceRevision);
    map['quote_start'] = Variable<int>(quoteStart);
    map['quote_end'] = Variable<int>(quoteEnd);
    map['quote_snippet'] = Variable<String>(quoteSnippet);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  EvidenceCompanion toCompanion(bool nullToAbsent) {
    return EvidenceCompanion(
      id: Value(id),
      ledgerItemId: Value(ledgerItemId),
      sourceConversationId: Value(sourceConversationId),
      sourceRevision: Value(sourceRevision),
      quoteStart: Value(quoteStart),
      quoteEnd: Value(quoteEnd),
      quoteSnippet: Value(quoteSnippet),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory EvidenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceRow(
      id: serializer.fromJson<String>(json['id']),
      ledgerItemId: serializer.fromJson<String>(json['ledgerItemId']),
      sourceConversationId: serializer.fromJson<String>(
        json['sourceConversationId'],
      ),
      sourceRevision: serializer.fromJson<int>(json['sourceRevision']),
      quoteStart: serializer.fromJson<int>(json['quoteStart']),
      quoteEnd: serializer.fromJson<int>(json['quoteEnd']),
      quoteSnippet: serializer.fromJson<String>(json['quoteSnippet']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ledgerItemId': serializer.toJson<String>(ledgerItemId),
      'sourceConversationId': serializer.toJson<String>(sourceConversationId),
      'sourceRevision': serializer.toJson<int>(sourceRevision),
      'quoteStart': serializer.toJson<int>(quoteStart),
      'quoteEnd': serializer.toJson<int>(quoteEnd),
      'quoteSnippet': serializer.toJson<String>(quoteSnippet),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  EvidenceRow copyWith({
    String? id,
    String? ledgerItemId,
    String? sourceConversationId,
    int? sourceRevision,
    int? quoteStart,
    int? quoteEnd,
    String? quoteSnippet,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => EvidenceRow(
    id: id ?? this.id,
    ledgerItemId: ledgerItemId ?? this.ledgerItemId,
    sourceConversationId: sourceConversationId ?? this.sourceConversationId,
    sourceRevision: sourceRevision ?? this.sourceRevision,
    quoteStart: quoteStart ?? this.quoteStart,
    quoteEnd: quoteEnd ?? this.quoteEnd,
    quoteSnippet: quoteSnippet ?? this.quoteSnippet,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  EvidenceRow copyWithCompanion(EvidenceCompanion data) {
    return EvidenceRow(
      id: data.id.present ? data.id.value : this.id,
      ledgerItemId: data.ledgerItemId.present
          ? data.ledgerItemId.value
          : this.ledgerItemId,
      sourceConversationId: data.sourceConversationId.present
          ? data.sourceConversationId.value
          : this.sourceConversationId,
      sourceRevision: data.sourceRevision.present
          ? data.sourceRevision.value
          : this.sourceRevision,
      quoteStart: data.quoteStart.present
          ? data.quoteStart.value
          : this.quoteStart,
      quoteEnd: data.quoteEnd.present ? data.quoteEnd.value : this.quoteEnd,
      quoteSnippet: data.quoteSnippet.present
          ? data.quoteSnippet.value
          : this.quoteSnippet,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceRow(')
          ..write('id: $id, ')
          ..write('ledgerItemId: $ledgerItemId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('quoteStart: $quoteStart, ')
          ..write('quoteEnd: $quoteEnd, ')
          ..write('quoteSnippet: $quoteSnippet, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ledgerItemId,
    sourceConversationId,
    sourceRevision,
    quoteStart,
    quoteEnd,
    quoteSnippet,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceRow &&
          other.id == this.id &&
          other.ledgerItemId == this.ledgerItemId &&
          other.sourceConversationId == this.sourceConversationId &&
          other.sourceRevision == this.sourceRevision &&
          other.quoteStart == this.quoteStart &&
          other.quoteEnd == this.quoteEnd &&
          other.quoteSnippet == this.quoteSnippet &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class EvidenceCompanion extends UpdateCompanion<EvidenceRow> {
  final Value<String> id;
  final Value<String> ledgerItemId;
  final Value<String> sourceConversationId;
  final Value<int> sourceRevision;
  final Value<int> quoteStart;
  final Value<int> quoteEnd;
  final Value<String> quoteSnippet;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const EvidenceCompanion({
    this.id = const Value.absent(),
    this.ledgerItemId = const Value.absent(),
    this.sourceConversationId = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.quoteStart = const Value.absent(),
    this.quoteEnd = const Value.absent(),
    this.quoteSnippet = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceCompanion.insert({
    required String id,
    required String ledgerItemId,
    required String sourceConversationId,
    required int sourceRevision,
    required int quoteStart,
    required int quoteEnd,
    required String quoteSnippet,
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ledgerItemId = Value(ledgerItemId),
       sourceConversationId = Value(sourceConversationId),
       sourceRevision = Value(sourceRevision),
       quoteStart = Value(quoteStart),
       quoteEnd = Value(quoteEnd),
       quoteSnippet = Value(quoteSnippet),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EvidenceRow> custom({
    Expression<String>? id,
    Expression<String>? ledgerItemId,
    Expression<String>? sourceConversationId,
    Expression<int>? sourceRevision,
    Expression<int>? quoteStart,
    Expression<int>? quoteEnd,
    Expression<String>? quoteSnippet,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ledgerItemId != null) 'ledger_item_id': ledgerItemId,
      if (sourceConversationId != null)
        'source_conversation_id': sourceConversationId,
      if (sourceRevision != null) 'source_revision': sourceRevision,
      if (quoteStart != null) 'quote_start': quoteStart,
      if (quoteEnd != null) 'quote_end': quoteEnd,
      if (quoteSnippet != null) 'quote_snippet': quoteSnippet,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceCompanion copyWith({
    Value<String>? id,
    Value<String>? ledgerItemId,
    Value<String>? sourceConversationId,
    Value<int>? sourceRevision,
    Value<int>? quoteStart,
    Value<int>? quoteEnd,
    Value<String>? quoteSnippet,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return EvidenceCompanion(
      id: id ?? this.id,
      ledgerItemId: ledgerItemId ?? this.ledgerItemId,
      sourceConversationId: sourceConversationId ?? this.sourceConversationId,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      quoteStart: quoteStart ?? this.quoteStart,
      quoteEnd: quoteEnd ?? this.quoteEnd,
      quoteSnippet: quoteSnippet ?? this.quoteSnippet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ledgerItemId.present) {
      map['ledger_item_id'] = Variable<String>(ledgerItemId.value);
    }
    if (sourceConversationId.present) {
      map['source_conversation_id'] = Variable<String>(
        sourceConversationId.value,
      );
    }
    if (sourceRevision.present) {
      map['source_revision'] = Variable<int>(sourceRevision.value);
    }
    if (quoteStart.present) {
      map['quote_start'] = Variable<int>(quoteStart.value);
    }
    if (quoteEnd.present) {
      map['quote_end'] = Variable<int>(quoteEnd.value);
    }
    if (quoteSnippet.present) {
      map['quote_snippet'] = Variable<String>(quoteSnippet.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceCompanion(')
          ..write('id: $id, ')
          ..write('ledgerItemId: $ledgerItemId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('quoteStart: $quoteStart, ')
          ..write('quoteEnd: $quoteEnd, ')
          ..write('quoteSnippet: $quoteSnippet, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtractionCandidatesTable extends ExtractionCandidates
    with TableInfo<$ExtractionCandidatesTable, ExtractionCandidateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtractionCandidatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConversationIdMeta =
      const VerificationMeta('sourceConversationId');
  @override
  late final GeneratedColumn<String> sourceConversationId =
      GeneratedColumn<String>(
        'source_conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceRevisionMeta = const VerificationMeta(
    'sourceRevision',
  );
  @override
  late final GeneratedColumn<int> sourceRevision = GeneratedColumn<int>(
    'source_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteStartMeta = const VerificationMeta(
    'quoteStart',
  );
  @override
  late final GeneratedColumn<int> quoteStart = GeneratedColumn<int>(
    'quote_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteEndMeta = const VerificationMeta(
    'quoteEnd',
  );
  @override
  late final GeneratedColumn<int> quoteEnd = GeneratedColumn<int>(
    'quote_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteSnippetMeta = const VerificationMeta(
    'quoteSnippet',
  );
  @override
  late final GeneratedColumn<String> quoteSnippet = GeneratedColumn<String>(
    'quote_snippet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sourceConversationId,
    sourceRevision,
    kind,
    statement,
    owner,
    dueDate,
    quoteStart,
    quoteEnd,
    quoteSnippet,
    note,
    reviewStatus,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction_candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionCandidateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_conversation_id')) {
      context.handle(
        _sourceConversationIdMeta,
        sourceConversationId.isAcceptableOrUnknown(
          data['source_conversation_id']!,
          _sourceConversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceConversationIdMeta);
    }
    if (data.containsKey('source_revision')) {
      context.handle(
        _sourceRevisionMeta,
        sourceRevision.isAcceptableOrUnknown(
          data['source_revision']!,
          _sourceRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRevisionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    } else if (isInserting) {
      context.missing(_statementMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('quote_start')) {
      context.handle(
        _quoteStartMeta,
        quoteStart.isAcceptableOrUnknown(data['quote_start']!, _quoteStartMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteStartMeta);
    }
    if (data.containsKey('quote_end')) {
      context.handle(
        _quoteEndMeta,
        quoteEnd.isAcceptableOrUnknown(data['quote_end']!, _quoteEndMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteEndMeta);
    }
    if (data.containsKey('quote_snippet')) {
      context.handle(
        _quoteSnippetMeta,
        quoteSnippet.isAcceptableOrUnknown(
          data['quote_snippet']!,
          _quoteSnippetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quoteSnippetMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtractionCandidateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionCandidateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceConversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation_id'],
      )!,
      sourceRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_revision'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      statement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      ),
      quoteStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_start'],
      )!,
      quoteEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_end'],
      )!,
      quoteSnippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_snippet'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ExtractionCandidatesTable createAlias(String alias) {
    return $ExtractionCandidatesTable(attachedDatabase, alias);
  }
}

class ExtractionCandidateRow extends DataClass
    implements Insertable<ExtractionCandidateRow> {
  final String id;
  final String userId;
  final String sourceConversationId;
  final int sourceRevision;
  final String kind;
  final String statement;
  final String? owner;
  final int? dueDate;
  final int quoteStart;
  final int quoteEnd;
  final String quoteSnippet;
  final String? note;
  final String reviewStatus;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const ExtractionCandidateRow({
    required this.id,
    required this.userId,
    required this.sourceConversationId,
    required this.sourceRevision,
    required this.kind,
    required this.statement,
    this.owner,
    this.dueDate,
    required this.quoteStart,
    required this.quoteEnd,
    required this.quoteSnippet,
    this.note,
    required this.reviewStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['source_conversation_id'] = Variable<String>(sourceConversationId);
    map['source_revision'] = Variable<int>(sourceRevision);
    map['kind'] = Variable<String>(kind);
    map['statement'] = Variable<String>(statement);
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String>(owner);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    map['quote_start'] = Variable<int>(quoteStart);
    map['quote_end'] = Variable<int>(quoteEnd);
    map['quote_snippet'] = Variable<String>(quoteSnippet);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['review_status'] = Variable<String>(reviewStatus);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ExtractionCandidatesCompanion toCompanion(bool nullToAbsent) {
    return ExtractionCandidatesCompanion(
      id: Value(id),
      userId: Value(userId),
      sourceConversationId: Value(sourceConversationId),
      sourceRevision: Value(sourceRevision),
      kind: Value(kind),
      statement: Value(statement),
      owner: owner == null && nullToAbsent
          ? const Value.absent()
          : Value(owner),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      quoteStart: Value(quoteStart),
      quoteEnd: Value(quoteEnd),
      quoteSnippet: Value(quoteSnippet),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      reviewStatus: Value(reviewStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory ExtractionCandidateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionCandidateRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceConversationId: serializer.fromJson<String>(
        json['sourceConversationId'],
      ),
      sourceRevision: serializer.fromJson<int>(json['sourceRevision']),
      kind: serializer.fromJson<String>(json['kind']),
      statement: serializer.fromJson<String>(json['statement']),
      owner: serializer.fromJson<String?>(json['owner']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      quoteStart: serializer.fromJson<int>(json['quoteStart']),
      quoteEnd: serializer.fromJson<int>(json['quoteEnd']),
      quoteSnippet: serializer.fromJson<String>(json['quoteSnippet']),
      note: serializer.fromJson<String?>(json['note']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sourceConversationId': serializer.toJson<String>(sourceConversationId),
      'sourceRevision': serializer.toJson<int>(sourceRevision),
      'kind': serializer.toJson<String>(kind),
      'statement': serializer.toJson<String>(statement),
      'owner': serializer.toJson<String?>(owner),
      'dueDate': serializer.toJson<int?>(dueDate),
      'quoteStart': serializer.toJson<int>(quoteStart),
      'quoteEnd': serializer.toJson<int>(quoteEnd),
      'quoteSnippet': serializer.toJson<String>(quoteSnippet),
      'note': serializer.toJson<String?>(note),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  ExtractionCandidateRow copyWith({
    String? id,
    String? userId,
    String? sourceConversationId,
    int? sourceRevision,
    String? kind,
    String? statement,
    Value<String?> owner = const Value.absent(),
    Value<int?> dueDate = const Value.absent(),
    int? quoteStart,
    int? quoteEnd,
    String? quoteSnippet,
    Value<String?> note = const Value.absent(),
    String? reviewStatus,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => ExtractionCandidateRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sourceConversationId: sourceConversationId ?? this.sourceConversationId,
    sourceRevision: sourceRevision ?? this.sourceRevision,
    kind: kind ?? this.kind,
    statement: statement ?? this.statement,
    owner: owner.present ? owner.value : this.owner,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    quoteStart: quoteStart ?? this.quoteStart,
    quoteEnd: quoteEnd ?? this.quoteEnd,
    quoteSnippet: quoteSnippet ?? this.quoteSnippet,
    note: note.present ? note.value : this.note,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ExtractionCandidateRow copyWithCompanion(ExtractionCandidatesCompanion data) {
    return ExtractionCandidateRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceConversationId: data.sourceConversationId.present
          ? data.sourceConversationId.value
          : this.sourceConversationId,
      sourceRevision: data.sourceRevision.present
          ? data.sourceRevision.value
          : this.sourceRevision,
      kind: data.kind.present ? data.kind.value : this.kind,
      statement: data.statement.present ? data.statement.value : this.statement,
      owner: data.owner.present ? data.owner.value : this.owner,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      quoteStart: data.quoteStart.present
          ? data.quoteStart.value
          : this.quoteStart,
      quoteEnd: data.quoteEnd.present ? data.quoteEnd.value : this.quoteEnd,
      quoteSnippet: data.quoteSnippet.present
          ? data.quoteSnippet.value
          : this.quoteSnippet,
      note: data.note.present ? data.note.value : this.note,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionCandidateRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('kind: $kind, ')
          ..write('statement: $statement, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('quoteStart: $quoteStart, ')
          ..write('quoteEnd: $quoteEnd, ')
          ..write('quoteSnippet: $quoteSnippet, ')
          ..write('note: $note, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sourceConversationId,
    sourceRevision,
    kind,
    statement,
    owner,
    dueDate,
    quoteStart,
    quoteEnd,
    quoteSnippet,
    note,
    reviewStatus,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionCandidateRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sourceConversationId == this.sourceConversationId &&
          other.sourceRevision == this.sourceRevision &&
          other.kind == this.kind &&
          other.statement == this.statement &&
          other.owner == this.owner &&
          other.dueDate == this.dueDate &&
          other.quoteStart == this.quoteStart &&
          other.quoteEnd == this.quoteEnd &&
          other.quoteSnippet == this.quoteSnippet &&
          other.note == this.note &&
          other.reviewStatus == this.reviewStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class ExtractionCandidatesCompanion
    extends UpdateCompanion<ExtractionCandidateRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sourceConversationId;
  final Value<int> sourceRevision;
  final Value<String> kind;
  final Value<String> statement;
  final Value<String?> owner;
  final Value<int?> dueDate;
  final Value<int> quoteStart;
  final Value<int> quoteEnd;
  final Value<String> quoteSnippet;
  final Value<String?> note;
  final Value<String> reviewStatus;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ExtractionCandidatesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceConversationId = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.kind = const Value.absent(),
    this.statement = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.quoteStart = const Value.absent(),
    this.quoteEnd = const Value.absent(),
    this.quoteSnippet = const Value.absent(),
    this.note = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtractionCandidatesCompanion.insert({
    required String id,
    required String userId,
    required String sourceConversationId,
    required int sourceRevision,
    required String kind,
    required String statement,
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    required int quoteStart,
    required int quoteEnd,
    required String quoteSnippet,
    this.note = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sourceConversationId = Value(sourceConversationId),
       sourceRevision = Value(sourceRevision),
       kind = Value(kind),
       statement = Value(statement),
       quoteStart = Value(quoteStart),
       quoteEnd = Value(quoteEnd),
       quoteSnippet = Value(quoteSnippet),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExtractionCandidateRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sourceConversationId,
    Expression<int>? sourceRevision,
    Expression<String>? kind,
    Expression<String>? statement,
    Expression<String>? owner,
    Expression<int>? dueDate,
    Expression<int>? quoteStart,
    Expression<int>? quoteEnd,
    Expression<String>? quoteSnippet,
    Expression<String>? note,
    Expression<String>? reviewStatus,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sourceConversationId != null)
        'source_conversation_id': sourceConversationId,
      if (sourceRevision != null) 'source_revision': sourceRevision,
      if (kind != null) 'kind': kind,
      if (statement != null) 'statement': statement,
      if (owner != null) 'owner': owner,
      if (dueDate != null) 'due_date': dueDate,
      if (quoteStart != null) 'quote_start': quoteStart,
      if (quoteEnd != null) 'quote_end': quoteEnd,
      if (quoteSnippet != null) 'quote_snippet': quoteSnippet,
      if (note != null) 'note': note,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtractionCandidatesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sourceConversationId,
    Value<int>? sourceRevision,
    Value<String>? kind,
    Value<String>? statement,
    Value<String?>? owner,
    Value<int?>? dueDate,
    Value<int>? quoteStart,
    Value<int>? quoteEnd,
    Value<String>? quoteSnippet,
    Value<String?>? note,
    Value<String>? reviewStatus,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ExtractionCandidatesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceConversationId: sourceConversationId ?? this.sourceConversationId,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      kind: kind ?? this.kind,
      statement: statement ?? this.statement,
      owner: owner ?? this.owner,
      dueDate: dueDate ?? this.dueDate,
      quoteStart: quoteStart ?? this.quoteStart,
      quoteEnd: quoteEnd ?? this.quoteEnd,
      quoteSnippet: quoteSnippet ?? this.quoteSnippet,
      note: note ?? this.note,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceConversationId.present) {
      map['source_conversation_id'] = Variable<String>(
        sourceConversationId.value,
      );
    }
    if (sourceRevision.present) {
      map['source_revision'] = Variable<int>(sourceRevision.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (quoteStart.present) {
      map['quote_start'] = Variable<int>(quoteStart.value);
    }
    if (quoteEnd.present) {
      map['quote_end'] = Variable<int>(quoteEnd.value);
    }
    if (quoteSnippet.present) {
      map['quote_snippet'] = Variable<String>(quoteSnippet.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionCandidatesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('kind: $kind, ')
          ..write('statement: $statement, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('quoteStart: $quoteStart, ')
          ..write('quoteEnd: $quoteEnd, ')
          ..write('quoteSnippet: $quoteSnippet, ')
          ..write('note: $note, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiProcessingConsentsTable extends AiProcessingConsents
    with TableInfo<$AiProcessingConsentsTable, AiProcessingConsentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiProcessingConsentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    status,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_processing_consents';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiProcessingConsentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiProcessingConsentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiProcessingConsentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $AiProcessingConsentsTable createAlias(String alias) {
    return $AiProcessingConsentsTable(attachedDatabase, alias);
  }
}

class AiProcessingConsentRow extends DataClass
    implements Insertable<AiProcessingConsentRow> {
  final String id;
  final String userId;
  final String status;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const AiProcessingConsentRow({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  AiProcessingConsentsCompanion toCompanion(bool nullToAbsent) {
    return AiProcessingConsentsCompanion(
      id: Value(id),
      userId: Value(userId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory AiProcessingConsentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiProcessingConsentRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  AiProcessingConsentRow copyWith({
    String? id,
    String? userId,
    String? status,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => AiProcessingConsentRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  AiProcessingConsentRow copyWithCompanion(AiProcessingConsentsCompanion data) {
    return AiProcessingConsentRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiProcessingConsentRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    status,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiProcessingConsentRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class AiProcessingConsentsCompanion
    extends UpdateCompanion<AiProcessingConsentRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const AiProcessingConsentsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiProcessingConsentsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String status,
    this.createdAt = const Value.absent(),
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<AiProcessingConsentRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiProcessingConsentsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return AiProcessingConsentsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiProcessingConsentsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localePreferenceMeta = const VerificationMeta(
    'localePreference',
  );
  @override
  late final GeneratedColumn<String> localePreference = GeneratedColumn<String>(
    'locale_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _debugModeEnabledMeta = const VerificationMeta(
    'debugModeEnabled',
  );
  @override
  late final GeneratedColumn<bool> debugModeEnabled = GeneratedColumn<bool>(
    'debug_mode_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("debug_mode_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _chatSystemPromptOverrideMeta =
      const VerificationMeta('chatSystemPromptOverride');
  @override
  late final GeneratedColumn<String> chatSystemPromptOverride =
      GeneratedColumn<String>(
        'chat_system_prompt_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _extractionPromptOverrideMeta =
      const VerificationMeta('extractionPromptOverride');
  @override
  late final GeneratedColumn<String> extractionPromptOverride =
      GeneratedColumn<String>(
        'extraction_prompt_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _extractionSystemPromptOverrideMeta =
      const VerificationMeta('extractionSystemPromptOverride');
  @override
  late final GeneratedColumn<String> extractionSystemPromptOverride =
      GeneratedColumn<String>(
        'extraction_system_prompt_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _extractionKindsIntroDismissedMeta =
      const VerificationMeta('extractionKindsIntroDismissed');
  @override
  late final GeneratedColumn<bool> extractionKindsIntroDismissed =
      GeneratedColumn<bool>(
        'extraction_kinds_intro_dismissed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("extraction_kinds_intro_dismissed" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    themeMode,
    localePreference,
    debugModeEnabled,
    chatSystemPromptOverride,
    extractionPromptOverride,
    extractionSystemPromptOverride,
    extractionKindsIntroDismissed,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('locale_preference')) {
      context.handle(
        _localePreferenceMeta,
        localePreference.isAcceptableOrUnknown(
          data['locale_preference']!,
          _localePreferenceMeta,
        ),
      );
    }
    if (data.containsKey('debug_mode_enabled')) {
      context.handle(
        _debugModeEnabledMeta,
        debugModeEnabled.isAcceptableOrUnknown(
          data['debug_mode_enabled']!,
          _debugModeEnabledMeta,
        ),
      );
    }
    if (data.containsKey('chat_system_prompt_override')) {
      context.handle(
        _chatSystemPromptOverrideMeta,
        chatSystemPromptOverride.isAcceptableOrUnknown(
          data['chat_system_prompt_override']!,
          _chatSystemPromptOverrideMeta,
        ),
      );
    }
    if (data.containsKey('extraction_prompt_override')) {
      context.handle(
        _extractionPromptOverrideMeta,
        extractionPromptOverride.isAcceptableOrUnknown(
          data['extraction_prompt_override']!,
          _extractionPromptOverrideMeta,
        ),
      );
    }
    if (data.containsKey('extraction_system_prompt_override')) {
      context.handle(
        _extractionSystemPromptOverrideMeta,
        extractionSystemPromptOverride.isAcceptableOrUnknown(
          data['extraction_system_prompt_override']!,
          _extractionSystemPromptOverrideMeta,
        ),
      );
    }
    if (data.containsKey('extraction_kinds_intro_dismissed')) {
      context.handle(
        _extractionKindsIntroDismissedMeta,
        extractionKindsIntroDismissed.isAcceptableOrUnknown(
          data['extraction_kinds_intro_dismissed']!,
          _extractionKindsIntroDismissedMeta,
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      localePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_preference'],
      )!,
      debugModeEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}debug_mode_enabled'],
      )!,
      chatSystemPromptOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_system_prompt_override'],
      ),
      extractionPromptOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_prompt_override'],
      ),
      extractionSystemPromptOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_system_prompt_override'],
      ),
      extractionKindsIntroDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}extraction_kinds_intro_dismissed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreferenceRow extends DataClass
    implements Insertable<UserPreferenceRow> {
  final String id;
  final String userId;
  final String themeMode;
  final String localePreference;
  final bool debugModeEnabled;
  final String? chatSystemPromptOverride;
  final String? extractionPromptOverride;
  final String? extractionSystemPromptOverride;
  final bool extractionKindsIntroDismissed;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const UserPreferenceRow({
    required this.id,
    required this.userId,
    required this.themeMode,
    required this.localePreference,
    required this.debugModeEnabled,
    this.chatSystemPromptOverride,
    this.extractionPromptOverride,
    this.extractionSystemPromptOverride,
    required this.extractionKindsIntroDismissed,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['theme_mode'] = Variable<String>(themeMode);
    map['locale_preference'] = Variable<String>(localePreference);
    map['debug_mode_enabled'] = Variable<bool>(debugModeEnabled);
    if (!nullToAbsent || chatSystemPromptOverride != null) {
      map['chat_system_prompt_override'] = Variable<String>(
        chatSystemPromptOverride,
      );
    }
    if (!nullToAbsent || extractionPromptOverride != null) {
      map['extraction_prompt_override'] = Variable<String>(
        extractionPromptOverride,
      );
    }
    if (!nullToAbsent || extractionSystemPromptOverride != null) {
      map['extraction_system_prompt_override'] = Variable<String>(
        extractionSystemPromptOverride,
      );
    }
    map['extraction_kinds_intro_dismissed'] = Variable<bool>(
      extractionKindsIntroDismissed,
    );
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      userId: Value(userId),
      themeMode: Value(themeMode),
      localePreference: Value(localePreference),
      debugModeEnabled: Value(debugModeEnabled),
      chatSystemPromptOverride: chatSystemPromptOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(chatSystemPromptOverride),
      extractionPromptOverride: extractionPromptOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionPromptOverride),
      extractionSystemPromptOverride:
          extractionSystemPromptOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionSystemPromptOverride),
      extractionKindsIntroDismissed: Value(extractionKindsIntroDismissed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory UserPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferenceRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      localePreference: serializer.fromJson<String>(json['localePreference']),
      debugModeEnabled: serializer.fromJson<bool>(json['debugModeEnabled']),
      chatSystemPromptOverride: serializer.fromJson<String?>(
        json['chatSystemPromptOverride'],
      ),
      extractionPromptOverride: serializer.fromJson<String?>(
        json['extractionPromptOverride'],
      ),
      extractionSystemPromptOverride: serializer.fromJson<String?>(
        json['extractionSystemPromptOverride'],
      ),
      extractionKindsIntroDismissed: serializer.fromJson<bool>(
        json['extractionKindsIntroDismissed'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'themeMode': serializer.toJson<String>(themeMode),
      'localePreference': serializer.toJson<String>(localePreference),
      'debugModeEnabled': serializer.toJson<bool>(debugModeEnabled),
      'chatSystemPromptOverride': serializer.toJson<String?>(
        chatSystemPromptOverride,
      ),
      'extractionPromptOverride': serializer.toJson<String?>(
        extractionPromptOverride,
      ),
      'extractionSystemPromptOverride': serializer.toJson<String?>(
        extractionSystemPromptOverride,
      ),
      'extractionKindsIntroDismissed': serializer.toJson<bool>(
        extractionKindsIntroDismissed,
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  UserPreferenceRow copyWith({
    String? id,
    String? userId,
    String? themeMode,
    String? localePreference,
    bool? debugModeEnabled,
    Value<String?> chatSystemPromptOverride = const Value.absent(),
    Value<String?> extractionPromptOverride = const Value.absent(),
    Value<String?> extractionSystemPromptOverride = const Value.absent(),
    bool? extractionKindsIntroDismissed,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => UserPreferenceRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    themeMode: themeMode ?? this.themeMode,
    localePreference: localePreference ?? this.localePreference,
    debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
    chatSystemPromptOverride: chatSystemPromptOverride.present
        ? chatSystemPromptOverride.value
        : this.chatSystemPromptOverride,
    extractionPromptOverride: extractionPromptOverride.present
        ? extractionPromptOverride.value
        : this.extractionPromptOverride,
    extractionSystemPromptOverride: extractionSystemPromptOverride.present
        ? extractionSystemPromptOverride.value
        : this.extractionSystemPromptOverride,
    extractionKindsIntroDismissed:
        extractionKindsIntroDismissed ?? this.extractionKindsIntroDismissed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  UserPreferenceRow copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      localePreference: data.localePreference.present
          ? data.localePreference.value
          : this.localePreference,
      debugModeEnabled: data.debugModeEnabled.present
          ? data.debugModeEnabled.value
          : this.debugModeEnabled,
      chatSystemPromptOverride: data.chatSystemPromptOverride.present
          ? data.chatSystemPromptOverride.value
          : this.chatSystemPromptOverride,
      extractionPromptOverride: data.extractionPromptOverride.present
          ? data.extractionPromptOverride.value
          : this.extractionPromptOverride,
      extractionSystemPromptOverride:
          data.extractionSystemPromptOverride.present
          ? data.extractionSystemPromptOverride.value
          : this.extractionSystemPromptOverride,
      extractionKindsIntroDismissed: data.extractionKindsIntroDismissed.present
          ? data.extractionKindsIntroDismissed.value
          : this.extractionKindsIntroDismissed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferenceRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('localePreference: $localePreference, ')
          ..write('debugModeEnabled: $debugModeEnabled, ')
          ..write('chatSystemPromptOverride: $chatSystemPromptOverride, ')
          ..write('extractionPromptOverride: $extractionPromptOverride, ')
          ..write(
            'extractionSystemPromptOverride: $extractionSystemPromptOverride, ',
          )
          ..write(
            'extractionKindsIntroDismissed: $extractionKindsIntroDismissed, ',
          )
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    themeMode,
    localePreference,
    debugModeEnabled,
    chatSystemPromptOverride,
    extractionPromptOverride,
    extractionSystemPromptOverride,
    extractionKindsIntroDismissed,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferenceRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.themeMode == this.themeMode &&
          other.localePreference == this.localePreference &&
          other.debugModeEnabled == this.debugModeEnabled &&
          other.chatSystemPromptOverride == this.chatSystemPromptOverride &&
          other.extractionPromptOverride == this.extractionPromptOverride &&
          other.extractionSystemPromptOverride ==
              this.extractionSystemPromptOverride &&
          other.extractionKindsIntroDismissed ==
              this.extractionKindsIntroDismissed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreferenceRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> themeMode;
  final Value<String> localePreference;
  final Value<bool> debugModeEnabled;
  final Value<String?> chatSystemPromptOverride;
  final Value<String?> extractionPromptOverride;
  final Value<String?> extractionSystemPromptOverride;
  final Value<bool> extractionKindsIntroDismissed;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localePreference = const Value.absent(),
    this.debugModeEnabled = const Value.absent(),
    this.chatSystemPromptOverride = const Value.absent(),
    this.extractionPromptOverride = const Value.absent(),
    this.extractionSystemPromptOverride = const Value.absent(),
    this.extractionKindsIntroDismissed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    required String id,
    required String userId,
    required String themeMode,
    this.localePreference = const Value.absent(),
    this.debugModeEnabled = const Value.absent(),
    this.chatSystemPromptOverride = const Value.absent(),
    this.extractionPromptOverride = const Value.absent(),
    this.extractionSystemPromptOverride = const Value.absent(),
    this.extractionKindsIntroDismissed = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       themeMode = Value(themeMode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserPreferenceRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? themeMode,
    Expression<String>? localePreference,
    Expression<bool>? debugModeEnabled,
    Expression<String>? chatSystemPromptOverride,
    Expression<String>? extractionPromptOverride,
    Expression<String>? extractionSystemPromptOverride,
    Expression<bool>? extractionKindsIntroDismissed,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (themeMode != null) 'theme_mode': themeMode,
      if (localePreference != null) 'locale_preference': localePreference,
      if (debugModeEnabled != null) 'debug_mode_enabled': debugModeEnabled,
      if (chatSystemPromptOverride != null)
        'chat_system_prompt_override': chatSystemPromptOverride,
      if (extractionPromptOverride != null)
        'extraction_prompt_override': extractionPromptOverride,
      if (extractionSystemPromptOverride != null)
        'extraction_system_prompt_override': extractionSystemPromptOverride,
      if (extractionKindsIntroDismissed != null)
        'extraction_kinds_intro_dismissed': extractionKindsIntroDismissed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? themeMode,
    Value<String>? localePreference,
    Value<bool>? debugModeEnabled,
    Value<String?>? chatSystemPromptOverride,
    Value<String?>? extractionPromptOverride,
    Value<String?>? extractionSystemPromptOverride,
    Value<bool>? extractionKindsIntroDismissed,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      localePreference: localePreference ?? this.localePreference,
      debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
      chatSystemPromptOverride:
          chatSystemPromptOverride ?? this.chatSystemPromptOverride,
      extractionPromptOverride:
          extractionPromptOverride ?? this.extractionPromptOverride,
      extractionSystemPromptOverride:
          extractionSystemPromptOverride ?? this.extractionSystemPromptOverride,
      extractionKindsIntroDismissed:
          extractionKindsIntroDismissed ?? this.extractionKindsIntroDismissed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (localePreference.present) {
      map['locale_preference'] = Variable<String>(localePreference.value);
    }
    if (debugModeEnabled.present) {
      map['debug_mode_enabled'] = Variable<bool>(debugModeEnabled.value);
    }
    if (chatSystemPromptOverride.present) {
      map['chat_system_prompt_override'] = Variable<String>(
        chatSystemPromptOverride.value,
      );
    }
    if (extractionPromptOverride.present) {
      map['extraction_prompt_override'] = Variable<String>(
        extractionPromptOverride.value,
      );
    }
    if (extractionSystemPromptOverride.present) {
      map['extraction_system_prompt_override'] = Variable<String>(
        extractionSystemPromptOverride.value,
      );
    }
    if (extractionKindsIntroDismissed.present) {
      map['extraction_kinds_intro_dismissed'] = Variable<bool>(
        extractionKindsIntroDismissed.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('localePreference: $localePreference, ')
          ..write('debugModeEnabled: $debugModeEnabled, ')
          ..write('chatSystemPromptOverride: $chatSystemPromptOverride, ')
          ..write('extractionPromptOverride: $extractionPromptOverride, ')
          ..write(
            'extractionSystemPromptOverride: $extractionSystemPromptOverride, ',
          )
          ..write(
            'extractionKindsIntroDismissed: $extractionKindsIntroDismissed, ',
          )
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatThreadsTable extends ChatThreads
    with TableInfo<$ChatThreadsTable, ChatThreadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
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
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    modelId,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_threads';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatThreadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatThreadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatThreadRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ChatThreadsTable createAlias(String alias) {
    return $ChatThreadsTable(attachedDatabase, alias);
  }
}

class ChatThreadRow extends DataClass implements Insertable<ChatThreadRow> {
  final String id;
  final String userId;
  final String title;
  final String? modelId;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const ChatThreadRow({
    required this.id,
    required this.userId,
    required this.title,
    this.modelId,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || modelId != null) {
      map['model_id'] = Variable<String>(modelId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ChatThreadsCompanion toCompanion(bool nullToAbsent) {
    return ChatThreadsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      modelId: modelId == null && nullToAbsent
          ? const Value.absent()
          : Value(modelId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory ChatThreadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatThreadRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      modelId: serializer.fromJson<String?>(json['modelId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'modelId': serializer.toJson<String?>(modelId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  ChatThreadRow copyWith({
    String? id,
    String? userId,
    String? title,
    Value<String?> modelId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => ChatThreadRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    modelId: modelId.present ? modelId.value : this.modelId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ChatThreadRow copyWithCompanion(ChatThreadsCompanion data) {
    return ChatThreadRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatThreadRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('modelId: $modelId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    modelId,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatThreadRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.modelId == this.modelId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class ChatThreadsCompanion extends UpdateCompanion<ChatThreadRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> modelId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ChatThreadsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.modelId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatThreadsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.modelId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChatThreadRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? modelId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (modelId != null) 'model_id': modelId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatThreadsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String?>? modelId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ChatThreadsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      modelId: modelId ?? this.modelId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatThreadsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('modelId: $modelId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    threadId,
    role,
    content,
    status,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageRow extends DataClass implements Insertable<ChatMessageRow> {
  final String id;
  final String userId;
  final String threadId;
  final String role;
  final String content;
  final String status;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const ChatMessageRow({
    required this.id,
    required this.userId,
    required this.threadId,
    required this.role,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['thread_id'] = Variable<String>(threadId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      userId: Value(userId),
      threadId: Value(threadId),
      role: Value(role),
      content: Value(content),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory ChatMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      threadId: serializer.fromJson<String>(json['threadId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'threadId': serializer.toJson<String>(threadId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  ChatMessageRow copyWith({
    String? id,
    String? userId,
    String? threadId,
    String? role,
    String? content,
    String? status,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => ChatMessageRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    threadId: threadId ?? this.threadId,
    role: role ?? this.role,
    content: content ?? this.content,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ChatMessageRow copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('threadId: $threadId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    threadId,
    role,
    content,
    status,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.threadId == this.threadId &&
          other.role == this.role &&
          other.content == this.content &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> threadId;
  final Value<String> role;
  final Value<String> content;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.threadId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String userId,
    required String threadId,
    required String role,
    required String content,
    required String status,
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       threadId = Value(threadId),
       role = Value(role),
       content = Value(content),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChatMessageRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? threadId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (threadId != null) 'thread_id': threadId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? threadId,
    Value<String>? role,
    Value<String>? content,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      threadId: threadId ?? this.threadId,
      role: role ?? this.role,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('threadId: $threadId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtractionJobsTable extends ExtractionJobs
    with TableInfo<$ExtractionJobsTable, ExtractionJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtractionJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConversationIdMeta =
      const VerificationMeta('sourceConversationId');
  @override
  late final GeneratedColumn<String> sourceConversationId =
      GeneratedColumn<String>(
        'source_conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceRevisionMeta = const VerificationMeta(
    'sourceRevision',
  );
  @override
  late final GeneratedColumn<int> sourceRevision = GeneratedColumn<int>(
    'source_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _completedChunkCountMeta =
      const VerificationMeta('completedChunkCount');
  @override
  late final GeneratedColumn<int> completedChunkCount = GeneratedColumn<int>(
    'completed_chunk_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalChunksMeta = const VerificationMeta(
    'totalChunks',
  );
  @override
  late final GeneratedColumn<int> totalChunks = GeneratedColumn<int>(
    'total_chunks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _candidatesFoundMeta = const VerificationMeta(
    'candidatesFound',
  );
  @override
  late final GeneratedColumn<int> candidatesFound = GeneratedColumn<int>(
    'candidates_found',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startTimeMsMeta = const VerificationMeta(
    'startTimeMs',
  );
  @override
  late final GeneratedColumn<int> startTimeMs = GeneratedColumn<int>(
    'start_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chunkTimingsJsonMeta = const VerificationMeta(
    'chunkTimingsJson',
  );
  @override
  late final GeneratedColumn<String> chunkTimingsJson = GeneratedColumn<String>(
    'chunk_timings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _progressTitleMeta = const VerificationMeta(
    'progressTitle',
  );
  @override
  late final GeneratedColumn<String> progressTitle = GeneratedColumn<String>(
    'progress_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _progressBodyMeta = const VerificationMeta(
    'progressBody',
  );
  @override
  late final GeneratedColumn<String> progressBody = GeneratedColumn<String>(
    'progress_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _completionTitleMeta = const VerificationMeta(
    'completionTitle',
  );
  @override
  late final GeneratedColumn<String> completionTitle = GeneratedColumn<String>(
    'completion_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _queuedSourceConversationIdsJsonMeta =
      const VerificationMeta('queuedSourceConversationIdsJson');
  @override
  late final GeneratedColumn<String> queuedSourceConversationIdsJson =
      GeneratedColumn<String>(
        'queued_source_conversation_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _batchIndexMeta = const VerificationMeta(
    'batchIndex',
  );
  @override
  late final GeneratedColumn<int> batchIndex = GeneratedColumn<int>(
    'batch_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _batchTotalMeta = const VerificationMeta(
    'batchTotal',
  );
  @override
  late final GeneratedColumn<int> batchTotal = GeneratedColumn<int>(
    'batch_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceConversationId,
    sourceRevision,
    completedChunkCount,
    totalChunks,
    candidatesFound,
    startTimeMs,
    chunkTimingsJson,
    progressTitle,
    progressBody,
    completionTitle,
    queuedSourceConversationIdsJson,
    batchIndex,
    batchTotal,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionJobRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_conversation_id')) {
      context.handle(
        _sourceConversationIdMeta,
        sourceConversationId.isAcceptableOrUnknown(
          data['source_conversation_id']!,
          _sourceConversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceConversationIdMeta);
    }
    if (data.containsKey('source_revision')) {
      context.handle(
        _sourceRevisionMeta,
        sourceRevision.isAcceptableOrUnknown(
          data['source_revision']!,
          _sourceRevisionMeta,
        ),
      );
    }
    if (data.containsKey('completed_chunk_count')) {
      context.handle(
        _completedChunkCountMeta,
        completedChunkCount.isAcceptableOrUnknown(
          data['completed_chunk_count']!,
          _completedChunkCountMeta,
        ),
      );
    }
    if (data.containsKey('total_chunks')) {
      context.handle(
        _totalChunksMeta,
        totalChunks.isAcceptableOrUnknown(
          data['total_chunks']!,
          _totalChunksMeta,
        ),
      );
    }
    if (data.containsKey('candidates_found')) {
      context.handle(
        _candidatesFoundMeta,
        candidatesFound.isAcceptableOrUnknown(
          data['candidates_found']!,
          _candidatesFoundMeta,
        ),
      );
    }
    if (data.containsKey('start_time_ms')) {
      context.handle(
        _startTimeMsMeta,
        startTimeMs.isAcceptableOrUnknown(
          data['start_time_ms']!,
          _startTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimeMsMeta);
    }
    if (data.containsKey('chunk_timings_json')) {
      context.handle(
        _chunkTimingsJsonMeta,
        chunkTimingsJson.isAcceptableOrUnknown(
          data['chunk_timings_json']!,
          _chunkTimingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('progress_title')) {
      context.handle(
        _progressTitleMeta,
        progressTitle.isAcceptableOrUnknown(
          data['progress_title']!,
          _progressTitleMeta,
        ),
      );
    }
    if (data.containsKey('progress_body')) {
      context.handle(
        _progressBodyMeta,
        progressBody.isAcceptableOrUnknown(
          data['progress_body']!,
          _progressBodyMeta,
        ),
      );
    }
    if (data.containsKey('completion_title')) {
      context.handle(
        _completionTitleMeta,
        completionTitle.isAcceptableOrUnknown(
          data['completion_title']!,
          _completionTitleMeta,
        ),
      );
    }
    if (data.containsKey('queued_source_conversation_ids_json')) {
      context.handle(
        _queuedSourceConversationIdsJsonMeta,
        queuedSourceConversationIdsJson.isAcceptableOrUnknown(
          data['queued_source_conversation_ids_json']!,
          _queuedSourceConversationIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('batch_index')) {
      context.handle(
        _batchIndexMeta,
        batchIndex.isAcceptableOrUnknown(data['batch_index']!, _batchIndexMeta),
      );
    }
    if (data.containsKey('batch_total')) {
      context.handle(
        _batchTotalMeta,
        batchTotal.isAcceptableOrUnknown(data['batch_total']!, _batchTotalMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtractionJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionJobRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceConversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation_id'],
      )!,
      sourceRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_revision'],
      )!,
      completedChunkCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_chunk_count'],
      )!,
      totalChunks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_chunks'],
      )!,
      candidatesFound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}candidates_found'],
      )!,
      startTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_time_ms'],
      )!,
      chunkTimingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_timings_json'],
      )!,
      progressTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_title'],
      )!,
      progressBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_body'],
      )!,
      completionTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_title'],
      )!,
      queuedSourceConversationIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}queued_source_conversation_ids_json'],
      )!,
      batchIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_index'],
      )!,
      batchTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_total'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExtractionJobsTable createAlias(String alias) {
    return $ExtractionJobsTable(attachedDatabase, alias);
  }
}

class ExtractionJobRow extends DataClass
    implements Insertable<ExtractionJobRow> {
  final String id;
  final String sourceConversationId;
  final int sourceRevision;
  final int completedChunkCount;
  final int totalChunks;
  final int candidatesFound;
  final int startTimeMs;
  final String chunkTimingsJson;
  final String progressTitle;
  final String progressBody;
  final String completionTitle;
  final String queuedSourceConversationIdsJson;
  final int batchIndex;
  final int batchTotal;
  final int createdAt;
  final int updatedAt;
  const ExtractionJobRow({
    required this.id,
    required this.sourceConversationId,
    required this.sourceRevision,
    required this.completedChunkCount,
    required this.totalChunks,
    required this.candidatesFound,
    required this.startTimeMs,
    required this.chunkTimingsJson,
    required this.progressTitle,
    required this.progressBody,
    required this.completionTitle,
    required this.queuedSourceConversationIdsJson,
    required this.batchIndex,
    required this.batchTotal,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_conversation_id'] = Variable<String>(sourceConversationId);
    map['source_revision'] = Variable<int>(sourceRevision);
    map['completed_chunk_count'] = Variable<int>(completedChunkCount);
    map['total_chunks'] = Variable<int>(totalChunks);
    map['candidates_found'] = Variable<int>(candidatesFound);
    map['start_time_ms'] = Variable<int>(startTimeMs);
    map['chunk_timings_json'] = Variable<String>(chunkTimingsJson);
    map['progress_title'] = Variable<String>(progressTitle);
    map['progress_body'] = Variable<String>(progressBody);
    map['completion_title'] = Variable<String>(completionTitle);
    map['queued_source_conversation_ids_json'] = Variable<String>(
      queuedSourceConversationIdsJson,
    );
    map['batch_index'] = Variable<int>(batchIndex);
    map['batch_total'] = Variable<int>(batchTotal);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExtractionJobsCompanion toCompanion(bool nullToAbsent) {
    return ExtractionJobsCompanion(
      id: Value(id),
      sourceConversationId: Value(sourceConversationId),
      sourceRevision: Value(sourceRevision),
      completedChunkCount: Value(completedChunkCount),
      totalChunks: Value(totalChunks),
      candidatesFound: Value(candidatesFound),
      startTimeMs: Value(startTimeMs),
      chunkTimingsJson: Value(chunkTimingsJson),
      progressTitle: Value(progressTitle),
      progressBody: Value(progressBody),
      completionTitle: Value(completionTitle),
      queuedSourceConversationIdsJson: Value(queuedSourceConversationIdsJson),
      batchIndex: Value(batchIndex),
      batchTotal: Value(batchTotal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExtractionJobRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionJobRow(
      id: serializer.fromJson<String>(json['id']),
      sourceConversationId: serializer.fromJson<String>(
        json['sourceConversationId'],
      ),
      sourceRevision: serializer.fromJson<int>(json['sourceRevision']),
      completedChunkCount: serializer.fromJson<int>(
        json['completedChunkCount'],
      ),
      totalChunks: serializer.fromJson<int>(json['totalChunks']),
      candidatesFound: serializer.fromJson<int>(json['candidatesFound']),
      startTimeMs: serializer.fromJson<int>(json['startTimeMs']),
      chunkTimingsJson: serializer.fromJson<String>(json['chunkTimingsJson']),
      progressTitle: serializer.fromJson<String>(json['progressTitle']),
      progressBody: serializer.fromJson<String>(json['progressBody']),
      completionTitle: serializer.fromJson<String>(json['completionTitle']),
      queuedSourceConversationIdsJson: serializer.fromJson<String>(
        json['queuedSourceConversationIdsJson'],
      ),
      batchIndex: serializer.fromJson<int>(json['batchIndex']),
      batchTotal: serializer.fromJson<int>(json['batchTotal']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceConversationId': serializer.toJson<String>(sourceConversationId),
      'sourceRevision': serializer.toJson<int>(sourceRevision),
      'completedChunkCount': serializer.toJson<int>(completedChunkCount),
      'totalChunks': serializer.toJson<int>(totalChunks),
      'candidatesFound': serializer.toJson<int>(candidatesFound),
      'startTimeMs': serializer.toJson<int>(startTimeMs),
      'chunkTimingsJson': serializer.toJson<String>(chunkTimingsJson),
      'progressTitle': serializer.toJson<String>(progressTitle),
      'progressBody': serializer.toJson<String>(progressBody),
      'completionTitle': serializer.toJson<String>(completionTitle),
      'queuedSourceConversationIdsJson': serializer.toJson<String>(
        queuedSourceConversationIdsJson,
      ),
      'batchIndex': serializer.toJson<int>(batchIndex),
      'batchTotal': serializer.toJson<int>(batchTotal),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ExtractionJobRow copyWith({
    String? id,
    String? sourceConversationId,
    int? sourceRevision,
    int? completedChunkCount,
    int? totalChunks,
    int? candidatesFound,
    int? startTimeMs,
    String? chunkTimingsJson,
    String? progressTitle,
    String? progressBody,
    String? completionTitle,
    String? queuedSourceConversationIdsJson,
    int? batchIndex,
    int? batchTotal,
    int? createdAt,
    int? updatedAt,
  }) => ExtractionJobRow(
    id: id ?? this.id,
    sourceConversationId: sourceConversationId ?? this.sourceConversationId,
    sourceRevision: sourceRevision ?? this.sourceRevision,
    completedChunkCount: completedChunkCount ?? this.completedChunkCount,
    totalChunks: totalChunks ?? this.totalChunks,
    candidatesFound: candidatesFound ?? this.candidatesFound,
    startTimeMs: startTimeMs ?? this.startTimeMs,
    chunkTimingsJson: chunkTimingsJson ?? this.chunkTimingsJson,
    progressTitle: progressTitle ?? this.progressTitle,
    progressBody: progressBody ?? this.progressBody,
    completionTitle: completionTitle ?? this.completionTitle,
    queuedSourceConversationIdsJson:
        queuedSourceConversationIdsJson ?? this.queuedSourceConversationIdsJson,
    batchIndex: batchIndex ?? this.batchIndex,
    batchTotal: batchTotal ?? this.batchTotal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExtractionJobRow copyWithCompanion(ExtractionJobsCompanion data) {
    return ExtractionJobRow(
      id: data.id.present ? data.id.value : this.id,
      sourceConversationId: data.sourceConversationId.present
          ? data.sourceConversationId.value
          : this.sourceConversationId,
      sourceRevision: data.sourceRevision.present
          ? data.sourceRevision.value
          : this.sourceRevision,
      completedChunkCount: data.completedChunkCount.present
          ? data.completedChunkCount.value
          : this.completedChunkCount,
      totalChunks: data.totalChunks.present
          ? data.totalChunks.value
          : this.totalChunks,
      candidatesFound: data.candidatesFound.present
          ? data.candidatesFound.value
          : this.candidatesFound,
      startTimeMs: data.startTimeMs.present
          ? data.startTimeMs.value
          : this.startTimeMs,
      chunkTimingsJson: data.chunkTimingsJson.present
          ? data.chunkTimingsJson.value
          : this.chunkTimingsJson,
      progressTitle: data.progressTitle.present
          ? data.progressTitle.value
          : this.progressTitle,
      progressBody: data.progressBody.present
          ? data.progressBody.value
          : this.progressBody,
      completionTitle: data.completionTitle.present
          ? data.completionTitle.value
          : this.completionTitle,
      queuedSourceConversationIdsJson:
          data.queuedSourceConversationIdsJson.present
          ? data.queuedSourceConversationIdsJson.value
          : this.queuedSourceConversationIdsJson,
      batchIndex: data.batchIndex.present
          ? data.batchIndex.value
          : this.batchIndex,
      batchTotal: data.batchTotal.present
          ? data.batchTotal.value
          : this.batchTotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionJobRow(')
          ..write('id: $id, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('completedChunkCount: $completedChunkCount, ')
          ..write('totalChunks: $totalChunks, ')
          ..write('candidatesFound: $candidatesFound, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('chunkTimingsJson: $chunkTimingsJson, ')
          ..write('progressTitle: $progressTitle, ')
          ..write('progressBody: $progressBody, ')
          ..write('completionTitle: $completionTitle, ')
          ..write(
            'queuedSourceConversationIdsJson: $queuedSourceConversationIdsJson, ',
          )
          ..write('batchIndex: $batchIndex, ')
          ..write('batchTotal: $batchTotal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceConversationId,
    sourceRevision,
    completedChunkCount,
    totalChunks,
    candidatesFound,
    startTimeMs,
    chunkTimingsJson,
    progressTitle,
    progressBody,
    completionTitle,
    queuedSourceConversationIdsJson,
    batchIndex,
    batchTotal,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionJobRow &&
          other.id == this.id &&
          other.sourceConversationId == this.sourceConversationId &&
          other.sourceRevision == this.sourceRevision &&
          other.completedChunkCount == this.completedChunkCount &&
          other.totalChunks == this.totalChunks &&
          other.candidatesFound == this.candidatesFound &&
          other.startTimeMs == this.startTimeMs &&
          other.chunkTimingsJson == this.chunkTimingsJson &&
          other.progressTitle == this.progressTitle &&
          other.progressBody == this.progressBody &&
          other.completionTitle == this.completionTitle &&
          other.queuedSourceConversationIdsJson ==
              this.queuedSourceConversationIdsJson &&
          other.batchIndex == this.batchIndex &&
          other.batchTotal == this.batchTotal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExtractionJobsCompanion extends UpdateCompanion<ExtractionJobRow> {
  final Value<String> id;
  final Value<String> sourceConversationId;
  final Value<int> sourceRevision;
  final Value<int> completedChunkCount;
  final Value<int> totalChunks;
  final Value<int> candidatesFound;
  final Value<int> startTimeMs;
  final Value<String> chunkTimingsJson;
  final Value<String> progressTitle;
  final Value<String> progressBody;
  final Value<String> completionTitle;
  final Value<String> queuedSourceConversationIdsJson;
  final Value<int> batchIndex;
  final Value<int> batchTotal;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExtractionJobsCompanion({
    this.id = const Value.absent(),
    this.sourceConversationId = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.completedChunkCount = const Value.absent(),
    this.totalChunks = const Value.absent(),
    this.candidatesFound = const Value.absent(),
    this.startTimeMs = const Value.absent(),
    this.chunkTimingsJson = const Value.absent(),
    this.progressTitle = const Value.absent(),
    this.progressBody = const Value.absent(),
    this.completionTitle = const Value.absent(),
    this.queuedSourceConversationIdsJson = const Value.absent(),
    this.batchIndex = const Value.absent(),
    this.batchTotal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtractionJobsCompanion.insert({
    required String id,
    required String sourceConversationId,
    this.sourceRevision = const Value.absent(),
    this.completedChunkCount = const Value.absent(),
    this.totalChunks = const Value.absent(),
    this.candidatesFound = const Value.absent(),
    required int startTimeMs,
    this.chunkTimingsJson = const Value.absent(),
    this.progressTitle = const Value.absent(),
    this.progressBody = const Value.absent(),
    this.completionTitle = const Value.absent(),
    this.queuedSourceConversationIdsJson = const Value.absent(),
    this.batchIndex = const Value.absent(),
    this.batchTotal = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceConversationId = Value(sourceConversationId),
       startTimeMs = Value(startTimeMs),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExtractionJobRow> custom({
    Expression<String>? id,
    Expression<String>? sourceConversationId,
    Expression<int>? sourceRevision,
    Expression<int>? completedChunkCount,
    Expression<int>? totalChunks,
    Expression<int>? candidatesFound,
    Expression<int>? startTimeMs,
    Expression<String>? chunkTimingsJson,
    Expression<String>? progressTitle,
    Expression<String>? progressBody,
    Expression<String>? completionTitle,
    Expression<String>? queuedSourceConversationIdsJson,
    Expression<int>? batchIndex,
    Expression<int>? batchTotal,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceConversationId != null)
        'source_conversation_id': sourceConversationId,
      if (sourceRevision != null) 'source_revision': sourceRevision,
      if (completedChunkCount != null)
        'completed_chunk_count': completedChunkCount,
      if (totalChunks != null) 'total_chunks': totalChunks,
      if (candidatesFound != null) 'candidates_found': candidatesFound,
      if (startTimeMs != null) 'start_time_ms': startTimeMs,
      if (chunkTimingsJson != null) 'chunk_timings_json': chunkTimingsJson,
      if (progressTitle != null) 'progress_title': progressTitle,
      if (progressBody != null) 'progress_body': progressBody,
      if (completionTitle != null) 'completion_title': completionTitle,
      if (queuedSourceConversationIdsJson != null)
        'queued_source_conversation_ids_json': queuedSourceConversationIdsJson,
      if (batchIndex != null) 'batch_index': batchIndex,
      if (batchTotal != null) 'batch_total': batchTotal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtractionJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceConversationId,
    Value<int>? sourceRevision,
    Value<int>? completedChunkCount,
    Value<int>? totalChunks,
    Value<int>? candidatesFound,
    Value<int>? startTimeMs,
    Value<String>? chunkTimingsJson,
    Value<String>? progressTitle,
    Value<String>? progressBody,
    Value<String>? completionTitle,
    Value<String>? queuedSourceConversationIdsJson,
    Value<int>? batchIndex,
    Value<int>? batchTotal,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExtractionJobsCompanion(
      id: id ?? this.id,
      sourceConversationId: sourceConversationId ?? this.sourceConversationId,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      completedChunkCount: completedChunkCount ?? this.completedChunkCount,
      totalChunks: totalChunks ?? this.totalChunks,
      candidatesFound: candidatesFound ?? this.candidatesFound,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      chunkTimingsJson: chunkTimingsJson ?? this.chunkTimingsJson,
      progressTitle: progressTitle ?? this.progressTitle,
      progressBody: progressBody ?? this.progressBody,
      completionTitle: completionTitle ?? this.completionTitle,
      queuedSourceConversationIdsJson:
          queuedSourceConversationIdsJson ??
          this.queuedSourceConversationIdsJson,
      batchIndex: batchIndex ?? this.batchIndex,
      batchTotal: batchTotal ?? this.batchTotal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceConversationId.present) {
      map['source_conversation_id'] = Variable<String>(
        sourceConversationId.value,
      );
    }
    if (sourceRevision.present) {
      map['source_revision'] = Variable<int>(sourceRevision.value);
    }
    if (completedChunkCount.present) {
      map['completed_chunk_count'] = Variable<int>(completedChunkCount.value);
    }
    if (totalChunks.present) {
      map['total_chunks'] = Variable<int>(totalChunks.value);
    }
    if (candidatesFound.present) {
      map['candidates_found'] = Variable<int>(candidatesFound.value);
    }
    if (startTimeMs.present) {
      map['start_time_ms'] = Variable<int>(startTimeMs.value);
    }
    if (chunkTimingsJson.present) {
      map['chunk_timings_json'] = Variable<String>(chunkTimingsJson.value);
    }
    if (progressTitle.present) {
      map['progress_title'] = Variable<String>(progressTitle.value);
    }
    if (progressBody.present) {
      map['progress_body'] = Variable<String>(progressBody.value);
    }
    if (completionTitle.present) {
      map['completion_title'] = Variable<String>(completionTitle.value);
    }
    if (queuedSourceConversationIdsJson.present) {
      map['queued_source_conversation_ids_json'] = Variable<String>(
        queuedSourceConversationIdsJson.value,
      );
    }
    if (batchIndex.present) {
      map['batch_index'] = Variable<int>(batchIndex.value);
    }
    if (batchTotal.present) {
      map['batch_total'] = Variable<int>(batchTotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionJobsCompanion(')
          ..write('id: $id, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('completedChunkCount: $completedChunkCount, ')
          ..write('totalChunks: $totalChunks, ')
          ..write('candidatesFound: $candidatesFound, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('chunkTimingsJson: $chunkTimingsJson, ')
          ..write('progressTitle: $progressTitle, ')
          ..write('progressBody: $progressBody, ')
          ..write('completionTitle: $completionTitle, ')
          ..write(
            'queuedSourceConversationIdsJson: $queuedSourceConversationIdsJson, ',
          )
          ..write('batchIndex: $batchIndex, ')
          ..write('batchTotal: $batchTotal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtractionRunsTable extends ExtractionRuns
    with TableInfo<$ExtractionRunsTable, ExtractionRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtractionRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConversationIdMeta =
      const VerificationMeta('sourceConversationId');
  @override
  late final GeneratedColumn<String> sourceConversationId =
      GeneratedColumn<String>(
        'source_conversation_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceConversationTitleMeta =
      const VerificationMeta('sourceConversationTitle');
  @override
  late final GeneratedColumn<String> sourceConversationTitle =
      GeneratedColumn<String>(
        'source_conversation_title',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelDisplayNameMeta = const VerificationMeta(
    'modelDisplayName',
  );
  @override
  late final GeneratedColumn<String> modelDisplayName = GeneratedColumn<String>(
    'model_display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledKindSlugsJsonMeta =
      const VerificationMeta('enabledKindSlugsJson');
  @override
  late final GeneratedColumn<String> enabledKindSlugsJson =
      GeneratedColumn<String>(
        'enabled_kind_slugs_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('["decision","commitment"]'),
      );
  static const VerificationMeta _kindCountsJsonMeta = const VerificationMeta(
    'kindCountsJson',
  );
  @override
  late final GeneratedColumn<String> kindCountsJson = GeneratedColumn<String>(
    'kind_counts_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _acceptedCountMeta = const VerificationMeta(
    'acceptedCount',
  );
  @override
  late final GeneratedColumn<int> acceptedCount = GeneratedColumn<int>(
    'accepted_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rejectedCountMeta = const VerificationMeta(
    'rejectedCount',
  );
  @override
  late final GeneratedColumn<int> rejectedCount = GeneratedColumn<int>(
    'rejected_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingCountMeta = const VerificationMeta(
    'pendingCount',
  );
  @override
  late final GeneratedColumn<int> pendingCount = GeneratedColumn<int>(
    'pending_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sourceConversationId,
    sourceConversationTitle,
    modelId,
    modelDisplayName,
    startedAt,
    completedAt,
    status,
    durationMs,
    enabledKindSlugsJson,
    kindCountsJson,
    acceptedCount,
    rejectedCount,
    pendingCount,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_conversation_id')) {
      context.handle(
        _sourceConversationIdMeta,
        sourceConversationId.isAcceptableOrUnknown(
          data['source_conversation_id']!,
          _sourceConversationIdMeta,
        ),
      );
    }
    if (data.containsKey('source_conversation_title')) {
      context.handle(
        _sourceConversationTitleMeta,
        sourceConversationTitle.isAcceptableOrUnknown(
          data['source_conversation_title']!,
          _sourceConversationTitleMeta,
        ),
      );
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('model_display_name')) {
      context.handle(
        _modelDisplayNameMeta,
        modelDisplayName.isAcceptableOrUnknown(
          data['model_display_name']!,
          _modelDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('enabled_kind_slugs_json')) {
      context.handle(
        _enabledKindSlugsJsonMeta,
        enabledKindSlugsJson.isAcceptableOrUnknown(
          data['enabled_kind_slugs_json']!,
          _enabledKindSlugsJsonMeta,
        ),
      );
    }
    if (data.containsKey('kind_counts_json')) {
      context.handle(
        _kindCountsJsonMeta,
        kindCountsJson.isAcceptableOrUnknown(
          data['kind_counts_json']!,
          _kindCountsJsonMeta,
        ),
      );
    }
    if (data.containsKey('accepted_count')) {
      context.handle(
        _acceptedCountMeta,
        acceptedCount.isAcceptableOrUnknown(
          data['accepted_count']!,
          _acceptedCountMeta,
        ),
      );
    }
    if (data.containsKey('rejected_count')) {
      context.handle(
        _rejectedCountMeta,
        rejectedCount.isAcceptableOrUnknown(
          data['rejected_count']!,
          _rejectedCountMeta,
        ),
      );
    }
    if (data.containsKey('pending_count')) {
      context.handle(
        _pendingCountMeta,
        pendingCount.isAcceptableOrUnknown(
          data['pending_count']!,
          _pendingCountMeta,
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtractionRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionRunRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceConversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation_id'],
      ),
      sourceConversationTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_conversation_title'],
      ),
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      modelDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_display_name'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      enabledKindSlugsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enabled_kind_slugs_json'],
      )!,
      kindCountsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_counts_json'],
      )!,
      acceptedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accepted_count'],
      )!,
      rejectedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rejected_count'],
      )!,
      pendingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ExtractionRunsTable createAlias(String alias) {
    return $ExtractionRunsTable(attachedDatabase, alias);
  }
}

class ExtractionRunRow extends DataClass
    implements Insertable<ExtractionRunRow> {
  final String id;
  final String userId;
  final String? sourceConversationId;
  final String? sourceConversationTitle;
  final String modelId;
  final String? modelDisplayName;
  final int startedAt;
  final int completedAt;
  final String status;
  final int durationMs;
  final String enabledKindSlugsJson;
  final String kindCountsJson;
  final int acceptedCount;
  final int rejectedCount;
  final int pendingCount;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const ExtractionRunRow({
    required this.id,
    required this.userId,
    this.sourceConversationId,
    this.sourceConversationTitle,
    required this.modelId,
    this.modelDisplayName,
    required this.startedAt,
    required this.completedAt,
    required this.status,
    required this.durationMs,
    required this.enabledKindSlugsJson,
    required this.kindCountsJson,
    required this.acceptedCount,
    required this.rejectedCount,
    required this.pendingCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || sourceConversationId != null) {
      map['source_conversation_id'] = Variable<String>(sourceConversationId);
    }
    if (!nullToAbsent || sourceConversationTitle != null) {
      map['source_conversation_title'] = Variable<String>(
        sourceConversationTitle,
      );
    }
    map['model_id'] = Variable<String>(modelId);
    if (!nullToAbsent || modelDisplayName != null) {
      map['model_display_name'] = Variable<String>(modelDisplayName);
    }
    map['started_at'] = Variable<int>(startedAt);
    map['completed_at'] = Variable<int>(completedAt);
    map['status'] = Variable<String>(status);
    map['duration_ms'] = Variable<int>(durationMs);
    map['enabled_kind_slugs_json'] = Variable<String>(enabledKindSlugsJson);
    map['kind_counts_json'] = Variable<String>(kindCountsJson);
    map['accepted_count'] = Variable<int>(acceptedCount);
    map['rejected_count'] = Variable<int>(rejectedCount);
    map['pending_count'] = Variable<int>(pendingCount);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ExtractionRunsCompanion toCompanion(bool nullToAbsent) {
    return ExtractionRunsCompanion(
      id: Value(id),
      userId: Value(userId),
      sourceConversationId: sourceConversationId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceConversationId),
      sourceConversationTitle: sourceConversationTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceConversationTitle),
      modelId: Value(modelId),
      modelDisplayName: modelDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(modelDisplayName),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      status: Value(status),
      durationMs: Value(durationMs),
      enabledKindSlugsJson: Value(enabledKindSlugsJson),
      kindCountsJson: Value(kindCountsJson),
      acceptedCount: Value(acceptedCount),
      rejectedCount: Value(rejectedCount),
      pendingCount: Value(pendingCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory ExtractionRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionRunRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceConversationId: serializer.fromJson<String?>(
        json['sourceConversationId'],
      ),
      sourceConversationTitle: serializer.fromJson<String?>(
        json['sourceConversationTitle'],
      ),
      modelId: serializer.fromJson<String>(json['modelId']),
      modelDisplayName: serializer.fromJson<String?>(json['modelDisplayName']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      completedAt: serializer.fromJson<int>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      enabledKindSlugsJson: serializer.fromJson<String>(
        json['enabledKindSlugsJson'],
      ),
      kindCountsJson: serializer.fromJson<String>(json['kindCountsJson']),
      acceptedCount: serializer.fromJson<int>(json['acceptedCount']),
      rejectedCount: serializer.fromJson<int>(json['rejectedCount']),
      pendingCount: serializer.fromJson<int>(json['pendingCount']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sourceConversationId': serializer.toJson<String?>(sourceConversationId),
      'sourceConversationTitle': serializer.toJson<String?>(
        sourceConversationTitle,
      ),
      'modelId': serializer.toJson<String>(modelId),
      'modelDisplayName': serializer.toJson<String?>(modelDisplayName),
      'startedAt': serializer.toJson<int>(startedAt),
      'completedAt': serializer.toJson<int>(completedAt),
      'status': serializer.toJson<String>(status),
      'durationMs': serializer.toJson<int>(durationMs),
      'enabledKindSlugsJson': serializer.toJson<String>(enabledKindSlugsJson),
      'kindCountsJson': serializer.toJson<String>(kindCountsJson),
      'acceptedCount': serializer.toJson<int>(acceptedCount),
      'rejectedCount': serializer.toJson<int>(rejectedCount),
      'pendingCount': serializer.toJson<int>(pendingCount),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  ExtractionRunRow copyWith({
    String? id,
    String? userId,
    Value<String?> sourceConversationId = const Value.absent(),
    Value<String?> sourceConversationTitle = const Value.absent(),
    String? modelId,
    Value<String?> modelDisplayName = const Value.absent(),
    int? startedAt,
    int? completedAt,
    String? status,
    int? durationMs,
    String? enabledKindSlugsJson,
    String? kindCountsJson,
    int? acceptedCount,
    int? rejectedCount,
    int? pendingCount,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => ExtractionRunRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sourceConversationId: sourceConversationId.present
        ? sourceConversationId.value
        : this.sourceConversationId,
    sourceConversationTitle: sourceConversationTitle.present
        ? sourceConversationTitle.value
        : this.sourceConversationTitle,
    modelId: modelId ?? this.modelId,
    modelDisplayName: modelDisplayName.present
        ? modelDisplayName.value
        : this.modelDisplayName,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    status: status ?? this.status,
    durationMs: durationMs ?? this.durationMs,
    enabledKindSlugsJson: enabledKindSlugsJson ?? this.enabledKindSlugsJson,
    kindCountsJson: kindCountsJson ?? this.kindCountsJson,
    acceptedCount: acceptedCount ?? this.acceptedCount,
    rejectedCount: rejectedCount ?? this.rejectedCount,
    pendingCount: pendingCount ?? this.pendingCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ExtractionRunRow copyWithCompanion(ExtractionRunsCompanion data) {
    return ExtractionRunRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceConversationId: data.sourceConversationId.present
          ? data.sourceConversationId.value
          : this.sourceConversationId,
      sourceConversationTitle: data.sourceConversationTitle.present
          ? data.sourceConversationTitle.value
          : this.sourceConversationTitle,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      modelDisplayName: data.modelDisplayName.present
          ? data.modelDisplayName.value
          : this.modelDisplayName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      enabledKindSlugsJson: data.enabledKindSlugsJson.present
          ? data.enabledKindSlugsJson.value
          : this.enabledKindSlugsJson,
      kindCountsJson: data.kindCountsJson.present
          ? data.kindCountsJson.value
          : this.kindCountsJson,
      acceptedCount: data.acceptedCount.present
          ? data.acceptedCount.value
          : this.acceptedCount,
      rejectedCount: data.rejectedCount.present
          ? data.rejectedCount.value
          : this.rejectedCount,
      pendingCount: data.pendingCount.present
          ? data.pendingCount.value
          : this.pendingCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionRunRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceConversationTitle: $sourceConversationTitle, ')
          ..write('modelId: $modelId, ')
          ..write('modelDisplayName: $modelDisplayName, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('durationMs: $durationMs, ')
          ..write('enabledKindSlugsJson: $enabledKindSlugsJson, ')
          ..write('kindCountsJson: $kindCountsJson, ')
          ..write('acceptedCount: $acceptedCount, ')
          ..write('rejectedCount: $rejectedCount, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sourceConversationId,
    sourceConversationTitle,
    modelId,
    modelDisplayName,
    startedAt,
    completedAt,
    status,
    durationMs,
    enabledKindSlugsJson,
    kindCountsJson,
    acceptedCount,
    rejectedCount,
    pendingCount,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionRunRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sourceConversationId == this.sourceConversationId &&
          other.sourceConversationTitle == this.sourceConversationTitle &&
          other.modelId == this.modelId &&
          other.modelDisplayName == this.modelDisplayName &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.status == this.status &&
          other.durationMs == this.durationMs &&
          other.enabledKindSlugsJson == this.enabledKindSlugsJson &&
          other.kindCountsJson == this.kindCountsJson &&
          other.acceptedCount == this.acceptedCount &&
          other.rejectedCount == this.rejectedCount &&
          other.pendingCount == this.pendingCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class ExtractionRunsCompanion extends UpdateCompanion<ExtractionRunRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> sourceConversationId;
  final Value<String?> sourceConversationTitle;
  final Value<String> modelId;
  final Value<String?> modelDisplayName;
  final Value<int> startedAt;
  final Value<int> completedAt;
  final Value<String> status;
  final Value<int> durationMs;
  final Value<String> enabledKindSlugsJson;
  final Value<String> kindCountsJson;
  final Value<int> acceptedCount;
  final Value<int> rejectedCount;
  final Value<int> pendingCount;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ExtractionRunsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceConversationId = const Value.absent(),
    this.sourceConversationTitle = const Value.absent(),
    this.modelId = const Value.absent(),
    this.modelDisplayName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.enabledKindSlugsJson = const Value.absent(),
    this.kindCountsJson = const Value.absent(),
    this.acceptedCount = const Value.absent(),
    this.rejectedCount = const Value.absent(),
    this.pendingCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtractionRunsCompanion.insert({
    required String id,
    required String userId,
    this.sourceConversationId = const Value.absent(),
    this.sourceConversationTitle = const Value.absent(),
    required String modelId,
    this.modelDisplayName = const Value.absent(),
    required int startedAt,
    required int completedAt,
    required String status,
    required int durationMs,
    this.enabledKindSlugsJson = const Value.absent(),
    this.kindCountsJson = const Value.absent(),
    this.acceptedCount = const Value.absent(),
    this.rejectedCount = const Value.absent(),
    this.pendingCount = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       modelId = Value(modelId),
       startedAt = Value(startedAt),
       completedAt = Value(completedAt),
       status = Value(status),
       durationMs = Value(durationMs),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExtractionRunRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sourceConversationId,
    Expression<String>? sourceConversationTitle,
    Expression<String>? modelId,
    Expression<String>? modelDisplayName,
    Expression<int>? startedAt,
    Expression<int>? completedAt,
    Expression<String>? status,
    Expression<int>? durationMs,
    Expression<String>? enabledKindSlugsJson,
    Expression<String>? kindCountsJson,
    Expression<int>? acceptedCount,
    Expression<int>? rejectedCount,
    Expression<int>? pendingCount,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sourceConversationId != null)
        'source_conversation_id': sourceConversationId,
      if (sourceConversationTitle != null)
        'source_conversation_title': sourceConversationTitle,
      if (modelId != null) 'model_id': modelId,
      if (modelDisplayName != null) 'model_display_name': modelDisplayName,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
      if (durationMs != null) 'duration_ms': durationMs,
      if (enabledKindSlugsJson != null)
        'enabled_kind_slugs_json': enabledKindSlugsJson,
      if (kindCountsJson != null) 'kind_counts_json': kindCountsJson,
      if (acceptedCount != null) 'accepted_count': acceptedCount,
      if (rejectedCount != null) 'rejected_count': rejectedCount,
      if (pendingCount != null) 'pending_count': pendingCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtractionRunsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? sourceConversationId,
    Value<String?>? sourceConversationTitle,
    Value<String>? modelId,
    Value<String?>? modelDisplayName,
    Value<int>? startedAt,
    Value<int>? completedAt,
    Value<String>? status,
    Value<int>? durationMs,
    Value<String>? enabledKindSlugsJson,
    Value<String>? kindCountsJson,
    Value<int>? acceptedCount,
    Value<int>? rejectedCount,
    Value<int>? pendingCount,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ExtractionRunsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceConversationId: sourceConversationId ?? this.sourceConversationId,
      sourceConversationTitle:
          sourceConversationTitle ?? this.sourceConversationTitle,
      modelId: modelId ?? this.modelId,
      modelDisplayName: modelDisplayName ?? this.modelDisplayName,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      durationMs: durationMs ?? this.durationMs,
      enabledKindSlugsJson: enabledKindSlugsJson ?? this.enabledKindSlugsJson,
      kindCountsJson: kindCountsJson ?? this.kindCountsJson,
      acceptedCount: acceptedCount ?? this.acceptedCount,
      rejectedCount: rejectedCount ?? this.rejectedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceConversationId.present) {
      map['source_conversation_id'] = Variable<String>(
        sourceConversationId.value,
      );
    }
    if (sourceConversationTitle.present) {
      map['source_conversation_title'] = Variable<String>(
        sourceConversationTitle.value,
      );
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (modelDisplayName.present) {
      map['model_display_name'] = Variable<String>(modelDisplayName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (enabledKindSlugsJson.present) {
      map['enabled_kind_slugs_json'] = Variable<String>(
        enabledKindSlugsJson.value,
      );
    }
    if (kindCountsJson.present) {
      map['kind_counts_json'] = Variable<String>(kindCountsJson.value);
    }
    if (acceptedCount.present) {
      map['accepted_count'] = Variable<int>(acceptedCount.value);
    }
    if (rejectedCount.present) {
      map['rejected_count'] = Variable<int>(rejectedCount.value);
    }
    if (pendingCount.present) {
      map['pending_count'] = Variable<int>(pendingCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionRunsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceConversationId: $sourceConversationId, ')
          ..write('sourceConversationTitle: $sourceConversationTitle, ')
          ..write('modelId: $modelId, ')
          ..write('modelDisplayName: $modelDisplayName, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('durationMs: $durationMs, ')
          ..write('enabledKindSlugsJson: $enabledKindSlugsJson, ')
          ..write('kindCountsJson: $kindCountsJson, ')
          ..write('acceptedCount: $acceptedCount, ')
          ..write('rejectedCount: $rejectedCount, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtractionItemKindsTable extends ExtractionItemKinds
    with TableInfo<$ExtractionItemKindsTable, ExtractionItemKindRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtractionItemKindsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractionHintMeta = const VerificationMeta(
    'extractionHint',
  );
  @override
  late final GeneratedColumn<String> extractionHint = GeneratedColumn<String>(
    'extraction_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _behaviorMeta = const VerificationMeta(
    'behavior',
  );
  @override
  late final GeneratedColumn<String> behavior = GeneratedColumn<String>(
    'behavior',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePolicyMeta = const VerificationMeta(
    'datePolicy',
  );
  @override
  late final GeneratedColumn<String> datePolicy = GeneratedColumn<String>(
    'date_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notePolicyMeta = const VerificationMeta(
    'notePolicy',
  );
  @override
  late final GeneratedColumn<String> notePolicy = GeneratedColumn<String>(
    'note_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerPolicyMeta = const VerificationMeta(
    'ownerPolicy',
  );
  @override
  late final GeneratedColumn<String> ownerPolicy = GeneratedColumn<String>(
    'owner_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledForExtractionMeta =
      const VerificationMeta('enabledForExtraction');
  @override
  late final GeneratedColumn<bool> enabledForExtraction = GeneratedColumn<bool>(
    'enabled_for_extraction',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled_for_extraction" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _teachingExamplesJsonMeta =
      const VerificationMeta('teachingExamplesJson');
  @override
  late final GeneratedColumn<String> teachingExamplesJson =
      GeneratedColumn<String>(
        'teaching_examples_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    slug,
    displayName,
    extractionHint,
    behavior,
    datePolicy,
    notePolicy,
    ownerPolicy,
    enabledForExtraction,
    isBuiltIn,
    sortOrder,
    teachingExamplesJson,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction_item_kinds';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionItemKindRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('extraction_hint')) {
      context.handle(
        _extractionHintMeta,
        extractionHint.isAcceptableOrUnknown(
          data['extraction_hint']!,
          _extractionHintMeta,
        ),
      );
    }
    if (data.containsKey('behavior')) {
      context.handle(
        _behaviorMeta,
        behavior.isAcceptableOrUnknown(data['behavior']!, _behaviorMeta),
      );
    } else if (isInserting) {
      context.missing(_behaviorMeta);
    }
    if (data.containsKey('date_policy')) {
      context.handle(
        _datePolicyMeta,
        datePolicy.isAcceptableOrUnknown(data['date_policy']!, _datePolicyMeta),
      );
    } else if (isInserting) {
      context.missing(_datePolicyMeta);
    }
    if (data.containsKey('note_policy')) {
      context.handle(
        _notePolicyMeta,
        notePolicy.isAcceptableOrUnknown(data['note_policy']!, _notePolicyMeta),
      );
    } else if (isInserting) {
      context.missing(_notePolicyMeta);
    }
    if (data.containsKey('owner_policy')) {
      context.handle(
        _ownerPolicyMeta,
        ownerPolicy.isAcceptableOrUnknown(
          data['owner_policy']!,
          _ownerPolicyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerPolicyMeta);
    }
    if (data.containsKey('enabled_for_extraction')) {
      context.handle(
        _enabledForExtractionMeta,
        enabledForExtraction.isAcceptableOrUnknown(
          data['enabled_for_extraction']!,
          _enabledForExtractionMeta,
        ),
      );
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('teaching_examples_json')) {
      context.handle(
        _teachingExamplesJsonMeta,
        teachingExamplesJson.isAcceptableOrUnknown(
          data['teaching_examples_json']!,
          _teachingExamplesJsonMeta,
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtractionItemKindRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionItemKindRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      extractionHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_hint'],
      ),
      behavior: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}behavior'],
      )!,
      datePolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_policy'],
      )!,
      notePolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_policy'],
      )!,
      ownerPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_policy'],
      )!,
      enabledForExtraction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled_for_extraction'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      teachingExamplesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teaching_examples_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ExtractionItemKindsTable createAlias(String alias) {
    return $ExtractionItemKindsTable(attachedDatabase, alias);
  }
}

class ExtractionItemKindRow extends DataClass
    implements Insertable<ExtractionItemKindRow> {
  final String id;
  final String userId;
  final String slug;
  final String displayName;
  final String? extractionHint;
  final String behavior;
  final String datePolicy;
  final String notePolicy;
  final String ownerPolicy;
  final bool enabledForExtraction;
  final bool isBuiltIn;
  final int sortOrder;
  final String? teachingExamplesJson;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int syncStatus;
  const ExtractionItemKindRow({
    required this.id,
    required this.userId,
    required this.slug,
    required this.displayName,
    this.extractionHint,
    required this.behavior,
    required this.datePolicy,
    required this.notePolicy,
    required this.ownerPolicy,
    required this.enabledForExtraction,
    required this.isBuiltIn,
    required this.sortOrder,
    this.teachingExamplesJson,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['slug'] = Variable<String>(slug);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || extractionHint != null) {
      map['extraction_hint'] = Variable<String>(extractionHint);
    }
    map['behavior'] = Variable<String>(behavior);
    map['date_policy'] = Variable<String>(datePolicy);
    map['note_policy'] = Variable<String>(notePolicy);
    map['owner_policy'] = Variable<String>(ownerPolicy);
    map['enabled_for_extraction'] = Variable<bool>(enabledForExtraction);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || teachingExamplesJson != null) {
      map['teaching_examples_json'] = Variable<String>(teachingExamplesJson);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ExtractionItemKindsCompanion toCompanion(bool nullToAbsent) {
    return ExtractionItemKindsCompanion(
      id: Value(id),
      userId: Value(userId),
      slug: Value(slug),
      displayName: Value(displayName),
      extractionHint: extractionHint == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionHint),
      behavior: Value(behavior),
      datePolicy: Value(datePolicy),
      notePolicy: Value(notePolicy),
      ownerPolicy: Value(ownerPolicy),
      enabledForExtraction: Value(enabledForExtraction),
      isBuiltIn: Value(isBuiltIn),
      sortOrder: Value(sortOrder),
      teachingExamplesJson: teachingExamplesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(teachingExamplesJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
    );
  }

  factory ExtractionItemKindRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionItemKindRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      slug: serializer.fromJson<String>(json['slug']),
      displayName: serializer.fromJson<String>(json['displayName']),
      extractionHint: serializer.fromJson<String?>(json['extractionHint']),
      behavior: serializer.fromJson<String>(json['behavior']),
      datePolicy: serializer.fromJson<String>(json['datePolicy']),
      notePolicy: serializer.fromJson<String>(json['notePolicy']),
      ownerPolicy: serializer.fromJson<String>(json['ownerPolicy']),
      enabledForExtraction: serializer.fromJson<bool>(
        json['enabledForExtraction'],
      ),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      teachingExamplesJson: serializer.fromJson<String?>(
        json['teachingExamplesJson'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'slug': serializer.toJson<String>(slug),
      'displayName': serializer.toJson<String>(displayName),
      'extractionHint': serializer.toJson<String?>(extractionHint),
      'behavior': serializer.toJson<String>(behavior),
      'datePolicy': serializer.toJson<String>(datePolicy),
      'notePolicy': serializer.toJson<String>(notePolicy),
      'ownerPolicy': serializer.toJson<String>(ownerPolicy),
      'enabledForExtraction': serializer.toJson<bool>(enabledForExtraction),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'teachingExamplesJson': serializer.toJson<String?>(teachingExamplesJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  ExtractionItemKindRow copyWith({
    String? id,
    String? userId,
    String? slug,
    String? displayName,
    Value<String?> extractionHint = const Value.absent(),
    String? behavior,
    String? datePolicy,
    String? notePolicy,
    String? ownerPolicy,
    bool? enabledForExtraction,
    bool? isBuiltIn,
    int? sortOrder,
    Value<String?> teachingExamplesJson = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? syncStatus,
  }) => ExtractionItemKindRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    slug: slug ?? this.slug,
    displayName: displayName ?? this.displayName,
    extractionHint: extractionHint.present
        ? extractionHint.value
        : this.extractionHint,
    behavior: behavior ?? this.behavior,
    datePolicy: datePolicy ?? this.datePolicy,
    notePolicy: notePolicy ?? this.notePolicy,
    ownerPolicy: ownerPolicy ?? this.ownerPolicy,
    enabledForExtraction: enabledForExtraction ?? this.enabledForExtraction,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    sortOrder: sortOrder ?? this.sortOrder,
    teachingExamplesJson: teachingExamplesJson.present
        ? teachingExamplesJson.value
        : this.teachingExamplesJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ExtractionItemKindRow copyWithCompanion(ExtractionItemKindsCompanion data) {
    return ExtractionItemKindRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      slug: data.slug.present ? data.slug.value : this.slug,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      extractionHint: data.extractionHint.present
          ? data.extractionHint.value
          : this.extractionHint,
      behavior: data.behavior.present ? data.behavior.value : this.behavior,
      datePolicy: data.datePolicy.present
          ? data.datePolicy.value
          : this.datePolicy,
      notePolicy: data.notePolicy.present
          ? data.notePolicy.value
          : this.notePolicy,
      ownerPolicy: data.ownerPolicy.present
          ? data.ownerPolicy.value
          : this.ownerPolicy,
      enabledForExtraction: data.enabledForExtraction.present
          ? data.enabledForExtraction.value
          : this.enabledForExtraction,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      teachingExamplesJson: data.teachingExamplesJson.present
          ? data.teachingExamplesJson.value
          : this.teachingExamplesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionItemKindRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('extractionHint: $extractionHint, ')
          ..write('behavior: $behavior, ')
          ..write('datePolicy: $datePolicy, ')
          ..write('notePolicy: $notePolicy, ')
          ..write('ownerPolicy: $ownerPolicy, ')
          ..write('enabledForExtraction: $enabledForExtraction, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('teachingExamplesJson: $teachingExamplesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    slug,
    displayName,
    extractionHint,
    behavior,
    datePolicy,
    notePolicy,
    ownerPolicy,
    enabledForExtraction,
    isBuiltIn,
    sortOrder,
    teachingExamplesJson,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionItemKindRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.slug == this.slug &&
          other.displayName == this.displayName &&
          other.extractionHint == this.extractionHint &&
          other.behavior == this.behavior &&
          other.datePolicy == this.datePolicy &&
          other.notePolicy == this.notePolicy &&
          other.ownerPolicy == this.ownerPolicy &&
          other.enabledForExtraction == this.enabledForExtraction &&
          other.isBuiltIn == this.isBuiltIn &&
          other.sortOrder == this.sortOrder &&
          other.teachingExamplesJson == this.teachingExamplesJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus);
}

class ExtractionItemKindsCompanion
    extends UpdateCompanion<ExtractionItemKindRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> slug;
  final Value<String> displayName;
  final Value<String?> extractionHint;
  final Value<String> behavior;
  final Value<String> datePolicy;
  final Value<String> notePolicy;
  final Value<String> ownerPolicy;
  final Value<bool> enabledForExtraction;
  final Value<bool> isBuiltIn;
  final Value<int> sortOrder;
  final Value<String?> teachingExamplesJson;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ExtractionItemKindsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.slug = const Value.absent(),
    this.displayName = const Value.absent(),
    this.extractionHint = const Value.absent(),
    this.behavior = const Value.absent(),
    this.datePolicy = const Value.absent(),
    this.notePolicy = const Value.absent(),
    this.ownerPolicy = const Value.absent(),
    this.enabledForExtraction = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.teachingExamplesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtractionItemKindsCompanion.insert({
    required String id,
    required String userId,
    required String slug,
    required String displayName,
    this.extractionHint = const Value.absent(),
    required String behavior,
    required String datePolicy,
    required String notePolicy,
    required String ownerPolicy,
    this.enabledForExtraction = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.teachingExamplesJson = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       slug = Value(slug),
       displayName = Value(displayName),
       behavior = Value(behavior),
       datePolicy = Value(datePolicy),
       notePolicy = Value(notePolicy),
       ownerPolicy = Value(ownerPolicy),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExtractionItemKindRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? slug,
    Expression<String>? displayName,
    Expression<String>? extractionHint,
    Expression<String>? behavior,
    Expression<String>? datePolicy,
    Expression<String>? notePolicy,
    Expression<String>? ownerPolicy,
    Expression<bool>? enabledForExtraction,
    Expression<bool>? isBuiltIn,
    Expression<int>? sortOrder,
    Expression<String>? teachingExamplesJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (slug != null) 'slug': slug,
      if (displayName != null) 'display_name': displayName,
      if (extractionHint != null) 'extraction_hint': extractionHint,
      if (behavior != null) 'behavior': behavior,
      if (datePolicy != null) 'date_policy': datePolicy,
      if (notePolicy != null) 'note_policy': notePolicy,
      if (ownerPolicy != null) 'owner_policy': ownerPolicy,
      if (enabledForExtraction != null)
        'enabled_for_extraction': enabledForExtraction,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (teachingExamplesJson != null)
        'teaching_examples_json': teachingExamplesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtractionItemKindsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? slug,
    Value<String>? displayName,
    Value<String?>? extractionHint,
    Value<String>? behavior,
    Value<String>? datePolicy,
    Value<String>? notePolicy,
    Value<String>? ownerPolicy,
    Value<bool>? enabledForExtraction,
    Value<bool>? isBuiltIn,
    Value<int>? sortOrder,
    Value<String?>? teachingExamplesJson,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ExtractionItemKindsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      extractionHint: extractionHint ?? this.extractionHint,
      behavior: behavior ?? this.behavior,
      datePolicy: datePolicy ?? this.datePolicy,
      notePolicy: notePolicy ?? this.notePolicy,
      ownerPolicy: ownerPolicy ?? this.ownerPolicy,
      enabledForExtraction: enabledForExtraction ?? this.enabledForExtraction,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      sortOrder: sortOrder ?? this.sortOrder,
      teachingExamplesJson: teachingExamplesJson ?? this.teachingExamplesJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (extractionHint.present) {
      map['extraction_hint'] = Variable<String>(extractionHint.value);
    }
    if (behavior.present) {
      map['behavior'] = Variable<String>(behavior.value);
    }
    if (datePolicy.present) {
      map['date_policy'] = Variable<String>(datePolicy.value);
    }
    if (notePolicy.present) {
      map['note_policy'] = Variable<String>(notePolicy.value);
    }
    if (ownerPolicy.present) {
      map['owner_policy'] = Variable<String>(ownerPolicy.value);
    }
    if (enabledForExtraction.present) {
      map['enabled_for_extraction'] = Variable<bool>(
        enabledForExtraction.value,
      );
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (teachingExamplesJson.present) {
      map['teaching_examples_json'] = Variable<String>(
        teachingExamplesJson.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionItemKindsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('extractionHint: $extractionHint, ')
          ..write('behavior: $behavior, ')
          ..write('datePolicy: $datePolicy, ')
          ..write('notePolicy: $notePolicy, ')
          ..write('ownerPolicy: $ownerPolicy, ')
          ..write('enabledForExtraction: $enabledForExtraction, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('teachingExamplesJson: $teachingExamplesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalUserScopesTable localUserScopes = $LocalUserScopesTable(
    this,
  );
  late final $SourceConversationsTable sourceConversations =
      $SourceConversationsTable(this);
  late final $LedgerItemsTable ledgerItems = $LedgerItemsTable(this);
  late final $EvidenceTable evidence = $EvidenceTable(this);
  late final $ExtractionCandidatesTable extractionCandidates =
      $ExtractionCandidatesTable(this);
  late final $AiProcessingConsentsTable aiProcessingConsents =
      $AiProcessingConsentsTable(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  late final $ChatThreadsTable chatThreads = $ChatThreadsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $ExtractionJobsTable extractionJobs = $ExtractionJobsTable(this);
  late final $ExtractionRunsTable extractionRuns = $ExtractionRunsTable(this);
  late final $ExtractionItemKindsTable extractionItemKinds =
      $ExtractionItemKindsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localUserScopes,
    sourceConversations,
    ledgerItems,
    evidence,
    extractionCandidates,
    aiProcessingConsents,
    userPreferences,
    chatThreads,
    chatMessages,
    extractionJobs,
    extractionRuns,
    extractionItemKinds,
  ];
}

typedef $$LocalUserScopesTableCreateCompanionBuilder =
    LocalUserScopesCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserScopesTableUpdateCompanionBuilder =
    LocalUserScopesCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$LocalUserScopesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserScopesTable> {
  $$LocalUserScopesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserScopesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserScopesTable> {
  $$LocalUserScopesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserScopesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserScopesTable> {
  $$LocalUserScopesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalUserScopesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserScopesTable,
          LocalUserScopeRow,
          $$LocalUserScopesTableFilterComposer,
          $$LocalUserScopesTableOrderingComposer,
          $$LocalUserScopesTableAnnotationComposer,
          $$LocalUserScopesTableCreateCompanionBuilder,
          $$LocalUserScopesTableUpdateCompanionBuilder,
          (
            LocalUserScopeRow,
            BaseReferences<
              _$AppDatabase,
              $LocalUserScopesTable,
              LocalUserScopeRow
            >,
          ),
          LocalUserScopeRow,
          PrefetchHooks Function()
        > {
  $$LocalUserScopesTableTableManager(
    _$AppDatabase db,
    $LocalUserScopesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserScopesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserScopesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserScopesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserScopesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserScopesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalUserScopesTable, LocalUserScopeRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalUserScopesTable,
                    LocalUserScopeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserScopesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserScopesTable,
      LocalUserScopeRow,
      $$LocalUserScopesTableFilterComposer,
      $$LocalUserScopesTableOrderingComposer,
      $$LocalUserScopesTableAnnotationComposer,
      $$LocalUserScopesTableCreateCompanionBuilder,
      $$LocalUserScopesTableUpdateCompanionBuilder,
      (
        LocalUserScopeRow,
        BaseReferences<_$AppDatabase, $LocalUserScopesTable, LocalUserScopeRow>,
      ),
      LocalUserScopeRow,
      PrefetchHooks Function()
    >;
typedef $$SourceConversationsTableCreateCompanionBuilder =
    SourceConversationsCompanion Function({
      required String id,
      required String userId,
      required String content,
      Value<String?> sourceUrl,
      required int sourceRevision,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<bool> isArchived,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$SourceConversationsTableUpdateCompanionBuilder =
    SourceConversationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> content,
      Value<String?> sourceUrl,
      Value<int> sourceRevision,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<bool> isArchived,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$SourceConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceConversationsTable> {
  $$SourceConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceConversationsTable> {
  $$SourceConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceConversationsTable> {
  $$SourceConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$SourceConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceConversationsTable,
          SourceConversationRow,
          $$SourceConversationsTableFilterComposer,
          $$SourceConversationsTableOrderingComposer,
          $$SourceConversationsTableAnnotationComposer,
          $$SourceConversationsTableCreateCompanionBuilder,
          $$SourceConversationsTableUpdateCompanionBuilder,
          (
            SourceConversationRow,
            BaseReferences<
              _$AppDatabase,
              $SourceConversationsTable,
              SourceConversationRow
            >,
          ),
          SourceConversationRow,
          PrefetchHooks Function()
        > {
  $$SourceConversationsTableTableManager(
    _$AppDatabase db,
    $SourceConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SourceConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<int> sourceRevision = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceConversationsCompanion(
                id: id,
                userId: userId,
                content: content,
                sourceUrl: sourceUrl,
                sourceRevision: sourceRevision,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                isArchived: isArchived,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String content,
                Value<String?> sourceUrl = const Value.absent(),
                required int sourceRevision,
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceConversationsCompanion.insert(
                id: id,
                userId: userId,
                content: content,
                sourceUrl: sourceUrl,
                sourceRevision: sourceRevision,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                isArchived: isArchived,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceConversationsTable, SourceConversationRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SourceConversationsTable,
                    SourceConversationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceConversationsTable,
      SourceConversationRow,
      $$SourceConversationsTableFilterComposer,
      $$SourceConversationsTableOrderingComposer,
      $$SourceConversationsTableAnnotationComposer,
      $$SourceConversationsTableCreateCompanionBuilder,
      $$SourceConversationsTableUpdateCompanionBuilder,
      (
        SourceConversationRow,
        BaseReferences<
          _$AppDatabase,
          $SourceConversationsTable,
          SourceConversationRow
        >,
      ),
      SourceConversationRow,
      PrefetchHooks Function()
    >;
typedef $$LedgerItemsTableCreateCompanionBuilder =
    LedgerItemsCompanion Function({
      required String id,
      required String userId,
      required String kind,
      required String statement,
      required String status,
      Value<String?> owner,
      Value<int?> dueDate,
      Value<String?> note,
      Value<String> kindDisplayNameSnapshot,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$LedgerItemsTableUpdateCompanionBuilder =
    LedgerItemsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> kind,
      Value<String> statement,
      Value<String> status,
      Value<String?> owner,
      Value<int?> dueDate,
      Value<String?> note,
      Value<String> kindDisplayNameSnapshot,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$LedgerItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerItemsTable> {
  $$LedgerItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kindDisplayNameSnapshot => $composableBuilder(
    column: $table.kindDisplayNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LedgerItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerItemsTable> {
  $$LedgerItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kindDisplayNameSnapshot => $composableBuilder(
    column: $table.kindDisplayNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgerItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerItemsTable> {
  $$LedgerItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get kindDisplayNameSnapshot => $composableBuilder(
    column: $table.kindDisplayNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$LedgerItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerItemsTable,
          LedgerItemRow,
          $$LedgerItemsTableFilterComposer,
          $$LedgerItemsTableOrderingComposer,
          $$LedgerItemsTableAnnotationComposer,
          $$LedgerItemsTableCreateCompanionBuilder,
          $$LedgerItemsTableUpdateCompanionBuilder,
          (
            LedgerItemRow,
            BaseReferences<_$AppDatabase, $LedgerItemsTable, LedgerItemRow>,
          ),
          LedgerItemRow,
          PrefetchHooks Function()
        > {
  $$LedgerItemsTableTableManager(_$AppDatabase db, $LedgerItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> owner = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> kindDisplayNameSnapshot = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerItemsCompanion(
                id: id,
                userId: userId,
                kind: kind,
                statement: statement,
                status: status,
                owner: owner,
                dueDate: dueDate,
                note: note,
                kindDisplayNameSnapshot: kindDisplayNameSnapshot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String kind,
                required String statement,
                required String status,
                Value<String?> owner = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> kindDisplayNameSnapshot = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerItemsCompanion.insert(
                id: id,
                userId: userId,
                kind: kind,
                statement: statement,
                status: status,
                owner: owner,
                dueDate: dueDate,
                note: note,
                kindDisplayNameSnapshot: kindDisplayNameSnapshot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LedgerItemsTable, LedgerItemRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LedgerItemsTable,
                    LedgerItemRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LedgerItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerItemsTable,
      LedgerItemRow,
      $$LedgerItemsTableFilterComposer,
      $$LedgerItemsTableOrderingComposer,
      $$LedgerItemsTableAnnotationComposer,
      $$LedgerItemsTableCreateCompanionBuilder,
      $$LedgerItemsTableUpdateCompanionBuilder,
      (
        LedgerItemRow,
        BaseReferences<_$AppDatabase, $LedgerItemsTable, LedgerItemRow>,
      ),
      LedgerItemRow,
      PrefetchHooks Function()
    >;
typedef $$EvidenceTableCreateCompanionBuilder =
    EvidenceCompanion Function({
      required String id,
      required String ledgerItemId,
      required String sourceConversationId,
      required int sourceRevision,
      required int quoteStart,
      required int quoteEnd,
      required String quoteSnippet,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$EvidenceTableUpdateCompanionBuilder =
    EvidenceCompanion Function({
      Value<String> id,
      Value<String> ledgerItemId,
      Value<String> sourceConversationId,
      Value<int> sourceRevision,
      Value<int> quoteStart,
      Value<int> quoteEnd,
      Value<String> quoteSnippet,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$EvidenceTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceTable> {
  $$EvidenceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ledgerItemId => $composableBuilder(
    column: $table.ledgerItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteEnd => $composableBuilder(
    column: $table.quoteEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EvidenceTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceTable> {
  $$EvidenceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ledgerItemId => $composableBuilder(
    column: $table.ledgerItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteEnd => $composableBuilder(
    column: $table.quoteEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidenceTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceTable> {
  $$EvidenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ledgerItemId => $composableBuilder(
    column: $table.ledgerItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quoteEnd =>
      $composableBuilder(column: $table.quoteEnd, builder: (column) => column);

  GeneratedColumn<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$EvidenceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvidenceTable,
          EvidenceRow,
          $$EvidenceTableFilterComposer,
          $$EvidenceTableOrderingComposer,
          $$EvidenceTableAnnotationComposer,
          $$EvidenceTableCreateCompanionBuilder,
          $$EvidenceTableUpdateCompanionBuilder,
          (
            EvidenceRow,
            BaseReferences<_$AppDatabase, $EvidenceTable, EvidenceRow>,
          ),
          EvidenceRow,
          PrefetchHooks Function()
        > {
  $$EvidenceTableTableManager(_$AppDatabase db, $EvidenceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ledgerItemId = const Value.absent(),
                Value<String> sourceConversationId = const Value.absent(),
                Value<int> sourceRevision = const Value.absent(),
                Value<int> quoteStart = const Value.absent(),
                Value<int> quoteEnd = const Value.absent(),
                Value<String> quoteSnippet = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceCompanion(
                id: id,
                ledgerItemId: ledgerItemId,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                quoteStart: quoteStart,
                quoteEnd: quoteEnd,
                quoteSnippet: quoteSnippet,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ledgerItemId,
                required String sourceConversationId,
                required int sourceRevision,
                required int quoteStart,
                required int quoteEnd,
                required String quoteSnippet,
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceCompanion.insert(
                id: id,
                ledgerItemId: ledgerItemId,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                quoteStart: quoteStart,
                quoteEnd: quoteEnd,
                quoteSnippet: quoteSnippet,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EvidenceTable, EvidenceRow>(table),
                  BaseReferences<_$AppDatabase, $EvidenceTable, EvidenceRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EvidenceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvidenceTable,
      EvidenceRow,
      $$EvidenceTableFilterComposer,
      $$EvidenceTableOrderingComposer,
      $$EvidenceTableAnnotationComposer,
      $$EvidenceTableCreateCompanionBuilder,
      $$EvidenceTableUpdateCompanionBuilder,
      (EvidenceRow, BaseReferences<_$AppDatabase, $EvidenceTable, EvidenceRow>),
      EvidenceRow,
      PrefetchHooks Function()
    >;
typedef $$ExtractionCandidatesTableCreateCompanionBuilder =
    ExtractionCandidatesCompanion Function({
      required String id,
      required String userId,
      required String sourceConversationId,
      required int sourceRevision,
      required String kind,
      required String statement,
      Value<String?> owner,
      Value<int?> dueDate,
      required int quoteStart,
      required int quoteEnd,
      required String quoteSnippet,
      Value<String?> note,
      Value<String> reviewStatus,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ExtractionCandidatesTableUpdateCompanionBuilder =
    ExtractionCandidatesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sourceConversationId,
      Value<int> sourceRevision,
      Value<String> kind,
      Value<String> statement,
      Value<String?> owner,
      Value<int?> dueDate,
      Value<int> quoteStart,
      Value<int> quoteEnd,
      Value<String> quoteSnippet,
      Value<String?> note,
      Value<String> reviewStatus,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ExtractionCandidatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExtractionCandidatesTable> {
  $$ExtractionCandidatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteEnd => $composableBuilder(
    column: $table.quoteEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExtractionCandidatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtractionCandidatesTable> {
  $$ExtractionCandidatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteEnd => $composableBuilder(
    column: $table.quoteEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExtractionCandidatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtractionCandidatesTable> {
  $$ExtractionCandidatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get quoteStart => $composableBuilder(
    column: $table.quoteStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quoteEnd =>
      $composableBuilder(column: $table.quoteEnd, builder: (column) => column);

  GeneratedColumn<String> get quoteSnippet => $composableBuilder(
    column: $table.quoteSnippet,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ExtractionCandidatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtractionCandidatesTable,
          ExtractionCandidateRow,
          $$ExtractionCandidatesTableFilterComposer,
          $$ExtractionCandidatesTableOrderingComposer,
          $$ExtractionCandidatesTableAnnotationComposer,
          $$ExtractionCandidatesTableCreateCompanionBuilder,
          $$ExtractionCandidatesTableUpdateCompanionBuilder,
          (
            ExtractionCandidateRow,
            BaseReferences<
              _$AppDatabase,
              $ExtractionCandidatesTable,
              ExtractionCandidateRow
            >,
          ),
          ExtractionCandidateRow,
          PrefetchHooks Function()
        > {
  $$ExtractionCandidatesTableTableManager(
    _$AppDatabase db,
    $ExtractionCandidatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtractionCandidatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtractionCandidatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExtractionCandidatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sourceConversationId = const Value.absent(),
                Value<int> sourceRevision = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<String?> owner = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<int> quoteStart = const Value.absent(),
                Value<int> quoteEnd = const Value.absent(),
                Value<String> quoteSnippet = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionCandidatesCompanion(
                id: id,
                userId: userId,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                kind: kind,
                statement: statement,
                owner: owner,
                dueDate: dueDate,
                quoteStart: quoteStart,
                quoteEnd: quoteEnd,
                quoteSnippet: quoteSnippet,
                note: note,
                reviewStatus: reviewStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sourceConversationId,
                required int sourceRevision,
                required String kind,
                required String statement,
                Value<String?> owner = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                required int quoteStart,
                required int quoteEnd,
                required String quoteSnippet,
                Value<String?> note = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionCandidatesCompanion.insert(
                id: id,
                userId: userId,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                kind: kind,
                statement: statement,
                owner: owner,
                dueDate: dueDate,
                quoteStart: quoteStart,
                quoteEnd: quoteEnd,
                quoteSnippet: quoteSnippet,
                note: note,
                reviewStatus: reviewStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExtractionCandidatesTable,
                    ExtractionCandidateRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExtractionCandidatesTable,
                    ExtractionCandidateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExtractionCandidatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtractionCandidatesTable,
      ExtractionCandidateRow,
      $$ExtractionCandidatesTableFilterComposer,
      $$ExtractionCandidatesTableOrderingComposer,
      $$ExtractionCandidatesTableAnnotationComposer,
      $$ExtractionCandidatesTableCreateCompanionBuilder,
      $$ExtractionCandidatesTableUpdateCompanionBuilder,
      (
        ExtractionCandidateRow,
        BaseReferences<
          _$AppDatabase,
          $ExtractionCandidatesTable,
          ExtractionCandidateRow
        >,
      ),
      ExtractionCandidateRow,
      PrefetchHooks Function()
    >;
typedef $$AiProcessingConsentsTableCreateCompanionBuilder =
    AiProcessingConsentsCompanion Function({
      required String id,
      Value<String> userId,
      required String status,
      Value<int> createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$AiProcessingConsentsTableUpdateCompanionBuilder =
    AiProcessingConsentsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$AiProcessingConsentsTableFilterComposer
    extends Composer<_$AppDatabase, $AiProcessingConsentsTable> {
  $$AiProcessingConsentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiProcessingConsentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiProcessingConsentsTable> {
  $$AiProcessingConsentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiProcessingConsentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiProcessingConsentsTable> {
  $$AiProcessingConsentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$AiProcessingConsentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiProcessingConsentsTable,
          AiProcessingConsentRow,
          $$AiProcessingConsentsTableFilterComposer,
          $$AiProcessingConsentsTableOrderingComposer,
          $$AiProcessingConsentsTableAnnotationComposer,
          $$AiProcessingConsentsTableCreateCompanionBuilder,
          $$AiProcessingConsentsTableUpdateCompanionBuilder,
          (
            AiProcessingConsentRow,
            BaseReferences<
              _$AppDatabase,
              $AiProcessingConsentsTable,
              AiProcessingConsentRow
            >,
          ),
          AiProcessingConsentRow,
          PrefetchHooks Function()
        > {
  $$AiProcessingConsentsTableTableManager(
    _$AppDatabase db,
    $AiProcessingConsentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiProcessingConsentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiProcessingConsentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiProcessingConsentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiProcessingConsentsCompanion(
                id: id,
                userId: userId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> userId = const Value.absent(),
                required String status,
                Value<int> createdAt = const Value.absent(),
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiProcessingConsentsCompanion.insert(
                id: id,
                userId: userId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AiProcessingConsentsTable,
                    AiProcessingConsentRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AiProcessingConsentsTable,
                    AiProcessingConsentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiProcessingConsentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiProcessingConsentsTable,
      AiProcessingConsentRow,
      $$AiProcessingConsentsTableFilterComposer,
      $$AiProcessingConsentsTableOrderingComposer,
      $$AiProcessingConsentsTableAnnotationComposer,
      $$AiProcessingConsentsTableCreateCompanionBuilder,
      $$AiProcessingConsentsTableUpdateCompanionBuilder,
      (
        AiProcessingConsentRow,
        BaseReferences<
          _$AppDatabase,
          $AiProcessingConsentsTable,
          AiProcessingConsentRow
        >,
      ),
      AiProcessingConsentRow,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      required String id,
      required String userId,
      required String themeMode,
      Value<String> localePreference,
      Value<bool> debugModeEnabled,
      Value<String?> chatSystemPromptOverride,
      Value<String?> extractionPromptOverride,
      Value<String?> extractionSystemPromptOverride,
      Value<bool> extractionKindsIntroDismissed,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> themeMode,
      Value<String> localePreference,
      Value<bool> debugModeEnabled,
      Value<String?> chatSystemPromptOverride,
      Value<String?> extractionPromptOverride,
      Value<String?> extractionSystemPromptOverride,
      Value<bool> extractionKindsIntroDismissed,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localePreference => $composableBuilder(
    column: $table.localePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get debugModeEnabled => $composableBuilder(
    column: $table.debugModeEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chatSystemPromptOverride => $composableBuilder(
    column: $table.chatSystemPromptOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionPromptOverride => $composableBuilder(
    column: $table.extractionPromptOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionSystemPromptOverride =>
      $composableBuilder(
        column: $table.extractionSystemPromptOverride,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get extractionKindsIntroDismissed => $composableBuilder(
    column: $table.extractionKindsIntroDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localePreference => $composableBuilder(
    column: $table.localePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get debugModeEnabled => $composableBuilder(
    column: $table.debugModeEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chatSystemPromptOverride => $composableBuilder(
    column: $table.chatSystemPromptOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionPromptOverride => $composableBuilder(
    column: $table.extractionPromptOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionSystemPromptOverride =>
      $composableBuilder(
        column: $table.extractionSystemPromptOverride,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get extractionKindsIntroDismissed => $composableBuilder(
    column: $table.extractionKindsIntroDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get localePreference => $composableBuilder(
    column: $table.localePreference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get debugModeEnabled => $composableBuilder(
    column: $table.debugModeEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chatSystemPromptOverride => $composableBuilder(
    column: $table.chatSystemPromptOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionPromptOverride => $composableBuilder(
    column: $table.extractionPromptOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionSystemPromptOverride =>
      $composableBuilder(
        column: $table.extractionSystemPromptOverride,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get extractionKindsIntroDismissed => $composableBuilder(
    column: $table.extractionKindsIntroDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTable,
          UserPreferenceRow,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            UserPreferenceRow,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTable,
              UserPreferenceRow
            >,
          ),
          UserPreferenceRow,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> localePreference = const Value.absent(),
                Value<bool> debugModeEnabled = const Value.absent(),
                Value<String?> chatSystemPromptOverride = const Value.absent(),
                Value<String?> extractionPromptOverride = const Value.absent(),
                Value<String?> extractionSystemPromptOverride =
                    const Value.absent(),
                Value<bool> extractionKindsIntroDismissed =
                    const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion(
                id: id,
                userId: userId,
                themeMode: themeMode,
                localePreference: localePreference,
                debugModeEnabled: debugModeEnabled,
                chatSystemPromptOverride: chatSystemPromptOverride,
                extractionPromptOverride: extractionPromptOverride,
                extractionSystemPromptOverride: extractionSystemPromptOverride,
                extractionKindsIntroDismissed: extractionKindsIntroDismissed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String themeMode,
                Value<String> localePreference = const Value.absent(),
                Value<bool> debugModeEnabled = const Value.absent(),
                Value<String?> chatSystemPromptOverride = const Value.absent(),
                Value<String?> extractionPromptOverride = const Value.absent(),
                Value<String?> extractionSystemPromptOverride =
                    const Value.absent(),
                Value<bool> extractionKindsIntroDismissed =
                    const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion.insert(
                id: id,
                userId: userId,
                themeMode: themeMode,
                localePreference: localePreference,
                debugModeEnabled: debugModeEnabled,
                chatSystemPromptOverride: chatSystemPromptOverride,
                extractionPromptOverride: extractionPromptOverride,
                extractionSystemPromptOverride: extractionSystemPromptOverride,
                extractionKindsIntroDismissed: extractionKindsIntroDismissed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserPreferencesTable, UserPreferenceRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserPreferencesTable,
                    UserPreferenceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTable,
      UserPreferenceRow,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        UserPreferenceRow,
        BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreferenceRow>,
      ),
      UserPreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$ChatThreadsTableCreateCompanionBuilder =
    ChatThreadsCompanion Function({
      required String id,
      required String userId,
      required String title,
      Value<String?> modelId,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ChatThreadsTableUpdateCompanionBuilder =
    ChatThreadsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String?> modelId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ChatThreadsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatThreadsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatThreadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ChatThreadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatThreadsTable,
          ChatThreadRow,
          $$ChatThreadsTableFilterComposer,
          $$ChatThreadsTableOrderingComposer,
          $$ChatThreadsTableAnnotationComposer,
          $$ChatThreadsTableCreateCompanionBuilder,
          $$ChatThreadsTableUpdateCompanionBuilder,
          (
            ChatThreadRow,
            BaseReferences<_$AppDatabase, $ChatThreadsTable, ChatThreadRow>,
          ),
          ChatThreadRow,
          PrefetchHooks Function()
        > {
  $$ChatThreadsTableTableManager(_$AppDatabase db, $ChatThreadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatThreadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> modelId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatThreadsCompanion(
                id: id,
                userId: userId,
                title: title,
                modelId: modelId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                Value<String?> modelId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatThreadsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                modelId: modelId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatThreadsTable, ChatThreadRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChatThreadsTable,
                    ChatThreadRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatThreadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatThreadsTable,
      ChatThreadRow,
      $$ChatThreadsTableFilterComposer,
      $$ChatThreadsTableOrderingComposer,
      $$ChatThreadsTableAnnotationComposer,
      $$ChatThreadsTableCreateCompanionBuilder,
      $$ChatThreadsTableUpdateCompanionBuilder,
      (
        ChatThreadRow,
        BaseReferences<_$AppDatabase, $ChatThreadsTable, ChatThreadRow>,
      ),
      ChatThreadRow,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      required String id,
      required String userId,
      required String threadId,
      required String role,
      required String content,
      required String status,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> threadId,
      Value<String> role,
      Value<String> content,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageRow,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessageRow,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
          ),
          ChatMessageRow,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                userId: userId,
                threadId: threadId,
                role: role,
                content: content,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String threadId,
                required String role,
                required String content,
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                userId: userId,
                threadId: threadId,
                role: role,
                content: content,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatMessagesTable, ChatMessageRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChatMessagesTable,
                    ChatMessageRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageRow,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessageRow,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
      ),
      ChatMessageRow,
      PrefetchHooks Function()
    >;
typedef $$ExtractionJobsTableCreateCompanionBuilder =
    ExtractionJobsCompanion Function({
      required String id,
      required String sourceConversationId,
      Value<int> sourceRevision,
      Value<int> completedChunkCount,
      Value<int> totalChunks,
      Value<int> candidatesFound,
      required int startTimeMs,
      Value<String> chunkTimingsJson,
      Value<String> progressTitle,
      Value<String> progressBody,
      Value<String> completionTitle,
      Value<String> queuedSourceConversationIdsJson,
      Value<int> batchIndex,
      Value<int> batchTotal,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExtractionJobsTableUpdateCompanionBuilder =
    ExtractionJobsCompanion Function({
      Value<String> id,
      Value<String> sourceConversationId,
      Value<int> sourceRevision,
      Value<int> completedChunkCount,
      Value<int> totalChunks,
      Value<int> candidatesFound,
      Value<int> startTimeMs,
      Value<String> chunkTimingsJson,
      Value<String> progressTitle,
      Value<String> progressBody,
      Value<String> completionTitle,
      Value<String> queuedSourceConversationIdsJson,
      Value<int> batchIndex,
      Value<int> batchTotal,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ExtractionJobsTableFilterComposer
    extends Composer<_$AppDatabase, $ExtractionJobsTable> {
  $$ExtractionJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedChunkCount => $composableBuilder(
    column: $table.completedChunkCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get candidatesFound => $composableBuilder(
    column: $table.candidatesFound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressTitle => $composableBuilder(
    column: $table.progressTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressBody => $composableBuilder(
    column: $table.progressBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionTitle => $composableBuilder(
    column: $table.completionTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get queuedSourceConversationIdsJson =>
      $composableBuilder(
        column: $table.queuedSourceConversationIdsJson,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get batchIndex => $composableBuilder(
    column: $table.batchIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batchTotal => $composableBuilder(
    column: $table.batchTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExtractionJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtractionJobsTable> {
  $$ExtractionJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedChunkCount => $composableBuilder(
    column: $table.completedChunkCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get candidatesFound => $composableBuilder(
    column: $table.candidatesFound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressTitle => $composableBuilder(
    column: $table.progressTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressBody => $composableBuilder(
    column: $table.progressBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionTitle => $composableBuilder(
    column: $table.completionTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queuedSourceConversationIdsJson =>
      $composableBuilder(
        column: $table.queuedSourceConversationIdsJson,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get batchIndex => $composableBuilder(
    column: $table.batchIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batchTotal => $composableBuilder(
    column: $table.batchTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExtractionJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtractionJobsTable> {
  $$ExtractionJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceRevision => $composableBuilder(
    column: $table.sourceRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedChunkCount => $composableBuilder(
    column: $table.completedChunkCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get candidatesFound => $composableBuilder(
    column: $table.candidatesFound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get progressTitle => $composableBuilder(
    column: $table.progressTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get progressBody => $composableBuilder(
    column: $table.progressBody,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionTitle => $composableBuilder(
    column: $table.completionTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get queuedSourceConversationIdsJson =>
      $composableBuilder(
        column: $table.queuedSourceConversationIdsJson,
        builder: (column) => column,
      );

  GeneratedColumn<int> get batchIndex => $composableBuilder(
    column: $table.batchIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get batchTotal => $composableBuilder(
    column: $table.batchTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExtractionJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtractionJobsTable,
          ExtractionJobRow,
          $$ExtractionJobsTableFilterComposer,
          $$ExtractionJobsTableOrderingComposer,
          $$ExtractionJobsTableAnnotationComposer,
          $$ExtractionJobsTableCreateCompanionBuilder,
          $$ExtractionJobsTableUpdateCompanionBuilder,
          (
            ExtractionJobRow,
            BaseReferences<
              _$AppDatabase,
              $ExtractionJobsTable,
              ExtractionJobRow
            >,
          ),
          ExtractionJobRow,
          PrefetchHooks Function()
        > {
  $$ExtractionJobsTableTableManager(
    _$AppDatabase db,
    $ExtractionJobsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtractionJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtractionJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtractionJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceConversationId = const Value.absent(),
                Value<int> sourceRevision = const Value.absent(),
                Value<int> completedChunkCount = const Value.absent(),
                Value<int> totalChunks = const Value.absent(),
                Value<int> candidatesFound = const Value.absent(),
                Value<int> startTimeMs = const Value.absent(),
                Value<String> chunkTimingsJson = const Value.absent(),
                Value<String> progressTitle = const Value.absent(),
                Value<String> progressBody = const Value.absent(),
                Value<String> completionTitle = const Value.absent(),
                Value<String> queuedSourceConversationIdsJson =
                    const Value.absent(),
                Value<int> batchIndex = const Value.absent(),
                Value<int> batchTotal = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionJobsCompanion(
                id: id,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                completedChunkCount: completedChunkCount,
                totalChunks: totalChunks,
                candidatesFound: candidatesFound,
                startTimeMs: startTimeMs,
                chunkTimingsJson: chunkTimingsJson,
                progressTitle: progressTitle,
                progressBody: progressBody,
                completionTitle: completionTitle,
                queuedSourceConversationIdsJson:
                    queuedSourceConversationIdsJson,
                batchIndex: batchIndex,
                batchTotal: batchTotal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceConversationId,
                Value<int> sourceRevision = const Value.absent(),
                Value<int> completedChunkCount = const Value.absent(),
                Value<int> totalChunks = const Value.absent(),
                Value<int> candidatesFound = const Value.absent(),
                required int startTimeMs,
                Value<String> chunkTimingsJson = const Value.absent(),
                Value<String> progressTitle = const Value.absent(),
                Value<String> progressBody = const Value.absent(),
                Value<String> completionTitle = const Value.absent(),
                Value<String> queuedSourceConversationIdsJson =
                    const Value.absent(),
                Value<int> batchIndex = const Value.absent(),
                Value<int> batchTotal = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExtractionJobsCompanion.insert(
                id: id,
                sourceConversationId: sourceConversationId,
                sourceRevision: sourceRevision,
                completedChunkCount: completedChunkCount,
                totalChunks: totalChunks,
                candidatesFound: candidatesFound,
                startTimeMs: startTimeMs,
                chunkTimingsJson: chunkTimingsJson,
                progressTitle: progressTitle,
                progressBody: progressBody,
                completionTitle: completionTitle,
                queuedSourceConversationIdsJson:
                    queuedSourceConversationIdsJson,
                batchIndex: batchIndex,
                batchTotal: batchTotal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExtractionJobsTable, ExtractionJobRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExtractionJobsTable,
                    ExtractionJobRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExtractionJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtractionJobsTable,
      ExtractionJobRow,
      $$ExtractionJobsTableFilterComposer,
      $$ExtractionJobsTableOrderingComposer,
      $$ExtractionJobsTableAnnotationComposer,
      $$ExtractionJobsTableCreateCompanionBuilder,
      $$ExtractionJobsTableUpdateCompanionBuilder,
      (
        ExtractionJobRow,
        BaseReferences<_$AppDatabase, $ExtractionJobsTable, ExtractionJobRow>,
      ),
      ExtractionJobRow,
      PrefetchHooks Function()
    >;
typedef $$ExtractionRunsTableCreateCompanionBuilder =
    ExtractionRunsCompanion Function({
      required String id,
      required String userId,
      Value<String?> sourceConversationId,
      Value<String?> sourceConversationTitle,
      required String modelId,
      Value<String?> modelDisplayName,
      required int startedAt,
      required int completedAt,
      required String status,
      required int durationMs,
      Value<String> enabledKindSlugsJson,
      Value<String> kindCountsJson,
      Value<int> acceptedCount,
      Value<int> rejectedCount,
      Value<int> pendingCount,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ExtractionRunsTableUpdateCompanionBuilder =
    ExtractionRunsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> sourceConversationId,
      Value<String?> sourceConversationTitle,
      Value<String> modelId,
      Value<String?> modelDisplayName,
      Value<int> startedAt,
      Value<int> completedAt,
      Value<String> status,
      Value<int> durationMs,
      Value<String> enabledKindSlugsJson,
      Value<String> kindCountsJson,
      Value<int> acceptedCount,
      Value<int> rejectedCount,
      Value<int> pendingCount,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ExtractionRunsTableFilterComposer
    extends Composer<_$AppDatabase, $ExtractionRunsTable> {
  $$ExtractionRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConversationTitle => $composableBuilder(
    column: $table.sourceConversationTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelDisplayName => $composableBuilder(
    column: $table.modelDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enabledKindSlugsJson => $composableBuilder(
    column: $table.enabledKindSlugsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kindCountsJson => $composableBuilder(
    column: $table.kindCountsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acceptedCount => $composableBuilder(
    column: $table.acceptedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rejectedCount => $composableBuilder(
    column: $table.rejectedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExtractionRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtractionRunsTable> {
  $$ExtractionRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConversationTitle => $composableBuilder(
    column: $table.sourceConversationTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelDisplayName => $composableBuilder(
    column: $table.modelDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enabledKindSlugsJson => $composableBuilder(
    column: $table.enabledKindSlugsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kindCountsJson => $composableBuilder(
    column: $table.kindCountsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acceptedCount => $composableBuilder(
    column: $table.acceptedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rejectedCount => $composableBuilder(
    column: $table.rejectedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExtractionRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtractionRunsTable> {
  $$ExtractionRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceConversationId => $composableBuilder(
    column: $table.sourceConversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceConversationTitle => $composableBuilder(
    column: $table.sourceConversationTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get modelDisplayName => $composableBuilder(
    column: $table.modelDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enabledKindSlugsJson => $composableBuilder(
    column: $table.enabledKindSlugsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kindCountsJson => $composableBuilder(
    column: $table.kindCountsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get acceptedCount => $composableBuilder(
    column: $table.acceptedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rejectedCount => $composableBuilder(
    column: $table.rejectedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ExtractionRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtractionRunsTable,
          ExtractionRunRow,
          $$ExtractionRunsTableFilterComposer,
          $$ExtractionRunsTableOrderingComposer,
          $$ExtractionRunsTableAnnotationComposer,
          $$ExtractionRunsTableCreateCompanionBuilder,
          $$ExtractionRunsTableUpdateCompanionBuilder,
          (
            ExtractionRunRow,
            BaseReferences<
              _$AppDatabase,
              $ExtractionRunsTable,
              ExtractionRunRow
            >,
          ),
          ExtractionRunRow,
          PrefetchHooks Function()
        > {
  $$ExtractionRunsTableTableManager(
    _$AppDatabase db,
    $ExtractionRunsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtractionRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtractionRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtractionRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> sourceConversationId = const Value.absent(),
                Value<String?> sourceConversationTitle = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String?> modelDisplayName = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int> completedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String> enabledKindSlugsJson = const Value.absent(),
                Value<String> kindCountsJson = const Value.absent(),
                Value<int> acceptedCount = const Value.absent(),
                Value<int> rejectedCount = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionRunsCompanion(
                id: id,
                userId: userId,
                sourceConversationId: sourceConversationId,
                sourceConversationTitle: sourceConversationTitle,
                modelId: modelId,
                modelDisplayName: modelDisplayName,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                durationMs: durationMs,
                enabledKindSlugsJson: enabledKindSlugsJson,
                kindCountsJson: kindCountsJson,
                acceptedCount: acceptedCount,
                rejectedCount: rejectedCount,
                pendingCount: pendingCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> sourceConversationId = const Value.absent(),
                Value<String?> sourceConversationTitle = const Value.absent(),
                required String modelId,
                Value<String?> modelDisplayName = const Value.absent(),
                required int startedAt,
                required int completedAt,
                required String status,
                required int durationMs,
                Value<String> enabledKindSlugsJson = const Value.absent(),
                Value<String> kindCountsJson = const Value.absent(),
                Value<int> acceptedCount = const Value.absent(),
                Value<int> rejectedCount = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionRunsCompanion.insert(
                id: id,
                userId: userId,
                sourceConversationId: sourceConversationId,
                sourceConversationTitle: sourceConversationTitle,
                modelId: modelId,
                modelDisplayName: modelDisplayName,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                durationMs: durationMs,
                enabledKindSlugsJson: enabledKindSlugsJson,
                kindCountsJson: kindCountsJson,
                acceptedCount: acceptedCount,
                rejectedCount: rejectedCount,
                pendingCount: pendingCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExtractionRunsTable, ExtractionRunRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExtractionRunsTable,
                    ExtractionRunRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExtractionRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtractionRunsTable,
      ExtractionRunRow,
      $$ExtractionRunsTableFilterComposer,
      $$ExtractionRunsTableOrderingComposer,
      $$ExtractionRunsTableAnnotationComposer,
      $$ExtractionRunsTableCreateCompanionBuilder,
      $$ExtractionRunsTableUpdateCompanionBuilder,
      (
        ExtractionRunRow,
        BaseReferences<_$AppDatabase, $ExtractionRunsTable, ExtractionRunRow>,
      ),
      ExtractionRunRow,
      PrefetchHooks Function()
    >;
typedef $$ExtractionItemKindsTableCreateCompanionBuilder =
    ExtractionItemKindsCompanion Function({
      required String id,
      required String userId,
      required String slug,
      required String displayName,
      Value<String?> extractionHint,
      required String behavior,
      required String datePolicy,
      required String notePolicy,
      required String ownerPolicy,
      Value<bool> enabledForExtraction,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<String?> teachingExamplesJson,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ExtractionItemKindsTableUpdateCompanionBuilder =
    ExtractionItemKindsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> slug,
      Value<String> displayName,
      Value<String?> extractionHint,
      Value<String> behavior,
      Value<String> datePolicy,
      Value<String> notePolicy,
      Value<String> ownerPolicy,
      Value<bool> enabledForExtraction,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<String?> teachingExamplesJson,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ExtractionItemKindsTableFilterComposer
    extends Composer<_$AppDatabase, $ExtractionItemKindsTable> {
  $$ExtractionItemKindsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionHint => $composableBuilder(
    column: $table.extractionHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datePolicy => $composableBuilder(
    column: $table.datePolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notePolicy => $composableBuilder(
    column: $table.notePolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPolicy => $composableBuilder(
    column: $table.ownerPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabledForExtraction => $composableBuilder(
    column: $table.enabledForExtraction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teachingExamplesJson => $composableBuilder(
    column: $table.teachingExamplesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExtractionItemKindsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtractionItemKindsTable> {
  $$ExtractionItemKindsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionHint => $composableBuilder(
    column: $table.extractionHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datePolicy => $composableBuilder(
    column: $table.datePolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notePolicy => $composableBuilder(
    column: $table.notePolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPolicy => $composableBuilder(
    column: $table.ownerPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabledForExtraction => $composableBuilder(
    column: $table.enabledForExtraction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teachingExamplesJson => $composableBuilder(
    column: $table.teachingExamplesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExtractionItemKindsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtractionItemKindsTable> {
  $$ExtractionItemKindsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionHint => $composableBuilder(
    column: $table.extractionHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get behavior =>
      $composableBuilder(column: $table.behavior, builder: (column) => column);

  GeneratedColumn<String> get datePolicy => $composableBuilder(
    column: $table.datePolicy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notePolicy => $composableBuilder(
    column: $table.notePolicy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerPolicy => $composableBuilder(
    column: $table.ownerPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabledForExtraction => $composableBuilder(
    column: $table.enabledForExtraction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get teachingExamplesJson => $composableBuilder(
    column: $table.teachingExamplesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ExtractionItemKindsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtractionItemKindsTable,
          ExtractionItemKindRow,
          $$ExtractionItemKindsTableFilterComposer,
          $$ExtractionItemKindsTableOrderingComposer,
          $$ExtractionItemKindsTableAnnotationComposer,
          $$ExtractionItemKindsTableCreateCompanionBuilder,
          $$ExtractionItemKindsTableUpdateCompanionBuilder,
          (
            ExtractionItemKindRow,
            BaseReferences<
              _$AppDatabase,
              $ExtractionItemKindsTable,
              ExtractionItemKindRow
            >,
          ),
          ExtractionItemKindRow,
          PrefetchHooks Function()
        > {
  $$ExtractionItemKindsTableTableManager(
    _$AppDatabase db,
    $ExtractionItemKindsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtractionItemKindsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtractionItemKindsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExtractionItemKindsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> extractionHint = const Value.absent(),
                Value<String> behavior = const Value.absent(),
                Value<String> datePolicy = const Value.absent(),
                Value<String> notePolicy = const Value.absent(),
                Value<String> ownerPolicy = const Value.absent(),
                Value<bool> enabledForExtraction = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> teachingExamplesJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionItemKindsCompanion(
                id: id,
                userId: userId,
                slug: slug,
                displayName: displayName,
                extractionHint: extractionHint,
                behavior: behavior,
                datePolicy: datePolicy,
                notePolicy: notePolicy,
                ownerPolicy: ownerPolicy,
                enabledForExtraction: enabledForExtraction,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                teachingExamplesJson: teachingExamplesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String slug,
                required String displayName,
                Value<String?> extractionHint = const Value.absent(),
                required String behavior,
                required String datePolicy,
                required String notePolicy,
                required String ownerPolicy,
                Value<bool> enabledForExtraction = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> teachingExamplesJson = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionItemKindsCompanion.insert(
                id: id,
                userId: userId,
                slug: slug,
                displayName: displayName,
                extractionHint: extractionHint,
                behavior: behavior,
                datePolicy: datePolicy,
                notePolicy: notePolicy,
                ownerPolicy: ownerPolicy,
                enabledForExtraction: enabledForExtraction,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                teachingExamplesJson: teachingExamplesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExtractionItemKindsTable, ExtractionItemKindRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ExtractionItemKindsTable,
                    ExtractionItemKindRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExtractionItemKindsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtractionItemKindsTable,
      ExtractionItemKindRow,
      $$ExtractionItemKindsTableFilterComposer,
      $$ExtractionItemKindsTableOrderingComposer,
      $$ExtractionItemKindsTableAnnotationComposer,
      $$ExtractionItemKindsTableCreateCompanionBuilder,
      $$ExtractionItemKindsTableUpdateCompanionBuilder,
      (
        ExtractionItemKindRow,
        BaseReferences<
          _$AppDatabase,
          $ExtractionItemKindsTable,
          ExtractionItemKindRow
        >,
      ),
      ExtractionItemKindRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalUserScopesTableTableManager get localUserScopes =>
      $$LocalUserScopesTableTableManager(_db, _db.localUserScopes);
  $$SourceConversationsTableTableManager get sourceConversations =>
      $$SourceConversationsTableTableManager(_db, _db.sourceConversations);
  $$LedgerItemsTableTableManager get ledgerItems =>
      $$LedgerItemsTableTableManager(_db, _db.ledgerItems);
  $$EvidenceTableTableManager get evidence =>
      $$EvidenceTableTableManager(_db, _db.evidence);
  $$ExtractionCandidatesTableTableManager get extractionCandidates =>
      $$ExtractionCandidatesTableTableManager(_db, _db.extractionCandidates);
  $$AiProcessingConsentsTableTableManager get aiProcessingConsents =>
      $$AiProcessingConsentsTableTableManager(_db, _db.aiProcessingConsents);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$ChatThreadsTableTableManager get chatThreads =>
      $$ChatThreadsTableTableManager(_db, _db.chatThreads);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$ExtractionJobsTableTableManager get extractionJobs =>
      $$ExtractionJobsTableTableManager(_db, _db.extractionJobs);
  $$ExtractionRunsTableTableManager get extractionRuns =>
      $$ExtractionRunsTableTableManager(_db, _db.extractionRuns);
  $$ExtractionItemKindsTableTableManager get extractionItemKinds =>
      $$ExtractionItemKindsTableTableManager(_db, _db.extractionItemKinds);
}
