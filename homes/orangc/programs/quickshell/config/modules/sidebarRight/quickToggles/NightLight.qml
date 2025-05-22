import "root:/modules/common"
import "root:/modules/common/widgets"
import "../"
import Quickshell.Hyprland
import Quickshell

QuickToggleButton {
    id: nightLightButton
    property bool enabled: false
    toggled: enabled
    buttonIcon: "bedtime"
    onClicked: {
        enabled = !enabled
        if (enabled) { Hyprland.dispatch("exec wlsunset -t 4000 -T 4001") }
        else { Hyprland.dispatch("exec pkill wlsunset") }
    }
    StyledToolTip { content: qsTr("Night Light") }
}
