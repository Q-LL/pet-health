import '../../care/domain/care_models.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../records/domain/health_record.dart';
import '../../records/domain/health_record_spec.dart';
import '../domain/reminder_models.dart';

ReminderDraft draftFromReminder(
  Reminder reminder, {
  required DateTime scheduledAt,
}) {
  return ReminderDraft(
    petId: reminder.petId,
    sourceType: reminder.sourceType,
    sourceId: reminder.sourceId,
    title: reminder.title,
    scheduledAt: scheduledAt,
    repeatRule: reminder.repeatRule,
    notificationId: reminder.notificationId,
    completionMode: reminder.completionMode,
    completionTarget: reminder.completionTarget,
    recordType: reminder.recordType,
    recordTitle: reminder.recordTitle,
    recordNumericValue: reminder.recordNumericValue,
    recordUnit: reminder.recordUnit,
    recordNote: reminder.recordNote,
    recordDetails: reminder.recordDetails,
    careType: reminder.careType,
    carePlace: reminder.carePlace,
    careNote: reminder.careNote,
    careDetails: reminder.careDetails,
    enabled: reminder.enabled,
    paused: reminder.paused,
  );
}

String careTypeForReminder(Reminder reminder) {
  final type = reminder.careType;
  if (type != null && careActivityTypes.contains(type) && type != 'walk') {
    return type;
  }
  if (isCareReminderSource(reminder.sourceType)) return reminder.sourceType;
  return 'custom';
}

CareActivityPrefill carePrefillFromReminder(Reminder reminder) {
  return CareActivityPrefill(
    place: reminder.carePlace,
    note: reminder.careNote,
    details: reminder.careDetails,
  );
}

String recordTypeForReminder(Reminder reminder) {
  final type = reminder.recordType;
  if (type != null && healthRecordTypes.contains(type)) return type;
  return defaultHealthRecordTypeForReminder(reminder.sourceType);
}

HealthRecordPrefill prefillFromReminder(Reminder reminder) {
  final type = recordTypeForReminder(reminder);
  final spec = healthRecordSpecFor(type);
  return HealthRecordPrefill(
    title: reminder.recordTitle?.trim().isNotEmpty == true
        ? reminder.recordTitle
        : spec.defaultTitle,
    note: reminder.recordNote,
    numericValue: reminder.recordNumericValue,
    unit: reminder.recordUnit ?? spec.defaultUnit,
    details: reminder.recordDetails,
  );
}

String defaultReminderTitle(String sourceType) {
  return switch (sourceType) {
    'food' => '喂食',
    'water' => '提醒饮水',
    'medication' => '用药',
    'vaccine' => '疫苗接种',
    'deworming' => '驱虫',
    'symptom' => '症状观察',
    'bath' => '洗澡',
    'oral' => '口腔护理',
    'combing' => '梳毛',
    'styling' => '美容',
    'nail' => '指甲护理',
    'ear' => '耳部护理',
    'eye' => '眼部护理',
    'paw' => '足爪护理',
    'environment' => '用品 / 环境清洁',
    'visit' => '就诊 / 复诊',
    _ => '',
  };
}

String formatReminderDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String formatReminderTime(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String formatReminderStatus(DateTime scheduledAt) {
  final local = scheduledAt.toLocal();
  final now = DateTime.now();
  if (local.isBefore(now)) {
    return '超时 ${formatOverdueDuration(now.difference(local))}';
  }
  final today = DateTime(now.year, now.month, now.day);
  final scheduledDay = DateTime(local.year, local.month, local.day);
  if (scheduledDay == today) return '今天 ${formatReminderTime(local)}';
  return '${local.month}/${local.day} ${formatReminderTime(local)}';
}

String formatOverdueDuration(Duration duration) {
  if (duration.inDays > 0) return '${duration.inDays} 天';
  if (duration.inHours > 0) return '${duration.inHours} 小时';
  final minutes = duration.inMinutes.clamp(1, 59);
  return '$minutes 分钟';
}

String sourceTypeLabel(String sourceType) => switch (sourceType) {
  'care_plan' => '护理计划',
  'food' => '喂食',
  'water' => '饮水',
  'symptom' => '症状观察',
  'medication' => '用药',
  'vaccine' => '疫苗',
  'deworming' => '驱虫',
  'bath' => '洗澡',
  'oral' => '口腔护理',
  'combing' => '梳毛',
  'styling' => '美容',
  'nail' => '指甲护理',
  'ear' => '耳部护理',
  'eye' => '眼部护理',
  'paw' => '足爪护理',
  'environment' => '环境清洁',
  'visit' => '就诊',
  _ => '手动提醒',
};

String weekdayLabel(int day) {
  return const {
    1: '周一',
    2: '周二',
    3: '周三',
    4: '周四',
    5: '周五',
    6: '周六',
    7: '周日',
  }[day]!;
}

String reminderErrorMessage(Object error) {
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请稍后重试';
}
