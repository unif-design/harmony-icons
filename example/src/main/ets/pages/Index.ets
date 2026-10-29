import { UnifIcon, UnifIconName, StarFilled, QrOutlined } from '@unif/harmony-icons';
import { iconCatalog } from '../generated/IconCatalog';

@Entry
@ComponentV2
struct IconsExample {
  @Local darkSurface: boolean = false;
  @Local customStroke: boolean = false;
  @Local customColor: boolean = false;
  @Local textScale: number = 1;
  @Local pressedCount: number = 0;
  @Local selectedIcon: UnifIconName = UnifIconName.StarOutlined;

  build() {
    Column({ space: 12 }) {
      Text('Unif Icons · 146')
        .fontSize(22 * this.textScale)
        .fontColor(this.darkSurface ? '#FFFFFF' : '#111111')
      Row({ space: 8 }) {
        Button('明暗').onClick(() => { this.darkSurface = !this.darkSurface; })
        Button('颜色').onClick(() => { this.customColor = !this.customColor; })
        Button('描边').onClick(() => { this.customStroke = !this.customStroke; })
        Button('字号').onClick(() => { this.textScale = this.textScale === 1 ? 1.3 : 1; })
      }
      Row({ space: 16 }) {
        StarFilled({ iconColor: '#D29300', iconSize: 32 })
        QrOutlined({ iconColor: this.darkSurface ? '#FFFFFF' : '#000000', iconSize: 32 })
        UnifIcon({ iconName: this.selectedIcon, iconSize: 32, iconColor: '#246BFD', accessibilityLabel: '当前图形' })
        Button('换图标').onClick(() => {
          this.selectedIcon = this.selectedIcon === UnifIconName.StarOutlined ? UnifIconName.ShutterRecordingOutlined : UnifIconName.StarOutlined;
        })
      }
      Button() {
        Row({ space: 8 }) {
          UnifIcon({ iconName: UnifIconName.PlusOutlined, iconColor: '#FFFFFF' })
          Text(`父控件点击 ${this.pressedCount}`).fontSize(14 * this.textScale)
        }
      }
      .height(44)
      .accessibilityText('计数按钮')
      .onClick(() => { this.pressedCount += 1; })
      Scroll() {
        Column({ space: 12 }) {
          ForEach(iconCatalog, (name: UnifIconName) => {
            Row({ space: 16 }) {
              Text(name)
                .fontSize(12 * this.textScale)
                .fontColor(this.darkSurface ? '#FFFFFF' : '#111111')
                .layoutWeight(1)
              ForEach([18, 24, 32], (iconDimension: number) => {
                UnifIcon({
                  iconName: name,
                  iconSize: iconDimension,
                  iconColor: this.customColor ? '#E64545' : (this.darkSurface ? '#FFFFFF' : '#000'),
                  lineWidth: this.customStroke ? 3 : undefined
                })
              }, (iconDimension: number): string => iconDimension.toString())
            }
            .width('100%')
            .height(48)
          }, (name: UnifIconName): string => name)
        }
        .padding(16)
      }
      .layoutWeight(1)
    }
    .padding({ top: 32, left: 12, right: 12, bottom: 16 })
    .width('100%')
    .height('100%')
    .backgroundColor(this.darkSurface ? '#171B22' : '#FFFFFF')
  }
}
