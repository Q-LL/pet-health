import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';
import 'package:pet_health/core/db/database_provider.dart';
import 'package:pet_health/core/db/pet_health_database.dart';
import 'package:pet_health/features/settings/application/display_settings.dart';

/// 页面测试用的整个 App，数据库在内存里。
///
/// drift 在取消订阅后还会留一个短计时器：测试结束前要先卸载界面并推进时钟，
/// 数据库放到普通的 tearDown 里关闭（不在测试的假时间里关）。
class AppHarness {
  /// [now] 固定"现在"；[locales] 模拟系统语言和地区（决定默认单位和日期顺序）。
  AppHarness({this.now, this.locales = const [Locale('zh', 'CN')]})
    : db = PetHealthDatabase(NativeDatabase.memory());

  final PetHealthDatabase db;
  final DateTime? now;
  final List<Locale> locales;

  /// 在真实时间里操作数据库；测试的假时间里等不到数据库的结果。
  Future<T?> seed<T>(WidgetTester tester, Future<T> Function() action) =>
      tester.runAsync(action);

  /// 手机尺寸的测试画面（逻辑像素 390×844），和 iPhone 一致。
  static const phoneSize = Size(390, 844);

  Future<void> pump(WidgetTester tester) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = phoneSize * 3;
    addTearDown(tester.view.reset);
    // 测试中途失败时也要先卸载界面，否则 tearDown 里关数据库会卡住。
    addTearDown(() => unmount(tester));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          petHealthDatabaseProvider.overrideWithValue(db),
          systemLocalesProvider.overrideWithValue(locales),
          if (now case final now?) clockProvider.overrideWithValue(() => now),
        ],
        child: const PawApp(),
      ),
    );
    // 等数据库的数据流送到界面。
    await settle(tester);
  }

  /// 数据库在测试之外改动后，让界面跟上。
  ///
  /// 保存一条记录可能要经过好几轮数据库读写，每一轮都要在真实时间里跑完，
  /// 再推进一帧让界面拿到结果，所以这里多来几轮。
  Future<void> settle(WidgetTester tester, {int rounds = 6}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> close() => db.close();
}
