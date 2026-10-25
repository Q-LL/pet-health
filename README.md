# 毛健康

离线优先的狗狗日常记录与陪伴应用，使用 Flutter 开发，支持中文和英文，用户数据保存在设备本地。

> **v1 重做中。** 当前分支按 [v1 开发计划](docs/V1_PLAN.md) 重新组织功能：一键记录、按犬种的预设、统一的计划、基于日常节奏的每日卡片，以及月度和年度陪伴回顾。旧版完整代码与文档保存在 `legacy-v0` 标签。

核心记录与统计不依赖账号或云端。每日卡片用于观察和回顾，不提供诊断、处方或药物剂量。

## 开始开发

需要 Flutter SDK，Dart 版本满足 `pubspec.yaml` 中的 `^3.12.2`。移动端开发另需 Xcode / CocoaPods 或 Android SDK。

```bash
git clone https://github.com/Q-LL/pet-health.git
cd pet-health
flutter pub get
flutter run -d chrome
```

连接手机或启动模拟器后，可用 `flutter devices` 查找设备，再运行：

```bash
flutter run -d <device-id>
```

修改用户数据库表结构时，先提升 `schemaVersion`，再生成代码、表结构快照和迁移步骤：

```bash
dart run build_runner build --delete-conflicting-outputs
```

```bash
dart run drift_dev make-migrations
```

快照保存在 `drift_schemas/`，迁移测试位于 `test/drift/`。

修改界面文字时，同时编辑 `lib/core/l10n/arb/` 下的中英文 ARB 文件，再重新生成：

```bash
flutter gen-l10n
```

Web 数据保存在当前浏览器中，与手机数据库独立。爱宠时光的系统相册引用仅在 iOS / Android 实现；Web 不调度系统通知，也不支持 Live Activity。

当前 iOS Runner 与 Live Activity 扩展的部署目标为 **iOS 26.0**，构建前请在 Xcode 核对目标系统和签名。

## 技术与目录

Flutter / Material 3、Riverpod、go_router、Drift / SQLite。

内置字体：中文标题 [ZCOOL KuaiLe](assets/fonts/zcool_kuaile/OFL.txt)、英文标题与数字 [Fredoka](assets/fonts/fredoka/OFL.txt)，均为 SIL Open Font License 1.1；正文使用系统字体。

```text
lib/
├── app/                # 启动、路由、底栏与主题
├── core/
│   ├── db/             # 用户数据库与迁移
│   ├── design/         # 设计语言：颜色、字体、图标、贴纸插画与组件
│   ├── knowledge/      # 内置知识数据库（v1 中冻结）
│   ├── files/          # 照片、相册引用与视频服务
│   ├── l10n/           # 中英文翻译与格式化
│   ├── notifications/  # 本地通知、iOS Live Activity
└── features/           # 按业务划分的模块
assets/                 # 应用图标与插画
test/                   # 数据、规则、迁移和页面回归测试
docs/                   # 开发计划、架构和文案
android/、ios/、web/     # 平台工程与 Web 数据库运行资源
```

## 检查与构建

```bash
flutter analyze --no-pub
flutter test --no-pub
flutter build web --no-pub --release
```

先执行 `flutter pub get`。数据层和主要页面测试使用内存数据库；原生相册授权、系统通知、后台恢复和 Live Activity 需单独在设备上验收。

## 文档

| 文档 | 用途 |
| --- | --- |
| [v1 开发计划](docs/V1_PLAN.md) | 产品方向、已定决策、12 周排期和验收要求 |
| [数据结构](docs/V1_SCHEMA.md) | v1 表结构、选项 code、单位与设置、现算数据 |
| [架构](docs/ARCHITECTURE.md) | 代码分层、媒体与平台边界、维护约定 |
| [文案草稿](docs/COPY_DRAFT.md) | 中英文语气原则、记录项、每日卡片与年度回顾示例 |
| [实机测试清单](docs/DEVICE_TESTING.md) | Web 上测不出来、要装到手机上确认的事项 |
