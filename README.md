# 毛健康

一个离线优先的狗狗健康履历与提醒 App，使用 Flutter、Material 3、Riverpod 和 go_router 构建。

当前处于 P0：记录、护理计划、提醒、本地健康动态和轻量知识库正在收尾。狗狗档案、健康记录、护理记录、照片头像、日历回看、历史记录编辑删除、护理计划、护理覆盖率、提醒中心、本地通知、健康动态建议、健康摘要和本地 SQLite 参考手册已经接入本地数据流；就诊、处方、通用附件、导出、备份、OCR 和 GPS 路线仍在后续阶段。

产品范围与技术决策见 [docs/PROJECT_BLUEPRINT.md](docs/PROJECT_BLUEPRINT.md)。开发进度、缺口和下一步顺序见 [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md)。本地 Repository 接口、前端接入示例与测试方法见 [docs/LOCAL_DATA_API.md](docs/LOCAL_DATA_API.md)。

## 本地运行

```bash
flutter pub get
flutter run -d chrome
```

## 质量检查

```bash
flutter analyze
flutter test
```
