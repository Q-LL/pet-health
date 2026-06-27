// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_database.dart';

// ignore_for_file: type=lint
class $KnowledgeArticlesTable extends KnowledgeArticles
    with TableInfo<$KnowledgeArticlesTable, KnowledgeArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityLevelMeta = const VerificationMeta(
    'severityLevel',
  );
  @override
  late final GeneratedColumn<String> severityLevel = GeneratedColumn<String>(
    'severity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('info'),
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dog'),
  );
  static const VerificationMeta _lifeStageMeta = const VerificationMeta(
    'lifeStage',
  );
  @override
  late final GeneratedColumn<String> lifeStage = GeneratedColumn<String>(
    'life_stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('any'),
  );
  static const VerificationMeta _contextKeysJsonMeta = const VerificationMeta(
    'contextKeysJson',
  );
  @override
  late final GeneratedColumn<String> contextKeysJson = GeneratedColumn<String>(
    'context_keys_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _redFlagsJsonMeta = const VerificationMeta(
    'redFlagsJson',
  );
  @override
  late final GeneratedColumn<String> redFlagsJson = GeneratedColumn<String>(
    'red_flags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _suggestedActionsJsonMeta =
      const VerificationMeta('suggestedActionsJson');
  @override
  late final GeneratedColumn<String> suggestedActionsJson =
      GeneratedColumn<String>(
        'suggested_actions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _reviewedStatusMeta = const VerificationMeta(
    'reviewedStatus',
  );
  @override
  late final GeneratedColumn<String> reviewedStatus = GeneratedColumn<String>(
    'reviewed_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('reviewed'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('2026.06'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    summary,
    body,
    severityLevel,
    species,
    lifeStage,
    contextKeysJson,
    tagsJson,
    redFlagsJson,
    suggestedActionsJson,
    reviewedStatus,
    version,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeArticle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('severity_level')) {
      context.handle(
        _severityLevelMeta,
        severityLevel.isAcceptableOrUnknown(
          data['severity_level']!,
          _severityLevelMeta,
        ),
      );
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    }
    if (data.containsKey('life_stage')) {
      context.handle(
        _lifeStageMeta,
        lifeStage.isAcceptableOrUnknown(data['life_stage']!, _lifeStageMeta),
      );
    }
    if (data.containsKey('context_keys_json')) {
      context.handle(
        _contextKeysJsonMeta,
        contextKeysJson.isAcceptableOrUnknown(
          data['context_keys_json']!,
          _contextKeysJsonMeta,
        ),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('red_flags_json')) {
      context.handle(
        _redFlagsJsonMeta,
        redFlagsJson.isAcceptableOrUnknown(
          data['red_flags_json']!,
          _redFlagsJsonMeta,
        ),
      );
    }
    if (data.containsKey('suggested_actions_json')) {
      context.handle(
        _suggestedActionsJsonMeta,
        suggestedActionsJson.isAcceptableOrUnknown(
          data['suggested_actions_json']!,
          _suggestedActionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('reviewed_status')) {
      context.handle(
        _reviewedStatusMeta,
        reviewedStatus.isAcceptableOrUnknown(
          data['reviewed_status']!,
          _reviewedStatusMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeArticle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      severityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity_level'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      lifeStage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}life_stage'],
      )!,
      contextKeysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_keys_json'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      redFlagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}red_flags_json'],
      )!,
      suggestedActionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_actions_json'],
      )!,
      reviewedStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewed_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KnowledgeArticlesTable createAlias(String alias) {
    return $KnowledgeArticlesTable(attachedDatabase, alias);
  }
}

class KnowledgeArticle extends DataClass
    implements Insertable<KnowledgeArticle> {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String body;
  final String severityLevel;
  final String species;
  final String lifeStage;
  final String contextKeysJson;
  final String tagsJson;
  final String redFlagsJson;
  final String suggestedActionsJson;
  final String reviewedStatus;
  final String version;
  final DateTime updatedAt;
  const KnowledgeArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.body,
    required this.severityLevel,
    required this.species,
    required this.lifeStage,
    required this.contextKeysJson,
    required this.tagsJson,
    required this.redFlagsJson,
    required this.suggestedActionsJson,
    required this.reviewedStatus,
    required this.version,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['summary'] = Variable<String>(summary);
    map['body'] = Variable<String>(body);
    map['severity_level'] = Variable<String>(severityLevel);
    map['species'] = Variable<String>(species);
    map['life_stage'] = Variable<String>(lifeStage);
    map['context_keys_json'] = Variable<String>(contextKeysJson);
    map['tags_json'] = Variable<String>(tagsJson);
    map['red_flags_json'] = Variable<String>(redFlagsJson);
    map['suggested_actions_json'] = Variable<String>(suggestedActionsJson);
    map['reviewed_status'] = Variable<String>(reviewedStatus);
    map['version'] = Variable<String>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KnowledgeArticlesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeArticlesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      summary: Value(summary),
      body: Value(body),
      severityLevel: Value(severityLevel),
      species: Value(species),
      lifeStage: Value(lifeStage),
      contextKeysJson: Value(contextKeysJson),
      tagsJson: Value(tagsJson),
      redFlagsJson: Value(redFlagsJson),
      suggestedActionsJson: Value(suggestedActionsJson),
      reviewedStatus: Value(reviewedStatus),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnowledgeArticle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeArticle(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      summary: serializer.fromJson<String>(json['summary']),
      body: serializer.fromJson<String>(json['body']),
      severityLevel: serializer.fromJson<String>(json['severityLevel']),
      species: serializer.fromJson<String>(json['species']),
      lifeStage: serializer.fromJson<String>(json['lifeStage']),
      contextKeysJson: serializer.fromJson<String>(json['contextKeysJson']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      redFlagsJson: serializer.fromJson<String>(json['redFlagsJson']),
      suggestedActionsJson: serializer.fromJson<String>(
        json['suggestedActionsJson'],
      ),
      reviewedStatus: serializer.fromJson<String>(json['reviewedStatus']),
      version: serializer.fromJson<String>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'summary': serializer.toJson<String>(summary),
      'body': serializer.toJson<String>(body),
      'severityLevel': serializer.toJson<String>(severityLevel),
      'species': serializer.toJson<String>(species),
      'lifeStage': serializer.toJson<String>(lifeStage),
      'contextKeysJson': serializer.toJson<String>(contextKeysJson),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'redFlagsJson': serializer.toJson<String>(redFlagsJson),
      'suggestedActionsJson': serializer.toJson<String>(suggestedActionsJson),
      'reviewedStatus': serializer.toJson<String>(reviewedStatus),
      'version': serializer.toJson<String>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeArticle copyWith({
    String? id,
    String? title,
    String? category,
    String? summary,
    String? body,
    String? severityLevel,
    String? species,
    String? lifeStage,
    String? contextKeysJson,
    String? tagsJson,
    String? redFlagsJson,
    String? suggestedActionsJson,
    String? reviewedStatus,
    String? version,
    DateTime? updatedAt,
  }) => KnowledgeArticle(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    summary: summary ?? this.summary,
    body: body ?? this.body,
    severityLevel: severityLevel ?? this.severityLevel,
    species: species ?? this.species,
    lifeStage: lifeStage ?? this.lifeStage,
    contextKeysJson: contextKeysJson ?? this.contextKeysJson,
    tagsJson: tagsJson ?? this.tagsJson,
    redFlagsJson: redFlagsJson ?? this.redFlagsJson,
    suggestedActionsJson: suggestedActionsJson ?? this.suggestedActionsJson,
    reviewedStatus: reviewedStatus ?? this.reviewedStatus,
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KnowledgeArticle copyWithCompanion(KnowledgeArticlesCompanion data) {
    return KnowledgeArticle(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      summary: data.summary.present ? data.summary.value : this.summary,
      body: data.body.present ? data.body.value : this.body,
      severityLevel: data.severityLevel.present
          ? data.severityLevel.value
          : this.severityLevel,
      species: data.species.present ? data.species.value : this.species,
      lifeStage: data.lifeStage.present ? data.lifeStage.value : this.lifeStage,
      contextKeysJson: data.contextKeysJson.present
          ? data.contextKeysJson.value
          : this.contextKeysJson,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      redFlagsJson: data.redFlagsJson.present
          ? data.redFlagsJson.value
          : this.redFlagsJson,
      suggestedActionsJson: data.suggestedActionsJson.present
          ? data.suggestedActionsJson.value
          : this.suggestedActionsJson,
      reviewedStatus: data.reviewedStatus.present
          ? data.reviewedStatus.value
          : this.reviewedStatus,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeArticle(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('body: $body, ')
          ..write('severityLevel: $severityLevel, ')
          ..write('species: $species, ')
          ..write('lifeStage: $lifeStage, ')
          ..write('contextKeysJson: $contextKeysJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('redFlagsJson: $redFlagsJson, ')
          ..write('suggestedActionsJson: $suggestedActionsJson, ')
          ..write('reviewedStatus: $reviewedStatus, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    summary,
    body,
    severityLevel,
    species,
    lifeStage,
    contextKeysJson,
    tagsJson,
    redFlagsJson,
    suggestedActionsJson,
    reviewedStatus,
    version,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeArticle &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.summary == this.summary &&
          other.body == this.body &&
          other.severityLevel == this.severityLevel &&
          other.species == this.species &&
          other.lifeStage == this.lifeStage &&
          other.contextKeysJson == this.contextKeysJson &&
          other.tagsJson == this.tagsJson &&
          other.redFlagsJson == this.redFlagsJson &&
          other.suggestedActionsJson == this.suggestedActionsJson &&
          other.reviewedStatus == this.reviewedStatus &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class KnowledgeArticlesCompanion extends UpdateCompanion<KnowledgeArticle> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<String> summary;
  final Value<String> body;
  final Value<String> severityLevel;
  final Value<String> species;
  final Value<String> lifeStage;
  final Value<String> contextKeysJson;
  final Value<String> tagsJson;
  final Value<String> redFlagsJson;
  final Value<String> suggestedActionsJson;
  final Value<String> reviewedStatus;
  final Value<String> version;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KnowledgeArticlesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.summary = const Value.absent(),
    this.body = const Value.absent(),
    this.severityLevel = const Value.absent(),
    this.species = const Value.absent(),
    this.lifeStage = const Value.absent(),
    this.contextKeysJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.redFlagsJson = const Value.absent(),
    this.suggestedActionsJson = const Value.absent(),
    this.reviewedStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeArticlesCompanion.insert({
    required String id,
    required String title,
    required String category,
    required String summary,
    required String body,
    this.severityLevel = const Value.absent(),
    this.species = const Value.absent(),
    this.lifeStage = const Value.absent(),
    this.contextKeysJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.redFlagsJson = const Value.absent(),
    this.suggestedActionsJson = const Value.absent(),
    this.reviewedStatus = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       summary = Value(summary),
       body = Value(body),
       updatedAt = Value(updatedAt);
  static Insertable<KnowledgeArticle> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? summary,
    Expression<String>? body,
    Expression<String>? severityLevel,
    Expression<String>? species,
    Expression<String>? lifeStage,
    Expression<String>? contextKeysJson,
    Expression<String>? tagsJson,
    Expression<String>? redFlagsJson,
    Expression<String>? suggestedActionsJson,
    Expression<String>? reviewedStatus,
    Expression<String>? version,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (body != null) 'body': body,
      if (severityLevel != null) 'severity_level': severityLevel,
      if (species != null) 'species': species,
      if (lifeStage != null) 'life_stage': lifeStage,
      if (contextKeysJson != null) 'context_keys_json': contextKeysJson,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (redFlagsJson != null) 'red_flags_json': redFlagsJson,
      if (suggestedActionsJson != null)
        'suggested_actions_json': suggestedActionsJson,
      if (reviewedStatus != null) 'reviewed_status': reviewedStatus,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeArticlesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? category,
    Value<String>? summary,
    Value<String>? body,
    Value<String>? severityLevel,
    Value<String>? species,
    Value<String>? lifeStage,
    Value<String>? contextKeysJson,
    Value<String>? tagsJson,
    Value<String>? redFlagsJson,
    Value<String>? suggestedActionsJson,
    Value<String>? reviewedStatus,
    Value<String>? version,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KnowledgeArticlesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      severityLevel: severityLevel ?? this.severityLevel,
      species: species ?? this.species,
      lifeStage: lifeStage ?? this.lifeStage,
      contextKeysJson: contextKeysJson ?? this.contextKeysJson,
      tagsJson: tagsJson ?? this.tagsJson,
      redFlagsJson: redFlagsJson ?? this.redFlagsJson,
      suggestedActionsJson: suggestedActionsJson ?? this.suggestedActionsJson,
      reviewedStatus: reviewedStatus ?? this.reviewedStatus,
      version: version ?? this.version,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (severityLevel.present) {
      map['severity_level'] = Variable<String>(severityLevel.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (lifeStage.present) {
      map['life_stage'] = Variable<String>(lifeStage.value);
    }
    if (contextKeysJson.present) {
      map['context_keys_json'] = Variable<String>(contextKeysJson.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (redFlagsJson.present) {
      map['red_flags_json'] = Variable<String>(redFlagsJson.value);
    }
    if (suggestedActionsJson.present) {
      map['suggested_actions_json'] = Variable<String>(
        suggestedActionsJson.value,
      );
    }
    if (reviewedStatus.present) {
      map['reviewed_status'] = Variable<String>(reviewedStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeArticlesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('body: $body, ')
          ..write('severityLevel: $severityLevel, ')
          ..write('species: $species, ')
          ..write('lifeStage: $lifeStage, ')
          ..write('contextKeysJson: $contextKeysJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('redFlagsJson: $redFlagsJson, ')
          ..write('suggestedActionsJson: $suggestedActionsJson, ')
          ..write('reviewedStatus: $reviewedStatus, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeSourcesTable extends KnowledgeSources
    with TableInfo<$KnowledgeSourcesTable, KnowledgeSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _organizationMeta = const VerificationMeta(
    'organization',
  );
  @override
  late final GeneratedColumn<String> organization = GeneratedColumn<String>(
    'organization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseNoteMeta = const VerificationMeta(
    'licenseNote',
  );
  @override
  late final GeneratedColumn<String> licenseNote = GeneratedColumn<String>(
    'license_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _accessedAtMeta = const VerificationMeta(
    'accessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> accessedAt = GeneratedColumn<DateTime>(
    'accessed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    organization,
    url,
    licenseNote,
    accessedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('organization')) {
      context.handle(
        _organizationMeta,
        organization.isAcceptableOrUnknown(
          data['organization']!,
          _organizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('license_note')) {
      context.handle(
        _licenseNoteMeta,
        licenseNote.isAcceptableOrUnknown(
          data['license_note']!,
          _licenseNoteMeta,
        ),
      );
    }
    if (data.containsKey('accessed_at')) {
      context.handle(
        _accessedAtMeta,
        accessedAt.isAcceptableOrUnknown(data['accessed_at']!, _accessedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_accessedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      organization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      licenseNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_note'],
      )!,
      accessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accessed_at'],
      )!,
    );
  }

  @override
  $KnowledgeSourcesTable createAlias(String alias) {
    return $KnowledgeSourcesTable(attachedDatabase, alias);
  }
}

class KnowledgeSource extends DataClass implements Insertable<KnowledgeSource> {
  final String id;
  final String title;
  final String organization;
  final String url;
  final String licenseNote;
  final DateTime accessedAt;
  const KnowledgeSource({
    required this.id,
    required this.title,
    required this.organization,
    required this.url,
    required this.licenseNote,
    required this.accessedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['organization'] = Variable<String>(organization);
    map['url'] = Variable<String>(url);
    map['license_note'] = Variable<String>(licenseNote);
    map['accessed_at'] = Variable<DateTime>(accessedAt);
    return map;
  }

  KnowledgeSourcesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeSourcesCompanion(
      id: Value(id),
      title: Value(title),
      organization: Value(organization),
      url: Value(url),
      licenseNote: Value(licenseNote),
      accessedAt: Value(accessedAt),
    );
  }

  factory KnowledgeSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeSource(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      organization: serializer.fromJson<String>(json['organization']),
      url: serializer.fromJson<String>(json['url']),
      licenseNote: serializer.fromJson<String>(json['licenseNote']),
      accessedAt: serializer.fromJson<DateTime>(json['accessedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'organization': serializer.toJson<String>(organization),
      'url': serializer.toJson<String>(url),
      'licenseNote': serializer.toJson<String>(licenseNote),
      'accessedAt': serializer.toJson<DateTime>(accessedAt),
    };
  }

  KnowledgeSource copyWith({
    String? id,
    String? title,
    String? organization,
    String? url,
    String? licenseNote,
    DateTime? accessedAt,
  }) => KnowledgeSource(
    id: id ?? this.id,
    title: title ?? this.title,
    organization: organization ?? this.organization,
    url: url ?? this.url,
    licenseNote: licenseNote ?? this.licenseNote,
    accessedAt: accessedAt ?? this.accessedAt,
  );
  KnowledgeSource copyWithCompanion(KnowledgeSourcesCompanion data) {
    return KnowledgeSource(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      organization: data.organization.present
          ? data.organization.value
          : this.organization,
      url: data.url.present ? data.url.value : this.url,
      licenseNote: data.licenseNote.present
          ? data.licenseNote.value
          : this.licenseNote,
      accessedAt: data.accessedAt.present
          ? data.accessedAt.value
          : this.accessedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSource(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('organization: $organization, ')
          ..write('url: $url, ')
          ..write('licenseNote: $licenseNote, ')
          ..write('accessedAt: $accessedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, organization, url, licenseNote, accessedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeSource &&
          other.id == this.id &&
          other.title == this.title &&
          other.organization == this.organization &&
          other.url == this.url &&
          other.licenseNote == this.licenseNote &&
          other.accessedAt == this.accessedAt);
}

class KnowledgeSourcesCompanion extends UpdateCompanion<KnowledgeSource> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> organization;
  final Value<String> url;
  final Value<String> licenseNote;
  final Value<DateTime> accessedAt;
  final Value<int> rowid;
  const KnowledgeSourcesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.organization = const Value.absent(),
    this.url = const Value.absent(),
    this.licenseNote = const Value.absent(),
    this.accessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeSourcesCompanion.insert({
    required String id,
    required String title,
    required String organization,
    required String url,
    this.licenseNote = const Value.absent(),
    required DateTime accessedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       organization = Value(organization),
       url = Value(url),
       accessedAt = Value(accessedAt);
  static Insertable<KnowledgeSource> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? organization,
    Expression<String>? url,
    Expression<String>? licenseNote,
    Expression<DateTime>? accessedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (organization != null) 'organization': organization,
      if (url != null) 'url': url,
      if (licenseNote != null) 'license_note': licenseNote,
      if (accessedAt != null) 'accessed_at': accessedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? organization,
    Value<String>? url,
    Value<String>? licenseNote,
    Value<DateTime>? accessedAt,
    Value<int>? rowid,
  }) {
    return KnowledgeSourcesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      url: url ?? this.url,
      licenseNote: licenseNote ?? this.licenseNote,
      accessedAt: accessedAt ?? this.accessedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String>(organization.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (licenseNote.present) {
      map['license_note'] = Variable<String>(licenseNote.value);
    }
    if (accessedAt.present) {
      map['accessed_at'] = Variable<DateTime>(accessedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSourcesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('organization: $organization, ')
          ..write('url: $url, ')
          ..write('licenseNote: $licenseNote, ')
          ..write('accessedAt: $accessedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeArticleSourcesTable extends KnowledgeArticleSources
    with TableInfo<$KnowledgeArticleSourcesTable, KnowledgeArticleSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeArticleSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_articles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_sources (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [articleId, sourceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_article_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeArticleSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId, sourceId};
  @override
  KnowledgeArticleSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeArticleSource(
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
    );
  }

  @override
  $KnowledgeArticleSourcesTable createAlias(String alias) {
    return $KnowledgeArticleSourcesTable(attachedDatabase, alias);
  }
}

class KnowledgeArticleSource extends DataClass
    implements Insertable<KnowledgeArticleSource> {
  final String articleId;
  final String sourceId;
  const KnowledgeArticleSource({
    required this.articleId,
    required this.sourceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<String>(articleId);
    map['source_id'] = Variable<String>(sourceId);
    return map;
  }

  KnowledgeArticleSourcesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeArticleSourcesCompanion(
      articleId: Value(articleId),
      sourceId: Value(sourceId),
    );
  }

  factory KnowledgeArticleSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeArticleSource(
      articleId: serializer.fromJson<String>(json['articleId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<String>(articleId),
      'sourceId': serializer.toJson<String>(sourceId),
    };
  }

  KnowledgeArticleSource copyWith({String? articleId, String? sourceId}) =>
      KnowledgeArticleSource(
        articleId: articleId ?? this.articleId,
        sourceId: sourceId ?? this.sourceId,
      );
  KnowledgeArticleSource copyWithCompanion(
    KnowledgeArticleSourcesCompanion data,
  ) {
    return KnowledgeArticleSource(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeArticleSource(')
          ..write('articleId: $articleId, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, sourceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeArticleSource &&
          other.articleId == this.articleId &&
          other.sourceId == this.sourceId);
}

class KnowledgeArticleSourcesCompanion
    extends UpdateCompanion<KnowledgeArticleSource> {
  final Value<String> articleId;
  final Value<String> sourceId;
  final Value<int> rowid;
  const KnowledgeArticleSourcesCompanion({
    this.articleId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeArticleSourcesCompanion.insert({
    required String articleId,
    required String sourceId,
    this.rowid = const Value.absent(),
  }) : articleId = Value(articleId),
       sourceId = Value(sourceId);
  static Insertable<KnowledgeArticleSource> custom({
    Expression<String>? articleId,
    Expression<String>? sourceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (sourceId != null) 'source_id': sourceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeArticleSourcesCompanion copyWith({
    Value<String>? articleId,
    Value<String>? sourceId,
    Value<int>? rowid,
  }) {
    return KnowledgeArticleSourcesCompanion(
      articleId: articleId ?? this.articleId,
      sourceId: sourceId ?? this.sourceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeArticleSourcesCompanion(')
          ..write('articleId: $articleId, ')
          ..write('sourceId: $sourceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeVersionsTable extends KnowledgeVersions
    with TableInfo<$KnowledgeVersionsTable, KnowledgeVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('global'),
  );
  static const VerificationMeta _releasedAtMeta = const VerificationMeta(
    'releasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> releasedAt = GeneratedColumn<DateTime>(
    'released_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    region,
    releasedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('released_at')) {
      context.handle(
        _releasedAtMeta,
        releasedAt.isAcceptableOrUnknown(data['released_at']!, _releasedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_releasedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      releasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}released_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $KnowledgeVersionsTable createAlias(String alias) {
    return $KnowledgeVersionsTable(attachedDatabase, alias);
  }
}

class KnowledgeVersion extends DataClass
    implements Insertable<KnowledgeVersion> {
  final String id;
  final String version;
  final String region;
  final DateTime releasedAt;
  final String notes;
  const KnowledgeVersion({
    required this.id,
    required this.version,
    required this.region,
    required this.releasedAt,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<String>(version);
    map['region'] = Variable<String>(region);
    map['released_at'] = Variable<DateTime>(releasedAt);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  KnowledgeVersionsCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeVersionsCompanion(
      id: Value(id),
      version: Value(version),
      region: Value(region),
      releasedAt: Value(releasedAt),
      notes: Value(notes),
    );
  }

  factory KnowledgeVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeVersion(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      region: serializer.fromJson<String>(json['region']),
      releasedAt: serializer.fromJson<DateTime>(json['releasedAt']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<String>(version),
      'region': serializer.toJson<String>(region),
      'releasedAt': serializer.toJson<DateTime>(releasedAt),
      'notes': serializer.toJson<String>(notes),
    };
  }

  KnowledgeVersion copyWith({
    String? id,
    String? version,
    String? region,
    DateTime? releasedAt,
    String? notes,
  }) => KnowledgeVersion(
    id: id ?? this.id,
    version: version ?? this.version,
    region: region ?? this.region,
    releasedAt: releasedAt ?? this.releasedAt,
    notes: notes ?? this.notes,
  );
  KnowledgeVersion copyWithCompanion(KnowledgeVersionsCompanion data) {
    return KnowledgeVersion(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      region: data.region.present ? data.region.value : this.region,
      releasedAt: data.releasedAt.present
          ? data.releasedAt.value
          : this.releasedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeVersion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('region: $region, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, region, releasedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeVersion &&
          other.id == this.id &&
          other.version == this.version &&
          other.region == this.region &&
          other.releasedAt == this.releasedAt &&
          other.notes == this.notes);
}

class KnowledgeVersionsCompanion extends UpdateCompanion<KnowledgeVersion> {
  final Value<String> id;
  final Value<String> version;
  final Value<String> region;
  final Value<DateTime> releasedAt;
  final Value<String> notes;
  final Value<int> rowid;
  const KnowledgeVersionsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.region = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeVersionsCompanion.insert({
    required String id,
    required String version,
    this.region = const Value.absent(),
    required DateTime releasedAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       releasedAt = Value(releasedAt);
  static Insertable<KnowledgeVersion> custom({
    Expression<String>? id,
    Expression<String>? version,
    Expression<String>? region,
    Expression<DateTime>? releasedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (region != null) 'region': region,
      if (releasedAt != null) 'released_at': releasedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? version,
    Value<String>? region,
    Value<DateTime>? releasedAt,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return KnowledgeVersionsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      region: region ?? this.region,
      releasedAt: releasedAt ?? this.releasedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (releasedAt.present) {
      map['released_at'] = Variable<DateTime>(releasedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeVersionsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('region: $region, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$KnowledgeDatabase extends GeneratedDatabase {
  _$KnowledgeDatabase(QueryExecutor e) : super(e);
  $KnowledgeDatabaseManager get managers => $KnowledgeDatabaseManager(this);
  late final $KnowledgeArticlesTable knowledgeArticles =
      $KnowledgeArticlesTable(this);
  late final $KnowledgeSourcesTable knowledgeSources = $KnowledgeSourcesTable(
    this,
  );
  late final $KnowledgeArticleSourcesTable knowledgeArticleSources =
      $KnowledgeArticleSourcesTable(this);
  late final $KnowledgeVersionsTable knowledgeVersions =
      $KnowledgeVersionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    knowledgeArticles,
    knowledgeSources,
    knowledgeArticleSources,
    knowledgeVersions,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_articles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('knowledge_article_sources', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('knowledge_article_sources', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$KnowledgeArticlesTableCreateCompanionBuilder =
    KnowledgeArticlesCompanion Function({
      required String id,
      required String title,
      required String category,
      required String summary,
      required String body,
      Value<String> severityLevel,
      Value<String> species,
      Value<String> lifeStage,
      Value<String> contextKeysJson,
      Value<String> tagsJson,
      Value<String> redFlagsJson,
      Value<String> suggestedActionsJson,
      Value<String> reviewedStatus,
      Value<String> version,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$KnowledgeArticlesTableUpdateCompanionBuilder =
    KnowledgeArticlesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> category,
      Value<String> summary,
      Value<String> body,
      Value<String> severityLevel,
      Value<String> species,
      Value<String> lifeStage,
      Value<String> contextKeysJson,
      Value<String> tagsJson,
      Value<String> redFlagsJson,
      Value<String> suggestedActionsJson,
      Value<String> reviewedStatus,
      Value<String> version,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$KnowledgeArticlesTableReferences
    extends
        BaseReferences<
          _$KnowledgeDatabase,
          $KnowledgeArticlesTable,
          KnowledgeArticle
        > {
  $$KnowledgeArticlesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $KnowledgeArticleSourcesTable,
    List<KnowledgeArticleSource>
  >
  _knowledgeArticleSourcesRefsTable(_$KnowledgeDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.knowledgeArticleSources,
        aliasName:
            'knowledge_articles__id__knowledge_article_sources__article_id',
      );

  $$KnowledgeArticleSourcesTableProcessedTableManager
  get knowledgeArticleSourcesRefs {
    final manager = $$KnowledgeArticleSourcesTableTableManager(
      $_db,
      $_db.knowledgeArticleSources,
    ).filter((f) => f.articleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _knowledgeArticleSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KnowledgeArticlesTableFilterComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticlesTable> {
  $$KnowledgeArticlesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severityLevel => $composableBuilder(
    column: $table.severityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lifeStage => $composableBuilder(
    column: $table.lifeStage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextKeysJson => $composableBuilder(
    column: $table.contextKeysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get redFlagsJson => $composableBuilder(
    column: $table.redFlagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedActionsJson => $composableBuilder(
    column: $table.suggestedActionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewedStatus => $composableBuilder(
    column: $table.reviewedStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> knowledgeArticleSourcesRefs(
    Expression<bool> Function($$KnowledgeArticleSourcesTableFilterComposer f) f,
  ) {
    final $$KnowledgeArticleSourcesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeArticleSources,
          getReferencedColumn: (t) => t.articleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeArticleSourcesTableFilterComposer(
                $db: $db,
                $table: $db.knowledgeArticleSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeArticlesTableOrderingComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticlesTable> {
  $$KnowledgeArticlesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severityLevel => $composableBuilder(
    column: $table.severityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifeStage => $composableBuilder(
    column: $table.lifeStage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextKeysJson => $composableBuilder(
    column: $table.contextKeysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get redFlagsJson => $composableBuilder(
    column: $table.redFlagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedActionsJson => $composableBuilder(
    column: $table.suggestedActionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewedStatus => $composableBuilder(
    column: $table.reviewedStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeArticlesTableAnnotationComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticlesTable> {
  $$KnowledgeArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get severityLevel => $composableBuilder(
    column: $table.severityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get lifeStage =>
      $composableBuilder(column: $table.lifeStage, builder: (column) => column);

  GeneratedColumn<String> get contextKeysJson => $composableBuilder(
    column: $table.contextKeysJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get redFlagsJson => $composableBuilder(
    column: $table.redFlagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedActionsJson => $composableBuilder(
    column: $table.suggestedActionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewedStatus => $composableBuilder(
    column: $table.reviewedStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> knowledgeArticleSourcesRefs<T extends Object>(
    Expression<T> Function($$KnowledgeArticleSourcesTableAnnotationComposer a)
    f,
  ) {
    final $$KnowledgeArticleSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeArticleSources,
          getReferencedColumn: (t) => t.articleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeArticleSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeArticleSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeArticlesTableTableManager
    extends
        RootTableManager<
          _$KnowledgeDatabase,
          $KnowledgeArticlesTable,
          KnowledgeArticle,
          $$KnowledgeArticlesTableFilterComposer,
          $$KnowledgeArticlesTableOrderingComposer,
          $$KnowledgeArticlesTableAnnotationComposer,
          $$KnowledgeArticlesTableCreateCompanionBuilder,
          $$KnowledgeArticlesTableUpdateCompanionBuilder,
          (KnowledgeArticle, $$KnowledgeArticlesTableReferences),
          KnowledgeArticle,
          PrefetchHooks Function({bool knowledgeArticleSourcesRefs})
        > {
  $$KnowledgeArticlesTableTableManager(
    _$KnowledgeDatabase db,
    $KnowledgeArticlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeArticlesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> severityLevel = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<String> lifeStage = const Value.absent(),
                Value<String> contextKeysJson = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> redFlagsJson = const Value.absent(),
                Value<String> suggestedActionsJson = const Value.absent(),
                Value<String> reviewedStatus = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeArticlesCompanion(
                id: id,
                title: title,
                category: category,
                summary: summary,
                body: body,
                severityLevel: severityLevel,
                species: species,
                lifeStage: lifeStage,
                contextKeysJson: contextKeysJson,
                tagsJson: tagsJson,
                redFlagsJson: redFlagsJson,
                suggestedActionsJson: suggestedActionsJson,
                reviewedStatus: reviewedStatus,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String category,
                required String summary,
                required String body,
                Value<String> severityLevel = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<String> lifeStage = const Value.absent(),
                Value<String> contextKeysJson = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> redFlagsJson = const Value.absent(),
                Value<String> suggestedActionsJson = const Value.absent(),
                Value<String> reviewedStatus = const Value.absent(),
                Value<String> version = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeArticlesCompanion.insert(
                id: id,
                title: title,
                category: category,
                summary: summary,
                body: body,
                severityLevel: severityLevel,
                species: species,
                lifeStage: lifeStage,
                contextKeysJson: contextKeysJson,
                tagsJson: tagsJson,
                redFlagsJson: redFlagsJson,
                suggestedActionsJson: suggestedActionsJson,
                reviewedStatus: reviewedStatus,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeArticlesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({knowledgeArticleSourcesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (knowledgeArticleSourcesRefs) db.knowledgeArticleSources,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (knowledgeArticleSourcesRefs)
                    await $_getPrefetchedData<
                      KnowledgeArticle,
                      $KnowledgeArticlesTable,
                      KnowledgeArticleSource
                    >(
                      currentTable: table,
                      referencedTable: $$KnowledgeArticlesTableReferences
                          ._knowledgeArticleSourcesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KnowledgeArticlesTableReferences(
                            db,
                            table,
                            p0,
                          ).knowledgeArticleSourcesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.articleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KnowledgeArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$KnowledgeDatabase,
      $KnowledgeArticlesTable,
      KnowledgeArticle,
      $$KnowledgeArticlesTableFilterComposer,
      $$KnowledgeArticlesTableOrderingComposer,
      $$KnowledgeArticlesTableAnnotationComposer,
      $$KnowledgeArticlesTableCreateCompanionBuilder,
      $$KnowledgeArticlesTableUpdateCompanionBuilder,
      (KnowledgeArticle, $$KnowledgeArticlesTableReferences),
      KnowledgeArticle,
      PrefetchHooks Function({bool knowledgeArticleSourcesRefs})
    >;
typedef $$KnowledgeSourcesTableCreateCompanionBuilder =
    KnowledgeSourcesCompanion Function({
      required String id,
      required String title,
      required String organization,
      required String url,
      Value<String> licenseNote,
      required DateTime accessedAt,
      Value<int> rowid,
    });
typedef $$KnowledgeSourcesTableUpdateCompanionBuilder =
    KnowledgeSourcesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> organization,
      Value<String> url,
      Value<String> licenseNote,
      Value<DateTime> accessedAt,
      Value<int> rowid,
    });

final class $$KnowledgeSourcesTableReferences
    extends
        BaseReferences<
          _$KnowledgeDatabase,
          $KnowledgeSourcesTable,
          KnowledgeSource
        > {
  $$KnowledgeSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $KnowledgeArticleSourcesTable,
    List<KnowledgeArticleSource>
  >
  _knowledgeArticleSourcesRefsTable(_$KnowledgeDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.knowledgeArticleSources,
        aliasName:
            'knowledge_sources__id__knowledge_article_sources__source_id',
      );

  $$KnowledgeArticleSourcesTableProcessedTableManager
  get knowledgeArticleSourcesRefs {
    final manager = $$KnowledgeArticleSourcesTableTableManager(
      $_db,
      $_db.knowledgeArticleSources,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _knowledgeArticleSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KnowledgeSourcesTableFilterComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeSourcesTable> {
  $$KnowledgeSourcesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseNote => $composableBuilder(
    column: $table.licenseNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> knowledgeArticleSourcesRefs(
    Expression<bool> Function($$KnowledgeArticleSourcesTableFilterComposer f) f,
  ) {
    final $$KnowledgeArticleSourcesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeArticleSources,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeArticleSourcesTableFilterComposer(
                $db: $db,
                $table: $db.knowledgeArticleSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeSourcesTableOrderingComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeSourcesTable> {
  $$KnowledgeSourcesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseNote => $composableBuilder(
    column: $table.licenseNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeSourcesTableAnnotationComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeSourcesTable> {
  $$KnowledgeSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get licenseNote => $composableBuilder(
    column: $table.licenseNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => column,
  );

  Expression<T> knowledgeArticleSourcesRefs<T extends Object>(
    Expression<T> Function($$KnowledgeArticleSourcesTableAnnotationComposer a)
    f,
  ) {
    final $$KnowledgeArticleSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeArticleSources,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeArticleSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeArticleSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeSourcesTableTableManager
    extends
        RootTableManager<
          _$KnowledgeDatabase,
          $KnowledgeSourcesTable,
          KnowledgeSource,
          $$KnowledgeSourcesTableFilterComposer,
          $$KnowledgeSourcesTableOrderingComposer,
          $$KnowledgeSourcesTableAnnotationComposer,
          $$KnowledgeSourcesTableCreateCompanionBuilder,
          $$KnowledgeSourcesTableUpdateCompanionBuilder,
          (KnowledgeSource, $$KnowledgeSourcesTableReferences),
          KnowledgeSource,
          PrefetchHooks Function({bool knowledgeArticleSourcesRefs})
        > {
  $$KnowledgeSourcesTableTableManager(
    _$KnowledgeDatabase db,
    $KnowledgeSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> organization = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> licenseNote = const Value.absent(),
                Value<DateTime> accessedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeSourcesCompanion(
                id: id,
                title: title,
                organization: organization,
                url: url,
                licenseNote: licenseNote,
                accessedAt: accessedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String organization,
                required String url,
                Value<String> licenseNote = const Value.absent(),
                required DateTime accessedAt,
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeSourcesCompanion.insert(
                id: id,
                title: title,
                organization: organization,
                url: url,
                licenseNote: licenseNote,
                accessedAt: accessedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({knowledgeArticleSourcesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (knowledgeArticleSourcesRefs) db.knowledgeArticleSources,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (knowledgeArticleSourcesRefs)
                    await $_getPrefetchedData<
                      KnowledgeSource,
                      $KnowledgeSourcesTable,
                      KnowledgeArticleSource
                    >(
                      currentTable: table,
                      referencedTable: $$KnowledgeSourcesTableReferences
                          ._knowledgeArticleSourcesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KnowledgeSourcesTableReferences(
                            db,
                            table,
                            p0,
                          ).knowledgeArticleSourcesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sourceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KnowledgeSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$KnowledgeDatabase,
      $KnowledgeSourcesTable,
      KnowledgeSource,
      $$KnowledgeSourcesTableFilterComposer,
      $$KnowledgeSourcesTableOrderingComposer,
      $$KnowledgeSourcesTableAnnotationComposer,
      $$KnowledgeSourcesTableCreateCompanionBuilder,
      $$KnowledgeSourcesTableUpdateCompanionBuilder,
      (KnowledgeSource, $$KnowledgeSourcesTableReferences),
      KnowledgeSource,
      PrefetchHooks Function({bool knowledgeArticleSourcesRefs})
    >;
typedef $$KnowledgeArticleSourcesTableCreateCompanionBuilder =
    KnowledgeArticleSourcesCompanion Function({
      required String articleId,
      required String sourceId,
      Value<int> rowid,
    });
typedef $$KnowledgeArticleSourcesTableUpdateCompanionBuilder =
    KnowledgeArticleSourcesCompanion Function({
      Value<String> articleId,
      Value<String> sourceId,
      Value<int> rowid,
    });

final class $$KnowledgeArticleSourcesTableReferences
    extends
        BaseReferences<
          _$KnowledgeDatabase,
          $KnowledgeArticleSourcesTable,
          KnowledgeArticleSource
        > {
  $$KnowledgeArticleSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KnowledgeArticlesTable _articleIdTable(_$KnowledgeDatabase db) =>
      db.knowledgeArticles.createAlias(
        'knowledge_article_sources__article_id__knowledge_articles__id',
      );

  $$KnowledgeArticlesTableProcessedTableManager get articleId {
    final $_column = $_itemColumn<String>('article_id')!;

    final manager = $$KnowledgeArticlesTableTableManager(
      $_db,
      $_db.knowledgeArticles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_articleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KnowledgeSourcesTable _sourceIdTable(_$KnowledgeDatabase db) =>
      db.knowledgeSources.createAlias(
        'knowledge_article_sources__source_id__knowledge_sources__id',
      );

  $$KnowledgeSourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$KnowledgeSourcesTableTableManager(
      $_db,
      $_db.knowledgeSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KnowledgeArticleSourcesTableFilterComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticleSourcesTable> {
  $$KnowledgeArticleSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$KnowledgeArticlesTableFilterComposer get articleId {
    final $$KnowledgeArticlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.articleId,
      referencedTable: $db.knowledgeArticles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeArticlesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeArticles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeSourcesTableFilterComposer get sourceId {
    final $$KnowledgeSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.knowledgeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeSourcesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeArticleSourcesTableOrderingComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticleSourcesTable> {
  $$KnowledgeArticleSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$KnowledgeArticlesTableOrderingComposer get articleId {
    final $$KnowledgeArticlesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.articleId,
      referencedTable: $db.knowledgeArticles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeArticlesTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeArticles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeSourcesTableOrderingComposer get sourceId {
    final $$KnowledgeSourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.knowledgeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeSourcesTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeArticleSourcesTableAnnotationComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeArticleSourcesTable> {
  $$KnowledgeArticleSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$KnowledgeArticlesTableAnnotationComposer get articleId {
    final $$KnowledgeArticlesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.articleId,
          referencedTable: $db.knowledgeArticles,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeArticlesTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeArticles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$KnowledgeSourcesTableAnnotationComposer get sourceId {
    final $$KnowledgeSourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.knowledgeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeSourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.knowledgeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeArticleSourcesTableTableManager
    extends
        RootTableManager<
          _$KnowledgeDatabase,
          $KnowledgeArticleSourcesTable,
          KnowledgeArticleSource,
          $$KnowledgeArticleSourcesTableFilterComposer,
          $$KnowledgeArticleSourcesTableOrderingComposer,
          $$KnowledgeArticleSourcesTableAnnotationComposer,
          $$KnowledgeArticleSourcesTableCreateCompanionBuilder,
          $$KnowledgeArticleSourcesTableUpdateCompanionBuilder,
          (KnowledgeArticleSource, $$KnowledgeArticleSourcesTableReferences),
          KnowledgeArticleSource,
          PrefetchHooks Function({bool articleId, bool sourceId})
        > {
  $$KnowledgeArticleSourcesTableTableManager(
    _$KnowledgeDatabase db,
    $KnowledgeArticleSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeArticleSourcesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$KnowledgeArticleSourcesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KnowledgeArticleSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> articleId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeArticleSourcesCompanion(
                articleId: articleId,
                sourceId: sourceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String articleId,
                required String sourceId,
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeArticleSourcesCompanion.insert(
                articleId: articleId,
                sourceId: sourceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeArticleSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({articleId = false, sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (articleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.articleId,
                                referencedTable:
                                    $$KnowledgeArticleSourcesTableReferences
                                        ._articleIdTable(db),
                                referencedColumn:
                                    $$KnowledgeArticleSourcesTableReferences
                                        ._articleIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$KnowledgeArticleSourcesTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$KnowledgeArticleSourcesTableReferences
                                        ._sourceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KnowledgeArticleSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$KnowledgeDatabase,
      $KnowledgeArticleSourcesTable,
      KnowledgeArticleSource,
      $$KnowledgeArticleSourcesTableFilterComposer,
      $$KnowledgeArticleSourcesTableOrderingComposer,
      $$KnowledgeArticleSourcesTableAnnotationComposer,
      $$KnowledgeArticleSourcesTableCreateCompanionBuilder,
      $$KnowledgeArticleSourcesTableUpdateCompanionBuilder,
      (KnowledgeArticleSource, $$KnowledgeArticleSourcesTableReferences),
      KnowledgeArticleSource,
      PrefetchHooks Function({bool articleId, bool sourceId})
    >;
typedef $$KnowledgeVersionsTableCreateCompanionBuilder =
    KnowledgeVersionsCompanion Function({
      required String id,
      required String version,
      Value<String> region,
      required DateTime releasedAt,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$KnowledgeVersionsTableUpdateCompanionBuilder =
    KnowledgeVersionsCompanion Function({
      Value<String> id,
      Value<String> version,
      Value<String> region,
      Value<DateTime> releasedAt,
      Value<String> notes,
      Value<int> rowid,
    });

class $$KnowledgeVersionsTableFilterComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeVersionsTable> {
  $$KnowledgeVersionsTableFilterComposer({
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

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnowledgeVersionsTableOrderingComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeVersionsTable> {
  $$KnowledgeVersionsTableOrderingComposer({
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

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeVersionsTableAnnotationComposer
    extends Composer<_$KnowledgeDatabase, $KnowledgeVersionsTable> {
  $$KnowledgeVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$KnowledgeVersionsTableTableManager
    extends
        RootTableManager<
          _$KnowledgeDatabase,
          $KnowledgeVersionsTable,
          KnowledgeVersion,
          $$KnowledgeVersionsTableFilterComposer,
          $$KnowledgeVersionsTableOrderingComposer,
          $$KnowledgeVersionsTableAnnotationComposer,
          $$KnowledgeVersionsTableCreateCompanionBuilder,
          $$KnowledgeVersionsTableUpdateCompanionBuilder,
          (
            KnowledgeVersion,
            BaseReferences<
              _$KnowledgeDatabase,
              $KnowledgeVersionsTable,
              KnowledgeVersion
            >,
          ),
          KnowledgeVersion,
          PrefetchHooks Function()
        > {
  $$KnowledgeVersionsTableTableManager(
    _$KnowledgeDatabase db,
    $KnowledgeVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<DateTime> releasedAt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeVersionsCompanion(
                id: id,
                version: version,
                region: region,
                releasedAt: releasedAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String version,
                Value<String> region = const Value.absent(),
                required DateTime releasedAt,
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeVersionsCompanion.insert(
                id: id,
                version: version,
                region: region,
                releasedAt: releasedAt,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnowledgeVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$KnowledgeDatabase,
      $KnowledgeVersionsTable,
      KnowledgeVersion,
      $$KnowledgeVersionsTableFilterComposer,
      $$KnowledgeVersionsTableOrderingComposer,
      $$KnowledgeVersionsTableAnnotationComposer,
      $$KnowledgeVersionsTableCreateCompanionBuilder,
      $$KnowledgeVersionsTableUpdateCompanionBuilder,
      (
        KnowledgeVersion,
        BaseReferences<
          _$KnowledgeDatabase,
          $KnowledgeVersionsTable,
          KnowledgeVersion
        >,
      ),
      KnowledgeVersion,
      PrefetchHooks Function()
    >;

class $KnowledgeDatabaseManager {
  final _$KnowledgeDatabase _db;
  $KnowledgeDatabaseManager(this._db);
  $$KnowledgeArticlesTableTableManager get knowledgeArticles =>
      $$KnowledgeArticlesTableTableManager(_db, _db.knowledgeArticles);
  $$KnowledgeSourcesTableTableManager get knowledgeSources =>
      $$KnowledgeSourcesTableTableManager(_db, _db.knowledgeSources);
  $$KnowledgeArticleSourcesTableTableManager get knowledgeArticleSources =>
      $$KnowledgeArticleSourcesTableTableManager(
        _db,
        _db.knowledgeArticleSources,
      );
  $$KnowledgeVersionsTableTableManager get knowledgeVersions =>
      $$KnowledgeVersionsTableTableManager(_db, _db.knowledgeVersions);
}
