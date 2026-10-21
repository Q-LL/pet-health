import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';
import 'package:pet_health/core/db/database_provider.dart';
import 'package:pet_health/core/db/pet_health_database.dart';

/// 页面测试用的整个 App，数据库在内存里。
///
/// drift 在取消订阅后还会留一个短计时器：测试结束前要先卸载界面并推进时钟，
/// 数据库放到普通的 tearDown 里关闭（不在测试的假时间里关）。
class AppHarness {
  AppHarness() : db = PetHealthDatabase(NativeDatabase.memory());

  final PetHealthDatabase db;

  /// 在真实时间里操作数据库；测试的假时间里等不到数据库的结果。
  Future<T?> seed<T>(WidgetTester tester, Future<T> Function() action) =>
      tester.runAsync(action);

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [petHealthDatabaseProvider.overrideWithValue(db)],
        child: const PawApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// 数据库在测试之外改动后，让界面跟上。
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> close() => db.close();
}
