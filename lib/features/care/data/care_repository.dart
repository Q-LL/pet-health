import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../domain/care_activity_filter.dart';
import '../domain/care_models.dart';

const defaultLocalPetId = 'local-default-pet';

final careRepositoryProvider = Provider<CareRepository>((ref) {
  return CareRepository(ref.watch(appDatabaseProvider));
});

/// 按筛选条件实时返回护理记录列表。
///
/// ```dart
/// final activities = ref.watch(filteredCareActivitiesProvider(
///   CareActivityFilter(petId: petId, type: 'bath', limit: 20),
/// ));
/// ```
final filteredCareActivitiesProvider = StreamProvider.autoDispose
    .family<List<CareActivity>, CareActivityFilter>((ref, filter) {
      return ref
          .watch(careRepositoryProvider)
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

class CareRepository {
  CareRepository(this._database) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final Uuid _uuid;

  Future<String> ensureDefaultPet() async {
    final existing = await (_database.select(
      _database.pets,
    )..where((pet) => pet.id.equals(defaultLocalPetId))).getSingleOrNull();
    if (existing != null) return existing.id;

    final now = DateTime.now().toUtc();
    await _database
        .into(_database.pets)
        .insert(
          db.PetsCompanion.insert(
            id: defaultLocalPetId,
            name: '我的狗狗',
            isPlaceholder: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return defaultLocalPetId;
  }

  Stream<List<CareActivity>> watchForPet(
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
    final query = _database.select(_database.careActivities)
      ..where((activity) {
        var expression = activity.petId.equals(petId);
        if (type != null) expression &= activity.type.equals(type);
        if (from != null) {
          expression &= activity.occurredAt.isBiggerOrEqualValue(from.toUtc());
        }
        if (to != null) {
          expression &= activity.occurredAt.isSmallerThanValue(to.toUtc());
        }
        if (search != null && search.isNotEmpty) {
          expression &=
              activity.place.contains(search) | activity.note.contains(search);
        }
        return expression;
      })
      ..orderBy([
        (activity) => OrderingTerm.desc(activity.occurredAt),
        (activity) => OrderingTerm.desc(activity.updatedAt),
      ]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().map(
      (rows) => rows.map(_activityFromRow).toList(growable: false),
    );
  }

  Future<List<CareActivity>> findForPet(
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

  Future<CareActivity?> getById(String id) async {
    final row = await (_database.select(
      _database.careActivities,
    )..where((activity) => activity.id.equals(id))).getSingleOrNull();
    return row == null ? null : _activityFromRow(row);
  }

  Future<CareActivity?> findLatestByType(String petId, String type) async {
    _validateQuery(type: type, from: null, to: null, limit: 1, offset: 0);
    final row =
        await (_database.select(_database.careActivities)
              ..where(
                (activity) =>
                    activity.petId.equals(petId) & activity.type.equals(type),
              )
              ..orderBy([(activity) => OrderingTerm.desc(activity.occurredAt)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _activityFromRow(row);
  }

  Future<CareActivity?> getActiveWalk(String petId) async {
    final row =
        await (_database.select(_database.careActivities)
              ..where(
                (activity) =>
                    activity.petId.equals(petId) &
                    activity.type.equals('walk') &
                    activity.endedAt.isNull(),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _activityFromRow(row);
  }

  Future<CareActivity> create(CareActivityDraft draft) => save(draft);

  Future<CareActivity> update(String id, CareActivityDraft draft) async {
    if (await getById(id) == null) {
      throw StateError('护理记录不存在：$id');
    }
    return save(draft, id: id);
  }

  Future<CareActivity> save(CareActivityDraft draft, {String? id}) async {
    _validateDraft(draft);
    final now = DateTime.now().toUtc();
    final targetId = id ?? _uuid.v4();
    final existing = await (_database.select(
      _database.careActivities,
    )..where((activity) => activity.id.equals(targetId))).getSingleOrNull();
    final startedAt = draft.startedAt?.toUtc();
    final endedAt = draft.endedAt?.toUtc();
    final duration = startedAt != null && endedAt != null
        ? endedAt.difference(startedAt).inSeconds
        : null;

    await _database
        .into(_database.careActivities)
        .insertOnConflictUpdate(
          db.CareActivitiesCompanion(
            id: Value(targetId),
            petId: Value(draft.petId),
            type: Value(draft.type),
            occurredAt: Value(draft.occurredAt.toUtc()),
            startedAt: Value(startedAt),
            endedAt: Value(endedAt),
            durationSeconds: Value(duration),
            place: Value(draft.place.trim()),
            note: Value(draft.note.trim()),
            detailsJson: Value(_encodeDetails(draft.details)),
            routeFilePath: Value(_trimmedOrNull(draft.routeFilePath)),
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
    final query = _database.selectOnly(_database.careActivities)
      ..addColumns([_database.careActivities.id.count()])
      ..where(_database.careActivities.petId.equals(petId));
    if (type != null) {
      query.where(_database.careActivities.type.equals(type));
    }
    if (from != null) {
      query.where(
        _database.careActivities.occurredAt.isBiggerOrEqualValue(from.toUtc()),
      );
    }
    if (to != null) {
      query.where(
        _database.careActivities.occurredAt.isSmallerThanValue(to.toUtc()),
      );
    }
    if (search != null && search.isNotEmpty) {
      query.where(
        _database.careActivities.place.contains(search) |
            _database.careActivities.note.contains(search),
      );
    }
    return query
        .map((row) => row.read(_database.careActivities.id.count()) ?? 0)
        .getSingle();
  }

  Future<bool> delete(String id) async {
    final deleted = await (_database.delete(
      _database.careActivities,
    )..where((activity) => activity.id.equals(id))).go();
    return deleted > 0;
  }

  Stream<CareState> watchState(String petId) {
    return watchForPet(petId).map((activities) {
      BathRecord? lastBath;
      DateTime? activeWalkStartedAt;
      final walks = <WalkRecord>[];

      for (final activity in activities) {
        if (activity.type == 'bath' && lastBath == null) {
          lastBath = BathRecord(
            occurredAt: activity.occurredAt,
            place: activity.place,
          );
        }
        if (activity.type != 'walk' || activity.startedAt == null) continue;
        if (activity.endedAt == null) {
          activeWalkStartedAt ??= activity.startedAt;
          continue;
        }
        walks.add(
          WalkRecord(
            startedAt: activity.startedAt!,
            endedAt: activity.endedAt!,
            duration:
                activity.duration ??
                activity.endedAt!.difference(activity.startedAt!),
            place: activity.place,
          ),
        );
      }

      return CareState(
        lastBath: lastBath,
        activeWalkStartedAt: activeWalkStartedAt,
        walks: walks,
      );
    });
  }

  Future<BathRecord> recordBath({
    required String petId,
    required DateTime occurredAt,
    required String place,
    String note = '',
  }) async {
    final activity = await create(
      CareActivityDraft(
        petId: petId,
        type: 'bath',
        occurredAt: occurredAt,
        place: place,
        note: note,
      ),
    );
    return BathRecord(occurredAt: activity.occurredAt, place: activity.place);
  }

  Future<DateTime> startWalk({required String petId, DateTime? at}) async {
    final active = await getActiveWalk(petId);
    if (active?.startedAt != null) return active!.startedAt!;

    final startedAt = (at ?? DateTime.now()).toUtc();
    await create(
      CareActivityDraft(
        petId: petId,
        type: 'walk',
        occurredAt: startedAt,
        startedAt: startedAt,
      ),
    );
    return startedAt;
  }

  Future<WalkRecord?> finishWalk({
    required String petId,
    required String place,
    DateTime? at,
    String note = '',
  }) async {
    final active = await getActiveWalk(petId);
    final startedAt = active?.startedAt;
    if (active == null || startedAt == null) return null;

    final requestedEnd = (at ?? DateTime.now()).toUtc();
    final endedAt = requestedEnd.isBefore(startedAt) ? startedAt : requestedEnd;
    final activity = await update(
      active.id,
      CareActivityDraft(
        petId: petId,
        type: 'walk',
        occurredAt: active.occurredAt,
        startedAt: startedAt,
        endedAt: endedAt,
        place: place,
        note: note,
        routeFilePath: active.routeFilePath,
      ),
    );
    return WalkRecord(
      startedAt: startedAt,
      endedAt: endedAt,
      duration: activity.duration ?? endedAt.difference(startedAt),
      place: activity.place,
    );
  }

  void _validateDraft(CareActivityDraft draft) {
    if (!careActivityTypes.contains(draft.type)) {
      throw FormatException('不支持的护理记录类型：${draft.type}');
    }
    if (draft.type == 'walk' && draft.startedAt == null) {
      throw const FormatException('遛狗记录必须填写开始时间');
    }
    if (draft.type != 'walk' &&
        (draft.startedAt != null || draft.endedAt != null)) {
      throw const FormatException('只有遛狗记录可以填写开始和结束时间');
    }
    final startedAt = draft.startedAt;
    final endedAt = draft.endedAt;
    if (startedAt != null && endedAt != null && endedAt.isBefore(startedAt)) {
      throw const FormatException('结束时间不能早于开始时间');
    }
    for (final entry in draft.details.entries) {
      if (entry.key.trim().isEmpty) {
        throw const FormatException('护理结构化字段名不能为空');
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
    if (type != null && !careActivityTypes.contains(type)) {
      throw FormatException('不支持的护理记录类型：$type');
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

  CareActivity _activityFromRow(db.CareActivity row) {
    final startedAt = row.startedAt?.toUtc();
    final endedAt = row.endedAt?.toUtc();
    return CareActivity(
      id: row.id,
      petId: row.petId,
      type: row.type,
      occurredAt: row.occurredAt.toUtc(),
      startedAt: startedAt,
      endedAt: endedAt,
      duration: row.durationSeconds == null
          ? null
          : Duration(seconds: row.durationSeconds!),
      place: row.place,
      note: row.note,
      details: _decodeDetails(row.detailsJson),
      routeFilePath: row.routeFilePath,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }
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
