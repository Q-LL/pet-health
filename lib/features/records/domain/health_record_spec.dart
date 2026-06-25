const healthRecordLabels = <String, String>{
  'weight': '体重',
  'food': '饮食',
  'water': '饮水',
  'elimination': '排泄',
  'symptom': '症状',
  'medication': '用药',
  'vaccine': '疫苗',
  'deworming': '驱虫',
  'custom': '自定义记录',
};

class HealthRecordFieldSpec {
  const HealthRecordFieldSpec.text({
    required this.key,
    required this.label,
    this.placeholder,
    this.required = false,
  }) : options = const [];

  const HealthRecordFieldSpec.choice({
    required this.key,
    required this.label,
    required this.options,
    this.required = false,
  }) : placeholder = null;

  final String key;
  final String label;
  final String? placeholder;
  final List<String> options;
  final bool required;

  bool get isChoice => options.isNotEmpty;
}

class HealthRecordTypeSpec {
  const HealthRecordTypeSpec({
    required this.type,
    required this.label,
    required this.defaultTitle,
    this.numericLabel,
    this.defaultUnit,
    this.unitOptions = const [],
    this.numericRequired = false,
    this.severityLabel,
    this.fields = const [],
    this.noteLabel = '备注（可选）',
  });

  final String type;
  final String label;
  final String defaultTitle;
  final String? numericLabel;
  final String? defaultUnit;
  final List<String> unitOptions;
  final bool numericRequired;
  final String? severityLabel;
  final List<HealthRecordFieldSpec> fields;
  final String noteLabel;

  bool get hasNumericValue => numericLabel != null;
  bool get hasSeverity => severityLabel != null;
}

const healthRecordTypeSpecs = <String, HealthRecordTypeSpec>{
  'weight': HealthRecordTypeSpec(
    type: 'weight',
    label: '体重',
    defaultTitle: '体重',
    numericLabel: '体重',
    defaultUnit: 'kg',
    unitOptions: ['kg', '斤', 'lb'],
    numericRequired: true,
    noteLabel: '称重条件、饭前饭后等（可选）',
  ),
  'food': HealthRecordTypeSpec(
    type: 'food',
    label: '饮食',
    defaultTitle: '喂食',
    numericLabel: '份量',
    defaultUnit: 'g',
    unitOptions: ['g', 'kg', 'ml', '勺', '杯', '粒', '包', '罐'],
    fields: [
      HealthRecordFieldSpec.text(key: 'foodName', label: '食物 / 品牌'),
      HealthRecordFieldSpec.choice(
        key: 'meal',
        label: '餐次',
        options: ['早餐', '午餐', '晚餐', '加餐', '训练奖励'],
      ),
      HealthRecordFieldSpec.choice(
        key: 'appetite',
        label: '食欲',
        options: ['正常吃完', '少吃', '没吃', '比平时多', '需要观察'],
      ),
    ],
    noteLabel: '换粮、剩余量、呕吐等补充（可选）',
  ),
  'water': HealthRecordTypeSpec(
    type: 'water',
    label: '饮水',
    defaultTitle: '饮水',
    numericLabel: '饮水量',
    defaultUnit: 'ml',
    unitOptions: ['ml', 'L', '碗'],
    fields: [
      HealthRecordFieldSpec.choice(
        key: 'pattern',
        label: '饮水状态',
        options: ['正常', '偏多', '偏少', '突然增多', '几乎不喝'],
      ),
    ],
    noteLabel: '水盆变化、天气或运动后情况（可选）',
  ),
  'elimination': HealthRecordTypeSpec(
    type: 'elimination',
    label: '排泄',
    defaultTitle: '排泄',
    fields: [
      HealthRecordFieldSpec.choice(
        key: 'kind',
        label: '类型',
        options: ['排便', '排尿', '排便 + 排尿'],
        required: true,
      ),
      HealthRecordFieldSpec.choice(
        key: 'stool',
        label: '便便状态',
        options: ['正常成形', '偏软', '腹泻', '偏硬', '带血 / 黏液', '未观察'],
      ),
      HealthRecordFieldSpec.choice(
        key: 'urine',
        label: '尿尿状态',
        options: ['正常', '偏黄', '频繁', '很少', '疑似带血', '未观察'],
      ),
      HealthRecordFieldSpec.text(key: 'count', label: '次数'),
    ],
    noteLabel: '颜色、气味、是否用力等（可选）',
  ),
  'symptom': HealthRecordTypeSpec(
    type: 'symptom',
    label: '症状',
    defaultTitle: '症状观察',
    severityLabel: '严重程度',
    fields: [
      HealthRecordFieldSpec.text(
        key: 'symptomName',
        label: '症状',
        required: true,
      ),
      HealthRecordFieldSpec.choice(
        key: 'duration',
        label: '持续时间',
        options: ['刚出现', '数小时', '1 天内', '超过 1 天', '反复出现'],
      ),
      HealthRecordFieldSpec.choice(
        key: 'status',
        label: '当前状态',
        options: ['已缓解', '仍在持续', '加重', '准备就医'],
      ),
    ],
    noteLabel: '诱因、频率、伴随表现（可选）',
  ),
  'medication': HealthRecordTypeSpec(
    type: 'medication',
    label: '用药',
    defaultTitle: '用药',
    numericLabel: '剂量',
    defaultUnit: '片',
    unitOptions: ['片', '粒', 'ml', 'mg', 'g', '滴', '支'],
    fields: [
      HealthRecordFieldSpec.text(
        key: 'medicineName',
        label: '药品名称',
        required: true,
      ),
      HealthRecordFieldSpec.choice(
        key: 'route',
        label: '给药方式',
        options: ['口服', '外用', '滴耳', '滴眼', '注射', '其他'],
      ),
      HealthRecordFieldSpec.choice(
        key: 'taken',
        label: '完成情况',
        options: ['已用', '部分用药', '拒绝 / 漏用'],
      ),
    ],
    noteLabel: '医嘱原文、不良反应或补充（可选）',
  ),
  'vaccine': HealthRecordTypeSpec(
    type: 'vaccine',
    label: '疫苗',
    defaultTitle: '疫苗接种',
    fields: [
      HealthRecordFieldSpec.text(
        key: 'vaccineName',
        label: '疫苗名称',
        required: true,
      ),
      HealthRecordFieldSpec.text(key: 'hospital', label: '医院 / 机构'),
      HealthRecordFieldSpec.text(key: 'batchNo', label: '批号'),
      HealthRecordFieldSpec.choice(
        key: 'reaction',
        label: '接种后反应',
        options: ['未观察到异常', '精神稍差', '食欲下降', '局部肿胀', '其他异常'],
      ),
    ],
    noteLabel: '医生说明、下次接种建议（可选）',
  ),
  'deworming': HealthRecordTypeSpec(
    type: 'deworming',
    label: '驱虫',
    defaultTitle: '驱虫',
    numericLabel: '用量',
    defaultUnit: '片',
    unitOptions: ['片', '粒', 'ml', '滴', '支'],
    fields: [
      HealthRecordFieldSpec.text(
        key: 'medicineName',
        label: '驱虫药名称',
        required: true,
      ),
      HealthRecordFieldSpec.choice(
        key: 'scope',
        label: '驱虫类型',
        options: ['体内', '体外', '体内 + 体外'],
      ),
      HealthRecordFieldSpec.choice(
        key: 'reaction',
        label: '用后反应',
        options: ['未观察到异常', '呕吐', '腹泻', '精神稍差', '皮肤刺激', '其他异常'],
      ),
    ],
    noteLabel: '规格、体重适用范围、医嘱（可选）',
  ),
  'custom': HealthRecordTypeSpec(
    type: 'custom',
    label: '自定义记录',
    defaultTitle: '自定义记录',
    fields: [HealthRecordFieldSpec.text(key: 'item', label: '记录项目')],
    noteLabel: '内容',
  ),
};

HealthRecordTypeSpec healthRecordSpecFor(String type) {
  return healthRecordTypeSpecs[type] ?? healthRecordTypeSpecs['custom']!;
}

String defaultHealthRecordTypeForReminder(String sourceType) {
  return switch (sourceType) {
    'food' => 'food',
    'water' => 'water',
    'symptom' => 'symptom',
    'medication' => 'medication',
    'vaccine' => 'vaccine',
    'deworming' => 'deworming',
    _ => 'custom',
  };
}
