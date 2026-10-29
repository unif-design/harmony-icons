# @unif/harmony-icons

HarmonyOS 7.0.0／API 26 的原生 ArkTS／ArkUI 图标库，包含 146 个同源图标。当前版本为 0.5.5，与所采用的 RN Icons 版本一致。

## 安装与配置

在需要使用图标的应用模块目录执行：

```sh
ohpm install @unif/harmony-icons
```

安装后从包根导入，无需额外初始化或宿主配置。应用需采用 HarmonyOS 7.0.0／API 26 及支持 `@ComponentV2` 的 ArkUI 工程。

## 使用示例

将图标调用放在 ArkUI 组件的 `build()` 中：

```typescript
import { UnifIcon, UnifIconName, StarFilled } from '@unif/harmony-icons';

UnifIcon({ iconName: UnifIconName.QrOutlined, iconSize: 24, iconColor: '#246BFD' })
StarFilled({ iconSize: 32, iconColor: '#D29300', accessibilityLabel: '已收藏' })
```

## 接口说明

公开入口包括通用组件 `UnifIcon`、图标名称枚举 `UnifIconName` 和 146 个命名组件。命名组件名称与所采用的 RN Icons 清单一致，参数如下：

| 参数 | 默认值 | 说明 |
|---|---|---|
| `iconName: UnifIconName` | 必填 | 通用入口的图标身份；命名组件不接受此项 |
| `iconSize: number` | `24` | 宽高 vp，有限正数，不跟随应用文字倍率 |
| `iconColor: string` | `'#000'` | 替换 currentColor，保留透明区域 |
| `lineWidth: number \| undefined` | `undefined` | 源坐标内描边，省略使用 1.75；有限非负数 |
| `accessibilityLabel: string` | `''` | 空白表示装饰隐藏，非空提供独立语义 |

所有公开组件均为 `@ComponentV2`，参数跟随父级更新。完整语义见 [API 文档](https://github.com/unif-design/harmony-icons/blob/main/docs/API.md)，全部图标见[公开导出](https://github.com/unif-design/harmony-icons/blob/main/library/Index.ets)。

## 所需权限

无需申请系统权限，不发起网络请求，没有额外运行时依赖。图标不处理业务和点击；父按钮负责名称、焦点、命中范围及禁用状态。

## 约束与限制

- 当前目标为 HarmonyOS 7.0.0／API 26，使用原生 Shape／Path 绘制，不依赖 React、RN、Node 或 Design。
- `iconSize` 不随系统字体倍率变化；颜色遵循 ArkUI 颜色字符串格式。实心和描边图标保留各自的图形与透明区域。
- 空白标签表示装饰图标；独立语义图标应提供 `accessibilityLabel`，状态也应有等价文字说明。
- 已完成 HAR 构建和独立宿主编译验证。实际图形、透明度、裁切、密度、读屏及父控件交互仍需设备验收，未签名构建不代表已安装运行。

## 发布包目录

```text
Index.d.ets                                  公共声明入口
ets/modules.abc                              ArkUI 字节码
src/main/ets/                                组件声明
src/main/resources/rawfile/icon-provenance.json  图标来源与摘要
```

HAR 包含完整绘图数据、字节码和声明，运行时无需访问源仓。

## 贡献与反馈

通过[仓库 Issues](https://github.com/unif-design/harmony-icons/issues)反馈问题或提交 PR。图形与名称由 [RN Icons 源仓](https://github.com/unif-design/react-native-icons)的 SVG 和清单维护，再由生成器更新本库；原生渲染与无障碍改动在本仓维护。开发与验证步骤见[仓库说明](https://github.com/unif-design/harmony-icons#同源生成)。

## 开源协议

采用 [MIT License](LICENSE)。
