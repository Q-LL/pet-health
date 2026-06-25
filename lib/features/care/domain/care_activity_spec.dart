const careActivityLabels = <String, String>{
  'bath': '洗澡',
  'walk': '遛狗',
  'oral': '口腔护理',
  'combing': '梳毛',
  'styling': '美容',
  'nail': '指甲护理',
  'ear': '耳部护理',
  'eye': '眼部护理',
  'paw': '足爪护理',
  'environment': '用品 / 环境清洁',
  'deworming': '驱虫护理',
  'custom': '自定义护理',
};

class CareActivityFieldSpec {
  const CareActivityFieldSpec.text({
    required this.key,
    required this.label,
    this.placeholder,
    this.required = false,
  }) : options = const [];

  const CareActivityFieldSpec.choice({
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

class CareActivityTypeSpec {
  const CareActivityTypeSpec({
    required this.type,
    required this.label,
    required this.placeLabel,
    required this.noteLabel,
    this.fields = const [],
  });

  final String type;
  final String label;
  final String placeLabel;
  final String noteLabel;
  final List<CareActivityFieldSpec> fields;
}

const careActivityTypeSpecs = <String, CareActivityTypeSpec>{
  'bath': CareActivityTypeSpec(
    type: 'bath',
    label: '洗澡',
    placeLabel: '具体地点（可选）',
    noteLabel: '洗澡情况、皮肤状态、吹干情况（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'method',
        label: '洗澡方式',
        options: ['家里洗澡', '宠物店洗澡', '医院护理', '其他'],
      ),
      CareActivityFieldSpec.choice(
        key: 'products',
        label: '洗护用品',
        options: ['沐浴露', '沐浴露 + 护毛素', '药浴', '免洗清洁', '未使用', '其他'],
      ),
      CareActivityFieldSpec.choice(
        key: 'coatDry',
        label: '吹干情况',
        options: ['完全吹干', '基本吹干', '局部潮湿', '未确认'],
      ),
    ],
  ),
  'oral': CareActivityTypeSpec(
    type: 'oral',
    label: '口腔护理',
    placeLabel: '地点（可选）',
    noteLabel: '牙龈、口气、牙结石观察（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'method',
        label: '护理方式',
        options: ['刷牙', '洁牙湿巾', '漱口水', '咀嚼洁齿', '口腔检查'],
      ),
      CareActivityFieldSpec.choice(
        key: 'cooperation',
        label: '配合度',
        options: ['配合', '一般', '抗拒', '只完成部分'],
      ),
    ],
  ),
  'combing': CareActivityTypeSpec(
    type: 'combing',
    label: '梳毛',
    placeLabel: '地点（可选）',
    noteLabel: '打结、掉毛、皮肤观察（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'coat',
        label: '毛发状态',
        options: ['顺滑', '轻微打结', '明显打结', '掉毛较多', '发现皮肤异常'],
      ),
      CareActivityFieldSpec.choice(
        key: 'tool',
        label: '工具',
        options: ['针梳', '排梳', '褪毛梳', '开结梳', '其他'],
      ),
    ],
  ),
  'styling': CareActivityTypeSpec(
    type: 'styling',
    label: '美容',
    placeLabel: '美容地点（可选）',
    noteLabel: '造型、修剪范围、店员反馈（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'service',
        label: '服务项目',
        options: ['基础美容', '全身修剪', '局部修剪', '剃毛', '专业护理'],
      ),
      CareActivityFieldSpec.text(key: 'shop', label: '门店 / 美容师'),
    ],
  ),
  'nail': CareActivityTypeSpec(
    type: 'nail',
    label: '指甲护理',
    placeLabel: '地点（可选）',
    noteLabel: '是否剪到血线、磨甲情况（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'action',
        label: '项目',
        options: ['检查', '修剪', '磨甲', '修剪 + 磨甲'],
      ),
      CareActivityFieldSpec.choice(
        key: 'result',
        label: '完成情况',
        options: ['顺利完成', '只完成前爪', '只完成后爪', '抗拒未完成'],
      ),
    ],
  ),
  'ear': CareActivityTypeSpec(
    type: 'ear',
    label: '耳部护理',
    placeLabel: '地点（可选）',
    noteLabel: '气味、分泌物、抓挠等观察（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'action',
        label: '项目',
        options: ['观察', '外耳清洁', '滴耳药后记录', '复查'],
      ),
      CareActivityFieldSpec.choice(
        key: 'status',
        label: '观察结果',
        options: ['未见异常', '有气味', '分泌物增多', '发红', '频繁抓挠'],
      ),
    ],
  ),
  'eye': CareActivityTypeSpec(
    type: 'eye',
    label: '眼部护理',
    placeLabel: '地点（可选）',
    noteLabel: '分泌物、泪痕、眼周状态（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'action',
        label: '项目',
        options: ['眼周清洁', '泪痕护理', '滴眼药后记录', '观察'],
      ),
      CareActivityFieldSpec.choice(
        key: 'status',
        label: '观察结果',
        options: ['未见异常', '分泌物增多', '流泪', '发红', '眯眼'],
      ),
    ],
  ),
  'paw': CareActivityTypeSpec(
    type: 'paw',
    label: '足爪护理',
    placeLabel: '地点（可选）',
    noteLabel: '趾间、肉垫、雨雪后清洁情况（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'action',
        label: '项目',
        options: ['擦爪', '足爪检查', '肉垫护理', '趾间清洁'],
      ),
      CareActivityFieldSpec.choice(
        key: 'status',
        label: '观察结果',
        options: ['未见异常', '潮湿', '发红', '破损', '异物'],
      ),
    ],
  ),
  'environment': CareActivityTypeSpec(
    type: 'environment',
    label: '用品 / 环境清洁',
    placeLabel: '清洁区域（可选）',
    noteLabel: '消毒方式、用品更换情况（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'item',
        label: '清洁对象',
        options: ['食盆', '水碗', '狗窝', '玩具', '牵引用品', '活动区域'],
      ),
      CareActivityFieldSpec.choice(
        key: 'method',
        label: '清洁方式',
        options: ['清洗', '消毒', '更换', '晾晒', '深度清洁'],
      ),
    ],
  ),
  'deworming': CareActivityTypeSpec(
    type: 'deworming',
    label: '驱虫护理',
    placeLabel: '地点（可选）',
    noteLabel: '药品、剂量、反应观察（可选）',
    fields: [
      CareActivityFieldSpec.choice(
        key: 'method',
        label: '驱虫类型',
        options: ['体外驱虫', '体内驱虫', '体内外同驱', '其他'],
      ),
      CareActivityFieldSpec.text(key: 'product', label: '药品名称'),
    ],
  ),
  'custom': CareActivityTypeSpec(
    type: 'custom',
    label: '自定义护理',
    placeLabel: '地点（可选）',
    noteLabel: '护理内容',
    fields: [
      CareActivityFieldSpec.text(key: 'item', label: '护理项目', required: true),
    ],
  ),
};

CareActivityTypeSpec careActivitySpecFor(String type) {
  return careActivityTypeSpecs[type] ?? careActivityTypeSpecs['custom']!;
}

bool isCareReminderSource(String sourceType) {
  return careActivityTypeSpecs.containsKey(sourceType) && sourceType != 'walk';
}
