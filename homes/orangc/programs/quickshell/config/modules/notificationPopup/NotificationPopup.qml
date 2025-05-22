import "root:/"
import "root:/modules/common/"
import "root:/modules/common/widgets"
import "root:/services"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: notificationPopup

    LazyLoader {
        loading: true
        PanelWindow {
            id: root
            visible: (columnLayout.children.length > 0 || notificationWidgetList.length > 0)
            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)

            property Component notifComponent: NotificationWidget {}
            property list<NotificationWidget> notificationWidgetList: []

            WlrLayershell.namespace: "quickshell:notificationPopup"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusiveZone: 0

            anchors {
                top: true
                right: true
                bottom: true
            }

            mask: Region {
                item: columnLayout
            }

            color: "transparent"
            implicitWidth: Appearance.sizes.notificationPopupWidth

            // Signal handlers to add/remove notifications
            Connections {
                target: Notifications
                function onNotify(notification) {
                    if (GlobalStates.sidebarRightOpen) {
                        return
                    }
                    // notificationRepeater.model = [notification, ...notificationRepeater.model]
                    const notif = root.notifComponent.createObject(columnLayout, { 
                        notificationObject: notification,
                        popup: true
                    });
                    notificationWidgetList.unshift(notif)

                    // Remove stuff from t he column, add back
                    for (let i = 0; i < notificationWidgetList.length; i++) {
                        if (notificationWidgetList[i].parent === columnLayout) {
                            notificationWidgetList[i].parent = null;
                        }
                    }

                    // Add notification widgets to the column
                    for (let i = 0; i < notificationWidgetList.length; i++) {
                        if (notificationWidgetList[i].parent === null) {
                            notificationWidgetList[i].parent = columnLayout;
                        }
                    }
                }
                function onDiscard(id) {
                    for (let i = notificationWidgetList.length - 1; i >= 0; i--) {
                        const widget = notificationWidgetList[i];
                        if (widget && widget.notificationObject && widget.notificationObject.id === id) {
                            widget.destroyWithAnimation();
                            notificationWidgetList.splice(i, 1);
                        }
                    }
                }
                function onTimeout(id) {
                    for (let i = notificationWidgetList.length - 1; i >= 0; i--) {
                        const widget = notificationWidgetList[i];
                        if (widget && widget.notificationObject && widget.notificationObject.id === id) {
                            widget.destroyWithAnimation();
                            notificationWidgetList.splice(i, 1);
                        }
                    }
                }
                function onDiscardAll() {
                    for (let i = notificationWidgetList.length - 1; i >= 0; i--) {
                        const widget = notificationWidgetList[i];
                        if (widget && widget.notificationObject) {
                            widget.destroyWithAnimation();
                        }
                    }
                    notificationWidgetList = [];
                }
            }

            ColumnLayout { // Scrollable window content
                id: columnLayout
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Appearance.sizes.elevationMargin * 2
                spacing: 0 // The widgets themselves have margins for spacing

                // Notifications are added by the above signal handlers
            }

        }
    }

}
