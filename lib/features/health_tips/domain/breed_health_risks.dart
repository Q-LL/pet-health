import 'package:flutter/material.dart';

/// 品种 → 常见健康风险映射（离线硬编码）。
///
/// 每条风险包含：风险名称、推荐关注图标、以及针对不同生命阶段的建议文案。
/// 未匹配到的品种自动回退到 `_default`。
class BreedRisk {
  const BreedRisk({
    required this.name,
    required this.icon,
    required this.body,
    required this.seniorBody,
  });

  final String name;
  final IconData icon;
  final String body;
  final String seniorBody;
}

const breedHealthRisks = <String, List<BreedRisk>>{
  // ─── 大型犬 ────────────────────────────────────────────────────────────────
  '金毛': [
    BreedRisk(
      name: '关节发育不良',
      icon: Icons.accessibility_new_rounded,
      body: '金毛犬髋关节和肘关节发育不良风险较高，建议每年体检时拍摄关节X光，日常避免频繁上下楼梯和剧烈跳跃。',
      seniorBody: '老年金毛关节磨损加剧，建议补充葡萄糖胺和软骨素，提供防滑地面和柔软床垫，减少跳跃动作。',
    ),
    BreedRisk(
      name: '肿瘤风险',
      icon: Icons.biotech_outlined,
      body: '金毛犬肿瘤发病率高于平均水平，7岁后建议每半年做一次全身检查，注意体表肿块、异常出血和体重骤降。',
      seniorBody: '老年金毛是肿瘤高发群体，发现任何新出现的肿块、淋巴结肿大或持续消瘦，应尽快就医排查。',
    ),
    BreedRisk(
      name: '心脏病',
      icon: Icons.favorite_outlined,
      body: '金毛犬有心肌病遗传倾向，年度体检建议包含心脏听诊和心电图，关注运动后异常喘喘和咳嗽。',
      seniorBody: '老年金毛心脏功能下降，若出现夜间咳嗽、运动不耐受或腹部膨胀，需尽快做心脏超声检查。',
    ),
  ],
  '拉布拉多': [
    BreedRisk(
      name: '关节发育不良',
      icon: Icons.accessibility_new_rounded,
      body: '拉布拉多髋关节发育不良风险较高，幼犬期避免过度运动，成犬期保持健康体重以减轻关节负担。',
      seniorBody: '老年拉布拉多关节炎常见，建议补充关节营养素，提供坡道辅助上下车，保持温和规律的运动。',
    ),
    BreedRisk(
      name: '肥胖',
      icon: Icons.monitor_weight_outlined,
      body: '拉布拉多食欲旺盛，肥胖风险显著高于其他犬种。建议严格按量喂食，每天保证足够运动量。',
      seniorBody: '老年拉布拉多新陈代谢减慢更易发胖，建议换成老年犬配方粮，减少高热量零食。',
    ),
    BreedRisk(
      name: '耳部感染',
      icon: Icons.hearing_outlined,
      body: '拉布拉多垂耳结构使耳道通风差，容易滋生细菌。建议每周检查耳朵，定期使用宠物耳部清洁液。',
      seniorBody: '老年拉布拉多耳道免疫力下降，若发现频繁甩头、耳内异味或红肿，需及时就医。',
    ),
  ],
  '德国牧羊犬': [
    BreedRisk(
      name: '关节与脊椎问题',
      icon: Icons.accessibility_new_rounded,
      body: '德牧髋关节和脊椎退行性疾病风险高，幼犬期避免爬楼梯，保持健康体重，每年体检建议拍片评估。',
      seniorBody: '老年德牧后肢无力是常见问题，建议补充关节营养素，提供防滑地面，必要时使用辅助背带。',
    ),
    BreedRisk(
      name: '消化不良',
      icon: Icons.restaurant_outlined,
      body: '德牧肠胃敏感，容易出现胃扭转和消化不良。建议少量多餐，饭后避免剧烈运动，选择易消化配方粮。',
      seniorBody: '老年德牧消化功能进一步减弱，建议选择高蛋白易消化配方，观察食欲变化和排便状态。',
    ),
  ],

  // ─── 小型犬 ────────────────────────────────────────────────────────────────
  '贵宾犬': [
    BreedRisk(
      name: '膝盖骨脱位',
      icon: Icons.accessibility_new_rounded,
      body: '贵宾犬膝盖骨脱位（髌骨脱位）是常见问题，避免让狗狗频繁跳上跳下，注意观察偶尔抬腿走路的表现。',
      seniorBody: '老年贵宾犬关节韧带松弛加重，建议补充关节营养素，避免湿滑地面，必要时手术评估。',
    ),
    BreedRisk(
      name: '牙周病',
      icon: Icons.medical_services_outlined,
      body: '贵宾犬牙齿拥挤导致牙结石和牙周病风险高，建议每周刷牙2–3次，每年做专业洁牙。',
      seniorBody: '老年贵宾犬牙齿脱落和牙龈炎常见，若口臭加重、进食困难或牙龈出血，需及时就医。',
    ),
  ],
  '吉娃娃': [
    BreedRisk(
      name: '膝盖骨脱位',
      icon: Icons.accessibility_new_rounded,
      body: '吉娃娃膝盖骨脱位风险较高，避免让它频繁从高处跳下，注意偶尔跛行或后腿僵硬的信号。',
      seniorBody: '老年吉娃娃关节退化加速，建议提供柔软床垫和防滑垫，减少跳跃动作。',
    ),
    BreedRisk(
      name: '心脏问题',
      icon: Icons.favorite_outlined,
      body: '吉娃娃是心脏瓣膜病高发小型犬，年度体检建议包含心脏听诊，注意咳嗽、气喘和活动耐力下降。',
      seniorBody: '老年吉娃娃心脏功能衰退，若出现夜间咳嗽、呼吸急促或运动不耐受，需尽快做心脏检查。',
    ),
    BreedRisk(
      name: '牙齿拥挤',
      icon: Icons.medical_services_outlined,
      body: '吉娃娃口腔空间小，牙齿拥挤容易积累牙结石，建议从小培养刷牙习惯，定期检查口腔健康。',
      seniorBody: '老年吉娃娃牙齿松动和脱落常见，建议换成软质食物，保持口腔清洁。',
    ),
  ],
  '博美': [
    BreedRisk(
      name: '气管塌陷',
      icon: Icons.air_outlined,
      body: '博美气管软骨脆弱，容易出现鹅叫声样咳嗽。建议使用背带代替项圈牵引，避免过度激动和高温环境。',
      seniorBody: '老年博美气管塌陷可能加重，若咳嗽频繁、呼吸困难或舌色发紫，需尽快就医。',
    ),
    BreedRisk(
      name: '牙周病',
      icon: Icons.medical_services_outlined,
      body: '博美牙齿容易积累牙结石，建议每周刷牙2–3次，每年做专业洁牙，注意口臭和牙龈出血信号。',
      seniorBody: '老年博美牙周病可能导致全身感染，若牙齿松动、进食困难，需及时处理。',
    ),
  ],

  // ─── 短鼻犬 ────────────────────────────────────────────────────────────────
  '法国斗牛犬': [
    BreedRisk(
      name: '呼吸困难',
      icon: Icons.air_outlined,
      body: '法斗是短头犬种，呼吸道结构天生受限。夏季尤其注意防暑，避免剧烈运动和高温环境，睡觉时保持通风。',
      seniorBody: '老年法斗呼吸功能进一步下降，若出现频繁打鼾加重、运动后紫舌或晕厥，需尽快评估呼吸道。',
    ),
    BreedRisk(
      name: '脊椎问题',
      icon: Icons.accessibility_new_rounded,
      body: '法斗脊椎结构特殊，椎间盘疾病风险高。避免让它频繁爬楼梯和跳跃，注意突然后腿无力或瘫痪信号。',
      seniorBody: '老年法斗脊椎退行性变常见，建议提供坡道代替楼梯，若出现拖腿或失禁需紧急就医。',
    ),
    BreedRisk(
      name: '皮肤褶皱感染',
      icon: Icons.cleaning_services_outlined,
      body: '法斗面部和尾部褶皱容易积累湿气和细菌，建议每天清洁褶皱区域并保持干燥。',
      seniorBody: '老年法斗皮肤免疫力下降，褶皱感染风险增加，若发现红肿、异味或分泌物需及时处理。',
    ),
  ],
  '巴哥犬': [
    BreedRisk(
      name: '呼吸困难',
      icon: Icons.air_outlined,
      body: '巴哥犬短鼻结构导致呼吸效率低，夏季尤其注意防暑降温，避免剧烈运动，保持凉爽通风的环境。',
      seniorBody: '老年巴哥犬呼吸功能衰退，若打鼾加重、运动耐力明显下降或出现紫舌，需就医评估。',
    ),
    BreedRisk(
      name: '眼部问题',
      icon: Icons.visibility_outlined,
      body: '巴哥犬眼球突出，角膜溃疡和干眼症风险高。避免灰尘和异物刺激，注意频繁眨眼、流泪或红肿信号。',
      seniorBody: '老年巴哥犬角膜退化和白内障常见，若眼球浑浊、视力下降或频繁碰撞，需眼科检查。',
    ),
    BreedRisk(
      name: '肥胖',
      icon: Icons.monitor_weight_outlined,
      body: '巴哥犬食欲好但运动量有限，肥胖会加重呼吸困难和关节负担。建议严格控量，每天适度运动。',
      seniorBody: '老年巴哥犬新陈代谢更慢，肥胖风险进一步升高，建议换成低热量老年犬配方粮。',
    ),
  ],

  // ─── 通用兜底 ─────────────────────────────────────────────────────────────
  '_default': [
    BreedRisk(
      name: '牙周病',
      icon: Icons.medical_services_outlined,
      body: '超过3岁的狗狗约80%存在不同程度的牙周病，细菌可随血液损伤心脏和肾脏。建议每周刷牙2–3次，每年专业洁牙。',
      seniorBody: '老年犬牙周病可能引发全身感染，若口臭加重、进食困难或牙龈出血，需及时就医处理。',
    ),
    BreedRisk(
      name: '肥胖',
      icon: Icons.monitor_weight_outlined,
      body: '肥胖会加重关节负担、诱发糖尿病和心脏病。建议按量喂食，保持每天适度运动，定期称重监控体重。',
      seniorBody: '老年犬新陈代谢减慢更易发胖，建议调整饮食结构，选择低热量高纤维配方，保持温和运动。',
    ),
    BreedRisk(
      name: '关节问题',
      icon: Icons.accessibility_new_rounded,
      body: '关节炎是狗狗最常见的退行性疾病，早期表现为起身缓慢、上下楼梯犹豫。建议保持健康体重，适度运动保护关节。',
      seniorBody: '老年犬关节磨损不可逆，建议补充葡萄糖胺和软骨素，提供防滑地面和柔软床垫，避免剧烈运动。',
    ),
  ],
};

/// 短鼻犬种集合，用于季节性建议中额外推送呼吸道注意。
const brachycephalicBreeds = {
  '法国斗牛犬',
  '巴哥犬',
  '英国斗牛犬',
  '波士顿梗',
  '西施犬',
  '北京犬',
  '日本狆',
};

/// 根据品种名称获取风险列表，未匹配返回 `_default`。
List<BreedRisk> risksForBreed(String? breed) {
  if (breed == null || breed.trim().isEmpty) {
    return breedHealthRisks['_default']!;
  }
  return breedHealthRisks[breed.trim()] ?? breedHealthRisks['_default']!;
}
