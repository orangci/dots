import "root:/modules/common"
import "root:/modules/common/functions/color_utils.js" as ColorUtils
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Button {
    id: button

    property string buttonText
    implicitHeight: 30
    implicitWidth: buttonTextWidget.implicitWidth + 15 * 2

    PointingHandInteraction {}

    background: Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.full
        color: (button.down && button.enabled) ? Appearance.colors.colLayer1Active : 
            ((button.hovered && button.enabled) ? Appearance.colors.colLayer1Hover : 
            ColorUtils.transparentize(Appearance.m3colors.m3surfaceContainerHigh, 1))

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)

        }

    }

    contentItem: StyledText {
        id: buttonTextWidget
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        text: buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.small
        color: button.enabled ? Appearance.m3colors.m3primary : Appearance.m3colors.m3outline

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

}
