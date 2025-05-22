import "root:/modules/common"
import "root:/modules/common/widgets/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Button {
    id: button

    property string buttonIcon
    property string buttonText
    property bool keyboardDown: false

    implicitHeight: 120
    implicitWidth: 120

    PointingHandInteraction {}
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = true
            button.clicked()
            event.accepted = true;
        }
    }
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = false
            event.accepted = true;
        }
    }

    background: Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.full
        color: (button.down || button.keyboardDown) ? Appearance.colors.colLayer2Active : ((button.hovered || button.focus) ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer2)

        Behavior on color {
            animation: Appearance.animation.elementMove.colorAnimation.createObject(this)
        }

    }

    contentItem: MaterialSymbol {
        id: icon
        anchors.fill: parent
        color: Appearance.colors.colOnLayer2
        horizontalAlignment: Text.AlignHCenter
        iconSize: 40
        text: buttonIcon
    }

    StyledToolTip {
        content: buttonText
    }

}
