//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QS_NO_RELOAD_POPUP=1

import "./modules/bar/"
import "./modules/mediaControls/"
import "./modules/notificationPopup/"
import "./modules/onScreenDisplay/"
import "./modules/overview/"
import "./modules/screenCorners/"
import "./modules/session/"
import "./modules/sidebarRight/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "./services/"

ShellRoot {
    Component.onCompleted: {
        ConfigLoader.loadConfig()
        PersistentStateManager.loadStates()
    }

    Bar {}
    MediaControls {}
    NotificationPopup {}
    OnScreenDisplayBrightness {}
    OnScreenDisplayVolume {}
    Overview {}
    ReloadPopup {}
    ScreenCorners {}
    Session {}
    SidebarRight {}
}

