# 毛健康 🐾

**离线优先的狗狗健康履历、提醒与兽医协作工具。**

毛健康帮助狗狗主人把「观察 → 记录 → 提醒 → 趋势提示 → 回顾 → 整理就诊资料」这条护理闭环搬到手机上：持续记录健康事实、按时处理护理事项、看懂数据变化，并在就诊前整理出兽医容易阅读的健康摘要。

它记录事实和医嘱，但**不替代兽医**——不做疾病诊断、不计算药物剂量、不给未经审核的急症判断。

所有数据默认保存在设备本地：无账号、无云端、无广告、无分析 SDK。

## 功能特性

### 记录与回顾

- **狗狗档案**：多狗家庭支持，姓名、犬种、性别、生日、绝育、过敏和慢性病，一键切换当前狗狗；3:4 竖屏头像，选图后原生裁切
- **健康记录（9 种）**：体重、饮食、饮水、排泄、症状（1–5 严重程度）、用药、疫苗、驱虫、自定义
- **护理记录（11 种）**：洗澡、遛狗、口腔、梳毛、美容、指甲、耳部、眼部、足爪、用品环境、自定义——护理与健康记录并列的一等数据
- **遛狗计时**：开始/结束自动计算时长，进行中状态跨重启可恢复；iOS 支持 Live Activity，Android 使用进行中通知兜底
- **日历回看与历史记录**：按天合并查看健康/护理记录，支持类型、关键词筛选、分页、编辑和删除确认
- **爱宠时光**：随笔 + 可选 Emoji 心情 + 系统相册引用组成的时间线。照片不限数量、视频单个不限时长，只保存相册引用不复制原件，缩略图使用 100 MB LRU 缓存（可在设置页查看和清除）

### 提醒与通知

- 单次与重复提醒（每天 / 每月 / 每周 N 次 / 每周指定星期 / 每 N 天 / 每 N 周）
- 完成、跳过、暂停、稍后提醒全程写入日志；提醒可绑定「完成后生成记录」的模板
- 系统本地通知覆盖普通提醒、护理计划到期和进行中遛狗；通知中心聚合逾期 / 今日 / 护理到期
- 数据库中的提醒是唯一真实来源，通知只是执行通道——权限被拒时记录照常保存

### 本地智能（确定性规则，无大模型）

- **健康动态**：近 7 / 30 / 90 天记录统计、摘要、优先洞察和建议
- **健康摘要**：模板化整理体重、记录频次、护理覆盖、饮食和症状，供就诊前快速回顾
- **护理计划**：根据犬种/体型、毛型、年龄、护理历史和事件（如遛狗结束）提出候选计划，主人确认后才开启；支持调整周期、暂停、跳过和忽略
- **护理覆盖统计**：本周完成率、连续达标周数、近 6 周 / 6 个月覆盖率——只展示事实，不生成「护理分」
- 每条建议都带触发原因和证据记录，数据不足时只提示继续记录，不输出健康结论

### 本地知识库

- 独立 `knowledge.sqlite` 离线参考手册：症状观察、记录指南、日常护理、预防健康、就医准备、生命周期、犬种差异和季节照护
- 分类浏览与关键词搜索；健康动态和护理计划卡片可跳转「了解更多」相关文章
- 知识库只辅助观察和就医准备，不参与 AI 问答，不提供诊断、处方或剂量

## 技术栈

| 领域 | 方案 |
|---|---|
| 框架 | Flutter（Material 3） |
| 状态管理 | Riverpod |
| 路由 | go_router（StatefulShellRoute 四 Tab） |
| 用户数据库 | Drift + SQLite（`user.sqlite`，schema v8，11 张表，外键级联） |
| 知识库 | 独立只读 `knowledge.sqlite`，Web 端走 sqlite3.wasm |
| 本地通知 | flutter_local_notifications + timezone；iOS 遛狗 Live Activity 原生实现 |
| 相册引用 | 自研平台通道：iOS PhotoKit / Android Photo Picker 持久 URI，不复制原件 |
| 平台差异 | 条件导入（`_io` / `_web` / `_stub`）隔离照片存储、相册服务、视频播放 |

## 架构一览

功能模块化 MVVM，页面只调用 Repository 或 Riverpod Provider，不直接操作 Drift 表：

```text
View（Flutter 页面）
  └─ Controller / Provider（Riverpod）
       ├─ Repository（业务校验、UUID、级联删除）
       │    ├─ user.sqlite（用户数据，可备份可删除）
       │    └─ knowledge.sqlite（公共知识，只读）
       ├─ 通知服务（提醒 / 护理到期 / 遛狗 Live Activity）
       └─ 文件服务（头像照片、相册引用、缩略图缓存）
```

核心数据表：`pets` 为根，健康记录、护理活动、护理计划、提醒、照片、爱宠时光及其媒体引用、各类操作日志全部外键级联到狗狗；删除狗狗即清理其全部数据与本地文件。

## 快速开始

环境要求：Flutter SDK（Dart ^3.12.2），iOS 构建需 Xcode，Android 构建需 Android SDK。

```bash
git clone https://github.com/Q-LL/pet-health.git
cd pet-health
flutter pub get
flutter run -d chrome   # Web 调试端
# 或连接手机后
flutter run
```

> 提示：爱宠时光相册引用、系统通知、遛狗 Live Activity 等平台能力仅在 iOS / Android 真机或模拟器上生效；Web 端数据保存在浏览器本地 SQLite，适合调试页面流程。

## 测试与质量

```bash
flutter analyze   # 静态检查
flutter test      # 全部单元测试（内存 SQLite，不污染真实数据）
flutter build web # 验证 Web 构建
```

测试覆盖：狗狗 / 照片 / 健康 / 护理 / 护理计划 / 提醒 / 爱宠时光各 Repository，健康建议、摘要、动态三个本地引擎，以及数据库迁移。

## 目录结构

```text
lib/
├── app/                    # 应用入口、go_router 路由、主题
├── core/
│   ├── database/           # user.sqlite（Drift schema 与迁移）
│   ├── knowledge/          # knowledge.sqlite
│   ├── files/              # 照片存储、相册引用服务、视频播放（条件导入）
│   ├── notifications/      # 本地通知、iOS 遛狗 Live Activity
│   ├── navigation/         # 弹层可见性控制
│   └── widgets/            # 页面框架、动效等通用组件
└── features/
    ├── home/               # 首页仪表盘与快捷操作
    ├── pets/               # 狗狗档案与照片管理
    ├── records/            # 健康记录
    ├── care/               # 护理活动、护理计划、覆盖统计
    ├── reminders/          # 提醒中心
    ├── calendar/           # 日历回看
    ├── memories/           # 爱宠时光（随笔、Emoji、相册引用）
    ├── health_tips/        # 本地健康动态、摘要、建议引擎
    ├── knowledge/          # 知识库页面
    ├── notifications/      # 通知中心
    └── settings/           # 设置与缓存管理
```

## 文档

深入设计请阅读 `docs/` 下的三份文档：

| 文档 | 内容 |
|---|---|
| [PROJECT_BLUEPRINT.md](docs/PROJECT_BLUEPRINT.md) | 产品蓝图：定位、页面地图、数据关系、智能与隐私边界、开发阶段 |
| [DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md) | 开发进度：已完成项、当前缺口和下一阶段顺序 |
| [LOCAL_DATA_API.md](docs/LOCAL_DATA_API.md) | 本地数据接口：Repository API、Provider 列表、错误约定与测试方法 |

## 隐私与设计边界

1. 用户数据完全离线，不上传狗狗档案或健康记录；知识库更新也不携带任何用户数据
2. 只申请当前功能必需的权限（通知、相机、相册、文件）；GPS 路线上线前不申请定位权限
3. 智能输出必须显示触发原因、使用的数据和建议行动；可解释、可测试、可忽略
4. 爱宠时光只保存系统相册引用，不复制原件；删除日志不影响相册
5. 所有数据库结构变更必须有迁移与回归测试

## 路线图

- **P0 收尾**：就诊记录与处方原文、通用附件、兽医健康摘要导出（PDF/CSV/JSON）、完整备份恢复
- **P1**：体重等趋势图、知识库 FTS5 与知识包更新、处方 OCR（用户逐项确认后入库）、GPS 遛狗路线
- **P2**：地图路线回顾、本地自然语言查询、用户自备 AI API（密钥存 Keychain/Keystore，调用前展示数据预览）

完整范围与优先级见 [PROJECT_BLUEPRINT.md](docs/PROJECT_BLUEPRINT.md)。
