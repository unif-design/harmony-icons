# @unif/harmony-icons

面向 HarmonyOS 7.0.0／API 26 的纯 ArkTS／ArkUI 图标 HAR，首批包含 146 个图标。本库版本与所采用的 `@unif/react-native-icons` 版本保持一致；当前为 0.5.5。

`library/` 提供 `UnifIcon`、`UnifIconName` 和 146 个同名组件；`example/` 是真实 ArkUI 消费宿主。Icons 不依赖 Design、React 或 React Native，不读取主题、应用字号或业务状态。

## 使用

在应用模块的 `oh-package.json5` 中将 `@unif/harmony-icons` 指向已构建并复制到消费工程的 HAR，再执行 OHPM 安装。从包根导入，不能深导入生成目录。

```typescript
import { UnifIcon, UnifIconName, StarFilled } from '@unif/harmony-icons';

// 放在 ArkUI build() 中。
UnifIcon({ iconName: UnifIconName.QrOutlined, iconSize: 24, iconColor: '#246BFD' })
StarFilled({ iconSize: 32, iconColor: '#D29300', accessibilityLabel: '已收藏' })
```

完整参数见 [API](docs/API.md)。装饰图标默认不产生读屏节点；按钮负责可访问名称、焦点、命中范围和禁用行为。

## 同源生成

唯一图形源为 `react-native-icons/src/svg/`，名称来自该仓的 `scripts/icon-manifest.json`。在 RN Icons 源仓运行：

```sh
node scripts/build-icons.cjs --target harmony --output ../harmony-icons
node scripts/build-icons.cjs --target harmony --output ../harmony-icons --check
yarn check:icons:all --harmony-root ../harmony-icons
node --test scripts/build-icons.test.cjs scripts/build-harmony-icons.test.cjs
node scripts/build-icons.cjs --check
```

`--output` 指定本仓实际位置；路径只是维护期生成输入，HAR 运行期不依赖源仓。全部 SVG 通过既有严格解析器与命名校验后才写文件；`--check` 只检查漂移，生成器会清理陈旧输出并拒绝覆盖非生成文件。禁止手改 `library/Index.ets`、`library/src/main/ets/generated/`、`example/src/main/ets/generated/` 和 `icon-provenance.json`。

两端共享 SVG、名称和校验规则。RN 的 `react-native-svg` 渲染依赖 React／RN；本库使用原生 Shape／Path，不引入 RN 运行时，也不实现通用 SVG 引擎。源 path 直接保留，rect 和 circle 转为等价路径；逐图元保留 fill、stroke、opacity 与圆角，视口裁切固定为 24 × 24。未来源特性超出现有严格 allowlist 时会整批失败，不能静默忽略。

源修订、清单摘要、生成器摘要和每个 SVG 的 SHA-256 随 HAR 打包在 `rawfile/icon-provenance.json`。

跨仓检查会同时读取 RN 与本仓真实产物；源仓或目标缺失即失败，不自动克隆、生成或发布。只读检查允许无关提交导致的提交号变化，仍逐项比较 SVG／清单／生成器摘要及所有生成文件。仅平台组件行为变化时，另外核对契约与原生实现。

`.github/workflows/icons-parity.yml` 在本仓 PR／main 推送时检出 RN Icons main，校验本仓生成产物是否跟进基线；Node 流水线不证明 HAR 构建或设备验收。RN 自身的 CI 与合并不等待鸿蒙。鸿蒙更新时先核对 RN main 的行为与版本，固定具体提交并生成、构建；溯源提交用于复现。尚未提交的本地生成器不构成远端可复现依据，正式交付前须重新固定来源。


## 构建与验证

使用 DevEco Studio 配套 SDK 26、Hvigor modelVersion 26.0.0 和 `devecocli`，在本仓执行：

```sh
devecocli build --modules library --build-mode debug
devecocli build --modules example --build-mode debug
python3 scripts/verify-har-consumer.py
```

HAR 输出：`library/build/default/outputs/default/library.har`。源码宿主输出：`example/build/default/outputs/default/example-default-unsigned.hap`。这些是当前工程的本地构建位置，不是发布包的运行依赖。

隔离验证脚本检查字节码、146 个声明与溯源资源，将 HAR 和示例复制到临时独立工程，移除源码模块依赖，并从包根实例化全部命名组件及通用入口后实际构建。脚本打印临时工程、HAR 摘要与未签名 HAP 路径，原始产物不入库。脚本失败保留临时目录便于诊断。

源码模块消费时，当前 Hvigor 会按 scoped 包名与 `module.name` 比较而给出 `Missing module info for local modules '@unif/harmony-icons'` 警告；保留包身份，通过独立 HAR 消费另行验证。当前 Hvigor 的版本检查要求首位非零，会对首位为 0 的版本给出 SemVer 警告；OHPM 实际使用标准 SemVer 校验，接受该研发版本，已完成本地安装与包消费。保留工具诊断，不修改校验器。未配置签名会给出 `No signingConfig found`，不影响未签名构建。

示例包含全部图标的 18／24／32 尺寸、明暗表面、显式颜色、描边切换、图标名称更新、应用文字倍率和父按钮点击。构建只证明接线与编译；实际图形、密度、透明度、裁切、读屏、父按钮交互及系统大字号仍需在相同条件下进行设备验收。没有安装、发布或真实业务验收结论。
