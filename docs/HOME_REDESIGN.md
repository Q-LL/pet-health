# 首页重构首批

本文保留首批首页工作的记录。当前主导航和主流程已继续重构，详见 [UI_REFACTOR.md](UI_REFACTOR.md)。

## 范围

仅重构首页和首页所见的导航配色，保留四个原导航栏目及其他页面。

- 暖白 / 森林绿主题、深色配色、局部入场与切换动画；减少动态效果时取消动画。
- 狗狗肖像与原创插画、首页内切换狗狗。
- 今日提醒预览最多三条；保留完成、稍后和新增提醒操作。
- 三个既有快捷记录、独立遛狗计时卡。
- 通过按狗狗 ID 隔离的 StreamProvider 读取最近体重、最近健康记录、最近时光。
- 护理计划及覆盖率入口；新增 `/home/memories` 直达现有时光页面。
- 数据库、提醒业务规则、原生通知和 Live Activity 沿用现有实现。

本轮不包含完整四 Tab 改版、体重曲线或其他二级页面重设计。

## 验证

执行 `flutter analyze --no-pub`、`flutter test --no-pub` 和 `flutter build web --no-pub`。
新增 320 / 430px、深色大字体、减少动态效果、多狗切换、体重流刷新和时光导航 Widget 测试。
浏览器预览使用独立本地浏览器数据；不代表 iPhone 真机触感、原生相册和实时活动验证。

## 插画素材

- 内置 imagegen 工具生成，非 CLI。
- 文件：`assets/illustrations/home-companion.png`
- 显示位置：未建档或未设置照片的欢迎主视觉；真实狗狗照片优先。
- 原始生成提示词：

> Create one refined editorial illustration asset for a premium Chinese dog health journal mobile app. No text, no letters, no UI, no border. Portrait 3:4 composition. A friendly cream golden dog with soft floppy terracotta ears sitting in a quiet garden, a curved dark forest green leash on ground, a few oversized sage green botanical leaves and a small pale apricot sun. Hand-painted flat gouache color blocks, subtle paper grain, restrained precise dark pencil details, sophisticated Japanese lifestyle magazine aesthetic, warm and comforting, not 3D or glossy or childish cartoon. Background solid warm off-white #F7F6F2 with generous breathing room. Palette forest green #254D43, sage #BDCDB8, apricot #F2D4BF, warm cream. Dog occupies central lower 65 percent, full body with tail visible. Polished production-quality illustration, calm composition.
