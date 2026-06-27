# 毛健康本地数据接口文档

> 版本：0.9
> 数据位置：设备本地 SQLite；Web 调试时保存在当前浏览器本地存储  
> 网络依赖：无；本文中的“接口”均为 Dart Repository API，不是 HTTP API

当前文档覆盖已经实现的本地数据接口：狗狗档案、狗狗照片、健康记录、护理活动、护理计划、护理覆盖统计、提醒、系统本地通知、遛狗实时活动、本地健康动态和本地知识库。就诊、处方、通用附件、导出、备份恢复和 OCR 尚未进入本接口文档。

## 1. 前端接入原则

- 页面只调用 Repository 或 Riverpod Provider，不直接操作 Drift 表。
- 所有实体 ID 为 UUID 字符串；第一个占位狗狗可能保留 `local-default-pet`。
- Repository 输入输出的时间统一为 UTC，页面展示时调用 `toLocal()`。
- `watch...` 返回实时 `Stream`，数据库变化后页面会自动收到新数据。
- 删除狗狗会通过 SQLite 外键级联删除其健康记录、护理记录、照片、护理计划、护理计划日志、提醒和提醒日志。

## 2. Riverpod 入口

### 基础 Provider

| Provider | 返回值 | 用途 |
|---|---|---|
| `petRepositoryProvider` | `PetRepository` | 狗狗档案写操作与单次查询 |
| `petsProvider` | `AsyncValue<List<PetProfile>>` | 实时狗狗列表（不含筛选） |
| `selectedPetIdProvider` | `AsyncValue<String>` | 当前狗狗 ID |
| `petPhotoRepositoryProvider` | `PetPhotoRepository` | 狗狗照片、头像和本地文件管理 |
| `healthRecordRepositoryProvider` | `HealthRecordRepository` | 健康记录读写 |
| `careRepositoryProvider` | `CareRepository` | 洗澡、遛狗等护理活动 |
| `carePlanRepositoryProvider` | `CarePlanRepository` | 护理计划持久化、完成日志和到期计算 |
| `carePlanControllerProvider` | `CarePlanState` | 当前狗狗的护理计划页面状态（数据库驱动） |
| `careCoverageProvider` | `AsyncValue<CareCoverage>` | 本周护理计划完成率、应完成数、连续达标周数 |
| `careCoverageDetailProvider` | `AsyncValue<CareCoverageDetail>` | 本周计划进度、近 6 周和近 6 个月覆盖率 |
| `reminderRepositoryProvider` | `ReminderRepository` | 提醒的创建、修改、暂停、完成和执行日志 |
| `careControllerProvider` | `CareState` | 当前狗狗的护理页面状态 |
| `healthTipsProvider` | `AsyncValue<List<HealthTip>>` | 基于档案、记录和护理计划生成本地健康建议 |
| `healthSummaryProvider` | `AsyncValue<HealthSummary>` | 聚合近 30/60 天记录、体重历史和护理覆盖率生成摘要 |
| `healthDynamicsProvider` | `AsyncValue<HealthDynamics>` | 健康动态页聚合摘要、优先洞察和建议 |
| `knowledgeRepositoryProvider` | `KnowledgeRepository` | 本地知识库分类、搜索、详情和相关文章查询 |
| `knowledgeArticlesProvider` | `AsyncValue<List<KnowledgeArticle>>` | 按分类和关键词返回知识文章 |
| `relatedKnowledgeProvider` | `AsyncValue<List<KnowledgeArticle>>` | 按场景 key 返回健康动态/护理页面的相关文章 |

### 筛选 Provider

以下 Provider 均为 `StreamProvider.autoDispose.family`，接受一个筛选参数对象作为 key，返回实时 `AsyncValue<List<...>>`。筛选参数对象实现了 `==` 和 `hashCode`，相同参数会复用缓存。

| Provider | 筛选参数类型 | 返回值 | 用途 |
|---|---|---|---|
| `filteredPetsProvider` | `PetFilter` | `AsyncValue<List<PetProfile>>` | 按关键词和狗狗类型/体型筛选狗狗（UI 已移除类型筛选下拉框，API 仍可用） |
| `filteredHealthRecordsProvider` | `HealthRecordFilter` | `AsyncValue<List<HealthRecord>>` | 按类型、日期、关键词筛选健康记录 |
| `filteredCareActivitiesProvider` | `CareActivityFilter` | `AsyncValue<List<CareActivity>>` | 按类型、日期、关键词筛选护理记录 |
| `carePlansForPetProvider` | `String` (petId) | `AsyncValue<List<CarePlan>>` | 实时狗狗护理计划列表 |
| `filteredRemindersProvider` | `ReminderFilter` | `AsyncValue<List<Reminder>>` | 按来源类型、启用状态、时间筛选提醒 |
| `todayRemindersProvider` | `String` (petId) | `AsyncValue<List<Reminder>>` | 今日启用且未暂停的提醒 |
| `filteredPetPhotosProvider` | `PetPhotoFilter` | `AsyncValue<List<PetPhoto>>` | 按关键词筛选狗狗照片 |

前端读取示例：

```dart
// 基础列表
final pets = ref.watch(petsProvider);
final selectedPetId = ref.watch(selectedPetIdProvider).value;

// 带筛选的列表
final filtered = ref.watch(filteredPetsProvider(
  const PetFilter(keyword: '团', species: '小型犬'),
));
final records = ref.watch(filteredHealthRecordsProvider(
  HealthRecordFilter(petId: petId, type: 'weight', limit: 20),
));
```

### 筛选参数对象

#### PetFilter

源文件：`lib/features/pets/domain/pet_filter.dart`

| 字段 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `keyword` | `String?` | `null` | 匹配名字、品种、过敏信息和慢性病信息 |
| `species` | `String?` | `null` | 精确筛选狗狗类型、犬种或体型 |
| `includePlaceholder` | `bool` | `false` | 是否包含占位档案 |
| `limit` | `int?` | `null` | 每页条数 |
| `offset` | `int` | `0` | 偏移量 |

`withoutPaging()` 返回不带 `limit` 和 `offset` 的副本，适合传入 `count()`。

#### HealthRecordFilter

源文件：`lib/features/records/domain/health_record_filter.dart`

| 字段 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `petId` | `String` | 必填 | 目标狗狗 ID |
| `type` | `String?` | `null` | 记录类型筛选 |
| `from` | `DateTime?` | `null` | 发生时间下界（包含） |
| `to` | `DateTime?` | `null` | 发生时间上界（不包含） |
| `keyword` | `String?` | `null` | 同时匹配标题和备注 |
| `limit` | `int?` | `null` | 每页条数 |
| `offset` | `int` | `0` | 偏移量 |

`withoutPaging()` 返回不带分页参数的副本。

#### CareActivityFilter

源文件：`lib/features/care/domain/care_activity_filter.dart`

字段与 `HealthRecordFilter` 一致，`keyword` 匹配地点和备注。

#### PetPhotoFilter

源文件：`lib/features/pets/domain/pet_photo_filter.dart`

| 字段 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `petId` | `String` | 必填 | 目标狗狗 ID |
| `keyword` | `String?` | `null` | 匹配原文件名和照片说明 |
| `limit` | `int?` | `null` | 每页条数 |
| `offset` | `int` | `0` | 偏移量 |

#### ReminderFilter

源文件：`lib/features/reminders/domain/reminder_filter.dart`

| 字段 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `petId` | `String` | 必填 | 目标狗狗 ID |
| `sourceType` | `String?` | `null` | 来源类型筛选 |
| `enabled` | `bool?` | `null` | 启用状态筛选 |
| `from` | `DateTime?` | `null` | 计划时间下界（包含） |
| `to` | `DateTime?` | `null` | 计划时间上界（不包含） |
| `limit` | `int?` | `null` | 每页条数 |
| `offset` | `int` | `0` | 偏移量 |

`withoutPaging()` 返回不带分页参数的副本。

## 3. 狗狗档案接口

源文件：`lib/features/pets/data/pet_repository.dart`

### 实时列表与条件查找

```dart
Stream<List<PetProfile>> watchPets({
  String? keyword,
  String? species,
  bool includePlaceholder = true,
  int? limit,
  int offset = 0,
})

Future<List<PetProfile>> findPets({
  String? keyword,
  String? species,
  bool includePlaceholder = false,
  int? limit,
  int offset = 0,
})
```

- `watchPets` 实时返回列表，数据变化后自动更新页面。
- `findPets` 只读取一次，适合搜索和分页。
- `keyword` 匹配名字、品种、过敏信息和慢性病信息。
- `species` 字段当前用于存放狗狗类型、犬种或体型等筛选值。
- 前端业务列表通常传 `includePlaceholder: false`。
- 分页要求 `limit > 0`、`offset >= 0`，且非零 `offset` 必须与 `limit` 同时使用。

### 总数查询

```dart
Future<int> count({
  String? keyword,
  String? species,
  bool includePlaceholder = false,
})
```

返回符合筛选条件的狗狗总数，不受 `limit` 和 `offset` 影响，适合分页 UI 计算总页数。

### 单条读取、创建、修改

```dart
Future<PetProfile?> getById(String id)
Future<PetProfile> create(PetDraft draft)
Future<PetProfile> update(String id, PetDraft draft)
Future<PetProfile> savePet(PetDraft draft, {String? id})
```

- `create`：创建狗狗；若只有占位档案，则升级占位档案并保留已有记录。
- `update`：只修改已有狗狗，ID 不存在时抛出 `StateError`。
- `savePet`：兼容性 upsert；新前端代码优先使用 `create/update`。
- 创建或修改成功后自动设为当前狗狗。
- `name` 必填，空名字抛出 `FormatException`。
- `avatarPath` 是兼容字段，前端不要直接修改；头像统一使用照片接口。

```dart
final pet = await ref.read(petRepositoryProvider).create(
  const PetDraft(
    name: '团子',
    species: '小型犬',
    breed: '贵宾犬',
    allergies: '无已知过敏',
  ),
);
```

### 当前狗狗与删除

```dart
Stream<String> watchSelectedPetId()
Future<String> ensureSelectedPetId()
Future<void> selectPet(String id)
Future<bool> delete(String id)
Future<bool> deletePet(String id)
```

- 当前选择保存在本地 `app_settings` 表。
- 删除返回是否实际删除到狗狗。
- 删除狗狗会级联删除健康记录、护理记录、照片、护理计划、提醒及其日志数据库行，并删除 App 私有目录中的照片文件。
- 删除当前狗狗后自动选择剩余狗狗；没有狗狗时重新创建占位档案。

## 4. 狗狗照片接口

源文件：`lib/features/pets/data/pet_photo_repository.dart`

照片只保存在本地：

- Android、iOS 和桌面端：原图写入 App 私有文档目录，SQLite 保存文件路径和元数据。
- Web 调试端：图片字节保存在浏览器本地 SQLite，不上传网络。
- 前端统一调用 `readBytes`，不需要根据平台自行判断路径或字节存储。

支持 `image/jpeg`、`image/png`、`image/webp`、`image/heic` 和 `image/heif`，单张上限为 20 MB。

### 实时列表、搜索和单条读取

```dart
Stream<List<PetPhoto>> watchForPet(
  String petId, {
  String? keyword,
  int? limit,
  int offset = 0,
})

Future<List<PetPhoto>> findForPet(...)
Future<PetPhoto?> getById(String id)
Future<Uint8List> readBytes(String id)
```

- 头像排在第一位，其余按拍摄时间和创建时间倒序。
- `keyword` 匹配原文件名和照片说明。
- `PetPhoto.filePath` 在原生端可用，`PetPhoto.bytes` 在 Web 端可用；展示图片时优先调用 `readBytes`。

### 新增照片

```dart
Future<PetPhoto> add({
  required String petId,
  required Uint8List bytes,
  required String originalName,
  required String mediaType,
  String caption = '',
  DateTime? capturedAt,
  bool setAsAvatar = false,
})
```

第一张照片自动成为头像。后续照片只有在 `setAsAvatar: true` 时替换头像。

```dart
final photo = await ref.read(petPhotoRepositoryProvider).add(
  petId: petId,
  bytes: await pickedFile.readAsBytes(),
  originalName: pickedFile.name,
  mediaType: 'image/jpeg',
  caption: '一岁生日',
  capturedAt: DateTime.now(),
  setAsAvatar: true,
);
```

文件选择由展示层负责，例如相机或相册选择器；Repository 只接收确认后的字节和元数据，不主动申请相机或相册权限。

### 修改说明、设置头像和删除

```dart
Future<PetPhoto> updateMetadata(
  String id, {
  required String caption,
  DateTime? capturedAt,
})

Future<PetPhoto> setAvatar(String id)
Future<bool> delete(String id)
Future<void> deleteAllForPet(String petId)
```

- `updateMetadata` 修改说明与拍摄时间，不重新写图片文件。
- `setAvatar` 保证每只狗狗最多一张头像。
- 删除当前头像后，自动选取该狗狗最新的剩余照片作为头像。
- `delete` 同时删除数据库记录与本地文件，重复删除返回 `false`。
- `deleteAllForPet` 主要供删除狗狗和完整数据清理使用，普通页面不要直接调用。

### 总数查询

```dart
Future<int> count(String petId, {String? keyword})
```

返回该狗狗符合关键词筛选条件的照片总数。

## 5. 健康记录接口

源文件：`lib/features/records/data/health_record_repository.dart`

支持的 `type`：

| 值 | 含义 |
|---|---|
| `weight` | 体重 |
| `food` | 饮食 |
| `water` | 饮水 |
| `elimination` | 排尿或排便 |
| `symptom` | 症状观察 |
| `medication` | 用药事实 |
| `vaccine` | 疫苗 |
| `deworming` | 驱虫 |
| `custom` | 自定义记录 |

### `watchForPet()`

```dart
Stream<List<HealthRecord>> watchForPet(
  String petId, {
  String? type,
  DateTime? from,
  DateTime? to,
  String? keyword,
  int? limit,
  int offset = 0,
})
```

实时按发生时间倒序返回记录。查询规则：

- `from` 包含边界，`to` 不包含边界，时间区间为 `[from, to)`。
- `keyword` 同时匹配标题和备注。
- `limit` 必须大于 0；`offset` 必须非负且只能与 `limit` 同时使用。
- 不传筛选条件时返回该狗狗的全部健康记录。

### `count()`

```dart
Future<int> count(
  String petId, {
  String? type,
  DateTime? from,
  DateTime? to,
  String? keyword,
})
```

返回符合筛选条件的记录总数，不受 `limit` 和 `offset` 影响，适合分页 UI 计算总页数。

```dart
final total = await repository.count(petId, type: 'weight');
final pages = (total / 20).ceil();
```

### `findForPet()`

```dart
Future<List<HealthRecord>> findForPet(
  String petId, {
  String? type,
  DateTime? from,
  DateTime? to,
  String? keyword,
  int? limit,
  int offset = 0,
})
```

参数和排序与 `watchForPet` 一致，但只读取一次，适合搜索页、分页加载和导出。

```dart
final page = await repository.findForPet(
  petId,
  type: 'symptom',
  keyword: '打喷嚏',
  from: monthStart,
  to: nextMonthStart,
  limit: 20,
  offset: 0,
);
```

### `create()` / `update()` / `save()`

```dart
Future<HealthRecord> create(HealthRecordDraft draft)
Future<HealthRecord> update(String id, HealthRecordDraft draft)
Future<HealthRecord> save(HealthRecordDraft draft, {String? id})
```

- `create`：创建新记录并生成 UUID。
- `update`：只修改已有记录；ID 不存在时抛出 `StateError`。
- `save`：兼容性 upsert；不传 `id` 创建，传 `id` 时更新或插入。新前端代码优先使用 `create/update`。

写入校验规则：

- `type` 必须在支持列表中。
- `title` 不能为空。
- `severity` 如填写，范围为 1–5。
- `weight` 必须填写 `numericValue`。

```dart
final selectedId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
await ref.read(healthRecordRepositoryProvider).create(
  HealthRecordDraft(
    petId: selectedId,
    type: 'weight',
    occurredAt: DateTime.now(),
    title: '晚饭前体重',
    numericValue: 4.8,
    unit: 'kg',
  ),
);
```

### `getById()` / `delete()`

```dart
Future<HealthRecord?> getById(String id)
Future<bool> delete(String id)
```

`delete` 返回是否实际删除到记录。

## 6. 护理活动接口

源文件：`lib/features/care/data/care_repository.dart`

支持的 `type`：

| 值 | 含义 |
|---|---|
| `bath` | 洗澡 |
| `walk` | 遛狗 |
| `oral` | 口腔护理 |
| `combing` | 梳毛 |
| `styling` | 美容 |
| `nail` | 指甲检查或修剪 |
| `ear` | 耳部观察或护理 |
| `eye` | 眼部观察或护理 |
| `paw` | 足爪检查或清洁 |
| `environment` | 用品与环境清洁 |
| `custom` | 自定义护理 |

### 通用读取和查找

```dart
Stream<List<CareActivity>> watchForPet(
  String petId, {
  String? type,
  DateTime? from,
  DateTime? to,
  String? keyword,
  int? limit,
  int offset = 0,
})

Future<List<CareActivity>> findForPet(...)
Future<CareActivity?> getById(String id)
Future<CareActivity?> getActiveWalk(String petId)
```

`keyword` 匹配地点和备注，其他筛选、时间边界、排序和分页规则与健康记录一致。

### 总数查询

```dart
Future<int> count(
  String petId, {
  String? type,
  DateTime? from,
  DateTime? to,
  String? keyword,
})
```

返回符合筛选条件的护理记录总数，适合分页 UI 计算总页数。

### 通用写入、修改和删除

```dart
Future<CareActivity> create(CareActivityDraft draft)
Future<CareActivity> update(String id, CareActivityDraft draft)
Future<CareActivity> save(CareActivityDraft draft, {String? id})
Future<bool> delete(String id)
```

- `create` 生成新 ID。
- `update` 要求目标已经存在，否则抛出 `StateError`。
- `save` 是兼容性 upsert；新代码优先使用 `create/update`。
- `walk` 必须填写 `startedAt`，`endedAt` 不能早于开始时间。
- 非 `walk` 类型不能填写 `startedAt/endedAt`。
- 遛狗时长由 Repository 根据开始和结束时间计算，前端不能直接写入时长。

```dart
final activity = await repository.create(
  CareActivityDraft(
    petId: petId,
    type: 'combing',
    occurredAt: DateTime.now(),
    place: '家里',
    note: '梳毛十五分钟，没有发现打结',
  ),
);

await repository.update(
  activity.id,
  CareActivityDraft(
    petId: petId,
    type: activity.type,
    occurredAt: activity.occurredAt,
    place: '阳台',
    note: activity.note,
  ),
);
```

### 洗澡和遛狗便捷接口

```dart
Stream<CareState> watchState(String petId)
Future<BathRecord> recordBath(...)
Future<DateTime> startWalk(...)
Future<WalkRecord?> finishWalk(...)
```

开始遛狗时立即写入数据库，`endedAt == null` 代表进行中；结束时更新同一条记录。数据库限制同一只狗狗最多存在一条进行中的遛狗记录。

页面通常直接使用 `careControllerProvider`，不需要自行组合这些方法。

## 7. 护理计划接口

源文件：`lib/features/care/data/care_plan_repository.dart`

护理计划持久化在 `care_plans` 表，完成和跳过日志记录在 `care_plan_logs` 表。`CarePlanController` 已改为数据库驱动，重启后计划状态可恢复。同一只狗狗的同一 `candidateId` 只保留一条计划记录。

### 读取

```dart
Stream<List<CarePlan>> watchForPet(String petId, {bool? enabled})
Future<List<CarePlan>> findForPet(String petId, {bool? enabled})
Future<CarePlan?> getById(String id)
Future<CarePlan?> findByCandidate(String petId, String candidateId)
```

- `watchForPet` 实时返回计划列表，数据变化后页面自动更新。
- `enabled` 筛选：`true` 只返回启用的，`false` 只返回关闭的（包含已忽略的），`null` 返回全部。
- `findByCandidate` 查找某只狗狗的某个候选 ID 对应的启用计划；已忽略或关闭的记录不会返回。

### 写入

```dart
Future<CarePlan> create(CarePlanDraft draft)
Future<CarePlan> update(String id, CarePlanDraft draft)
Future<bool> enable(String id)
Future<bool> pause(String id)
Future<bool> resume(String id)
Future<bool> disable(String id)
Future<bool> delete(String id)
Future<CarePlan> dismiss(String petId, String candidateId)
```

- `create`：创建新计划，必须填写 `petId`、`candidateId`、`careType`、`title`、`scheduleRule`；如果同一只狗狗已经存在相同 `candidateId`，会复用并更新原记录，避免重复计划。
- `update`：修改已有计划，ID 不存在时抛出 `StateError`。
- `pause/resume`：暂停或恢复计划。
- `disable`：关闭计划。
- `dismiss`：忽略候选。已有计划则关闭；无记录则创建一条 `enabled=false, reasonSnapshot='dismissed'` 的占位记录。

### 日志

```dart
Future<CarePlanLog> logCompletion(String planId, {String note})
Future<CarePlanLog> logSkip(String planId, {String note})
Stream<List<CarePlanLog>> watchLogs(String planId, {int? limit})
Future<List<CarePlanLog>> findLogs(String planId, {int? limit})
```

- `logCompletion/logSkip` 写入日志并关联 `planId` 和 `petId`。
- 日志按 `occurredAt DESC` 排序。

### 到期计算

```dart
Future<void> recalculateNextDue(String planId)
```

根据最近一次 `completed` 日志和固定周期 `scheduleRule` 重新计算 `nextDueAt`。当前支持：

| 格式 | 示例 | 计算方式 |
|---|---|---|
| `每天` | `每天` | 加 1 天 |
| `每 N 天` | `每 3 天` | 加 N 天 |
| `每 N 周` | `每 2 周` | 加 N 周 |
| `每周 N 次` | `每周 3 次` | 按一周均匀分布，向上取整天数 |
| 每周一次类文案 | `每周 1 次`、`每周一次`、`每周观察` | 加 7 天 |

事件触发或历史驱动文案（如 `每次遛狗后询问`、`根据历史间隔`）不会推导固定日期，`nextDueAt` 保持为空，后续由对应规则引擎补充。

## 8. 护理覆盖统计接口

源文件：`lib/features/care/application/care_coverage.dart`

护理覆盖统计从已启用护理计划和护理活动记录实时计算，不单独落库。事件驱动计划不计入固定周期覆盖率。

```dart
final coverage = await ref.watch(careCoverageProvider.future);
final detail = await ref.watch(careCoverageDetailProvider.future);
```

### `CareCoverage`

| 字段 | 含义 |
|---|---|
| `totalActivePlans` | 已开启的非事件驱动计划数量 |
| `completedThisWeek` | 本周已完成次数 |
| `expectedThisWeek` | 本周应完成次数 |
| `weeklyRate` | 本周覆盖率，范围 `0.0~1.0` |
| `currentStreak` | 连续达标周数，达标线为 80% |
| `coverageLevel` | `excellent`、`good` 或 `needs_improvement` |

### `CareCoverageDetail`

`CareCoverageDetail.thisWeek` 返回本周每个固定周期计划的应完成、已完成和剩余次数；`weeklyPeriods` 返回近 6 周覆盖率，`monthlyPeriods` 返回近 6 个月覆盖率。页面只展示事实完成情况，不生成护理分。

## 9. 提醒接口

源文件：`lib/features/reminders/data/reminder_repository.dart`

提醒持久化在 `reminders` 表，执行日志在 `reminder_logs` 表。支持的 `sourceType`：

| 值 | 含义 |
|---|---|
| `care_plan` | 来自护理计划 |
| `manual` | 手动创建 |
| `food` | 饮食 |
| `water` | 饮水 |
| `symptom` | 症状观察 |
| `bath` | 洗澡 |
| `oral` | 口腔护理 |
| `combing` | 梳毛 |
| `styling` | 美容 |
| `nail` | 指甲检查或修剪 |
| `ear` | 耳部观察或护理 |
| `eye` | 眼部观察或护理 |
| `paw` | 足爪检查或清洁 |
| `environment` | 用品与环境清洁 |
| `visit` | 来自就诊 |
| `medication` | 来自用药 |
| `vaccine` | 来自疫苗 |
| `deworming` | 来自驱虫 |

### 读取

```dart
Stream<List<Reminder>> watchForPet(String petId, {String? sourceType, bool? enabled, DateTime? from, DateTime? to, int? limit, int offset})
Future<List<Reminder>> findForPet(...)
Future<Reminder?> getById(String id)
Future<int> count(String petId, {String? sourceType, bool? enabled})
Stream<List<Reminder>> watchTodayReminders(String petId)
Stream<List<Reminder>> watchPendingReminders(String petId)
```

- 筛选、时间边界、排序和分页规则与健康记录一致。
- `watchTodayReminders` 当前等同于 `watchPendingReminders`。
- `watchPendingReminders` 返回所有已到期但未完成的提醒和今天内的提醒，逾期提醒不会跨天消失。

### 写入

```dart
Future<Reminder> create(ReminderDraft draft)
Future<Reminder> update(String id, ReminderDraft draft)
Future<bool> enable(String id)
Future<bool> pause(String id)
Future<bool> resume(String id)
Future<bool> disable(String id)
Future<bool> delete(String id)
```

- `create`：必须填写 `petId`、`sourceType`、`title`、`scheduledAt`。
- `sourceType` 必须在支持列表中，`title` 不能为空。
- `repeatRule` 如填写，必须符合下方重复规则格式；非法格式抛出 `FormatException`。
- `completionMode` 必须是 `none`、`ask_record` 或 `auto_record`。
- `completionTarget` 必须是 `health` 或 `care`。
- 当 `completionMode != none` 时，必须提供对应的健康记录或护理记录模板字段。
- `update` 要求目标已存在，否则抛出 `StateError`。

### 完成提醒后的记录模板

提醒可以只作为待办，也可以绑定完成后的记录动作：

| 字段 | 含义 |
|---|---|
| `completionMode` | `none` 不生成记录；`ask_record` 完成时带入模板并让用户确认；`auto_record` 直接生成预填写记录 |
| `completionTarget` | `health` 绑定健康记录；`care` 绑定护理记录 |
| `recordType` / `recordTitle` / `recordNumericValue` / `recordUnit` / `recordNote` / `recordDetails` | 健康记录模板 |
| `careType` / `carePlace` / `careNote` / `careDetails` | 护理记录模板 |

`auto_record` 会校验对应记录类型的必填字段；护理记录模板不支持 `walk`，遛狗仍走开始/结束计时流程。

### 日志

```dart
Future<ReminderLog> logAction(String reminderId, String action, {String result})
Stream<List<ReminderLog>> watchLogs(String reminderId, {int? limit})
Future<List<ReminderLog>> findLogs(String reminderId, {int? limit})
```

- `action` 必须是 `fired`、`completed`、`skipped`、`snoozed` 或 `failed`。
- `result` 保存额外信息，如“已完成”或失败原因。

### 重复规则

`repeatRule` 字段支持以下格式：

| 格式 | 含义 |
|---|---|
| `daily` | 每天 |
| `monthly` | 每月 |
| `weekly:N` | 每周 N 次 |
| `weekly_days:1,3,5` | 每周指定星期，1 表示周一，7 表示周日 |
| `interval:Nd` | 每 N 天 |
| `interval:Nw` | 每 N 周 |

辅助类 `ReminderRepeatRule` 提供 `parse(raw)`、`format()` 和 `nextOccurrence(from)` 方法。

## 10. 系统通知与遛狗实时活动

源文件：

- `lib/core/notifications/notification_service.dart`
- `lib/core/notifications/walk_live_activity_service.dart`

系统通知不是数据源，只是提醒和遛狗状态的执行/展示通道。Repository 写入成功后，页面或控制器再调用通知服务。

| 方法 | 用途 |
|---|---|
| `initialize()` | 非 Web 平台初始化本地通知、时区和通知响应回调 |
| `requestPermissions()` | 请求 Android/iOS 通知权限和 Android 精确闹钟权限 |
| `scheduleReminder(reminder)` / `cancelReminder(reminder)` | 调度或取消普通提醒通知 |
| `scheduleCarePlanDue(...)` / `cancelCarePlanDue(planId)` | 调度或取消护理计划到期通知 |
| `showCarePlanDueNow(...)` | App 前台时立即显示护理计划到期通知 |
| `showWalkTimer(...)` / `cancelWalkTimer()` | 展示或关闭进行中遛狗通知；iOS 优先使用 Live Activity |
| `walkLiveActivityService.getPendingFinish()` | App 恢复前台时读取从 iOS Live Activity 触发的结束遛狗请求 |

边界：

- Web 调试端不调度系统通知，但提醒数据仍会保存。
- Live Activity 是最佳努力能力，失败时回退到普通本地通知。
- 通知权限被拒绝时，写入 Repository 不应失败；页面需要提示用户去系统设置恢复权限。

## 11. 本地健康动态接口

源文件：

- `lib/features/health_tips/application/health_tips_provider.dart`
- `lib/features/health_tips/application/health_summary_provider.dart`
- `lib/features/health_tips/application/health_dynamics_provider.dart`

健康动态全部在本地计算，不调用网络和大语言模型。

| Provider | 输入数据 | 输出 |
|---|---|---|
| `healthTipsProvider` | 当前狗狗档案、近 30 天健康记录、体重历史、护理计划和覆盖率 | `List<HealthTip>`，含类别、优先级、正文和出现原因 |
| `healthSummaryProvider` | 近 30 天记录、30–60 天对比记录、体重历史和护理覆盖率 | `HealthSummary`，含体重、记录频次、护理、饮食和症状摘要 |
| `healthDynamicsProvider` | 近 90 天记录、摘要上下文和建议上下文 | `HealthDynamics`，聚合摘要、优先洞察和建议 |

输出原则：

- 数据不足时返回空内容或数据质量提示，不生成诊断结论。
- 每条建议带 `reason` 或 `evidence`，便于页面解释“为什么出现”。
- 护理数据只作为上下文和完成情况，不自动推断疾病因果关系。

## 12. 错误约定

## 12. 本地知识库接口

源文件：

- `lib/core/knowledge/knowledge_database.dart`
- `lib/features/knowledge/data/knowledge_repository.dart`

本地知识库使用独立 `knowledge.sqlite`，与用户数据 `user.sqlite` 分离。当前定位是离线参考手册：帮助用户观察、记录、护理和准备就医；不参与 AI 问答，不提供诊断、处方、剂量或治疗方案。

### 数据表

| 表 | 用途 |
|---|---|
| `knowledge_articles` | 知识文章正文、分类、风险等级、上下文关联和 JSON 列表字段 |
| `knowledge_sources` | 来源标题、机构、URL、访问日期和许可说明 |
| `knowledge_article_sources` | 文章与来源的多对多关系 |
| `knowledge_versions` | 本地知识包版本、地区和说明 |

### Repository

```dart
Future<List<String>> listCategories()
Future<List<KnowledgeArticle>> findArticles({
  String? category,
  String keyword = '',
  int limit = 80,
})
Future<KnowledgeArticle?> getArticle(String id)
Future<List<KnowledgeArticle>> findRelated({
  required String contextKey,
  int limit = 3,
})
Future<List<KnowledgeSource>> sourcesForArticle(String articleId)
```

`contextKey` 用于 App 内轻联动，例如：

| 场景 | contextKey |
|---|---|
| 饮水记录或饮水动态 | `record.water` |
| 体重趋势 | `record.weight` |
| 消化相关健康动态 | `health_dynamics.digestive` |
| 口腔护理计划 | `care.oral` |
| 耳部观察计划 | `care.ear` |
| 足爪检查计划 | `care.paw` |
| 疫苗提醒 | `reminder.vaccine` |
| 驱虫提醒 | `reminder.deworming` |
| 幼犬/成年/老年生命周期 | `life_stage.puppy`、`life_stage.adult`、`life_stage.senior` |
| 小型犬/大型犬体型差异 | `breed.small`、`breed.large` |
| 常见犬种差异 | `breed.golden_retriever`、`breed.labrador_retriever`、`breed.poodle`、`breed.border_collie`、`breed.dachshund`、`breed.husky` |
| 短鼻犬夏季照护 | `breed.brachycephalic`、`season.summer` |
| 四季照护 | `season.spring`、`season.summer`、`season.autumn`、`season.winter` |

当前搜索使用标题、摘要、正文和标签的简单本地匹配；FTS5、知识包替换和更多审核条目后续补充。

## 13. 错误约定

| 错误 | 情况 | 前端处理 |
|---|---|---|
| `FormatException` | 类型、时间范围、分页或必填字段不合法 | 显示字段错误，不关闭编辑表单 |
| `StateError` | 更新的记录不存在 | 刷新列表并提示记录可能已被删除 |
| SQLite 外键错误 | `petId` 不存在 | 刷新当前狗狗，阻止保存 |
| `UnsupportedError` | 当前平台不支持本地照片存储 | 禁用照片入口并保留其他档案功能 |

所有写操作返回的 `Future` 必须等待完成后再关闭表单。数据库写入失败时不要先在 UI 中显示“保存成功”。

## 14. 自动化测试

安装依赖并生成数据库代码：

```bash
flutter pub get
dart run build_runner build
```

运行完整检查：

```bash
flutter analyze
flutter test
flutter build web
```

只运行数据层测试：

```bash
flutter test test/features/pets/pet_repository_test.dart
flutter test test/features/pets/pet_photo_repository_test.dart
flutter test test/features/records/health_record_repository_test.dart
flutter test test/features/care/care_repository_test.dart
flutter test test/features/care/care_plan_controller_test.dart
flutter test test/features/reminders/reminder_repository_test.dart
flutter test test/features/health_tips/health_tips_engine_test.dart
flutter test test/features/health_tips/health_summary_engine_test.dart
flutter test test/features/health_tips/health_dynamics_engine_test.dart
```

测试使用内存 SQLite，不会污染手机、模拟器或浏览器中的真实数据。

## 15. 手工验收

1. 执行 `flutter run -d chrome` 或连接手机运行。
2. 打开“狗狗”，创建第一只狗狗；确认占位页面变成狗狗卡片。
3. 再创建第二只狗狗，点击卡片切换“当前”标记。
4. 回到首页，为当前狗狗记录洗澡并开始遛狗。
5. 完全关闭并重新打开 App，确认当前狗狗、洗澡记录和进行中的遛狗仍存在。
6. 结束遛狗，再次重启，确认时长和地点仍存在。
7. 删除狗狗前确认警告文案；删除后确认自动选择剩余狗狗。

开发调试需要清空全部本地数据时，应卸载 App 或清除站点存储。不要在正式功能中直接删除 SQLite 文件。
