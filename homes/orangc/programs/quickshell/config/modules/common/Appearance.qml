import QtQuick
import Quickshell
import "root:/modules/common/functions/color_utils.js" as ColorUtils
import "root:/base16.js" as Base16
import "root:/config.js" as Config
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property QtObject m3colors
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes

    m3colors: QtObject {
        property bool darkmode: false
        property bool transparent: false
        property color m3primary_paletteKeyColor: Base16.base0E
        property color m3secondary_paletteKeyColor: Base16.base0C
        property color m3tertiary_paletteKeyColor: Base16.base09
        property color m3neutral_paletteKeyColor: Base16.base05
        property color m3neutral_variant_paletteKeyColor: Base16.base04
        property color m3background: Base16.base01
        property color m3onBackground: Base16.base05
        property color m3surface: Base16.base01
        property color m3surfaceDim: Base16.base01
        property color m3surfaceBright: Base16.base02
        property color m3surfaceContainerLowest: Base16.base00
        property color m3surfaceContainerLow: Base16.base00
        property color m3surfaceContainer: Base16.base02
        property color m3surfaceContainerHigh: Base16.base03
        property color m3surfaceContainerHighest: Base16.base04
        property color m3onSurface: Base16.base05
        property color m3surfaceVariant: Base16.base03
        property color m3onSurfaceVariant: Base16.base05
        property color m3inverseSurface: Base16.base05
        property color m3inverseOnSurface: Base16.base00
        property color m3outline: Base16.base04
        property color m3outlineVariant: Base16.base03
        property color m3shadow: Base16.base01
        property color m3scrim: Base16.base01
        property color m3surfaceTint: Base16.base0E
        property color m3primary: Base16.base0E
        property color m3onPrimary: Base16.base00
        property color m3primaryContainer: Base16.base03
        property color m3onPrimaryContainer: Base16.base06
        property color m3inversePrimary: Base16.base0A
        property color m3secondary: Base16.base0B
        property color m3onSecondary: Base16.base00
        property color m3secondaryContainer: Base16.base02
        property color m3onSecondaryContainer: Base16.base06
        property color m3tertiary: Base16.base09
        property color m3onTertiary: Base16.base00
        property color m3tertiaryContainer: Base16.base08
        property color m3onTertiaryContainer: Base16.base01
        property color m3error: Base16.base08
        property color m3onError: Base16.base00
        property color m3errorContainer: Base16.base08
        property color m3onErrorContainer: Base16.base0B
        property color m3primaryFixed: Base16.base06
        property color m3primaryFixedDim: Base16.base0E
        property color m3onPrimaryFixed: Base16.base00
        property color m3onPrimaryFixedVariant: Base16.base05
        property color m3secondaryFixed: Base16.base06
        property color m3secondaryFixedDim: Base16.base0C
        property color m3onSecondaryFixed: Base16.base00
        property color m3onSecondaryFixedVariant: Base16.base05
        property color m3tertiaryFixed: Base16.base0B
        property color m3tertiaryFixedDim: Base16.base09
        property color m3onTertiaryFixed: Base16.base00
        property color m3onTertiaryFixedVariant: Base16.base05
        property color m3success: Base16.base0B
        property color m3onSuccess: Base16.base00
        property color m3successContainer: Base16.base02
        property color m3onSuccessContainer: Base16.base06
        property color term0: Base16.base06
        property color term1: Base16.base08
        property color term2: Base16.base09
        property color term3: Base16.base0A
        property color term4: Base16.base0B
        property color term5: Base16.base08
        property color term6: Base16.base0E
        property color term7: Base16.base02
        property color term8: Base16.base00
        property color term9: Base16.base08
        property color term10: Base16.base09
        property color term11: Base16.base0A
        property color term12: Base16.base0B
        property color term13: Base16.base08
        property color term14: Base16.base0E
        property color term15: Base16.base00
    }

    colors: QtObject {
        property color colSubtext: m3colors.m3outline
        property color colLayer0: m3colors.m3background
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Hover: ColorUtils.mix(colLayer0, colOnLayer0, 0.9)
        property color colLayer0Active: ColorUtils.mix(colLayer0, colOnLayer0, 0.8)
        property color colLayer1: m3colors.m3surfaceContainerLow;
        property color colOnLayer1: m3colors.m3onSurfaceVariant;
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45);
        property color colLayer2: ColorUtils.mix(m3colors.m3surfaceContainer, m3colors.m3surfaceContainerHigh, 0.55);
        property color colOnLayer2: m3colors.m3onSurface;
        property color colOnLayer2Disabled: ColorUtils.mix(colOnLayer2, m3colors.m3background, 0.4);
        property color colLayer3: ColorUtils.mix(m3colors.m3surfaceContainerHigh, m3colors.m3onSurface, 0.96);
        property color colOnLayer3: m3colors.m3onSurface;
        property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92);
        property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85);
        property color colLayer2Hover: ColorUtils.mix(colLayer2, colOnLayer2, 0.90);
        property color colLayer2Active: ColorUtils.mix(colLayer2, colOnLayer2, 0.80);
        property color colLayer2Disabled: ColorUtils.mix(colLayer2, m3colors.m3background, 0.8);
        property color colLayer3Hover: ColorUtils.mix(colLayer3, colOnLayer3, 0.90);
        property color colLayer3Active: ColorUtils.mix(colLayer3, colOnLayer3, 0.80);
        property color colPrimaryHover: ColorUtils.mix(m3colors.m3primary, colLayer1Hover, 0.85)
        property color colPrimaryActive: ColorUtils.mix(m3colors.m3primary, colLayer1Active, 0.7)
        property color colPrimaryContainerHover: ColorUtils.mix(m3colors.m3primaryContainer, colLayer1Hover, 0.7)
        property color colPrimaryContainerActive: ColorUtils.mix(m3colors.m3primaryContainer, colLayer1Active, 0.6)
        property color colSecondaryHover: ColorUtils.mix(m3colors.m3secondary, colLayer1Hover, 0.85)
        property color colSecondaryActive: ColorUtils.mix(m3colors.m3secondary, colLayer1Active, 0.4)
        property color colSecondaryContainerHover: ColorUtils.mix(m3colors.m3secondaryContainer, colLayer1Hover, 0.6)
        property color colSecondaryContainerActive: ColorUtils.mix(m3colors.m3secondaryContainer, colLayer1Active, 0.54)
        property color colSurfaceContainerHighestHover: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.95)
        property color colSurfaceContainerHighestActive: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.85)
        property color colTooltip: "#3C4043" // m3colors.m3inverseSurface in the specs, but the m3 website actually uses this color
        property color colOnTooltip: "#F8F9FA" // m3colors.m3inverseOnSurface in the specs, but the m3 website actually uses this color
        property color colScrim: ColorUtils.transparentize(m3colors.m3scrim, 0.5)
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.75)
    }

    rounding: QtObject {
        property int unsharpen: 2
        property int verysmall: 8
        property int small: 12
        property int normal: 17
        property int large: 23
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: 18
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Config.fontMain
            property string title: Config.fontTitle
            property string iconMaterial: Config.fontIconMaterial
            property string iconNerd: Config.fontIconNerd
            property string monospace: Config.fontMono
            property string reading: Config.fontReading
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 13
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: 28
        }
    }

    animationCurves: QtObject {
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: 450
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasized
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }
        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
            property int velocity: 850
            property Component colorAnimation: Component {ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }
        property QtObject scroll: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }
        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
        property QtObject positionShift: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasized
            property int velocity: 650
        }
    }

    sizes: QtObject {
        property real barHeight: 40
        property real barCenterSideModuleWidth: 360
        property real barPreferredSideSectionWidth: 400
        property real sidebarWidth: 460
        property real sidebarWidthExtended: 750
        property real osdWidth: 200
        property real mediaControlsWidth: 440
        property real mediaControlsHeight: 160
        property real notificationPopupWidth: 410
        property real searchWidthCollapsed: 260
        property real searchWidth: 450
        property real hyprlandGapsOut: 5
        property real elevationMargin: 8
        property real fabShadowRadius: 5
        property real fabHoveredShadowRadius: 7
    }
}
