import '../../../core/codes/coded_enum.dart';

/// 记录类型。完成计划所需的记录也用这里的类型。
enum EntryType implements CodedEnum {
  meal('meal'),
  water('water'),
  potty('potty'),
  brushing('brushing'),
  walk('walk'),
  bath('bath'),
  grooming('grooming'),

  /// 驱虫：一次给药可覆盖体内、跳蚤蜱虫、心丝虫预防中的几类。
  parasitePrevention('parasite_prevention'),
  weight('weight'),
  earCheck('ear_check'),
  otherCare('other_care'),
  symptom('symptom'),
  medication('medication'),
  vaccine('vaccine'),

  /// 兽医做的检查，比如粪检、心丝虫检测；只记录结果，App 不解读。
  vetTest('vet_test'),

  /// 自定义事项，比如看医生的预约；名称写在记录的 `label` 里。
  custom('custom');

  const EntryType(this.code);

  @override
  final String code;
}

enum Appetite implements CodedEnum {
  finished('finished'),
  leftSome('left_some'),
  barelyAte('barely_ate');

  const Appetite(this.code);

  @override
  final String code;
}

enum WaterIntake implements CodedEnum {
  more('more'),
  normal('normal'),
  less('less');

  const WaterIntake(this.code);

  @override
  final String code;
}

enum PottyKind implements CodedEnum {
  poop('poop'),
  pee('pee');

  const PottyKind(this.code);

  @override
  final String code;
}

enum StoolStatus implements CodedEnum {
  normal('normal'),
  soft('soft'),
  diarrhea('diarrhea'),
  hard('hard'),
  bloodOrMucus('blood_or_mucus');

  const StoolStatus(this.code);

  @override
  final String code;
}

enum UrineStatus implements CodedEnum {
  normal('normal'),
  frequent('frequent'),
  little('little'),
  unusualColor('unusual_color');

  const UrineStatus(this.code);

  @override
  final String code;
}

enum CoatCondition implements CodedEnum {
  smooth('smooth'),
  tangles('tangles'),
  heavyShedding('heavy_shedding'),
  skinIssue('skin_issue');

  const CoatCondition(this.code);

  @override
  final String code;
}

enum BathPlace implements CodedEnum {
  home('home'),
  groomer('groomer'),
  vet('vet');

  const BathPlace(this.code);

  @override
  final String code;
}

enum GroomingPlace implements CodedEnum {
  groomer('groomer'),
  home('home');

  const GroomingPlace(this.code);

  @override
  final String code;
}

/// 一次驱虫覆盖的范围；复方药可以多选。
///
/// 心丝虫预防药杀的是过去约 30 天内进入体内的幼虫，没有"往后的保护期"，
/// 文案只说距离上次给药的天数，不说保护期。
enum ParasiteCoverage implements CodedEnum {
  intestinal('intestinal'),
  fleasTicks('fleas_ticks'),
  heartworm('heartworm');

  const ParasiteCoverage(this.code);

  @override
  final String code;
}

enum VetTestKind implements CodedEnum {
  fecal('fecal'),
  heartworm('heartworm'),
  other('other');

  const VetTestKind(this.code);

  @override
  final String code;
}

enum VetTestResult implements CodedEnum {
  negative('negative'),
  positive('positive'),
  pending('pending');

  const VetTestResult(this.code);

  @override
  final String code;
}

enum EarCondition implements CodedEnum {
  clean('clean'),
  waxy('waxy'),
  redOrSmelly('red_or_smelly');

  const EarCondition(this.code);

  @override
  final String code;
}

enum OtherCareKind implements CodedEnum {
  teeth('teeth'),
  nails('nails'),
  eyes('eyes'),
  paws('paws'),
  environment('environment'),
  other('other');

  const OtherCareKind(this.code);

  @override
  final String code;
}

/// 能观察到的表现，不是病名。
enum SymptomKind implements CodedEnum {
  vomiting('vomiting'),
  diarrhea('diarrhea'),
  coughing('coughing'),
  itching('itching'),
  limping('limping'),
  lowEnergy('low_energy'),
  other('other');

  const SymptomKind(this.code);

  @override
  final String code;
}

enum SymptomStatus implements CodedEnum {
  better('better'),
  same('same'),
  worse('worse');

  const SymptomStatus(this.code);

  @override
  final String code;
}
