import { getUnifIconDefinition, UnifIconDefinition, UnifIconElement, UnifIconName } from './generated/UnifIconData';

@ComponentV2
export struct UnifIcon {
  @Require @Param iconName: UnifIconName;
  @Param iconSize: number = 24;
  @Param iconColor: string = '#000';
  @Param lineWidth: number | undefined = undefined;
  @Param accessibilityLabel: string = '';

  @Computed
  get definition(): UnifIconDefinition {
    return getUnifIconDefinition(this.iconName);
  }

  build() {
    Shape() {
      ForEach(this.definition.elements, (element: UnifIconElement) => {
        Path({ width: '24px', height: '24px' })
          .commands(element.commands)
          .fill(element.hasFill ? this.iconColor : Color.Transparent)
          .stroke(element.hasStroke ? this.iconColor : Color.Transparent)
          .strokeWidth(`${this.lineWidth ?? this.definition.strokeWidth}px`)
          .strokeLineCap(LineCapStyle.Round)
          .strokeLineJoin(LineJoinStyle.Round)
          .opacity(element.alpha)
          .antiAlias(true)
          .accessibilityLevel('no')
      }, (element: UnifIconElement): string => element.key)
    }
    // Path commands use px; a px viewport keeps source geometry independent of device density.
    .viewPort({ x: '0px', y: '0px', width: '24px', height: '24px' })
    .width(this.iconSize)
    .height(this.iconSize)
    .clip(true)
    .hitTestBehavior(HitTestMode.None)
    .accessibilityLevel(this.accessibilityLabel.trim().length > 0 ? 'yes' : 'no-hide-descendants')
    .accessibilityText(this.accessibilityLabel)
  }
}
