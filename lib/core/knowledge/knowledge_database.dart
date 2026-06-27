import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'knowledge_database.g.dart';

class KnowledgeArticles extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get summary => text()();
  TextColumn get body => text()();
  TextColumn get severityLevel => text().withDefault(const Constant('info'))();
  TextColumn get species => text().withDefault(const Constant('dog'))();
  TextColumn get lifeStage => text().withDefault(const Constant('any'))();
  TextColumn get contextKeysJson => text().withDefault(const Constant('[]'))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get redFlagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get suggestedActionsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get reviewedStatus =>
      text().withDefault(const Constant('reviewed'))();
  TextColumn get version => text().withDefault(const Constant('2026.06'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class KnowledgeSources extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get organization => text()();
  TextColumn get url => text()();
  TextColumn get licenseNote => text().withDefault(const Constant(''))();
  DateTimeColumn get accessedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class KnowledgeArticleSources extends Table {
  TextColumn get articleId =>
      text().references(KnowledgeArticles, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceId =>
      text().references(KnowledgeSources, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {articleId, sourceId};
}

class KnowledgeVersions extends Table {
  TextColumn get id => text()();
  TextColumn get version => text()();
  TextColumn get region => text().withDefault(const Constant('global'))();
  DateTimeColumn get releasedAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    KnowledgeArticles,
    KnowledgeSources,
    KnowledgeArticleSources,
    KnowledgeVersions,
  ],
)
class KnowledgeDatabase extends _$KnowledgeDatabase {
  KnowledgeDatabase(super.executor);

  KnowledgeDatabase.defaults()
    : super(
        driftDatabase(
          name: 'knowledge',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seed();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final articleCountExpression = knowledgeArticles.id.count();
      final articleCount =
          await (selectOnly(knowledgeArticles)
                ..addColumns([articleCountExpression]))
              .map((row) => row.read(articleCountExpression) ?? 0)
              .getSingle();
      if (articleCount < _seedArticles.length) {
        await _seed();
      }
    },
  );

  Future<void> _seed() async {
    final now = DateTime.utc(2026, 6, 28);
    await into(knowledgeVersions).insertOnConflictUpdate(
      KnowledgeVersionsCompanion.insert(
        id: 'knowledge_2026_08',
        version: '2026.08',
        releasedAt: now,
        notes: const Value(
          'v2026.08: 全面扩展知识库——新增急救、营养、皮肤、行为分类，'
          '补充 35 篇文章，优化 contextKey 覆盖。',
        ),
      ),
    );

    for (final source in _seedSources) {
      await into(knowledgeSources).insertOnConflictUpdate(
        KnowledgeSourcesCompanion.insert(
          id: source.id,
          title: source.title,
          organization: source.organization,
          url: source.url,
          licenseNote: const Value(_sourceLicenseNote),
          accessedAt: now,
        ),
      );
    }

    for (final article in _seedArticles) {
      await into(knowledgeArticles).insertOnConflictUpdate(
        KnowledgeArticlesCompanion.insert(
          id: article.id,
          title: article.title,
          category: article.category,
          summary: article.summary,
          body: article.body,
          severityLevel: Value(article.severityLevel),
          species: Value(article.species),
          lifeStage: Value(article.lifeStage),
          contextKeysJson: Value(jsonEncode(article.contextKeys)),
          tagsJson: Value(jsonEncode(article.tags)),
          redFlagsJson: Value(jsonEncode(article.redFlags)),
          suggestedActionsJson: Value(jsonEncode(article.suggestedActions)),
          reviewedStatus: const Value('reviewed'),
          version: const Value('2026.08'),
          updatedAt: now,
        ),
      );
      for (final sourceId in article.sourceIds) {
        await into(knowledgeArticleSources).insert(
          KnowledgeArticleSourcesCompanion.insert(
            articleId: article.id,
            sourceId: sourceId,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    }
  }
}

class _SeedSource {
  const _SeedSource({
    required this.id,
    required this.title,
    required this.organization,
    required this.url,
  });

  final String id;
  final String title;
  final String organization;
  final String url;
}

const _sourceLicenseNote = '仅记录来源链接；App 内条目为整理后的原创中文说明。';

class _SeedArticle {
  const _SeedArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.body,
    required this.contextKeys,
    required this.tags,
    required this.suggestedActions,
    required this.sourceIds,
    this.severityLevel = 'info',
    this.redFlags = const [],
    this.species = 'dog',
    this.lifeStage = 'any',
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final String body;
  final String severityLevel;
  final String species;
  final String lifeStage;
  final List<String> contextKeys;
  final List<String> tags;
  final List<String> redFlags;
  final List<String> suggestedActions;
  final List<String> sourceIds;
}

const _seedSources = [
  _SeedSource(
    id: 'aaha_vaccine_2022',
    title: '2022 AAHA Canine Vaccination Guidelines',
    organization: 'AAHA',
    url:
        'https://www.aaha.org/resources/2022-aaha-canine-vaccination-guidelines/',
  ),
  _SeedSource(
    id: 'wsava_nutrition',
    title: 'Global Nutrition Guidelines',
    organization: 'WSAVA',
    url: 'https://wsava.org/global-guidelines/global-nutrition-guidelines/',
  ),
  _SeedSource(
    id: 'wsava_dental',
    title: 'Global Dental Guidelines',
    organization: 'WSAVA',
    url: 'https://wsava.org/global-guidelines/dental-guidelines/',
  ),
  _SeedSource(
    id: 'merck_dog_owners',
    title: 'Dog Owners health resources',
    organization: 'Merck Veterinary Manual',
    url: 'https://www.merckvetmanual.com/dog-owners',
  ),
  _SeedSource(
    id: 'avma_pet_owners',
    title: 'Pet owners resources',
    organization: 'AVMA',
    url: 'https://www.avma.org/resources-tools/pet-owners',
  ),
  _SeedSource(
    id: 'aaha_life_stage',
    title: 'Canine Life Stage Guidelines',
    organization: 'AAHA',
    url:
        'https://www.aaha.org/resources/2019-aaha-canine-life-stage-guidelines/',
  ),
  _SeedSource(
    id: 'avma_warm_weather',
    title: 'Warm weather pet safety',
    organization: 'AVMA',
    url:
        'https://www.avma.org/resources-tools/pet-owners/petcare/warm-weather-pet-safety',
  ),
  _SeedSource(
    id: 'avma_cold_weather',
    title: 'Cold weather pet safety',
    organization: 'AVMA',
    url:
        'https://www.avma.org/resources-tools/pet-owners/petcare/cold-weather-animal-safety',
  ),
  _SeedSource(
    id: 'avsab_socialization',
    title: 'Puppy Socialization Position Statement',
    organization: 'AVSAB',
    url: 'https://avsab.org/resources/position-statements/',
  ),
  _SeedSource(
    id: 'akc_breeds',
    title: 'Dog Breeds',
    organization: 'American Kennel Club',
    url: 'https://www.akc.org/dog-breeds/',
  ),
  _SeedSource(
    id: 'aspca_poison',
    title: 'Animal Poison Control Center',
    organization: 'ASPCA',
    url: 'https://www.aspca.org/pet-care/animal-poison-control',
  ),
  _SeedSource(
    id: 'red_cross_pet',
    title: 'Pet First Aid',
    organization: 'American Red Cross',
    url: 'https://www.redcross.org/take-a-class/pet-first-aid',
  ),
  _SeedSource(
    id: 'aaha_nutrition',
    title: '2021 AAHA Nutrition and Weight Management Guidelines',
    organization: 'AAHA',
    url:
        'https://www.aaha.org/resources/2021-aaha-nutrition-and-weight-management-guidelines/',
  ),
  _SeedSource(
    id: 'wsava_pain',
    title: 'WSAVA Global Pain Council Guidelines',
    organization: 'WSAVA',
    url: 'https://wsava.org/global-guidelines/pain-guidelines/',
  ),
  _SeedSource(
    id: 'avma_flea_tick',
    title: 'Flea and Tick Control',
    organization: 'AVMA',
    url:
        'https://www.avma.org/resources-tools/pet-owners/petcare/flea-and-tick-control',
  ),
  _SeedSource(
    id: 'merck_emergency',
    title: 'Emergency and Critical Care',
    organization: 'Merck Veterinary Manual',
    url: 'https://www.merckvetmanual.com/emergency-medicine-and-critical-care',
  ),
];

const _seedArticles = [
  _SeedArticle(
    id: 'observe_vomiting',
    title: '呕吐时先记录哪些信息',
    category: 'symptom_observation',
    summary: '把次数、时间、呕吐物状态和精神食欲一起记录，能帮助后续判断是否需要就医。',
    body:
        '偶发呕吐不一定代表严重问题，但连续呕吐、伴随精神差或无法饮水时需要更谨慎。记录时建议写清发生时间、当天第几次、呕吐物外观、是否吃了异常食物、是否腹泻、精神状态和饮水情况。不要自行给药或强行喂食；如果症状持续，带上记录和照片咨询兽医。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'health_dynamics.digestive'],
    tags: ['呕吐', '消化', '症状记录'],
    redFlags: ['连续多次呕吐', '呕吐物带血', '明显精神沉郁', '无法喝水或喝水后立刻吐'],
    suggestedActions: ['记录次数和时间', '拍摄呕吐物照片', '同步记录食欲、饮水和排便'],
    sourceIds: ['merck_dog_owners', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'observe_diarrhea',
    title: '腹泻和软便怎么观察',
    category: 'symptom_observation',
    summary: '排便异常要关注频率、形态、颜色、是否带血，以及是否伴随食欲或精神变化。',
    body:
        '软便或腹泻记录最好包含：一天几次、形态是偏软还是水样、颜色是否异常、是否有黏液或血、是否换粮或吃过零食。轻微变化可以先持续记录并保持饮水；如果腹泻频繁、带血、幼犬或老年犬出现精神差，应尽快联系兽医。',
    severityLevel: 'watch',
    contextKeys: ['record.elimination', 'health_dynamics.digestive'],
    tags: ['腹泻', '软便', '排泄记录'],
    redFlags: ['便血', '水样腹泻持续', '幼犬或老年犬同时精神差', '伴随频繁呕吐'],
    suggestedActions: ['记录便便形态和次数', '保留照片', '回看近期换粮、零食和误食情况'],
    sourceIds: ['merck_dog_owners', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'observe_water_change',
    title: '饮水变化怎么记录',
    category: 'record_guide',
    summary: '饮水突然增多或减少时，最好连同排尿、食欲和天气一起看。',
    body:
        '饮水量受天气、运动和饮食影响很大，单日变化不一定异常。建议记录大致饮水量、补水次数、当天运动量、是否吃干粮或湿粮，以及排尿次数和尿色。如果饮水明显增多或减少持续几天，或同时出现排尿异常、食欲下降、精神差，应联系兽医。',
    severityLevel: 'watch',
    contextKeys: ['record.water', 'health_dynamics.water_change'],
    tags: ['饮水', '排尿', '记录指南'],
    redFlags: ['饮水突然大幅增加并持续', '几乎不喝水', '伴随排尿带血或频繁排尿'],
    suggestedActions: ['用同一个水碗估算日饮水量', '同步记录尿频和尿色', '标记天气和运动量'],
    sourceIds: ['merck_dog_owners', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'observe_appetite_change',
    title: '食欲下降时别只写“没吃”',
    category: 'record_guide',
    summary: '食欲记录要写清吃了多少、挑食还是完全拒食，以及是否伴随其他症状。',
    body:
        '记录食欲下降时，建议写清平时食量、这次吃了几成、是否只拒绝主粮、是否仍愿意吃零食、是否有呕吐腹泻或精神变化。短暂挑食可以观察，但完全拒食、幼犬老年犬拒食，或同时精神差，应尽快咨询兽医。',
    severityLevel: 'watch',
    contextKeys: ['record.food', 'health_dynamics.digestive'],
    tags: ['饮食', '食欲', '记录指南'],
    redFlags: ['完全拒食', '拒食伴随精神沉郁', '幼犬或老年犬持续不吃'],
    suggestedActions: ['记录吃了几成', '记录是否换粮或加餐', '同步记录精神和排泄'],
    sourceIds: ['wsava_nutrition', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'care_oral_basics',
    title: '口腔护理的基础原则',
    category: 'daily_care',
    summary: '口腔护理以温和、持续和适合狗狗为原则，异常疼痛或出血应咨询兽医。',
    body:
        '家庭口腔护理可以从短时间触碰口唇、适应牙刷或指套开始，再逐步增加清洁时间。只使用犬用口腔护理用品，不使用人用牙膏。口臭、牙龈红肿、出血、进食疼痛或牙齿松动不是普通清洁能解决的问题，应咨询兽医。',
    severityLevel: 'info',
    contextKeys: ['care.oral', 'breed.small'],
    tags: ['口腔', '牙齿', '护理'],
    redFlags: ['牙龈明显红肿或出血', '进食疼痛', '牙齿松动', '口臭突然明显加重'],
    suggestedActions: ['从短时间适应开始', '使用犬用护理用品', '把异常写入症状记录'],
    sourceIds: ['wsava_dental'],
  ),
  _SeedArticle(
    id: 'care_ear_observation',
    title: '耳部观察看什么',
    category: 'daily_care',
    summary: '日常观察重点是气味、分泌物、红肿和抓挠，不建议频繁深度清洁。',
    body:
        '耳部护理的重点不是越洗越干净，而是定期观察。可以记录是否有异味、分泌物颜色、耳廓是否红肿、是否频繁甩头或抓耳。不要把棉签深入耳道；如果有疼痛、异味明显、分泌物增多或反复抓挠，建议咨询兽医。',
    severityLevel: 'info',
    contextKeys: ['care.ear', 'record.symptom'],
    tags: ['耳朵', '护理', '观察'],
    redFlags: ['明显异味', '分泌物增多', '耳朵疼痛', '频繁甩头抓耳'],
    suggestedActions: ['记录气味和分泌物', '拍摄耳廓照片', '避免深入耳道清理'],
    sourceIds: ['merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'care_paw_check',
    title: '足爪检查适合放在遛狗后',
    category: 'daily_care',
    summary: '遛狗后顺手看脚垫、趾缝和指甲，可以更早发现异物或破损。',
    body:
        '外出后可以快速检查脚垫是否破损、趾缝是否夹有草籽或小石子、指甲是否劈裂。雨雪或泥地后及时擦干足爪，减少潮湿刺激。若持续舔爪、跛行、出血或脚垫裂口，建议记录并联系兽医。',
    severityLevel: 'info',
    contextKeys: ['care.paw', 'care.walk'],
    tags: ['足爪', '脚垫', '遛狗后'],
    redFlags: ['跛行', '脚垫出血或裂口', '持续舔咬足爪', '趾缝红肿'],
    suggestedActions: ['遛狗后快速检查', '雨雪后擦干', '发现异常拍照记录'],
    sourceIds: ['merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'care_bath_frequency',
    title: '洗澡频率不要只看固定天数',
    category: 'daily_care',
    summary: '洗澡间隔要结合皮肤状态、活动环境、毛发类型和兽医建议。',
    body:
        '不同狗狗适合的洗澡频率差异很大。室内活动多、皮肤健康的狗狗可以间隔更久；户外泥地、皮肤油脂明显或有兽医建议时可调整。洗澡过勤可能造成皮肤干燥，洗后要彻底吹干。皮肤红肿、持续瘙痒或有异味时，不要只靠增加洗澡频率解决。',
    severityLevel: 'info',
    contextKeys: ['care.bath', 'care.combing', 'record.symptom', 'skin_coat'],
    tags: ['洗澡', '皮肤', '护理计划'],
    redFlags: ['皮肤红肿', '持续瘙痒', '明显异味', '洗后仍反复抓挠'],
    suggestedActions: ['记录上次洗澡时间和地点', '观察皮肤和毛发状态', '异常时转为症状记录'],
    sourceIds: ['merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'preventive_vaccine_record',
    title: '疫苗记录要保留哪些信息',
    category: 'preventive_health',
    summary: '疫苗记录最好保留接种日期、疫苗名称、医院和下一次提醒。',
    body:
        '疫苗计划应由兽医根据年龄、生活环境和当地风险决定。App 中建议记录接种日期、疫苗名称、医院或医生、批号（如有）、不良反应和下一次提醒。不要根据知识库自行补种或调整间隔；不确定时咨询兽医。',
    severityLevel: 'info',
    contextKeys: ['record.vaccine', 'reminder.vaccine', 'vet.visit'],
    tags: ['疫苗', '预防', '提醒'],
    redFlags: ['接种后出现明显过敏反应', '精神状态急剧变差', '呼吸异常'],
    suggestedActions: ['保存接种信息', '设置下次提醒', '记录接种后观察情况'],
    sourceIds: ['aaha_vaccine_2022', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'preventive_deworming_record',
    title: '驱虫提醒和记录怎么配合',
    category: 'preventive_health',
    summary: '驱虫频率受地区、外出、年龄和生活方式影响，记录能帮助你按兽医建议执行。',
    body:
        '驱虫不是所有狗狗都完全相同的固定周期。建议按兽医建议或产品说明执行，并记录日期、药品名、体内/体外、体重和是否有不良反应。经常去草地、接触其他动物或所在地区寄生虫活跃时，更应保持提醒和观察。',
    severityLevel: 'info',
    contextKeys: [
      'record.deworming',
      'reminder.deworming',
      'season.summer',
      'care.deworming',
    ],
    tags: ['驱虫', '寄生虫', '提醒'],
    redFlags: ['用药后明显呕吐腹泻', '精神沉郁', '疑似蜱虫叮咬后异常'],
    suggestedActions: ['记录驱虫日期', '设置下一次提醒', '外出后检查皮毛和足爪'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'vet_visit_prepare',
    title: '看兽医前整理这些资料',
    category: 'vet_preparation',
    summary: '时间线、照片、饮食饮水、排泄、用药和既往病史，通常比零散回忆更有帮助。',
    body:
        '就诊前可以整理：症状第一次出现时间、每天变化、照片或视频、食欲饮水、排泄、体重、近期用药、疫苗驱虫记录、是否换粮或误食。把事实按时间顺序列出来，能帮助兽医更快理解情况。不要为了凑信息自行推断诊断。',
    severityLevel: 'info',
    contextKeys: ['health_dynamics.general', 'record.symptom', 'record.weight'],
    tags: ['就医准备', '健康摘要', '时间线'],
    redFlags: ['呼吸困难', '抽搐', '严重外伤', '持续无法站立', '疑似中毒'],
    suggestedActions: ['整理最近记录', '带照片或视频', '列出用药和接种信息'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'urgent_when_to_call',
    title: '这些情况优先联系兽医',
    category: 'vet_preparation',
    summary: '知识库不能诊断；遇到明显红旗情况时，应优先联系兽医或急诊。',
    body:
        '如果狗狗出现呼吸困难、抽搐、严重外伤、持续无法站立、疑似中毒、反复呕吐腹泻并精神差、出血不止、排尿困难或剧烈疼痛，不要只依赖 App 观察。请尽快联系兽医或当地急诊，并携带已记录的时间线、照片和用药信息。',
    severityLevel: 'urgent',
    contextKeys: ['health_dynamics.urgent', 'record.symptom'],
    tags: ['红旗提示', '急诊', '就医'],
    redFlags: ['呼吸困难', '抽搐', '疑似中毒', '出血不止', '排尿困难', '持续无法站立'],
    suggestedActions: ['立即联系兽医', '带上记录和照片', '不要自行给药或拖延观察'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'weight_recording_basics',
    title: '体重记录为什么要看趋势',
    category: 'record_guide',
    summary: '单次体重不如连续趋势有意义，记录时尽量保持相同称重条件。',
    body:
        '体重最好在相似时间、相似状态下记录，例如饭前或固定一周同一天。连续上升或下降比单次波动更值得关注。记录体重时可以同时备注食量、运动量和近期症状，方便后续回看。',
    severityLevel: 'info',
    contextKeys: [
      'record.weight',
      'health_dynamics.weight_change',
      'record.food',
      'health_dynamics.digestive',
    ],
    tags: ['体重', '趋势', '记录指南'],
    redFlags: ['短期明显下降', '持续增重且活动减少', '体重变化伴随食欲或精神异常'],
    suggestedActions: ['固定称重条件', '持续记录趋势', '同步备注饮食和运动'],
    sourceIds: ['wsava_nutrition', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'life_puppy_socialization',
    title: '幼犬期：把社会化当成温柔练习',
    category: 'life_stage',
    summary: '幼犬期适合在安全前提下逐步接触声音、环境、陌生人和同类。',
    body:
        '幼犬期的重点不是大量刺激，而是让狗狗在安全、可控、愉快的体验中建立信心。可以短时间接触不同地面、声音、交通环境、温和的人和健康犬只。没有完成疫苗前，外出和接触对象要听从兽医建议。害怕、躲避或过度兴奋时，先降低难度，不强迫。',
    severityLevel: 'info',
    contextKeys: ['life_stage.puppy', 'health_dynamics.life_stage'],
    tags: ['幼犬', '社会化', '行为'],
    redFlags: ['持续恐惧躲避', '频繁咬人且难以转移', '外出后明显不适'],
    suggestedActions: ['每天做短时间新体验', '记录害怕或兴奋的场景', '按兽医建议安排疫苗和外出'],
    sourceIds: ['aaha_life_stage', 'avsab_socialization'],
  ),
  _SeedArticle(
    id: 'life_adolescent_training',
    title: '青春期：听话倒退很常见',
    category: 'life_stage',
    summary: '青少年犬精力和探索欲增强，稳定作息、运动和正向训练比责罚更有帮助。',
    body:
        '青春期狗狗可能出现注意力下降、牵引冲动、拆家或测试边界。主人可以保持固定作息，增加嗅闻和互动运动，把训练拆成短而高频的小练习。记录哪些场景最容易失控，有助于调整运动量和环境管理。',
    severityLevel: 'info',
    contextKeys: [
      'life_stage.adolescent',
      'health_dynamics.life_stage',
      'care.walk',
    ],
    tags: ['青春期', '训练', '行为'],
    redFlags: ['突然攻击行为', '持续破坏且伴随焦虑', '运动后仍异常躁动'],
    suggestedActions: ['固定作息和运动', '短时间正向训练', '记录触发场景'],
    sourceIds: ['aaha_life_stage', 'akc_breeds'],
  ),
  _SeedArticle(
    id: 'life_adult_routine',
    title: '成年犬：稳定记录最能看出变化',
    category: 'life_stage',
    summary: '成年犬健康管理的价值在于建立自己的基线：体重、食欲、饮水、排泄和运动。',
    body:
        '成年犬通常生活节奏稳定，很适合建立个人基线。每周体重、日常饮食饮水、排泄状态、护理完成情况和运动量，能帮助你发现偏离平常状态的变化。不要追求每天记录所有内容，保持轻量持续更重要。',
    severityLevel: 'info',
    contextKeys: [
      'life_stage.adult',
      'health_dynamics.life_stage',
      'record.weight',
      'record.food',
    ],
    tags: ['成年犬', '基线', '记录'],
    redFlags: ['体重持续变化', '饮水或排尿明显改变', '食欲和精神同时下降'],
    suggestedActions: ['建立体重和饮水基线', '持续记录排泄状态', '定期回看护理覆盖率'],
    sourceIds: ['aaha_life_stage', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'life_senior_comfort',
    title: '老年犬：舒适度和细微变化更重要',
    category: 'life_stage',
    summary: '老年犬要关注体重、活动能力、疼痛迹象、睡眠、饮水排尿和认知变化。',
    body:
        '老年犬的变化常常比较慢：不愿上楼、起身变慢、夜间不安、饮水排尿变化、体重下降或毛发状态改变，都值得连续记录。家庭照护可以从防滑地垫、舒适床垫、规律体检和温和运动做起。突然恶化或疼痛表现应联系兽医。',
    severityLevel: 'watch',
    contextKeys: [
      'life_stage.senior',
      'health_dynamics.life_stage',
      'record.weight',
      'health_dynamics.weight_change',
    ],
    tags: ['老年犬', '舒适度', '慢性变化'],
    redFlags: ['突然无法站立', '持续疼痛表现', '明显消瘦', '夜间严重不安'],
    suggestedActions: ['记录活动能力和睡眠', '关注饮水排尿', '优化防滑和休息环境'],
    sourceIds: ['aaha_life_stage', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'season_summer_heat_safety',
    title: '夏季：短时间外出也要防热',
    category: 'seasonal_care',
    summary: '炎热天气要避开高温地面、减少正午活动，并随时提供清水。',
    body:
        '夏季照护重点是避热、补水和观察喘息。把遛狗安排在清晨或傍晚，出门前用手背试地面温度，带水并减少高强度运动。短鼻犬、老年犬、肥胖犬和有心肺问题的狗狗更需要谨慎。出现过度喘气、虚弱、舌色异常或站立困难时，应尽快联系兽医。',
    severityLevel: 'watch',
    contextKeys: [
      'season.summer',
      'care.walk',
      'breed.brachycephalic',
      'health_dynamics.urgent',
    ],
    tags: ['夏季', '高温', '防暑'],
    redFlags: ['过度喘气', '虚弱站不稳', '舌色异常', '高温后精神明显变差'],
    suggestedActions: ['避开正午遛狗', '随身带水', '记录高温天运动和饮水'],
    sourceIds: ['avma_warm_weather', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'season_winter_cold_safety',
    title: '冬季：保暖和防滑都要看',
    category: 'seasonal_care',
    summary: '低温会影响小型犬、短毛犬、幼犬、老年犬和有关节问题的狗狗。',
    body:
        '冬季外出要根据体型、毛量和年龄调整时长。小型犬、短毛犬、幼犬、老年犬和慢性病犬更容易受冷。雨雪后擦干足爪，室内铺防滑垫，避免突然剧烈运动。若出现颤抖、行动困难、脚垫破损或关节明显不适，应记录并咨询兽医。',
    severityLevel: 'watch',
    contextKeys: [
      'season.winter',
      'care.paw',
      'breed.small',
      'life_stage.senior',
    ],
    tags: ['冬季', '保暖', '防滑'],
    redFlags: ['持续颤抖', '行动困难', '脚垫破损', '关节疼痛表现'],
    suggestedActions: ['缩短严寒外出时间', '雨雪后擦干足爪', '铺防滑垫'],
    sourceIds: ['avma_cold_weather', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'season_spring_allergy_shedding',
    title: '春季：换毛和过敏观察',
    category: 'seasonal_care',
    summary: '春季常见换毛、花粉刺激和寄生虫活跃，梳毛和外出后检查会更有用。',
    body:
        '春季气温回升，很多狗狗会进入换毛期，也更容易接触花粉和草籽。建议增加梳毛频率，外出后检查足爪和皮肤，记录是否频繁舔爪、打喷嚏或皮肤瘙痒。症状持续或皮肤红肿时，不要只靠洗澡处理。',
    severityLevel: 'info',
    contextKeys: [
      'season.spring',
      'care.combing',
      'care.paw',
      'record.symptom',
    ],
    tags: ['春季', '换毛', '过敏观察'],
    redFlags: ['持续瘙痒', '皮肤红肿', '频繁舔爪', '发现蜱虫叮咬后异常'],
    suggestedActions: ['增加梳毛', '外出后检查足爪', '记录皮肤和打喷嚏变化'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'season_autumn_routine_reset',
    title: '秋季：把作息和体重拉回稳定',
    category: 'seasonal_care',
    summary: '秋季食欲和运动节奏都可能变化，适合重新检查体重、饮食和护理计划。',
    body:
        '秋季天气转凉，狗狗活动意愿和食欲可能改变。可以重新确认体重基线、调整遛狗时间、检查驱虫和疫苗提醒是否过期。昼夜温差大时，幼犬、老年犬和短毛犬要留意保暖。',
    severityLevel: 'info',
    contextKeys: [
      'season.autumn',
      'record.weight',
      'record.food',
      'reminder.deworming',
      'reminder.vaccine',
    ],
    tags: ['秋季', '体重', '作息'],
    redFlags: ['食欲突然大幅下降', '体重持续变化', '精神明显变差'],
    suggestedActions: ['复查体重趋势', '整理提醒计划', '观察早晚温差下的状态'],
    sourceIds: ['aaha_life_stage', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'breed_small_dog_notes',
    title: '小型犬：成熟较早，也更要注意口腔',
    category: 'breed_traits',
    summary: '很多小型犬成年较早，日常照护里口腔、体重和低温适应值得多看。',
    body:
        '小型犬通常身体成熟较早，运动量需求不一定低，但更容易被零食和抱抱掩盖体重变化。小型犬口腔空间小，牙垢和口腔不适更需要早期关注。寒冷天气、湿滑地面和高处跳下也要多留意。',
    severityLevel: 'info',
    contextKeys: ['breed.small', 'care.oral', 'record.weight', 'care.nail'],
    tags: ['小型犬', '口腔', '体型差异'],
    redFlags: ['口臭突然加重', '不愿咀嚼', '频繁跳下后跛行'],
    suggestedActions: ['关注口腔护理', '记录体重趋势', '冬季做好保暖'],
    sourceIds: ['aaha_life_stage', 'wsava_dental'],
  ),
  _SeedArticle(
    id: 'breed_large_dog_notes',
    title: '大型犬：成长慢，关节和体重更要稳',
    category: 'breed_traits',
    summary: '大型犬成熟期更长，幼年快速增重、成年体重和老年关节都值得连续记录。',
    body:
        '大型犬通常成熟更慢，幼犬期不要只追求快速长大。成年后体重管理和规律运动会影响关节负担。老年大型犬如果出现起身慢、上楼犹豫、运动后不适，建议记录活动能力并咨询兽医。',
    severityLevel: 'info',
    contextKeys: [
      'breed.large',
      'record.weight',
      'life_stage.senior',
      'health_dynamics.weight_change',
    ],
    tags: ['大型犬', '关节', '体重'],
    redFlags: ['突然跛行', '起身困难', '体重快速变化'],
    suggestedActions: ['持续记录体重', '保持温和运动', '观察起身和上下楼状态'],
    sourceIds: ['aaha_life_stage', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'breed_brachycephalic_heat',
    title: '短鼻犬：炎热天气要更保守',
    category: 'breed_traits',
    summary: '法斗、巴哥等短鼻犬散热和呼吸效率较低，高温运动要更谨慎。',
    body:
        '短鼻犬在热天、潮湿天气或兴奋运动后更容易喘不过来。外出时间建议更短，避免正午和高强度追跑，室内保持凉爽。若出现异常喘息、舌色改变、虚弱或不愿活动，应尽快联系兽医。',
    severityLevel: 'watch',
    contextKeys: [
      'breed.brachycephalic',
      'season.summer',
      'health_dynamics.urgent',
    ],
    tags: ['短鼻犬', '法斗', '巴哥', '防暑'],
    redFlags: ['异常喘息', '舌色发紫或发暗', '高温后虚弱', '呼吸费力'],
    suggestedActions: ['缩短热天外出', '避免高强度运动', '记录喘息和恢复时间'],
    sourceIds: ['akc_breeds', 'avma_warm_weather'],
  ),
  _SeedArticle(
    id: 'breed_retriever_notes',
    title: '金毛和拉布拉多：友好之外也要管住体重',
    category: 'breed_traits',
    summary: '寻回犬常见特点是亲人、爱互动、食欲好；体重和运动节奏很值得记录。',
    body:
        '金毛和拉布拉多通常亲人、乐于互动，也常常很喜欢食物。主人可以把训练奖励切成小份，并记录体重、运动和零食。热天游泳或户外活动后，注意耳朵、皮肤和足爪状态。',
    severityLevel: 'info',
    contextKeys: [
      'breed.golden_retriever',
      'breed.labrador_retriever',
      'record.weight',
      'care.ear',
    ],
    tags: ['金毛', '拉布拉多', '体重管理'],
    redFlags: ['体重持续上升', '运动后跛行', '耳朵异味或抓耳'],
    suggestedActions: ['记录零食和运动', '定期称重', '户外后检查耳朵和足爪'],
    sourceIds: ['akc_breeds', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'breed_poodle_notes',
    title: '贵宾犬：聪明活跃，也需要稳定梳毛',
    category: 'breed_traits',
    summary: '贵宾犬学习能力强、互动需求高，卷毛护理和耳部观察要持续。',
    body:
        '贵宾犬通常聪明、活跃、愿意学习，适合用短时间训练和嗅闻游戏消耗精力。卷曲毛发需要规律梳理，避免打结；修毛和洗澡后也要观察皮肤状态。耳部毛发和潮湿环境可能让耳部观察更重要。',
    severityLevel: 'info',
    contextKeys: ['breed.poodle', 'care.combing', 'care.ear', 'care.oral'],
    tags: ['贵宾犬', '梳毛', '耳部观察'],
    redFlags: ['毛发严重打结', '耳朵异味', '皮肤红肿瘙痒'],
    suggestedActions: ['规律梳毛', '安排修毛计划', '记录耳部气味和分泌物'],
    sourceIds: ['akc_breeds', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'breed_border_collie_notes',
    title: '边牧：高智商需要“脑力运动”',
    category: 'breed_traits',
    summary: '边牧精力和学习需求高，单纯散步可能不够，嗅闻、训练和任务感更重要。',
    body:
        '边牧通常学习快、精力足，对环境变化敏感。除了运动，也需要嗅闻、找物、短训练和可完成的小任务。如果活动不足，可能表现为焦躁、追逐、拆家或过度吠叫。记录这些行为出现的时间和前因，有助于调整安排。',
    severityLevel: 'info',
    contextKeys: ['breed.border_collie', 'health_dynamics.breed'],
    tags: ['边牧', '行为', '运动'],
    redFlags: ['突然攻击或恐惧', '持续焦虑', '运动后仍异常亢奋'],
    suggestedActions: ['安排嗅闻和训练', '记录行为触发场景', '保持规律作息'],
    sourceIds: ['akc_breeds'],
  ),
  _SeedArticle(
    id: 'breed_dachshund_notes',
    title: '腊肠犬：长背短腿更要保护脊柱',
    category: 'breed_traits',
    summary: '腊肠犬体型特殊，跳上跳下、肥胖和剧烈扭转都需要更谨慎。',
    body:
        '腊肠犬的长背短腿很有辨识度，也意味着日常要留意脊柱负担。尽量减少频繁跳高跳下，保持体重稳定，使用坡道或台阶辅助上下沙发。若突然疼痛、弓背、不愿走路或后肢无力，应尽快联系兽医。',
    severityLevel: 'watch',
    contextKeys: [
      'breed.dachshund',
      'record.weight',
      'health_dynamics.weight_change',
    ],
    tags: ['腊肠犬', '脊柱', '体重'],
    redFlags: ['突然后肢无力', '明显疼痛', '不愿走路', '弓背发抖'],
    suggestedActions: ['控制体重', '减少跳上跳下', '记录疼痛和活动变化'],
    sourceIds: ['akc_breeds', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'breed_husky_notes',
    title: '哈士奇：运动和天气都要一起看',
    category: 'breed_traits',
    summary: '哈士奇精力充沛、耐寒但不等于耐热，夏季运动安排要保守。',
    body:
        '哈士奇通常精力旺盛、喜欢活动，也有较强独立性。寒冷天气不代表可以忽略足爪和防滑；炎热天气则需要明显降低运动强度，避开高温时段。记录运动后恢复时间和饮水，有助于判断安排是否合适。',
    severityLevel: 'info',
    contextKeys: ['breed.husky', 'season.summer', 'season.winter', 'care.paw'],
    tags: ['哈士奇', '运动', '季节'],
    redFlags: ['热天运动后虚弱', '脚垫破损', '持续异常喘息'],
    suggestedActions: ['安排规律运动', '夏季避开高温', '冬季检查足爪'],
    sourceIds: ['akc_breeds', 'avma_warm_weather', 'avma_cold_weather'],
  ),

  // ─── 急救常识 ──────────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'emergency_poisoning',
    title: '疑似中毒时先做这些事',
    category: 'emergency_first_aid',
    summary: '误食有毒物品后不要自行催吐，先记录毒物和剂量，尽快联系兽医。',
    body:
        '狗狗中毒的常见来源包括巧克力、葡萄、木糖醇、洋葱、人类药物和清洁剂。发现误食后，不要擅自催吐或灌盐水；记录误食物品、大致剂量、发生时间和当前症状，带上包装尽快联系兽医或急诊。途中可于牙龈涂抹少量蜂蜜应急。',
    severityLevel: 'urgent',
    contextKeys: [
      'record.medication',
      'vet.emergency',
      'health_dynamics.urgent',
    ],
    tags: ['中毒', '急救', '有毒食物'],
    redFlags: ['抽搐或瘯挛', '持续呕吐', '意识模糊', '呼吸困难', '出血不止'],
    suggestedActions: ['记录毒物和剂量', '带上包装就医', '不要自行催吐或给药'],
    sourceIds: ['aspca_poison', 'red_cross_pet', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'emergency_choking',
    title: '窒息和呼吸困难的紧急应对',
    category: 'emergency_first_aid',
    summary: '狗狗突然呼吸困难或窒息时，先检查口腔异物，保持气道通畅，尽快送医。',
    body:
        '窒息常见原因包括异物卡喉、舌头后坠或呕吐物堵塞。先观察狗狗是否能自主咳出异物，小心打开口腔检查但不要深入探取。保持头颈部伸展，清除口鼻分泌物。如果狗狗失去意识，可尝试小型犬倒提轻拍背部。无论是否缓解都应尽快就医。',
    severityLevel: 'urgent',
    contextKeys: ['health_dynamics.urgent', 'vet.emergency'],
    tags: ['窒息', '呼吸困难', '急救'],
    redFlags: ['完全无法呼吸', '牙龈发紫', '意识丧失', '剧烈咳嗽后无缓解'],
    suggestedActions: ['清除口鼻异物', '保持气道伸展', '立即送医'],
    sourceIds: ['red_cross_pet', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'emergency_heatstroke',
    title: '中暑的识别与紧急降温',
    category: 'emergency_first_aid',
    summary: '过度喘息、虚弱和体温过高是中暑信号，要立即降温并联系兽医。',
    body:
        '狗狗主要靠喘息散热，效率有限。中暑表现包括剧烈喘息、流涎过多、牙龈发红或发紫、虚弱、呕吐、瘯挛或意识模糊。立即将狗狗移至阴凉处，用凉水（不是冰水）浇淋身体，尤其腋下、腹股沟和脚垫。提供少量饮水但不要强灌。同时联系兽医，即使症状缓解也应检查。',
    severityLevel: 'urgent',
    contextKeys: [
      'season.summer',
      'breed.brachycephalic',
      'vet.emergency',
      'health_dynamics.urgent',
    ],
    tags: ['中暑', '高温', '急救'],
    redFlags: ['体温超过40°C', '瘯挛或昏迷', '牙龈发紫', '无法站立'],
    suggestedActions: ['移至阴凉处', '用凉水降温', '提供少量饮水', '立即联系兽医'],
    sourceIds: ['avma_warm_weather', 'red_cross_pet', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'emergency_wound_bleeding',
    title: '外伤出血的临时处理',
    category: 'emergency_first_aid',
    summary: '出血时先用干净布按压止血，不要反复揭开查看，尽快送医。',
    body:
        '发现出血时，用干净纱布或毛巾持续按压伤口 5-10 分钟，不要频繁揭开查看。如可能抬高受伤肢体。动脉出血（鲜红喷射）最危险，静脉出血（暗红持续流出）也需及时处理。不要用酒精或碘酒直接灌洗深层伤口。止血压迫后尽快送医，路上注意保暖。',
    severityLevel: 'urgent',
    contextKeys: ['record.symptom', 'vet.emergency'],
    tags: ['出血', '外伤', '急救'],
    redFlags: ['出血不止', '动脉喷射性出血', '伤口深大', '伴随瘯挛或意识变化'],
    suggestedActions: ['持续按压止血', '抬高患肢', '不要冲洗深层伤口', '尽快送医'],
    sourceIds: ['red_cross_pet', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'emergency_seizure',
    title: '抽搐发作时怎么办',
    category: 'emergency_first_aid',
    summary: '抽搐时不要往嘴里塞东西，保护狗狗不受伤，记录时长，尽快联系兽医。',
    body:
        '狗狗抽搐时全身僵硬、瘯挛、可能流涎或失禁。不要往嘴里塞任何东西（狗狗不会吞舌），不要强行按住身体。移开周围硬物防止碰撞，保持环境安静，用柔和灯光。记录发作开始时间和持续时间。首次发作、持续超过 3 分钟、连续发作或发作后意识不清，都应紧急就医。',
    severityLevel: 'urgent',
    contextKeys: ['record.symptom', 'vet.emergency', 'health_dynamics.urgent'],
    tags: ['抽搐', '癫疒', '急救'],
    redFlags: ['首次发作', '持续超过3分钟', '连续多次发作', '发作后意识不清'],
    suggestedActions: ['移开周围硬物', '记录发作时间', '不要塞嘴或强按', '尽快联系兽医'],
    sourceIds: ['red_cross_pet', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'emergency_bloat',
    title: '胃扭转的识别与紧急应对',
    category: 'emergency_first_aid',
    summary: '腹部突然膨胀、干呕不出、焦躁不安是胃扭转的红旗信号，必须立即急诊。',
    body:
        '胃扭转（GDV）常见于大型犬和深胸犬，进食后剧烈运动是高风险场景。表现包括腹部突然膨胀、反复干呕但吐不出、流涎增多、焦躁不安、牙龈发白、脉搏加快。这是真正的急诊，每小时都在恶化。立即联系急诊兽医，不要喂食喂水。预防建议包括少量多餐、饭后休息、避免拾高食碗。',
    severityLevel: 'urgent',
    contextKeys: ['breed.large', 'record.symptom', 'vet.emergency'],
    tags: ['胃扭转', '大型犬', '急救'],
    redFlags: ['腹部突然膨胀', '反复干呕无吐出物', '牙龈发白', '脉搏加快'],
    suggestedActions: ['立即联系急诊', '不要喂食喂水', '少量多餐预防', '饭后避免剧烈运动'],
    sourceIds: ['merck_emergency', 'akc_breeds'],
  ),

  // ─── 营养与饮食 ──────────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'nutrition_balanced_diet',
    title: '犬粮选择和营养均衡基础',
    category: 'nutrition_diet',
    summary: '选择符合AAFCO或FEDIAF标准的全价犬粮，根据年龄和活动量调整喂食量。',
    body:
        '选择犬粮时优先看是否符合 AAFCO 或 FEDIAF 营养标准，而不是只看品牌或价格。幼犬、成犬和老年犬的营养需求不同，应按照生命阶段选择。喂食量参考包装建议并根据体重趋势和活动量调整。零食不应超过总热量的 10%。换粮应逐步过渡，至少 5-7 天，避免消化不适。',
    severityLevel: 'info',
    contextKeys: ['record.food', 'health_dynamics.digestive'],
    tags: ['犬粮', '营养均衡', '喂食'],
    redFlags: ['突然拒绝进食', '换粮后持续腹泻', '体重急剧变化'],
    suggestedActions: ['查看犬粮营养标准', '根据体重趋势调整量', '零食控制在10%以内'],
    sourceIds: ['aaha_nutrition', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'nutrition_toxic_foods',
    title: '狗狗不能吃的常见食物',
    category: 'nutrition_diet',
    summary: '巧克力、葡萄、木糖醇、洋葱、大蒜等对狗狗有严重毒性，不存在安全剂量。',
    body:
        '高危有毒食物包括：巧克力（可可碱中毒）、葡萄/葡萄干（急性肾衰竭）、木糖醇（低血糖和肝衰竭）、洋葱/大蒜/韭菜（溶血性贫血）、夏威夷果（肌肉无力）、酒精（昏迷甚至死亡）、人类药物（肝肾损伤）。不存在“安全剂量”，微量也可能致命。误食后立即记录并联系兽医。',
    severityLevel: 'urgent',
    contextKeys: ['record.food', 'vet.emergency'],
    tags: ['有毒食物', '巧克力', '木糖醇', '葡萄'],
    redFlags: ['误食巧克力或葡萄', '误食含木糖醇产品', '误食人类药物', '出现呕吐抽搐'],
    suggestedActions: ['记录误食物品和剂量', '带上包装就医', '家中存放有毒物品加锁'],
    sourceIds: ['aspca_poison', 'avma_pet_owners', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'nutrition_puppy_feeding',
    title: '幼犬喂食频率和过渡',
    category: 'nutrition_diet',
    summary: '幼犬胃小能量需求高，需要少量多餐，换粮要更缓慢。',
    body:
        '幼犬（2-6 个月）通常每天需要喂 3-4 次，6-12 个月逐步过渡到每天 2 次。选择幼犬专用粮，蛋白质和热量密度高于成犬粮。换粮过渡期至少 7-10 天，混合比例逐步调整。幼犬拒食或呕吐不应等待太久，因为低血糖风险更高。记录食量、体重增长和排便状态，方便兽医评估发育情况。',
    severityLevel: 'info',
    lifeStage: 'puppy',
    contextKeys: ['life_stage.puppy', 'record.food'],
    tags: ['幼犬', '喂食', '营养'],
    redFlags: ['连续拒食超过一顿', '呕吐后精神差', '体重不增或下降'],
    suggestedActions: ['每天 3-4 次喂食', '缓慢换粮', '记录体重增长曲线'],
    sourceIds: ['aaha_nutrition', 'aaha_life_stage'],
  ),
  _SeedArticle(
    id: 'nutrition_senior_diet',
    title: '老年犬饮食调整要点',
    category: 'nutrition_diet',
    summary: '老年犬可能需要调整蛋白质、热量和关节营养素，体重管理更关键。',
    body:
        '老年犬代谢减慢、活动量下降，但营养需求并不简单减少。可能需要调整蛋白质质量、增加关节营养素（如葡萄糖胺、软骨素）、关注肾脏和心脏营养。体重过重会加重关节负担，过轻可能提示潜在疾病。建议选择老年犬粮或兽医推荐处方粮，定期体检评估营养方案。',
    severityLevel: 'info',
    lifeStage: 'senior',
    contextKeys: ['life_stage.senior', 'record.food', 'record.weight'],
    tags: ['老年犬', '饮食', '营养调整'],
    redFlags: ['体重持续下降', '食欲突然变化', '饮水明显增多'],
    suggestedActions: ['选择老年犬粮', '定期体检评估营养方案', '记录体重趋势'],
    sourceIds: ['aaha_nutrition', 'aaha_life_stage'],
  ),
  _SeedArticle(
    id: 'nutrition_obesity',
    title: '肥胖的判断与减重策略',
    category: 'nutrition_diet',
    summary: '体况评分(BCS)比体重数字更实用，减重要循序渐进。',
    body:
        '狗狗肥胖会增加关节、心脏、糖尿病和癌症风险。判断肥胖不只看体重数字，更重要的是体况评分 (BCS)：理想状态下肋骨可摸到但看不到明显轮廓，腰线从上方可见。减重建议每周减 1-2% 体重，减少零食、增加规律运动，不要突然大幅减少食量。每月复查体重和 BCS，调整方案。',
    severityLevel: 'watch',
    contextKeys: ['record.weight', 'health_dynamics.weight_change'],
    tags: ['肥胖', 'BCS', '减重'],
    redFlags: ['呼吸困难', '无法清洁自身', '腹部明显膨隆'],
    suggestedActions: ['学会体况评分', '每周记录体重', '减少零食增加运动'],
    sourceIds: ['aaha_nutrition', 'wsava_nutrition'],
  ),
  _SeedArticle(
    id: 'nutrition_raw_food',
    title: '生骨肉和自制餐的风险与注意事项',
    category: 'nutrition_diet',
    summary: '自制饮食容易营养不均衡，生食有细菌污染风险，请在兽医指导下操作。',
    body:
        '生骨肉饮食支持者认为更接近自然，但也存在沙门氏菌、大肠杆菌污染风险，以及钙磷比例不当、维生素缺乏等营养失衡问题。自制餐如果不经过营养师计算，很难长期均衡。如果选择自制或生食，建议在兽医营养师指导下制定配方，定期做营养评估和体检。',
    severityLevel: 'watch',
    contextKeys: ['record.food'],
    tags: ['生骨肉', '自制餐', '营养风险'],
    redFlags: ['持续腹泻或呕吐', '体重持续下降', '骨骼异常（幼犬）'],
    suggestedActions: ['咨询兽医营养师', '定期营养评估', '注意食材卫生'],
    sourceIds: ['aaha_nutrition', 'wsava_nutrition'],
  ),

  // ─── 皮肤与被毛 ──────────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'skin_hotspots',
    title: '急性湿疹（热点）的识别和处理',
    category: 'skin_coat',
    summary: '热点是狗狗突然出现的潮湿、红肿、脱毛区域，发展很快，需要兽医处理。',
    body:
        '热点（急性湿性皮炎）常在数小时内出现，表现为局部红肿、潮湿、脱毛、狗狗持续舔咬或抓挠。常见诱因包括过敏、潮湿、寄生虫、疼痛或焦虑。家庭可以先剪短周围毛发、保持干燥，但不要涂人用药膏。热点通常需要兽医开具抗生素、止痒药或外用药，同时要找到并解决根本诱因。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'care.bath'],
    tags: ['热点', '湿疹', '皮肤'],
    redFlags: ['快速扩大', '化脓恶臭', '狗狗精神差', '多处同时出现'],
    suggestedActions: ['剪短周围毛发', '保持干燥', '记录位置和时间', '联系兽医'],
    sourceIds: ['merck_dog_owners', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'skin_allergy',
    title: '皮肤过敏的常见原因和观察',
    category: 'skin_coat',
    summary: '狗狗皮肤过敏常见表现是瘙痒、红肿和反复耳部感染，记录触发因素有帮助。',
    body:
        '狗狗过敏的三大类型：跳蚤过敏（最常见）、食物过敏和环境过敏（花粉、尘螨、霉菌）。常见表现包括持续瘙痒、舔爪、腋下发红、反复耳部感染和皮肤红肿。记录症状出现的时间、季节、接触物和饮食变化，能帮助兽医缩小排查范围。不要自行使用人用抗过敏药，剂量和安全性都不同。',
    severityLevel: 'watch',
    contextKeys: ['season.spring', 'record.symptom'],
    tags: ['过敏', '瘙痒', '皮肤'],
    redFlags: ['全身性红肿', '呼吸困难', '面部肿胀', '反复感染不愈'],
    suggestedActions: ['记录症状时间和触发因素', '外出后检查皮肤', '保持跳蚤防控'],
    sourceIds: ['merck_dog_owners', 'avma_flea_tick'],
  ),
  _SeedArticle(
    id: 'coat_shedding_manage',
    title: '换毛期管理和梳毛技巧',
    category: 'skin_coat',
    summary: '春秋换毛期增加梳毛频率可以减少家中毛发，也能早发现皮肤问题。',
    body:
        '很多狗狗在春秋两季会有明显换毛期，底毛大量脱落。增加梳毛频率（每天或隔天）可以减少家中散落的毛发，也能促进皮肤血液循环。根据毛型选择合适工具：短毛犬用橡胶梳，长毛犬用针梳和排梳，底毛厚的犬种可用褪毛梳。梳毛时顺便检查皮肤有无红肿、结痂、肿块和寄生虫。',
    severityLevel: 'info',
    contextKeys: ['care.combing', 'season.spring', 'season.autumn'],
    tags: ['换毛', '梳毛', '季节'],
    redFlags: ['局部秃斑', '皮肤结痂', '梳毛时明显疼痛'],
    suggestedActions: ['增加梳毛频率', '选择合适工具', '检查皮肤状态'],
    sourceIds: ['merck_dog_owners', 'akc_breeds'],
  ),
  _SeedArticle(
    id: 'skin_parasite',
    title: '体外寄生虫的皮肤表现',
    category: 'skin_coat',
    summary: '跳蚤、蜱虫和螨虫都会引起皮肤问题，定期驱虫和外出后检查是关键。',
    body:
        '跳蚤是最常见的体外寄生虫，可引起跳蚤过敏性皮炎，表现是后腰、尾根和大腿内侧瘙痒。蜱虫可传播莱姆病等严重疾病，发现后要用专用工具拔除，不要用手捏。螨虫可引起脱毛、结痂和强烈瘙痒。定期使用驱虫药、外出后检查皮毛、发现异常及时处理是预防的关键。',
    severityLevel: 'watch',
    contextKeys: ['reminder.deworming', 'record.symptom', 'care.deworming'],
    tags: ['跳蚤', '蜱虫', '寄生虫', '皮肤'],
    redFlags: ['发现蜱虫附着', '大面积脱毛', '皮肤结痂化脓'],
    suggestedActions: ['定期驱虫', '外出后检查', '发现蜱虫正确拔除'],
    sourceIds: ['avma_flea_tick', 'merck_dog_owners'],
  ),

  // ─── 行为与训练 ──────────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'behavior_separation_anxiety',
    title: '分离焦虑的观察和缓解',
    category: 'behavior_training',
    summary: '主人离开后狗狗持续吠叫、拆家或排泄失禁，可能是分离焦虑而不是“调皮”。',
    body:
        '分离焦虑的表现包括：主人准备出门时紧张不安、离开后持续吠叫或哀叫、破坏门或窗户附近物品、在室内排泄、过度流涎。这不是“报复”或“调皮”，而是一种情绪困扰。可以从短时间离开练习、提供安全感和互动玩具开始。严重情况需要专业行为训练师或兽医行为科介入。不要因焦虑行为惩罚狗狗。',
    severityLevel: 'watch',
    contextKeys: ['health_dynamics.general'],
    tags: ['分离焦虑', '行为', '训练'],
    redFlags: ['自伤行为', '持续数小时不停吠叫', '每次离开都失禁'],
    suggestedActions: ['记录离开后行为', '短时间离开练习', '提供互动玩具'],
    sourceIds: ['avma_pet_owners', 'avsab_socialization'],
  ),
  _SeedArticle(
    id: 'behavior_excessive_barking',
    title: '吠叫过多的原因分析',
    category: 'behavior_training',
    summary: '吠叫是狗狗的正常沟通方式，但过多吠叫要先找原因再调整。',
    body:
        '狗狗吠叫的常见原因包括警报（陌生声音或人）、兴奋、焦虑、无聊和寻求关注。先记录吠叫发生的时间、触发因素和持续时间，帮助判断类型。警报型可通过脱敏训练减少；无聊型需要增加运动和精神刺激；焦虑型可能需要专业行为干预。不要因吠叫惩罚狗狗，这可能会加重焦虑。',
    severityLevel: 'info',
    contextKeys: ['health_dynamics.general'],
    tags: ['吠叫', '行为', '训练'],
    redFlags: ['伴随攻击行为', '突然行为改变', '持续焦虑表现'],
    suggestedActions: ['记录吠叫触发因素', '增加运动和精神刺激', '考虑脱敏训练'],
    sourceIds: ['avsab_socialization', 'akc_breeds'],
  ),
  _SeedArticle(
    id: 'behavior_leash_pulling',
    title: '牵引拉扯的训练思路',
    category: 'behavior_training',
    summary: '拉扯牵引是常见问题，关键是让狗狗学会“拉紧就不走，松了才前进”。',
    body:
        '牵引拉扯是很多主人的困扰。核心原则是：拉紧牵引绳时停下不动，等狗狗回头看你或绳子松了才继续前进。可以配合奖励零食和口头鼓励。选择合适工具（前扣胸背带、头环）可以帮助控制，但最终还是需要持续训练。每次遛狗时保持一致规则，不要有时允许拉有时不允许。',
    severityLevel: 'info',
    contextKeys: ['care.walk'],
    tags: ['牵引', '拉扯', '遛狗'],
    redFlags: ['牵引时出现攻击行为', '颈部受伤', '持续焦虑'],
    suggestedActions: ['拉紧就停，松了才走', '使用合适胸背带', '每次保持一致'],
    sourceIds: ['avsab_socialization', 'akc_breeds'],
  ),
  _SeedArticle(
    id: 'behavior_fear_phases',
    title: '恐惧期和敏感期如何应对',
    category: 'behavior_training',
    summary: '幼犬和青少年犬可能出现恐惧期，不要强迫接触害怕的事物。',
    body:
        '狗狗在幼犬期（约 8-11 周）和青少年期（约 6-14 个月）可能出现恐惧期，突然对之前不害怕的事物产生恐惧反应。这是发育的正常阶段。不要强迫狗狗接近恐惧对象，也不要过度安慰（可能强化恐惧行为）。保持平静，降低环境难度，让狗狗在自己的节奏下探索。如果恐惧反应严重影响生活，建议咨询兽医行为科。',
    severityLevel: 'info',
    contextKeys: ['life_stage.puppy', 'life_stage.adolescent'],
    tags: ['恐惧期', '敏感期', '行为发育'],
    redFlags: ['持续恐惧无法缓解', '攻击性行为', '恐惧严重影响日常生活'],
    suggestedActions: ['不强迫接触恐惧对象', '降低环境难度', '保持平静'],
    sourceIds: ['avsab_socialization', 'aaha_life_stage'],
  ),
  _SeedArticle(
    id: 'behavior_house_training',
    title: '定点排泄的引导方法',
    category: 'behavior_training',
    summary: '定点排泄训练需要耐心、规律作息和及时奖励，不是狗狗“故意捣乱”。',
    body:
        '定点排泄训练的核心是规律作息、及时奖励和正确清理。幼犬膀胱控制能力有限，饭后、睡醒后和玩耍后都需要外出。排泄在正确位置时立即奖励。意外发生时不要事后惩罚（狗狗无法关联），而是默默清理并用酶清洁剂去除气味。如果成年犬突然室内排泄，先排查健康原因（泌尿感染、糖尿病等）。',
    severityLevel: 'info',
    contextKeys: ['record.elimination', 'life_stage.puppy'],
    tags: ['定点排泄', '幼犬', '训练'],
    redFlags: ['成年犬突然失禁', '排泄带血', '频繁小量排尿'],
    suggestedActions: ['规律外出时间', '正确位置立即奖励', '用酶清洁剂清理'],
    sourceIds: ['avsab_socialization', 'merck_dog_owners'],
  ),

  // ─── 补充症状观察 ──────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'observe_coughing',
    title: '咳嗽和呼吸异常怎么记录',
    category: 'symptom_observation',
    summary: '咳嗽类型、频率、触发场景和精神状态一起记录，对后续诊断很有帮助。',
    body:
        '狗狗咳嗽可能是气管塌陷、心脏病、犬窝咳、肺炎或异物等多种原因。记录时注意咳嗽类型（干咳、湿咳、鹅叫声样咳嗽）、发生时间、是否运动后加重、是否夜间频繁、精神食欲和牙龈颜色。持续咳嗽、呼吸困难或牙龈发紫应立即就医。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'health_dynamics.urgent'],
    tags: ['咳嗽', '呼吸', '症状记录'],
    redFlags: ['呼吸困难', '牙龈发紫', '咳血', '无法平卧'],
    suggestedActions: ['记录咳嗽类型和频率', '拍摄咳嗽视频', '注意运动后和夜间变化'],
    sourceIds: ['merck_dog_owners', 'merck_emergency'],
  ),
  _SeedArticle(
    id: 'observe_skin_lumps',
    title: '皮肤肿块和包块观察',
    category: 'symptom_observation',
    summary: '发现新肿块时记录位置、大小和质地，持续生长或变硬应尽快检查。',
    body:
        '狗狗身上发现的肿块不一定都是恶性的，脂肪瘤、囊肿和炎性结节也很常见。发现新肿块时记录位置、大小（可用尺对比拍照）、质地（软/硬/固定）、是否有疼痛和生长速度。老年犬更应定期检查全身。快速生长、变硬、固定、溃烂或出血的肿块应尽快就医做细胞学检查。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'life_stage.senior'],
    tags: ['肿块', '包块', '皮肤观察'],
    redFlags: ['快速生长', '质地变硬或固定', '溃烂出血', '精神食欲变差'],
    suggestedActions: ['拍照并量尺记录', '定期全身检查', '生长异常时就医'],
    sourceIds: ['merck_dog_owners', 'aaha_life_stage'],
  ),
  _SeedArticle(
    id: 'observe_limping',
    title: '跛行和活动能力变化',
    category: 'symptom_observation',
    summary: '跛行可能从轻微扭伤到骨折或关节病，记录出现时间和触发场景很重要。',
    body:
        '跛行的原因范围很广：扭伤、异物刺入、指甲劈裂、关节炎、韧带损伤、骨折或神经问题。记录时注意哪条腿、什么时候开始、是持续还是间歇、运动后是否加重、是否有肿胀或触痛。轻微跛行可以先限制运动观察 24-48 小时，但如果不能承重、明显疼痛或伴随其他症状，应尽快就医。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'breed.large', 'life_stage.senior'],
    tags: ['跛行', '关节', '活动能力'],
    redFlags: ['完全不能承重', '明显肿胀变形', '伴随发热', '突然后肢无力'],
    suggestedActions: ['记录跛行腿和时间', '限制运动观察', '拍摄行走视频'],
    sourceIds: ['merck_dog_owners', 'wsava_pain'],
  ),
  _SeedArticle(
    id: 'observe_itching',
    title: '瘙痒和频繁抓挠记录',
    category: 'symptom_observation',
    summary: '瘙痒是狗狗最常见的皮肤症状，记录部位、频率和触发场景有助于定位原因。',
    body:
        '狗狗瘙痒的常见原因包括过敏（食物、环境、跳蚤）、寄生虫、感染和皮肤干燥。记录时注意抓挠的部位（爪子、腋下、耳后、腹部）、频率、是否有皮肤红肿脱毛、是否在特定场景后加重（外出、换粮、洗澡后）。轻度瘙痒可以先观察，但持续瘙痒影响睡眠和生活质量时，应联系兽医。',
    severityLevel: 'watch',
    contextKeys: ['record.symptom', 'care.bath', 'season.spring'],
    tags: ['瘙痒', '抓挠', '皮肤观察'],
    redFlags: ['抓挠到破皮出血', '大面积脱毛红肿', '面部肿胀'],
    suggestedActions: ['记录瘙痒部位和频率', '检查跳蚤', '回看换粮和环境变化'],
    sourceIds: ['merck_dog_owners', 'avma_flea_tick'],
  ),

  // ─── 补充日常护理 ──────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'care_eye_discharge',
    title: '眼部分泌物和泪痕护理',
    category: 'daily_care',
    summary: '日常观察眼部是否清澈、分泌物量和颜色，泪痕持续增多可能需要检查。',
    body:
        '少量透明眼屎是正常的，可以用湿润棉球从内向外轻拭。但黄色或绿色分泌物提示可能感染，持续流泪或泪痕加重可能与鼻泪管堵塞、过敏或眼部结构有关。短鼻犬和小型犬更容易有泪痕问题。不要用手指触碰眼球，不要使用人用眼药水。如果眼部红肿、疼痛、羞明或分泌物明显增多，应就医。',
    severityLevel: 'info',
    contextKeys: ['care.eye'],
    tags: ['眼睛', '泪痕', '分泌物'],
    redFlags: ['眼睛红肿', '黄色或绿色分泌物', '羞明或眨眼频繁', '眼球表面浑浊'],
    suggestedActions: ['用湿棉球清洁', '记录分泌物颜色', '异常时就医'],
    sourceIds: ['merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'care_environment_hygiene',
    title: '用品和环境清洁的重要性',
    category: 'daily_care',
    summary: '食盆、水碗、床垫和玩具的定期清洁能减少皮肤和消化问题。',
    body:
        '狗狗的食盆和水碗建议每天清洗，避免细菌和霉菌滋生。床垫和毯子每周清洗一次。玩具定期清洁，尤其是毛绒玩具和橡胶玩具容易积累唾液和污垢。清洁用品选择宠物安全的清洁剂，避免含氯或强酸强碱产品。食盆建议选择不锈钢或陶瓷材质，避免塑料（易刮伤藏污）。',
    severityLevel: 'info',
    contextKeys: ['care.environment'],
    tags: ['环境清洁', '用品', '卫生'],
    redFlags: ['食盆有异味或霉斑', '水碗滑腻', '床垫潮湿有异味'],
    suggestedActions: ['每天洗水碗食盆', '每周洗床垫', '使用宠物安全清洁剂'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'care_nail_bloodline',
    title: '指甲护理与血线处理',
    category: 'daily_care',
    summary: '修甲时每次少剪一点，看到粉色血线就停止；如果出血，用止血粉按压。',
    body:
        '狗狗指甲过长会影响步态和关节负担。修甲时每次只剪尖端 1-2mm，浅色指甲可看到粉色血线，深色指甲要更谨慎。如果不小心剪到血线，用止血粉或玉米淀粉按压 30 秒以上。平时在硬地面活动可以帮助自然磨损。建议每 2-4 周检查一次指甲长度。',
    severityLevel: 'info',
    contextKeys: ['care.nail'],
    tags: ['指甲', '血线', '修甲'],
    redFlags: ['指甲劈裂露出肉', '持续出血不止', '指甲嵌入肉垫'],
    suggestedActions: ['每次少剪一点', '备好止血粉', '定期检查长度'],
    sourceIds: ['merck_dog_owners', 'akc_breeds'],
  ),
  _SeedArticle(
    id: 'care_styling_grooming',
    title: '美容修毛的注意要点',
    category: 'daily_care',
    summary: '专业美容后检查皮肤有无剃伤，注意耳道和肛周清洁，避免过度剃毛。',
    body:
        '美容修毛对某些犬种（如贵宾、比熊、雪纳瑞）是日常护理的重要部分。美容后检查皮肤是否有剃伤、红肿或敏感。不建议全身剃毛（尤其是双层毛犬种），因为毛发有隔热和防晒作用。耳道修毛后注意观察是否有炎症。美容时如果狗狗紧张，应分段进行，不要强迫一次完成。',
    severityLevel: 'info',
    contextKeys: ['care.styling'],
    tags: ['美容', '修毛', '护理'],
    redFlags: ['美容后发现剃伤', '皮肤红肿敏感', '耳道发炎'],
    suggestedActions: ['美容后检查皮肤', '避免全身剃毛', '分段进行减少压力'],
    sourceIds: ['merck_dog_owners', 'akc_breeds'],
  ),

  // ─── 补充预防健康 ──────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'preventive_annual_checkup',
    title: '年度体检的意义和准备',
    category: 'preventive_health',
    summary: '定期体检能发现早期问题，建议成年犬每年一次、老年犬每半年一次。',
    body:
        '定期体检可以检测早期健康问题，包括体重变化、牙齿状态、心脏杂音、关节活动和血液指标。成年犬建议每年至少一次全面体检，老年犬和慢性病犬建议每半年一次。体检前可以整理近期健康记录、饮食信息、用药情况和任何观察到的变化。体检也是更新疫苗和驱虫计划的好时机。',
    severityLevel: 'info',
    contextKeys: ['record.weight', 'vet.visit'],
    tags: ['体检', '预防', '年度检查'],
    redFlags: ['体重急剧变化', '发现新肿块', '牙齿严重牙垢'],
    suggestedActions: ['每年安排体检', '整理健康记录', '准备问题清单'],
    sourceIds: ['aaha_life_stage', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'preventive_neutering',
    title: '绝育前后护理要点',
    category: 'preventive_health',
    summary: '绝育是常见手术，但术前准备和术后护理同样重要。',
    body:
        '绝育手术前需要禁食（通常术前 8-12 小时），术后需要戴伊丽莎白圈防止舔伤口，限制活动 7-14 天。每天检查伤口是否红肿、渗液或裂开。记录食欲、排泄和精神状态恢复情况。绝育后代谢会降低，需要注意调整食量避免肥胖。如伤口异常或持续精神差，应联系兽医。',
    severityLevel: 'info',
    contextKeys: ['record.medication', 'vet.visit'],
    tags: ['绝育', '手术', '术后护理'],
    redFlags: ['伤口裂开或化脓', '持续出血', '术后 24h 仍不进食', '发烧'],
    suggestedActions: ['术前禁食', '术后戴伊丽莎白圈', '每天检查伤口'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'preventive_medication_record',
    title: '长期用药的记录要点',
    category: 'preventive_health',
    summary: '长期用药要记录药品名、剂量、给药方式和观察指标，方便复查评估。',
    body:
        '狗狗可能需要长期用药的情况包括甲状腺素、心脏药、关节保健品、癫疒药等。每次用药记录建议包括：药品名、剂量、给药方式、给药时间和观察指标。不要自行停药或调量，即使看起来“好了”。定期复查血液指标和体重，确保药物效果和安全。把用药记录与疫苗、驱虫记录一起保存，方便兽医查阅。',
    severityLevel: 'info',
    contextKeys: ['record.medication', 'reminder.medication'],
    tags: ['用药', '长期药', '记录'],
    redFlags: ['用药后出现新症状', '呕吐腹泻加重', '精神状态急剧变差'],
    suggestedActions: ['记录药品和剂量', '不自行停药调量', '定期复查指标'],
    sourceIds: ['merck_dog_owners', 'avma_pet_owners'],
  ),

  // ─── 记录指南补充 ──────────────────────────────────────────────────────────
  _SeedArticle(
    id: 'record_medication_guide',
    title: '用药记录怎么写更有帮助',
    category: 'record_guide',
    summary: '药品名、剂量、方式、时间和反应是用药记录的五要素。',
    body:
        '用药记录的五要素：1) 药品名（通用名和品牌名）；2) 剂量（mg 或片数）；3) 给药方式（口服、外用、注射等）；4) 给药时间和频率；5) 用药后的反应和不良反应。处方药和非处方药都要记录。如果是兽医处方，保留原始医嘱，包括用药时长、复查时间和注意事项。',
    severityLevel: 'info',
    contextKeys: ['record.medication', 'reminder.medication', 'vet.visit'],
    tags: ['用药记录', '剂量', '记录指南'],
    redFlags: [],
    suggestedActions: ['记录五要素', '保留医嘱原文', '设置用药提醒'],
    sourceIds: ['merck_dog_owners', 'avma_pet_owners'],
  ),
  _SeedArticle(
    id: 'record_symptom_detail',
    title: '症状记录的细节要求',
    category: 'record_guide',
    summary: '好的症状记录应包含时间线、外观描述、照片和伴随表现。',
    body:
        '记录症状时，除了基本描述，建议补充：1) 首次出现时间；2) 频率和持续时长；3) 外观描述（颜色、大小、质地）；4) 照片或视频；5) 伴随的其他表现（精神、食欲、排泄、饮水）；6) 可能的触发因素（换粮、外出、接触异物）。时间线越完整，兽医越容易做出判断。不要根据猜测写“可能是 XX”，而是记录客观事实。',
    severityLevel: 'info',
    contextKeys: ['record.symptom', 'vet.visit'],
    tags: ['症状记录', '时间线', '就医准备'],
    redFlags: [],
    suggestedActions: ['记录时间线和外观', '拍照存档', '记录伴随表现'],
    sourceIds: ['avma_pet_owners', 'merck_dog_owners'],
  ),
  _SeedArticle(
    id: 'record_custom_usage',
    title: '自定义记录的使用场景',
    category: 'record_guide',
    summary: '不属于常规类型的健康事件，可以用自定义记录保存。',
    body:
        '自定义记录适合用于：体检报告、绝育手术记录、过敏反应记录、行为观察记录、保险理赔记录、特殊事件等。填写时建议写清标题、发生时间、详细描述和后续计划。可以配合照片和文档一起保存。自定义记录可以在历史列表中通过关键词搜索找到。',
    severityLevel: 'info',
    contextKeys: ['record.custom'],
    tags: ['自定义记录', '体检', '特殊事件'],
    redFlags: [],
    suggestedActions: ['写清标题和时间', '补充详细描述', '配合照片保存'],
    sourceIds: ['avma_pet_owners'],
  ),
];
