import 'package:flutter/material.dart';

/// 一条季节性建议模板。
class SeasonalTipTemplate {
  const SeasonalTipTemplate({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    this.needsDewormingCheck = false,
    this.needsBrachycephalic = false,
    this.needsJointCondition = false,
    this.needsNotNeutered = false,
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;

  /// 仅在用户近期无驱虫记录时展示。
  final bool needsDewormingCheck;

  /// 仅对短鼻犬种展示。
  final bool needsBrachycephalic;

  /// 仅在慢性病含关节相关词时展示。
  final bool needsJointCondition;

  /// 仅对未绝育宠物展示。
  final bool needsNotNeutered;
}

/// 春季建议池 (3–5月)。
const springTips = <SeasonalTipTemplate>[
  SeasonalTipTemplate(
    id: 'seasonal_spring_shedding',
    icon: Icons.brush_outlined,
    title: '换毛季来了，多梳毛',
    body: '春天气温回升，狗狗开始脱去冬毛换上新毛。每天梳理一次可以帮助去除死毛、促进新毛生长，也能减少家里毛发飘散。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_spring_deworming',
    icon: Icons.bug_report_outlined,
    title: '春季是驱虫重点期',
    body: '春暖花开也是寄生虫活跃的季节，跳蚤、蜱虫和蚊子开始增多。建议按时做体内外驱虫，外出归来检查身上有没有蜱虫叮咬。',
    needsDewormingCheck: true,
  ),
  SeasonalTipTemplate(
    id: 'seasonal_spring_allergy',
    icon: Icons.filter_vintage_outlined,
    title: '注意花粉过敏',
    body: '春季花粉飘散，部分狗狗可能出现皮肤瘙痒、频繁舔爪、打喷嚏等过敏反应。外出归来用湿毛巾擦拭可以减少过敏原附着。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_spring_vaccine',
    icon: Icons.vaccines_outlined,
    title: '春季适合做体检和补种疫苗',
    body: '春季是带狗狗做年度体检和补种疫苗的好时机，天气温和出行方便。检查项目建议包含血常规、粪便检查和抗体检测。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_spring_mating',
    icon: Icons.pets_rounded,
    title: '发情期注意看护',
    body: '春季是狗狗发情高峰期，未绝育的狗狗外出时请牵好牵引绳，避免意外交配。如果暂不考虑繁殖，可以咨询兽医了解绝育时机。',
    needsNotNeutered: true,
  ),
];

/// 夏季建议池 (6–8月)。
const summerTips = <SeasonalTipTemplate>[
  SeasonalTipTemplate(
    id: 'seasonal_summer_heat',
    icon: Icons.wb_sunny_outlined,
    title: '高温天注意防暑',
    body:
        '狗狗散热能力远不如人类，气温超过30°C时要避免在烈日下运动。遛狗选在清晨或傍晚，随时提供充足的清水，警惕大口喘气和舌头紫红等中暑信号。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_summer_water',
    icon: Icons.water_drop_rounded,
    title: '夏天要多关注饮水量',
    body: '高温天狗狗水分流失加快，建议每天记录饮水量，保持水盆清洁并随时换上新鲜水。饮水量突然增多或减少都值得留意。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_summer_food',
    icon: Icons.restaurant_outlined,
    title: '食物保鲜要注意',
    body: '夏天食物容易变质，湿粮开封后尽快吃完，干粮也要密封保存。剩食及时清理，食盆每天清洗，避免细菌滋生引起肠胃问题。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_summer_parasite',
    icon: Icons.bug_report_outlined,
    title: '夏季蚊虫活跃，加强防护',
    body: '蚊虫活跃期也是心丝虫病传播高峰，建议按时做体外驱虫，外出时使用宠物安全的驱蚊产品，避免黄昏在草丛长时间逗留。',
    needsDewormingCheck: true,
  ),
  SeasonalTipTemplate(
    id: 'seasonal_summer_walk_time',
    icon: Icons.directions_walk_rounded,
    title: '遛狗时间调整到早晚',
    body: '柏油路面在正午可达60°C以上，会烫伤狗狗的脚垫。建议把遛狗时间安排在清晨7点前或傍晚6点后，用手背贴地面测试温度。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_summer_brachy',
    icon: Icons.air_outlined,
    title: '短鼻犬种夏天要格外小心',
    body: '法斗、巴哥等短鼻犬种呼吸效率低，高温下极易中暑甚至危及生命。建议开空调保持室内凉爽，外出时间缩短到15分钟以内。',
    needsBrachycephalic: true,
  ),
];

/// 秋季建议池 (9–11月)。
const autumnTips = <SeasonalTipTemplate>[
  SeasonalTipTemplate(
    id: 'seasonal_autumn_shedding',
    icon: Icons.brush_outlined,
    title: '秋季换毛期，加强梳理',
    body: '秋天是狗狗换上冬毛的季节，掉毛量会明显增加。每天多梳几次毛可以帮助顺利过渡，适当补充维生素E促进新毛生长。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_autumn_appetite',
    icon: Icons.restaurant_outlined,
    title: '食欲旺盛期注意控制',
    body: '秋季狗狗食欲通常会变好，身体在为过冬储备能量。适当增加营养但不要放任暴食，配合足够的运动量，避免体重超标。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_autumn_disease',
    icon: Icons.shield_outlined,
    title: '秋季传染病高发，注意防护',
    body: '秋天气温下降使病毒存活时间延长，犬细小、犬瘟热等传染病进入高发期。确保疫苗接种及时，避免接触来历不明的狗狗。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_autumn_temp',
    icon: Icons.thermostat_auto_outlined,
    title: '昼夜温差大，预防感冒',
    body: '秋季早晚温差可达10°C以上，狗狗也容易受凉感冒。夜间睡觉确保窝垫温暖干燥，雨天外出后及时擦干身体。',
  ),
];

/// 冬季建议池 (12–2月)。
const winterTips = <SeasonalTipTemplate>[
  SeasonalTipTemplate(
    id: 'seasonal_winter_warmth',
    icon: Icons.ac_unit_rounded,
    title: '做好保暖措施',
    body: '冬天外出建议穿保暖外套，尤其是短毛犬和小型犬。室内保持温度在10°C以上，睡觉时确保窝垫厚实干燥，避免直接睡在冰冷的地板上。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_winter_joint',
    icon: Icons.accessibility_new_rounded,
    title: '冬天关节容易受凉',
    body: '低温会让关节炎症状加重，建议为狗狗提供支撑性好的床垫，在光滑地面铺设防滑垫。起床后先轻柔活动几分钟再出门。',
    needsJointCondition: true,
  ),
  SeasonalTipTemplate(
    id: 'seasonal_winter_bath',
    icon: Icons.bathtub_outlined,
    title: '冬天适当减少洗澡频率',
    body: '冬季洗澡过勤容易导致皮肤干燥和感冒，建议延长到每2–3周洗一次。洗完务必彻底吹干，选择温暖的室内环境进行。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_winter_exercise',
    icon: Icons.fitness_center_outlined,
    title: '室内运动不能少',
    body: '冬天户外活动减少，但运动量不足容易导致肥胖和肌肉流失。可以利用室内空间做嗅闻游戏、拔河和短距离往返跑来保持活力。',
  ),
  SeasonalTipTemplate(
    id: 'seasonal_winter_skin',
    icon: Icons.water_outlined,
    title: '冬季皮肤容易干燥',
    body: '暖气和干燥空气会使狗狗皮肤缺水、毛发干枯。可以适当补充鱼油或卵磷脂，洗澡后使用宠物保湿喷雾，保持饮水充足。',
  ),
];

/// 根据月份返回当季建议池。
List<SeasonalTipTemplate> seasonalTipsForMonth(int month) {
  if (month >= 3 && month <= 5) return springTips;
  if (month >= 6 && month <= 8) return summerTips;
  if (month >= 9 && month <= 11) return autumnTips;
  return winterTips;
}
