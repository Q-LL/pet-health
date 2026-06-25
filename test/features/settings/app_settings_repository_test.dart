import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/features/settings/data/app_settings_repository.dart';

void main() {
  late AppDatabase database;
  late AppSettingsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = AppSettingsRepository(database);
  });

  tearDown(() => database.close());

  test('stores exactly three quick action ids', () async {
    await repository.saveQuickActionIds([
      'health:food',
      'care:oral',
      'care:paw',
    ]);

    final ids = await repository.getQuickActionIds();

    expect(ids, ['health:food', 'care:oral', 'care:paw']);
  });

  test('rejects incomplete quick action selection', () {
    expect(
      () => repository.saveQuickActionIds(['health:food']),
      throwsFormatException,
    );
  });
}
