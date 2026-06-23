# 毛健康本地数据接口文档

> 版本：0.5
> 数据位置：设备本地 SQLite；Web 调试时保存在当前浏览器本地存储  
> 网络依赖：无；本文中的“接口”均为 Dart Repository API，不是 HTTP API

当前文档覆盖已经实现的本地数据接口：狗狗档案、狗狗照片、健康记录和护理活动。提醒、就诊、处方、通用附件、护理计划持久化、导出、备份恢复、本地知识库和 OCR 尚未进入本接口文档。

## 1. 前端接入原则

- 页面只调用 Repository 或 Riverpod Provider，不直接操作 Drift 表。
- 所有实体 ID 为 UUID 字符串；第一个占位狗狗可能保留 `local-default-pet`。
- Repository 输入输出的时间统一为 UTC，页面展示时调用 `toLocal()`。
- `watch...` 返回实时 `Stream`，数据库变化后页面会自动收到新数据。
- 删除狗狗会通过 SQLite 外键级联删除其健康与护理记录。

## 2. Riverpod 入口

| Provider | 返回值 | 用途 |
|---|---|---|
| `petRepositoryProvider` | `PetRepository` | 狗狗档案写操作与单次查询 |
| `petsProvider` | `AsyncValue<List<PetProfile>>` | 实时狗狗列表 |
| `selectedPetIdProvider` | `AsyncValue<String>` | 当前狗狗 ID |
| `petPhotoRepositoryProvider` | `PetPhotoRepository` | 狗狗照片、头像和本地文件管理 |
| `healthRecordRepositoryProvider` | `HealthRecordRepository` | 健康记录读写 |
| `careRepositoryProvider` | `CareRepository` | 洗澡、遛狗等护理活动 |
| `careControllerProvider` | `CareState` | 当前狗狗的护理页面状态 |

前端读取示例：

```dart
final pets = ref.watch(petsProvider);
final selectedPetId = ref.watch(selectedPetIdProvider).value;
```

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
- 删除狗狗会级联删除健康记录、护理记录和照片数据库行，并删除 App 私有目录中的照片文件。
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

## 5. 健康记录接口

源文件：`lib/features/records/data/health_record_repository.dart`

支持的 `type`：

| 值 | 含义 |
|---|---|
| `weight` | 体重 |
| `food_water` | 饮食或饮水 |
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
| `grooming` | 梳毛或美容 |
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
    type: 'grooming',
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

## 7. 错误约定

| 错误 | 情况 | 前端处理 |
|---|---|---|
| `FormatException` | 类型、时间范围、分页或必填字段不合法 | 显示字段错误，不关闭编辑表单 |
| `StateError` | 更新的记录不存在 | 刷新列表并提示记录可能已被删除 |
| SQLite 外键错误 | `petId` 不存在 | 刷新当前狗狗，阻止保存 |
| `UnsupportedError` | 当前平台不支持本地照片存储 | 禁用照片入口并保留其他档案功能 |

所有写操作返回的 `Future` 必须等待完成后再关闭表单。数据库写入失败时不要先在 UI 中显示“保存成功”。

## 8. 自动化测试

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
```

测试使用内存 SQLite，不会污染手机、模拟器或浏览器中的真实数据。

## 9. 手工验收

1. 执行 `flutter run -d chrome` 或连接手机运行。
2. 打开“狗狗”，创建第一只狗狗；确认占位页面变成狗狗卡片。
3. 再创建第二只狗狗，点击卡片切换“当前”标记。
4. 回到首页，为当前狗狗记录洗澡并开始遛狗。
5. 完全关闭并重新打开 App，确认当前狗狗、洗澡记录和进行中的遛狗仍存在。
6. 结束遛狗，再次重启，确认时长和地点仍存在。
7. 删除狗狗前确认警告文案；删除后确认自动选择剩余狗狗。

开发调试需要清空全部本地数据时，应卸载 App 或清除站点存储。不要在正式功能中直接删除 SQLite 文件。
