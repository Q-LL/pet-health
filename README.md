# 毛健康

一个离线优先的狗狗健康履历与提醒 App，使用 Flutter、Material 3、Riverpod 和 go_router 构建。

当前处于 P0：记录管理闭环收尾。狗狗档案、健康记录、护理记录、日历回看、历史记录编辑删除和狗狗头像已经接入本地 Repository；提醒、就诊、导出、备份和本地知识库仍在后续数据接口阶段。

产品范围与技术决策见 [PROJECT_BLUEPRINT.md](PROJECT_BLUEPRINT.md)。开发进度、缺口和下一步顺序见 [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md)。本地 Repository 接口、前端接入示例与测试方法见 [docs/LOCAL_DATA_API.md](docs/LOCAL_DATA_API.md)。

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
