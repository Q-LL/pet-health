import '../../features/cards/domain/card_codes.dart';
import '../../features/entries/domain/entry_codes.dart';
import '../../features/pets/domain/pet_codes.dart';
import '../../features/settings/domain/app_preferences.dart';
import '../codes/coded_enum.dart';
import '../format/date_display.dart';
import '../units/unit_preferences.dart';
import '../units/units.dart';
import 'generated/app_localizations.dart';

/// 存储 code 到显示文字的映射。
///
/// 每个映射都是穷尽的 switch：新增 code 而没有翻译时编译不通过，
/// 不会在界面上显示空白。
extension CodeLabels on AppLocalizations {
  String entryType(EntryType value) => switch (value) {
    EntryType.meal => entryTypeMeal,
    EntryType.water => entryTypeWater,
    EntryType.potty => entryTypePotty,
    EntryType.brushing => entryTypeBrushing,
    EntryType.walk => entryTypeWalk,
    EntryType.bath => entryTypeBath,
    EntryType.grooming => entryTypeGrooming,
    EntryType.parasitePrevention => entryTypeParasitePrevention,
    EntryType.weight => entryTypeWeight,
    EntryType.earCheck => entryTypeEarCheck,
    EntryType.otherCare => entryTypeOtherCare,
    EntryType.symptom => entryTypeSymptom,
    EntryType.medication => entryTypeMedication,
    EntryType.vaccine => entryTypeVaccine,
    EntryType.vetTest => entryTypeVetTest,
    EntryType.custom => entryTypeCustom,
  };

  String appetite(Appetite value) => switch (value) {
    Appetite.finished => appetiteFinished,
    Appetite.leftSome => appetiteLeftSome,
    Appetite.barelyAte => appetiteBarelyAte,
  };

  String waterIntake(WaterIntake value) => switch (value) {
    WaterIntake.more => waterIntakeMore,
    WaterIntake.normal => waterIntakeNormal,
    WaterIntake.less => waterIntakeLess,
  };

  String pottyKind(PottyKind value) => switch (value) {
    PottyKind.poop => pottyKindPoop,
    PottyKind.pee => pottyKindPee,
  };

  String stool(StoolStatus value) => switch (value) {
    StoolStatus.normal => stoolNormal,
    StoolStatus.soft => stoolSoft,
    StoolStatus.diarrhea => stoolDiarrhea,
    StoolStatus.hard => stoolHard,
    StoolStatus.bloodOrMucus => stoolBloodOrMucus,
  };

  String urine(UrineStatus value) => switch (value) {
    UrineStatus.normal => urineNormal,
    UrineStatus.frequent => urineFrequent,
    UrineStatus.little => urineLittle,
    UrineStatus.unusualColor => urineUnusualColor,
  };

  String coat(CoatCondition value) => switch (value) {
    CoatCondition.smooth => coatSmooth,
    CoatCondition.tangles => coatTangles,
    CoatCondition.heavyShedding => coatHeavyShedding,
    CoatCondition.skinIssue => coatSkinIssue,
  };

  String bathPlace(BathPlace value) => switch (value) {
    BathPlace.home => bathPlaceHome,
    BathPlace.groomer => bathPlaceGroomer,
    BathPlace.vet => bathPlaceVet,
  };

  String groomingPlace(GroomingPlace value) => switch (value) {
    GroomingPlace.groomer => groomingPlaceGroomer,
    GroomingPlace.home => groomingPlaceHome,
  };

  String parasiteCoverage(ParasiteCoverage value) => switch (value) {
    ParasiteCoverage.intestinal => parasiteCoverageIntestinal,
    ParasiteCoverage.fleasTicks => parasiteCoverageFleasTicks,
    ParasiteCoverage.heartworm => parasiteCoverageHeartworm,
  };

  String vetTestKind(VetTestKind value) => switch (value) {
    VetTestKind.fecal => vetTestKindFecal,
    VetTestKind.heartworm => vetTestKindHeartworm,
    VetTestKind.other => vetTestKindOther,
  };

  String vetTestResult(VetTestResult value) => switch (value) {
    VetTestResult.negative => vetTestResultNegative,
    VetTestResult.positive => vetTestResultPositive,
    VetTestResult.pending => vetTestResultPending,
  };

  String ears(EarCondition value) => switch (value) {
    EarCondition.clean => earsClean,
    EarCondition.waxy => earsWaxy,
    EarCondition.redOrSmelly => earsRedOrSmelly,
  };

  String otherCare(OtherCareKind value) => switch (value) {
    OtherCareKind.teeth => otherCareTeeth,
    OtherCareKind.nails => otherCareNails,
    OtherCareKind.eyes => otherCareEyes,
    OtherCareKind.paws => otherCarePaws,
    OtherCareKind.environment => otherCareEnvironment,
    OtherCareKind.other => otherCareOther,
  };

  String symptomKind(SymptomKind value) => switch (value) {
    SymptomKind.vomiting => symptomKindVomiting,
    SymptomKind.diarrhea => symptomKindDiarrhea,
    SymptomKind.coughing => symptomKindCoughing,
    SymptomKind.itching => symptomKindItching,
    SymptomKind.limping => symptomKindLimping,
    SymptomKind.lowEnergy => symptomKindLowEnergy,
    SymptomKind.other => symptomKindOther,
  };

  String symptomStatus(SymptomStatus value) => switch (value) {
    SymptomStatus.better => symptomStatusBetter,
    SymptomStatus.same => symptomStatusSame,
    SymptomStatus.worse => symptomStatusWorse,
  };

  String sex(PetSex value) => switch (value) {
    PetSex.male => sexMale,
    PetSex.female => sexFemale,
  };

  String breedGroup(BreedGroup value) => switch (value) {
    BreedGroup.largeDouble => breedGroupLargeDouble,
    BreedGroup.mediumDouble => breedGroupMediumDouble,
    BreedGroup.smallSilky => breedGroupSmallSilky,
    BreedGroup.curly => breedGroupCurly,
    BreedGroup.smallShort => breedGroupSmallShort,
    BreedGroup.largeShort => breedGroupLargeShort,
    BreedGroup.mixed => breedGroupMixed,
  };

  /// 预设犬种的名称；不在预设里的 code 返回 `null`，页面改用用户手写的名称。
  String? breed(String? code) => switch (code) {
    'golden_retriever' => breedGoldenRetriever,
    'labrador_retriever' => breedLabradorRetriever,
    'german_shepherd' => breedGermanShepherd,
    'bernese_mountain_dog' => breedBerneseMountainDog,
    'samoyed' => breedSamoyed,
    'siberian_husky' => breedSiberianHusky,
    'corgi' => breedCorgi,
    'shiba_inu' => breedShibaInu,
    'border_collie' => breedBorderCollie,
    'australian_shepherd' => breedAustralianShepherd,
    'cavalier_king_charles_spaniel' => breedCavalierKingCharlesSpaniel,
    'maltese' => breedMaltese,
    'yorkshire_terrier' => breedYorkshireTerrier,
    'shih_tzu' => breedShihTzu,
    'papillon' => breedPapillon,
    'poodle' => breedPoodle,
    'bichon_frise' => breedBichonFrise,
    'doodle' => breedDoodle,
    'french_bulldog' => breedFrenchBulldog,
    'pug' => breedPug,
    'chihuahua' => breedChihuahua,
    'dachshund' => breedDachshund,
    'beagle' => breedBeagle,
    'boxer' => breedBoxer,
    'doberman' => breedDoberman,
    'pit_bull' => breedPitBull,
    _ => null,
  };

  String language(AppLanguage value) => switch (value) {
    AppLanguage.system => languageSystem,
    AppLanguage.zh => languageZh,
    AppLanguage.en => languageEn,
  };

  String unitSystem(UnitSystem value) => switch (value) {
    UnitSystem.auto => unitSystemAuto,
    UnitSystem.metric => unitSystemMetric,
    UnitSystem.imperial => unitSystemImperial,
  };

  String dateFormat(DateDisplayFormat value) => switch (value) {
    DateDisplayFormat.auto => dateFormatAuto,
    DateDisplayFormat.ymd => dateFormatYmd,
    DateDisplayFormat.mdy => dateFormatMdy,
    DateDisplayFormat.dmy => dateFormatDmy,
  };

  String cardCategory(CardCategory value) => switch (value) {
    CardCategory.observation => cardCategoryObservation,
    CardCategory.comingUp => cardCategoryComingUp,
    CardCategory.tip => cardCategoryTip,
    CardCategory.moment => cardCategoryMoment,
  };

  String cardFrequency(CardFrequency value) => switch (value) {
    CardFrequency.normal => cardFrequencyNormal,
    CardFrequency.less => cardFrequencyLess,
    CardFrequency.off => cardFrequencyOff,
  };

  /// 食物份量单位的名称，用在输入框旁边。
  String foodUnit(PortionUnit value) => switch (value) {
    PortionUnit.scoop => unitScoop,
    PortionUnit.cup => unitCup,
    PortionUnit.g => unitGram,
    PortionUnit.can => unitCan,
    PortionUnit.pouch => unitPouch,
    PortionUnit.piece => unitPiece,
    // 用药单位不出现在食物输入里；兜底显示 code。
    PortionUnit.tablet || PortionUnit.ml || PortionUnit.mg || PortionUnit.drop =>
      value.code,
  };

  /// 水量单位的名称，用在输入框旁边。
  String volumeUnit(VolumeUnit value) => switch (value) {
    VolumeUnit.ml => unitMl,
    VolumeUnit.oz => unitOz,
    VolumeUnit.cup => unitCups,
  };

  /// 记录细节里任意一个选项的名称，用于按 details 通用地显示选项。
  String option(CodedEnum value) => switch (value) {
    final Appetite v => appetite(v),
    final WaterIntake v => waterIntake(v),
    final PottyKind v => pottyKind(v),
    final StoolStatus v => stool(v),
    final UrineStatus v => urine(v),
    final CoatCondition v => coat(v),
    final BathPlace v => bathPlace(v),
    final GroomingPlace v => groomingPlace(v),
    final ParasiteCoverage v => parasiteCoverage(v),
    final VetTestKind v => vetTestKind(v),
    final VetTestResult v => vetTestResult(v),
    final EarCondition v => ears(v),
    final OtherCareKind v => otherCare(v),
    final SymptomKind v => symptomKind(v),
    final SymptomStatus v => symptomStatus(v),
    _ => throw ArgumentError.value(value, 'value', 'Not a record option'),
  };
}
