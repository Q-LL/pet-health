import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/health_tips/application/health_tips_engine.dart';
import 'package:pet_health/features/health_tips/domain/breed_health_risks.dart';
import 'package:pet_health/features/health_tips/domain/health_tip.dart';
import 'package:pet_health/features/health_tips/domain/life_stage_tips.dart';
import 'package:pet_health/features/health_tips/domain/seasonal_tips.dart';

const _engine = HealthTipsEngine();

PetTipsProfile _pet({
  String name = '团子',
  String? species = '小型犬',
  String? breed = '贵宾犬',
  DateTime? birthday,
  bool? neutered = true,
  String allergies = '',
  String chronicConditions = '',
}) {
  return PetTipsProfile(
    id: 'test-pet',
    name: name,
    species: species,
    breed: breed,
    birthday: birthday,
    neutered: neutered,
    allergies: allergies,
    chronicConditions: chronicConditions,
  );
}

HealthTipsContext _ctx({
  PetTipsProfile? pet,
  List<TipsHealthRecord> recentRecords = const [],
  List<TipsWeightRecord> weightHistory = const [],
  int enabledPlanCount = 0,
  bool hasEnabledDewormingPlan = false,
  double coverageRate = 1.0,
  DateTime? now,
}) {
  return HealthTipsContext(
    pet: pet ?? _pet(),
    recentRecords: recentRecords,
    weightHistory: weightHistory,
    enabledPlanCount: enabledPlanCount,
    hasEnabledDewormingPlan: hasEnabledDewormingPlan,
    coverageRate: coverageRate,
    now: now ?? DateTime(2026, 6, 25),
  );
}

void main() {
  group('HealthTipsEngine - 基础', () {
    test('空名字宠物不输出建议', () {
      final tips = _engine.generate(_ctx(pet: _pet(name: '')));
      expect(tips, isEmpty);
    });

    test('默认输出最多 4 条建议', () {
      final tips = _engine.generate(
        _ctx(pet: _pet(birthday: DateTime(2020, 1, 1))),
      );
      expect(tips.length, lessThanOrEqualTo(4));
    });

    test('同 id 建议不重复', () {
      final tips = _engine.generate(
        _ctx(pet: _pet(birthday: DateTime(2020, 1, 1))),
      );
      final ids = tips.map((t) => t.id).toSet();
      expect(ids.length, tips.length);
    });
  });

  group('HealthTipsEngine - 季节性建议', () {
    test('春季月份输出春季建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 4, 15),
        ),
      );
      final seasonal = tips.where((t) => t.category == 'seasonal');
      expect(seasonal, isNotEmpty);
      expect(seasonal.any((t) => t.id.startsWith('seasonal_spring')), isTrue);
    });

    test('夏季月份输出夏季建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 7, 15),
        ),
      );
      final seasonal = tips.where((t) => t.category == 'seasonal');
      expect(seasonal.any((t) => t.id.startsWith('seasonal_summer')), isTrue);
    });

    test('秋季月份输出秋季建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 10, 15),
        ),
      );
      final seasonal = tips.where((t) => t.category == 'seasonal');
      expect(seasonal.any((t) => t.id.startsWith('seasonal_autumn')), isTrue);
    });

    test('冬季月份输出冬季建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 1, 15),
        ),
      );
      final seasonal = tips.where((t) => t.category == 'seasonal');
      expect(seasonal.any((t) => t.id.startsWith('seasonal_winter')), isTrue);
    });

    test('有驱虫计划时不推送驱虫提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          hasEnabledDewormingPlan: true,
          now: DateTime(2026, 4, 15),
        ),
      );
      expect(tips.any((t) => t.id == 'seasonal_spring_deworming'), isFalse);
    });

    test('短鼻犬种在夏季获得额外建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(breed: '法国斗牛犬', birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 7, 15),
        ),
        maxTips: 20,
      );
      expect(tips.any((t) => t.id == 'seasonal_summer_brachy'), isTrue);
    });

    test('非短鼻犬种不会收到短鼻专属建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(breed: '贵宾犬', birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 7, 15),
        ),
      );
      expect(tips.any((t) => t.id == 'seasonal_summer_brachy'), isFalse);
    });

    test('关节问题慢性病在冬季收到关节建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1), chronicConditions: '关节炎'),
          now: DateTime(2026, 1, 15),
        ),
      );
      expect(tips.any((t) => t.id == 'seasonal_winter_joint'), isTrue);
    });
  });

  group('HealthTipsEngine - 生命阶段', () {
    test('幼犬阶段输出幼犬建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2026, 1, 1)),
          now: DateTime(2026, 6, 25),
        ),
      );
      expect(tips.any((t) => t.category == 'life_stage'), isTrue);
      expect(tips.any((t) => t.id.startsWith('puppy_')), isTrue);
    });

    test('成年阶段输出成年建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          now: DateTime(2026, 6, 25),
        ),
      );
      expect(tips.any((t) => t.category == 'life_stage'), isTrue);
      expect(tips.any((t) => t.id.startsWith('mature_')), isTrue);
    });

    test('老年大型犬输出老年建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(
            species: '大型犬',
            breed: '金毛',
            birthday: DateTime(2019, 6, 1),
          ),
          now: DateTime(2026, 6, 25),
        ),
        maxTips: 20,
      );
      expect(tips.any((t) => t.category == 'life_stage'), isTrue);
      expect(tips.any((t) => t.id.startsWith('senior_')), isTrue);
    });

    test('没有生日时不输出生命阶段建议', () {
      final tips = _engine.generate(_ctx(pet: _pet(birthday: null)));
      expect(tips.any((t) => t.category == 'life_stage'), isFalse);
    });
  });

  group('HealthTipsEngine - 数据洞察', () {
    test('体重上升趋势触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          weightHistory: [
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 1), value: 5.0),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 8), value: 5.2),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 15), value: 5.5),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 22), value: 5.8),
          ],
        ),
      );
      expect(tips.any((t) => t.id == 'insight_weight_up'), isTrue);
    });

    test('体重下降趋势触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          weightHistory: [
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 1), value: 8.0),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 8), value: 7.7),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 15), value: 7.3),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 22), value: 7.0),
          ],
        ),
      );
      expect(tips.any((t) => t.id == 'insight_weight_down'), isTrue);
    });

    test('体重稳定不触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          weightHistory: [
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 1), value: 5.0),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 8), value: 5.0),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 15), value: 5.1),
            TipsWeightRecord(occurredAt: DateTime(2026, 6, 22), value: 5.0),
          ],
        ),
      );
      expect(tips.any((t) => t.id.startsWith('insight_weight_')), isFalse);
    });

    test('症状记录过多触发提醒', () {
      final records = List.generate(
        4,
        (i) => TipsHealthRecord(
          type: 'symptom',
          occurredAt: DateTime(2026, 6, 10 + i),
          title: '症状观察',
        ),
      );
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          recentRecords: records,
        ),
      );
      expect(tips.any((t) => t.id == 'insight_symptom_frequent'), isTrue);
    });

    test('排泄异常触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          recentRecords: [
            TipsHealthRecord(
              type: 'elimination',
              occurredAt: DateTime(2026, 6, 20),
              title: '排泄',
              details: {'stool': '腹泻'},
            ),
          ],
        ),
      );
      expect(tips.any((t) => t.id == 'insight_stool_abnormal'), isTrue);
    });

    test('护理覆盖率低触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          enabledPlanCount: 3,
          coverageRate: 0.4,
        ),
      );
      expect(tips.any((t) => t.id == 'insight_coverage_low'), isTrue);
    });

    test('食欲和排泄组合异常触发多维提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          recentRecords: [
            TipsHealthRecord(
              type: 'food',
              occurredAt: DateTime(2026, 6, 22),
              title: '喂食',
              details: {'appetite': '少吃'},
            ),
            TipsHealthRecord(
              type: 'elimination',
              occurredAt: DateTime(2026, 6, 23),
              title: '排泄',
              details: {'stool': '腹泻'},
            ),
          ],
        ),
        maxTips: 20,
      );
      expect(tips.any((t) => t.id == 'insight_digestive_cluster'), isTrue);
    });

    test('记录空白超过7天触发提醒', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(birthday: DateTime(2022, 1, 1)),
          recentRecords: [
            TipsHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 6, 1),
              title: '体重',
            ),
          ],
          now: DateTime(2026, 6, 25),
        ),
        maxTips: 20,
      );
      expect(tips.any((t) => t.id == 'insight_record_gap'), isTrue);
    });
  });

  group('HealthTipsEngine - 品种特定', () {
    test('金毛品种获得金毛风险建议', () {
      final tips = _engine.generate(
        _ctx(
          pet: _pet(breed: '金毛', birthday: DateTime(2022, 1, 1)),
        ),
      );
      expect(tips.any((t) => t.category == 'breed'), isTrue);
      expect(tips.any((t) => t.title.contains('金毛')), isTrue);
    });

    test('未知品种使用默认风险', () {
      final risks = risksForBreed('未知品种');
      expect(risks, isNotEmpty);
      expect(risks.any((r) => r.name == '牙周病'), isTrue);
    });

    test('空品种使用默认风险', () {
      final risks = risksForBreed(null);
      expect(risks, breedHealthRisks['_default']);
    });
  });

  group('life_stage_tips', () {
    test('小型犬生命阶段计算', () {
      expect(computeLifeStage(0.5), DogLifeStage.puppy);
      expect(computeLifeStage(2), DogLifeStage.youngAdult);
      expect(computeLifeStage(5), DogLifeStage.matureAdult);
      expect(computeLifeStage(8), DogLifeStage.senior);
      expect(computeLifeStage(11), DogLifeStage.geriatric);
    });

    test('大型犬生命阶段计算', () {
      expect(computeLifeStage(1, isLargeBreed: true), DogLifeStage.puppy);
      expect(computeLifeStage(3, isLargeBreed: true), DogLifeStage.youngAdult);
      expect(computeLifeStage(5, isLargeBreed: true), DogLifeStage.matureAdult);
      expect(computeLifeStage(7, isLargeBreed: true), DogLifeStage.senior);
      expect(computeLifeStage(9, isLargeBreed: true), DogLifeStage.geriatric);
    });

    test('每个阶段都有建议', () {
      for (final stage in DogLifeStage.values) {
        expect(tipsForStage(stage), isNotEmpty);
      }
    });
  });

  group('seasonal_tips', () {
    test('月份正确映射季节', () {
      expect(seasonalTipsForMonth(3), springTips);
      expect(seasonalTipsForMonth(6), summerTips);
      expect(seasonalTipsForMonth(9), autumnTips);
      expect(seasonalTipsForMonth(12), winterTips);
      expect(seasonalTipsForMonth(1), winterTips);
    });
  });

  group('breed_health_risks', () {
    test('短鼻犬种集合包含法斗和巴哥', () {
      expect(brachycephalicBreeds.contains('法国斗牛犬'), isTrue);
      expect(brachycephalicBreeds.contains('巴哥犬'), isTrue);
      expect(brachycephalicBreeds.contains('贵宾犬'), isFalse);
    });
  });
}
