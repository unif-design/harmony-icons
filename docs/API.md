# Harmony Icons API

从 `@unif/harmony-icons` 包根导入。目标为 API 26，使用 `@ComponentV2`。

| 参数 | 类型 | 默认值 | 语义 |
|---|---|---|---|
| `iconName` | `UnifIconName` | 必填 | 146 个枚举键与源清单组件名一一对应 |
| `iconSize` | `number` | `24` | 图标宽高，ArkUI 逻辑单位 vp；不随应用文字倍率变化 |
| `iconColor` | `string` | `'#000'` | ArkUI 颜色字符串，替换源 `currentColor`，透明区域保留 |
| `lineWidth` | `number \| undefined` | `undefined` | 24 × 24 源坐标内的描边宽度；省略使用源值 1.75；`0` 表示无描边 |
| `accessibilityLabel` | `string` | `''` | 空白默认装饰隐藏；非空提供独立语义说明 |

`iconSize` 应为有限正数，`lineWidth` 应为有限非负数，颜色遵循 ArkUI 颜色字符串格式。尺寸、颜色、描边、名称和可访问说明均由父级 `@Param` 输入更新。多实例不修改共享图形数据。

146 个命名组件（如 `QrOutlined`、`StarFilled`）由同一清单生成，参数与 `UnifIcon` 相同，但不再接收 `iconName`。全部入口见 `library/Index.ets`；无需复制名称列表或几何数据。

```typescript
import { UnifIcon, UnifIconName, ShutterRecordingOutlined } from '@unif/harmony-icons';

UnifIcon({
  iconName: UnifIconName.Aspect169Outlined,
  iconSize: 32,
  iconColor: '#E64545',
  lineWidth: 2.5,
  accessibilityLabel: '十六比九画幅'
})
ShutterRecordingOutlined({ iconSize: 24, iconColor: '#E64545' })
```

形状内部按 px 解释 SVG 路径和描边，24px 视口统一缩放到 `iconSize` vp，避免设备密度改变相对几何。图元按源顺序绘制，独立填充、描边、透明度及圆角均保留，并裁切在图标矩形内。

图标不注册点击、不推断动作、不请求业务数据。装饰图标不重复朗读；父操作控件提供名称、焦点、触摸面积和禁用语义。独立状态图标必须有等价文字说明，不能只通过颜色传达状态。

`lineWidth` 不会给源 `stroke="none"` 的实心图元添加边线；颜色也不会填满源 `fill="none"` 的透明区域。`StarOutlined` 和 `StarFilled` 保留不同真实图形。
