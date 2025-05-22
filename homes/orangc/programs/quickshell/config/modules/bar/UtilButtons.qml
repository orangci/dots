import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/config.js" as Config
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Rectangle {
    id: root
    property bool borderless: ConfigOptions.bar.borderless
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32
    color: borderless ? "transparent" : Appearance.colors.colLayer1
    radius: Appearance.rounding.small

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        CircleUtilButton {
            Layout.alignment: Qt.AlignVCenter
            onClicked: Hyprland.dispatch(`exec ${Config.screenshot_command}`)

            MaterialSymbol {
                horizontalAlignment: Qt.AlignHCenter
                fill: 1
                text: "screenshot_region"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer2
            }

        }

        CircleUtilButton {
            Layout.alignment: Qt.AlignVCenter
            onClicked: Hyprland.dispatch(`exec ${Config.colour_picker_command}`)

            MaterialSymbol {
                horizontalAlignment: Qt.AlignHCenter
                fill: 1
                text: "colorize"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer2
            }

        }

    }

}
