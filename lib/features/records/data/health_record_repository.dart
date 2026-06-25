import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../domain/health_record.dart';
import '../domain/health_record_filter.dart';

final healthRecordRepositoryProvider = Provider<HealthRecordRepository>((ref) {
  return HealthRecordRepository(ref.watch(appDatabaseProvider));
});

/// 按筛选条件实时返回健康记录列表。
///
/// ```dart
/// final records = ref.watch(filteredHealthRecordsProvider(
///   HealthRecordFilter(petId: petId, type: 'weight', limit: 20),
/// ));
/// ```
final filteredHealthRecordsProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, HealthRecordFilter>((ref, filter) {
      return ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(
            filter.petId,
            type: filter.type,
            from: filter.from,
            to: filter.to,
            keyword: filter.keyword,
            limit: filter.limit,
            offset: filter.offset,
          );
    });

class HealthRecordRepository {
  HealthRecordRepository(this._database) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final Uuid _uuid;

  Stream<List<HealthRecord>> watchForPet(
    String petId, {
    String? type,
    DateTime? from,
    DateTime? to,
    String? keyword,
    int? limit,
    int offset = 0,
  }) {
    _validateQuery(
      type: type,
      from: from,
      to: to,
      limit: limit,
      offset: offset,
    );
    final search = keyword?.trim();
    final query = _database.select(_database.healthRecords)
      ..where((record) {
        var expression = record.petId.equals(petId);
        if (type != null) expression &= record.type.equals(type);
        if (from != null) {
          expression &= record.occurredAt.isBiggerOrEqualValue(from.toUtc());
        }
        if (to != null) {
          expression &= record.occurredAt.isSmallerThanValue(to.toUtc());
        }
        if (search != null && search.isNotEmpty) {
          expression &=
              record.title.contains(search) | record.note.contains(search);
        }
        return expression;
      })
      ..orderBy([(record) => OrderingTerm.desc(record.occurredAt)]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().map(
      (rows) => rows.map(_recordFromRow).toList(growable: false),
    );
  }

  Future<List<HealthRecord>> findForPet(
    String petId, {
    String? type,
    DateTime? from,
    DateTime? to,
    String? keyword,
    int? limit,
    int offset = 0,
  }) {
    return watchForPet(
      petId,
      type: type,
      from: from,
      to: to,
      keyword: keyword,
      limit: limit,
      offset: offset,
    ).first;
  }

  Future<HealthRecord?> getById(String id) async {
    final row = await (_database.select(
      _database.healthRecords,
    )..where((record) => record.id.equals(id))).getSingleOrNull();
    return row == null ? null : _recordFromRow(row);
  }

  Future<HealthRecord> create(HealthRecordDraft draft) => save(draft);

  Future<HealthRecord> update(String id, HealthRecordDraft draft) async {
    if (await getById(id) == null) {
      throw StateError('健康记录不存在：$id');
    }
    return save(draft, id: id);
  }

  Future<HealthRecord> save(HealthRecordDraft draft, {String? id}) async {
    _validate(draft);
    final now = DateTime.now().toUtc();
    final targetId = id ?? _uuid.v4();
    final existing = await (_database.select(
      _database.healthRecords,
    )..where((record) => record.id.equals(targetId))).getSingleOrNull();

    await _database
        .into(_database.healthRecords)
        .insertOnConflictUpdate(
          db.HealthRecordsCompanion(
            id: Value(targetId),
            petId: Value(draft.petId),
            type: Value(draft.type),
            occurredAt: Value(draft.occurredAt.toUtc()),
            title: Value(draft.title.trim()),
            note: Value(draft.note.trim()),
            numericValue: Value(draft.numericValue),
            unit: Value(_trimmedOrNull(draft.unit)),
            severity: Value(draft.severity),
            detailsJson: Value(_encodeDetails(draft.details)),
            createdAt: Value(existing?.createdAt.toUtc() ?? now),
            updatedAt: Value(now),
          ),
        );
    return (await getById(targetId))!;
  }

  Future<int> count(
    String petId, {
    String? type,
    DateTime? from,
    DateTime? to,
    String? keyword,
  }) {
    _validateQuery(type: type, from: from, to: to, limit: null, offset: 0);
    final search = keyword?.trim();
    final query = _database.selectOnly(_database.healthRecords)
      ..addColumns([_database.healthRecords.id.count()])
      ..where(_database.healthRecords.petId.equals(petId));
    if (type != null) {
      query.where(_database.healthRecords.type.equals(type));
    }
    if (from != null) {
      query.where(
        _database.healthRecords.occurredAt.isBiggerOrEqualValue(from.toUtc()),
      );
    }
    if (to != null) {
      query.where(
        _database.healthRecords.occurredAt.isSmallerThanValue(to.toUtc()),
      );
    }
    if (search != null && search.isNotEmpty) {
      query.where(
        _database.healthRecords.title.contains(search) |
            _database.healthRecords.note.contains(search),
      );
    }
    return query
        .map((row) => row.read(_database.healthRecords.id.count()) ?? 0)
        .getSingle();
  }

  Future<bool> delete(String id) async {
    final deleted = await (_database.delete(
      _database.healthRecords,
    )..where((record) => record.id.equals(id))).go();
    return deleted > 0;
  }

  void _validate(HealthRecordDraft draft) {
    if (!healthRecordTypes.contains(draft.type)) {
      throw FormatException('不支持的健康记录类型：${draft.type}');
    }
    if (draft.title.trim().isEmpty) {
      throw const FormatException('记录标题不能为空');
    }
    final severity = draft.severity;
    if (severity != null && (severity < 1 || severity > 5)) {
      throw const FormatException('严重程度必须在 1 到 5 之间');
    }
    if (draft.type == 'weight' && draft.numericValue == null) {
      throw const FormatException('体重记录必须填写数值');
    }
    for (final entry in draft.details.entries) {
      if (entry.key.trim().isEmpty) {
        throw const FormatException('结构化字段名不能为空');
      }
    }
  }

  void _validateQuery({
    String? type,
    DateTime? from,
    DateTime? to,
    int? limit,
    required int offset,
  }) {
    if (type != null && !healthRecordTypes.contains(type)) {
      throw FormatException('不支持的健康记录类型：$type');
    }
    if (from != null && to != null && !from.isBefore(to)) {
      throw const FormatException('查询开始时间必须早于结束时间');
    }
    if (limit != null && limit <= 0) {
      throw const FormatException('limit 必须大于 0');
    }
    if (offset < 0 || (offset > 0 && limit == null)) {
      throw const FormatException('offset 必须非负且只能与 limit 一起使用');
    }
  }

  HealthRecord _recordFromRow(db.HealthRecord row) => HealthRecord(
    id: row.id,
    petId: row.petId,
    type: row.type,
    occurredAt: row.occurredAt.toUtc(),
    title: row.title,
    note: row.note,
    numericValue: row.numericValue,
    unit: row.unit,
    severity: row.severity,
    details: _decodeDetails(row.detailsJson),
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );
}

String? _trimmedOrNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

String _encodeDetails(Map<String, String> details) {
  final cleaned = <String, String>{};
  for (final entry in details.entries) {
    final key = entry.key.trim();
    final value = entry.value.trim();
    if (key.isNotEmpty && value.isNotEmpty) cleaned[key] = value;
  }
  return jsonEncode(cleaned);
}

Map<String, String> _decodeDetails(String raw) {
  if (raw.trim().isEmpty) return const {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return const {};
    return decoded.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  } on FormatException {
    return const {};
  }
}
