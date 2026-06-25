import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';

const quickActionSettingKey = 'home.quick_actions';
const defaultQuickActionIds = ['health:weight', 'care:bath', 'care:walk'];
const fixedMoreRecordActionId = 'more:records';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(ref.watch(appDatabaseProvider));
});

final quickActionIdsProvider = StreamProvider.autoDispose<List<String>>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watchQuickActionIds();
});

class AppSettingsRepository {
  AppSettingsRepository(this._database);

  final db.AppDatabase _database;

  Stream<List<String>> watchQuickActionIds() {
    return (_database.select(_database.appSettings)
          ..where((setting) => setting.key.equals(quickActionSettingKey)))
        .watchSingleOrNull()
        .map((row) => _parseQuickActions(row?.value));
  }

  Future<List<String>> getQuickActionIds() {
    return (_database.select(_database.appSettings)
          ..where((setting) => setting.key.equals(quickActionSettingKey)))
        .getSingleOrNull()
        .then((row) => _parseQuickActions(row?.value));
  }

  Future<void> saveQuickActionIds(List<String> ids) async {
    final cleaned = <String>[];
    for (final id in ids) {
      if (!quickActionOptions.any((option) => option.id == id)) continue;
      if (!cleaned.contains(id)) cleaned.add(id);
      if (cleaned.length == 3) break;
    }
    if (cleaned.length != 3) {
      throw const FormatException('请选择 3 个快速记录入口');
    }
    await _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          db.AppSettingsCompanion.insert(
            key: quickActionSettingKey,
            value: cleaned.join(','),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }
}

class QuickActionOption {
  const QuickActionOption({
    required this.id,
    required this.label,
    required this.kind,
    required this.type,
  });

  final String id;
  final String label;
  final String kind;
  final String type;
}

const quickActionOptions = [
  QuickActionOption(
    id: 'health:weight',
    label: '体重',
    kind: 'health',
    type: 'weight',
  ),
  QuickActionOption(
    id: 'health:food',
    label: '喂食',
    kind: 'health',
    type: 'food',
  ),
  QuickActionOption(
    id: 'health:water',
    label: '饮水',
    kind: 'health',
    type: 'water',
  ),
  QuickActionOption(
    id: 'health:elimination',
    label: '排泄',
    kind: 'health',
    type: 'elimination',
  ),
  QuickActionOption(
    id: 'health:symptom',
    label: '症状',
    kind: 'health',
    type: 'symptom',
  ),
  QuickActionOption(
    id: 'health:medication',
    label: '用药',
    kind: 'health',
    type: 'medication',
  ),
  QuickActionOption(
    id: 'health:vaccine',
    label: '疫苗',
    kind: 'health',
    type: 'vaccine',
  ),
  QuickActionOption(
    id: 'health:deworming',
    label: '驱虫',
    kind: 'health',
    type: 'deworming',
  ),
  QuickActionOption(
    id: 'health:custom',
    label: '自定义健康',
    kind: 'health',
    type: 'custom',
  ),
  QuickActionOption(id: 'care:bath', label: '洗澡', kind: 'care', type: 'bath'),
  QuickActionOption(id: 'care:oral', label: '口腔护理', kind: 'care', type: 'oral'),
  QuickActionOption(
    id: 'care:combing',
    label: '梳毛',
    kind: 'care',
    type: 'combing',
  ),
  QuickActionOption(
    id: 'care:styling',
    label: '美容',
    kind: 'care',
    type: 'styling',
  ),
  QuickActionOption(id: 'care:nail', label: '指甲护理', kind: 'care', type: 'nail'),
  QuickActionOption(id: 'care:ear', label: '耳部护理', kind: 'care', type: 'ear'),
  QuickActionOption(id: 'care:eye', label: '眼部护理', kind: 'care', type: 'eye'),
  QuickActionOption(id: 'care:paw', label: '足爪护理', kind: 'care', type: 'paw'),
  QuickActionOption(
    id: 'care:environment',
    label: '环境清洁',
    kind: 'care',
    type: 'environment',
  ),
  QuickActionOption(id: 'care:walk', label: '遛狗', kind: 'care', type: 'walk'),
  QuickActionOption(
    id: 'care:custom',
    label: '自定义护理',
    kind: 'care',
    type: 'custom',
  ),
];

List<String> _parseQuickActions(String? raw) {
  if (raw == null || raw.trim().isEmpty) return defaultQuickActionIds;
  final validIds = quickActionOptions.map((option) => option.id).toSet();
  final ids = raw
      .split(',')
      .map((part) => part.trim())
      .where((id) => id != fixedMoreRecordActionId)
      .where((id) => validIds.contains(id))
      .toSet()
      .toList();
  if (ids.length != 3) return defaultQuickActionIds;
  return ids;
}
