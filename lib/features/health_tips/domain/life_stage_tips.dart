import 'package:flutter/material.dart';

/// 狗狗生命阶段。
enum DogLifeStage {
  /// 幼犬期。
  puppy,

  /// 青年期。
  youngAdult,

  /// 成熟成犬期。
  matureAdult,

  /// 老年期。
  senior,

  /// 高龄期。
  geriatric,
}

/// 生命阶段标签。
const lifeStageLabels = <DogLifeStage, String>{
  DogLifeStage.puppy: '幼犬期',
  DogLifeStage.youngAdult: '青年期',
  DogLifeStage.matureAdult: '成熟期',
  DogLifeStage.senior: '老年期',
  DogLifeStage.geriatric: '高龄期',
};

/// 根据年龄和体型判断生命阶段。
///
/// [isLargeBreed] 为 true 时使用中大型犬标准（老化更快）。
DogLifeStage computeLifeStage(double ageInYears, {bool isLargeBreed = false}) {
  if (isLargeBreed) {
    if (ageInYears < 1.5) return DogLifeStage.puppy;
    if (ageInYears < 4) return DogLifeStage.youngAdult;
    if (ageInYears < 6) return DogLifeStage.matureAdult;
    if (ageInYears < 8) return DogLifeStage.senior;
    return DogLifeStage.geriatric;
  }
  // 小型犬 / 中型犬标准
  if (ageInYears < 1) return DogLifeStage.puppy;
  if (ageInYears < 3) return DogLifeStage.youngAdult;
  if (ageInYears < 7) return DogLifeStage.matureAdult;
  if (ageInYears < 10) return DogLifeStage.senior;
  return DogLifeStage.geriatric;
}

/// 一条生命阶段建议。
class LifeStageTip {
  const LifeStageTip({
    required this.id,
    required this.stage,
    required this.icon,
    required this.title,
    required this.body,
    required this.reason,
  });

  final String id;
  final DogLifeStage stage;
  final IconData icon;
  final String title;
  final String body;
  final String reason;
}

/// 根据生命阶段返回建议列表。
List<LifeStageTip> tipsForStage(DogLifeStage stage) {
  return _allTips.where((tip) => tip.stage == stage).toList();
}

const _allTips = <LifeStageTip>[
  // ─── 幼犬期 ────────────────────────────────────────────────────────────────
  LifeStageTip(
    id: 'puppy_vaccine',
    stage: DogLifeStage.puppy,
    icon: Icons.vaccines_outlined,
    title: '疫苗计划不能马虎',
    body: '幼犬需在6–8周龄接种第一针，之后每3–4周补一针，共3针，16周龄前完成。成年后核心疫苗每3年加强一次，狂犬疫苗每年一次。',
    reason: '幼犬阶段是建立免疫保护的关键窗口期。',
  ),
  LifeStageTip(
    id: 'puppy_socialize',
    stage: DogLifeStage.puppy,
    icon: Icons.groups_outlined,
    title: '社会化训练黄金期',
    body: '3–14周龄是狗狗社会化的黄金窗口，多让它接触不同的人、动物、声音和环境，用正向奖励建立积极的体验。',
    reason: '幼犬期社会化不足可能导致成年后恐惧和攻击行为。',
  ),
  LifeStageTip(
    id: 'puppy_food',
    stage: DogLifeStage.puppy,
    icon: Icons.restaurant_outlined,
    title: '幼犬粮喂养到合适年龄',
    body: '小型犬约12个月可以过渡到成犬粮，大型犬需要15–18个月以上，确保骨骼关节充分发育。换粮要逐步混合过渡7–10天。',
    reason: '幼犬营养需求与成犬不同，过早或过晚换粮都可能影响发育。',
  ),

  // ─── 青年期 ────────────────────────────────────────────────────────────────
  LifeStageTip(
    id: 'young_exercise',
    stage: DogLifeStage.youngAdult,
    icon: Icons.directions_run_rounded,
    title: '保持充足的运动量',
    body: '青年犬精力旺盛，每天至少30–60分钟的运动有助于保持健康体重、消耗精力和预防行为问题。可以尝试跑步、飞盘和游泳。',
    reason: '运动不足容易导致肥胖、焦虑和破坏性行为。',
  ),
  LifeStageTip(
    id: 'young_neuter',
    stage: DogLifeStage.youngAdult,
    icon: Icons.medical_services_outlined,
    title: '了解绝育的时机和益处',
    body: '如果暂不计划繁殖，适龄绝育可以预防子宫蓄脓、降低乳腺肿瘤和前列腺疾病风险。建议与兽医讨论适合你家狗狗的绝育时机。',
    reason: '绝育决策影响长期健康，需要综合考虑品种和体型。',
  ),
  LifeStageTip(
    id: 'young_training',
    stage: DogLifeStage.youngAdult,
    icon: Icons.school_outlined,
    title: '持续训练和脑力游戏',
    body: '青年犬仍然在学习，持续的服从训练、嗅闻游戏和益智玩具可以满足脑力需求，加深你们的默契。每天10–15分钟的训练就够了。',
    reason: '脑力消耗对狗狗来说和体力消耗同样重要。',
  ),

  // ─── 成熟期 ────────────────────────────────────────────────────────────────
  LifeStageTip(
    id: 'mature_weight',
    stage: DogLifeStage.matureAdult,
    icon: Icons.monitor_weight_outlined,
    title: '中年体重管理是关键',
    body: '新陈代谢开始减慢，饮食量要跟着调整。保持体态评分在4–5分（肋骨可触不可见），每年称重1–2次，超重会加速关节磨损和器官负担。',
    reason: '成熟期肥胖是多种慢性病的催化剂。',
  ),
  LifeStageTip(
    id: 'mature_oral',
    stage: DogLifeStage.matureAdult,
    icon: Icons.medical_services_outlined,
    title: '口腔护理不能忽视',
    body: '超过3岁的狗狗约80%存在牙周病。建议每周刷牙2–3次，配合洁齿骨，每年做专业洁牙。牙周细菌可随血液损伤心脏和肾脏。',
    reason: '口腔健康与全身健康密切相关。',
  ),
  LifeStageTip(
    id: 'mature_checkup',
    stage: DogLifeStage.matureAdult,
    icon: Icons.assignment_outlined,
    title: '坚持年度体检',
    body: '很多慢性病早期没有明显症状。年度体检建议包含血常规、生化全项和尿检，有异常时加做B超和X光，早发现早干预。',
    reason: '定期筛查是预防慢性病最有效的手段。',
  ),

  // ─── 老年期 ────────────────────────────────────────────────────────────────
  LifeStageTip(
    id: 'senior_checkup',
    stage: DogLifeStage.senior,
    icon: Icons.assignment_outlined,
    title: '建议每半年体检一次',
    body: '老年犬身体变化快，建议每6个月做一次全面体检，重点关注SDMA肾功能指标、心脏超声和关节X光，很多慢性病早期干预效果最好。',
    reason: '老年犬体检频率应高于年轻犬。',
  ),
  LifeStageTip(
    id: 'senior_joint',
    stage: DogLifeStage.senior,
    icon: Icons.accessibility_new_rounded,
    title: '关注关节健康',
    body: '起身变慢、上下楼犹豫、不愿跳跃都是关节炎的信号。建议补充葡萄糖胺和软骨素，保持温和规律的运动，在光滑地面铺防滑垫。',
    reason: '关节炎是老年犬最常见的退行性疾病。',
  ),
  LifeStageTip(
    id: 'senior_diet',
    stage: DogLifeStage.senior,
    icon: Icons.restaurant_outlined,
    title: '考虑换成老年犬配方粮',
    body: '老年犬配方粮通常降低了磷和钠含量，增加了关节支持和抗氧化成分。过渡时新旧粮按7–10天逐步混合，观察消化适应情况。',
    reason: '老年犬的营养需求与成犬有明显差异。',
  ),
  LifeStageTip(
    id: 'senior_cognitive',
    stage: DogLifeStage.senior,
    icon: Icons.psychology_outlined,
    title: '保持脑力活跃',
    body: '老年犬也可能出现认知退化，表现为迷路、夜间不安或忘记训练过的指令。每天保持嗅闻游戏和轻度训练，有助于延缓认知衰退。',
    reason: '脑力活动有助于维持认知功能和情绪健康。',
  ),

  // ─── 高龄期 ────────────────────────────────────────────────────────────────
  LifeStageTip(
    id: 'geriatric_comfort',
    stage: DogLifeStage.geriatric,
    icon: Icons.bed_outlined,
    title: '提升日常舒适度',
    body: '提供厚实支撑性好的床垫，在光滑地面铺防滑垫，使用坡道代替跳跃。调整水盆和食盆高度，让它不需要弯腰就能进食饮水。',
    reason: '高龄犬身体机能明显衰退，环境适配能大幅提升生活质量。',
  ),
  LifeStageTip(
    id: 'geriatric_pain',
    stage: DogLifeStage.geriatric,
    icon: Icons.healing_outlined,
    title: '留意疼痛信号',
    body: '高龄犬可能默默承受疼痛，表现为不爱动、食欲下降、易怒或过度舔舐某个部位。发现这些信号请及时就医，不要当作"只是老了"。',
    reason: '疼痛会严重影响生活质量，但往往是可管理的。',
  ),
  LifeStageTip(
    id: 'geriatric_quality',
    stage: DogLifeStage.geriatric,
    icon: Icons.favorite_outlined,
    title: '定期评估生活质量',
    body: '关注它是否还能从日常活动中获得快乐：吃饭、散步、和你互动。如果痛苦多于快乐的 days 越来越多，可以和兽医讨论临终关怀方案。',
    reason: '生活质量评估是高龄犬护理的核心目标。',
  ),
];
