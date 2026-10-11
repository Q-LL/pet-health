# v1 数据结构

2026-10-11 草案，等作者确认后实现。产品决策见 [v1 开发计划](V1_PLAN.md)，文案见 [文案草稿](COPY_DRAFT.md)。

## 设计原则

1. **所有做过的事放在一张表里。** 健康、护理、遛狗的记录都写进 `entries`。完成计划不另记日志，做完的那条记录本身就代表完成。
2. **选项存 code，不存显示文字。** 选项都用 Dart enum，按 enum 名存储（如 `stool: soft`），显示时再翻译。用户写的自由文本只放在 `note` 和 `label` 里，引擎从不读取或匹配这两个字段。
3. **能精确换算的量存标准单位。** 体重存 kg，水量存 ml，距离存 m，温度存 °C，按用户设置的单位显示。食物份量不能精确换算（见"单位"一节），按用户选的单位原样存。
4. **能算出来的就不存。** 下次到期时间、日常节奏基线、年度回顾都从 `entries` 现算。
5. **enum 只加不改。** 已经存进数据库的 enum 名不能重命名或删除；废弃的值保留，只是不在界面上显示。

## 与旧代码并存

- 新数据库放在 `lib/core/db/`，类名 `PetHealthDatabase`，数据库名 `pet_health`，`schemaVersion` 从 1 开始。
- 旧的 `lib/core/database/`（`AppDatabase`，库名 `user`）在 v1 开发期间保持不动，旧界面照常可用。新界面逐页接到新数据库，所有旧页面都替换完以后，再一并删除旧数据库、`drift_schemas/app/` 的 v8 快照和对应的迁移测试。
- v1 使用新的 bundle ID，手机上不会读到旧数据。在 Web 上新旧数据库名不同，也不会冲突。

## 表

### `pets`：狗狗档案

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | text PK | |
| `name` | text | |
| `sex` | enum? | `male` / `female` |
| `neutered` | bool? | |
| `birthDate` | date? | 精度为 month 时，存当月 1 日 |
| `birthPrecision` | enum | `day` / `month`；不知道确切生日时可以只填年月 |
| `homeDate` | date? | 到家日期，"在一起第 N 天"由它算出 |
| `breedCode` | text? | 预设犬种列表里的 code，如 `golden_retriever` |
| `breedName` | text? | 预设里没有的犬种由用户手写；只用于显示 |
| `breedGroup` | enum | 由犬种推导出来，用户可以改；取值见下方 |
| `avatarPhotoId` | text? | 引用 `pet_photos` |
| `createdAt`、`updatedAt` | datetime | |

`breedGroup` 的取值：`large_double`、`medium_double`、`small_silky`、`curly`、`small_short`、`large_short`、`mixed`，对应 [COPY_DRAFT 第 6 节](COPY_DRAFT.md#6-犬种分组--breed-groups) 的 7 个分组。

旧表里的 `isPlaceholder`（首次启动时用的占位档案）、过敏和慢性病文本不再保留：没有档案时直接进入引导流程；过敏和慢性病等到做就诊功能时再设计。

### `pet_presets`：每只狗的习惯预设

一只狗一行，`petId` 是主键。

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `mealAmount` | real? | 每餐份量，比如 2 |
| `mealUnit` | enum? | 份量单位；不填时用设置里的默认食物单位 |
| `mealsPerDay` | int? | 一天几餐，用于学习日常节奏 |
| `bowlMl` | real? | 水碗容量，一律按 ml 存 |
| `weightCadence` | enum | `weekly` / `biweekly` / `monthly` / `quarterly` / `off` |
| `quickTypes` | json | 首页一键记录显示哪些类型、按什么顺序，如 `["meal","water","potty","brushing"]` |

### `entries`：所有记录

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | text PK | |
| `petId` | text FK | 删除狗狗时级联删除 |
| `type` | enum | 取值见下表 |
| `occurredAt` | datetime | 按 UTC 存 |
| `planId` | text? | 这条记录完成了哪个计划 |
| `amount` | real? | 数量 |
| `unit` | enum? | 只在份量不能换算时填（饮食、用药）；能换算的量按标准单位存，这一列留空 |
| `startedAt`、`endedAt` | datetime? | 遛狗用；`endedAt` 为空表示正在遛 |
| `durationSec` | int? | 遛狗时长 |
| `distanceM` | real? | 遛狗距离，可以不填 |
| `details` | json | **只存 code** |
| `label` | text? | 用户填写的名称：药品名、疫苗名、自定义事项名 |
| `note` | text | 备注 |
| `createdAt`、`updatedAt` | datetime | |

索引：`(petId, occurredAt)`、`(petId, type, occurredAt)`；每只狗同时最多只能有一条进行中的遛狗记录。

#### 记录类型和 `details` 里的 code

| `type` | 数量 | `details` | 一键记录的默认值 |
| --- | --- | --- | --- |
| `meal` | 份量 + `unit` | `appetite`: `finished` / `left_some` / `barely_ate` | 预设份量，`finished` |
| `water` | ml | `intake`: `more` / `normal` / `less` | 一碗的容量 |
| `potty` | — | `kind`: `poop` / `pee`；`stool`: `normal` / `soft` / `diarrhea` / `hard` / `blood_or_mucus`；`urine`: `normal` / `frequent` / `little` / `unusual_color` | `poop` + `normal` |
| `brushing` | — | `coat`: `smooth` / `tangles` / `heavy_shedding` / `skin_issue` | `smooth` |
| `walk` | 时长、距离 | — | 开始计时 / 结束计时 |
| `bath` | — | `where`: `home` / `groomer` / `vet` | `home` |
| `grooming` | — | `where`: `groomer` / `home` | `groomer` |
| `dewormer` | — | `coverage`: [`internal`, `external`] 可多选 | 上一次的覆盖范围 |
| `heartworm` | — | — | |
| `weight` | kg | — | |
| `ear_check` | — | `ears`: `clean` / `waxy` / `red_or_smelly` | `clean` |
| `other_care` | — | `kind`: `teeth` / `nails` / `eyes` / `paws` / `environment` / `other` | |
| `symptom` | — | `kind`: `vomiting` / `diarrhea` / `coughing` / `itching` / `limping` / `low_energy` / `other`；`status`: `better` / `same` / `worse` | |
| `medication` | 剂量 + `unit` | — | |
| `vaccine` | — | — | |

症状只记录能看到的表现，不出现任何病名。

### `plans`：计划（同时承担提醒）

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | text PK | |
| `petId` | text FK | |
| `entryType` | enum | 完成这个计划需要记哪种记录；一次性事项填 `custom` |
| `entryKind` | text? | 细分到具体项，比如 `other_care` 下的 `nails` |
| `title` | text? | 只有 `custom` 才填；内置类型的名称由翻译文件提供 |
| `schedule` | enum | `every_n_days` / `times_per_week` / `once` |
| `intervalDays` | int? | |
| `timesPerWeek` | int? | |
| `dueAt` | datetime? | `once` 专用，比如看医生的预约 |
| `notifyTime` | time? | 当天几点提醒；不填就不发通知 |
| `snoozedUntil` | datetime? | 点了"稍后提醒"后，到这个时间之前不再提醒 |
| `notificationId` | int? | |
| `source` | enum | `breed_default`：按犬种自动生成；`user`：用户自己建的 |
| `paused` | bool | |
| `createdAt`、`updatedAt` | datetime | |

**到期时间的算法**：
- `every_n_days`：最近一条匹配记录的时间加上间隔天数；还没有任何记录时，视为今天到期。
- `times_per_week`：最近 7 天的次数少于目标次数时，算作到期。
- `once`：到 `dueAt` 时到期；记了一条匹配的记录后，这个计划就算完成，不再提醒。

计划只提供"稍后提醒"，不提供"跳过"。没做就是没做，下次到期时间依然从上一次实际完成的时间往后推算。

### `card_history`：每日卡片记录

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | text PK | |
| `petId` | text FK | |
| `day` | text | 本地日期 `yyyy-MM-dd` |
| `cardKey` | text | 比如 `tip.hot_pavement`、`obs.water_more` |
| `category` | enum | `observation` / `coming_up` / `tip` / `moment` |
| `params` | json | 生成卡片时的参数，比如 `{"days":26}` |
| `dismissed` | bool | 用户是否关掉了这张卡片 |
| `createdAt` | datetime | |

作用：
- 同一天内卡片保持不变，不会每次打开都重新生成；
- 同一条贴士在一段冷却期内不会重复出现；
- 年度回顾以后可能会用到这些数据。

### `weather_days`：天气缓存

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `day` | text PK | 本地日期 |
| `maxC`、`minC` | real | |
| `precipProb` | int | 降水概率，单位 % |
| `uvMax` | real | |
| `fetchedAt` | datetime | |

更换城市时清空这张表。

### 原样沿用

`pet_photos`、`memory_entries`、`memory_media_refs` 的结构不变，搬到新数据库里。知识库是独立的数据库，不动。

## 设置（`app_settings` 键值表）

| 键 | 取值 | 默认值 |
| --- | --- | --- |
| `selectedPetId` | | |
| `locale` | `system` / `zh` / `en` | `system` |
| `unitSystem` | `auto` / `metric` / `imperial` | `auto`：根据系统地区判断，美国用 imperial |
| `unit.weight` | `kg` / `lb` / `jin` | 跟随 `unitSystem` |
| `unit.water` | `ml` / `oz` / `cup` | 跟随 `unitSystem` |
| `unit.distance` | `km` / `mi` | 跟随 `unitSystem` |
| `unit.temperature` | `c` / `f` | 跟随 `unitSystem` |
| `unit.food` | `scoop` / `cup` / `g` / `can` / `pouch` | imperial 默认 `cup`，metric 默认 `g` |
| `weather.city`、`weather.lat`、`weather.lon`、`weather.tz` | | 不填城市就不出天气卡片 |
| `cards.observation`、`cards.coming_up`、`cards.tip`、`cards.moment` | `off` / `less` / `normal` | `normal` |

**单位的优先级**：用户单独设置的单位 > `unitSystem` > 系统地区。每一项都可以在设置里单独改，比如体重用 kg、水量用 oz。

**为什么食物不换算**：一勺或一杯狗粮有多少克，取决于粮的颗粒和密度，没法精确换算。所以食物按用户选的单位原样存，观察引擎也只拿同一只狗、同一种单位的记录互相比较。

**卡片频率**：
- `less` 表示这一类卡片每隔几天才出一张；`off` 表示完全不出。
- 卡片上有"少看这类"按钮，点一次就把这一类降一档（`normal` → `less` → `off`），之后可以在设置里改回来。
- **例外**：便便带血、症状加重这类重要观察，不受频率设置限制。

## 现算的数据

| 内容 | 算法 |
| --- | --- |
| 下次到期 | 见 `plans` 一节 |
| 日常节奏基线 | 最近 28 天里，每种类型每天的次数和数量；有记录的天数不满 7 天时不算基线 |
| 在一起第 N 天 | 今天减去 `homeDate` |
| 年度"使用天数" | 当年至少有一条 `entries` 或时光记录的本地日期的个数 |
| 年度回顾里的数字 | 按年份汇总 `entries` |

## 代码位置

```text
lib/core/db/            PetHealthDatabase、表定义、类型转换器
lib/core/units/         单位 enum、换算、按设置决定显示单位
lib/core/l10n/          ARB 文件（zh、en）与生成的本地化代码
lib/features/entries/   记录：domain（type 与 details code）、data（Repository）
lib/features/plans/     计划：domain（到期时间计算）、data
lib/features/pets/      档案、犬种列表、分组与默认值
```

## 第 1 周的测试

- 每种 `details` 都能和 JSON 互相转换，往返后不丢失信息；读到不认识的 code 时不报错，直接忽略。
- 单位换算：kg ↔ lb ↔ 斤、ml ↔ oz ↔ cup、km ↔ mi、°C ↔ °F 往返精度。
- 单位优先级：单独设置 > 单位制 > 地区。
- 到期时间：三种 schedule 各自的计算、还没有任何记录的情况、稍后提醒、跨午夜和夏令时切换。
- Repository：多只狗的数据互相隔离；每只狗最多一条进行中的遛狗；删除狗狗时级联删除它的数据。
