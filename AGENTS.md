# Harmony Icons 开发入口

本仓库提供 HarmonyOS 7.0.0／API 26 的纯 ArkTS／ArkUI Icons HAR。使用中文交流。

- 源码维护使用 `harmony-development` 的 `harmony-icons` 专题；测试、审查和交付按对应阶段技能取得规范。未安装技能时从工程采用的同一规范源取得依据，不把 RN API 当原生实现。
- 先读取 [README](README.md) 的同源生成与校验说明，以及本次涉及的 [API](docs/API.md)。SVG 和名称清单由 `react-native-icons` 源仓唯一维护，按真实工作区定位，不另存一套可编辑资源。
- `library/src/main/ets/generated/`、`library/Index.ets`、`example/src/main/ets/generated/` 与 `icon-provenance.json` 由源仓生成器更新。图形或命名变化回到源；原生参数、渲染和无障碍变化修改所属手写实现并核对 RN 契约。
- 生成后执行两端实际产物的一致性检查；缺少源仓、所需修订或授权时报告未验证范围，不使用手改生成文件或跳过检查来消除差异。
- 从 HAR 公开入口验证独立宿主与资源；源码检查、自动化、构建和设备视觉／交互分别报告。Icons 不依赖 Design，不读取应用主题或业务状态。
- HAR 包版本在 `library/oh-package.json5` 声明，与所采用 RN Icons 源仓 `package.json` 的版本保持一致；升级采用版本时一并核对源修订、生成产物和公开消费。
- 库变更走独立分支和 PR；提交、推送、合并及发布按任务授权执行。提交信息与 PR 标题、描述使用中文，保留必要类型前缀和代码标识。
