import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pet_health_database.dart';

final petHealthDatabaseProvider = Provider<PetHealthDatabase>((ref) {
  final database = PetHealthDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});

/// 当前时间；测试里覆盖它来固定"现在"。
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
