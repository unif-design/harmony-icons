# @unif/harmony-icons

API 26 的纯 ArkTS／ArkUI 图标库，包含 146 个同源图标。当前版本为 0.5.5，与所采用的 RN Icons 版本一致。

```typescript
import { UnifIcon, UnifIconName, StarFilled } from '@unif/harmony-icons';

// 在 ArkUI build() 中使用。
UnifIcon({ iconName: UnifIconName.QrOutlined, iconSize: 24, iconColor: '#246BFD' })
StarFilled({ iconSize: 32, iconColor: '#D29300', accessibilityLabel: '已收藏' })
```

| 参数 | 默认值 | 说明 |
|---|---|---|
| `iconName: UnifIconName` | 必填 | 通用入口的图标身份；命名组件不接受此项 |
| `iconSize: number` | `24` | 宽高 vp，有限正数，不跟随应用文字倍率 |
| `iconColor: string` | `'#000'` | 替换 currentColor，保留透明区域 |
| `lineWidth: number \| undefined` | `undefined` | 源坐标内描边，省略使用 1.75；有限非负数 |
| `accessibilityLabel: string` | `''` | 空白表示装饰隐藏，非空提供独立语义 |

所有公开组件均为 `@ComponentV2`，参数跟随父级更新。图标不处理业务、请求和点击；父按钮负责名称、焦点、命中范围和禁用状态。

唯一图形源在 RN Icons 的 `src/svg/` 与 `scripts/icon-manifest.json`，通过同一严格解析校验生成本库的 Shape／Path 几何。HAR 包含全部绘图数据、字节码和声明，不需要 React、RN、Node 或源仓路径。源修订与哈希随包记录在 `rawfile/icon-provenance.json`。

构建接入已验证；实际图形、透明度、裁切、密度、读屏及父控件交互需要对应设备验收，未签名构建不代表已安装运行。
