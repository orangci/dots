/*
    SPDX-FileCopyrightText: 2014 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
    SPDX-FileCopyrightText: 2021 Mikel Johnson <mikel5764@gmail.com>
    SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
    SPDX-FileCopyrightText: 2022 Himprakash Deka <himprakashd@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.13 as Kirigami
import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

EmptyPage {
    id: root

    property alias searchText: searchField.text
    readonly property alias leaveButtons: leaveButtons
    property real preferredStackViewWidth: 0

    contentHeight: Math.max(searchField.implicitHeight, leaveButtons.implicitHeight)

    LeaveButtons {
        id: leaveButtons
        anchors.left: parent.left
        height: parent.height
        Keys.onLeftPressed: searchField.forceActiveFocus(Qt.TabFocusReason)
        Keys.onRightPressed: searchField.forceActiveFocus(Qt.TabFocusReason)
        Keys.onDownPressed: if (plasmoid.rootItem.sideBar) {
            plasmoid.rootItem.sideBar.forceActiveFocus(Qt.TabFocusReason)
        } else {
            plasmoid.rootItem.contentArea.forceActiveFocus(Qt.TabFocusReason)
        }
    }

    RowLayout {
        id: rowLayout
        height: parent.height
        anchors.right: parent.right
        width: preferredStackViewWidth
        Keys.onDownPressed: plasmoid.rootItem.contentArea.forceActiveFocus(Qt.TabFocusReason)

        PC3.TextField {
            id: searchField
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            focus: true
            placeholderText: i18n("Search")
            clearButtonShown: true
            Accessible.editable: true
            Accessible.searchEdit: true
            inputMethodHints: Qt.ImhNoPredictiveText
            Binding {
                target: plasmoid.rootItem
                property: "searchField"
                value: searchField
            }
            Connections {
                target: plasmoid
                function onExpandedChanged() {
                    if(!plasmoid.expanded) {
                        searchField.clear()
                    }
                }
            }
            Shortcut {
                sequence: StandardKey.Find
                onActivated: {
                    searchField.forceActiveFocus(Qt.ShortcutFocusReason)
                    searchField.selectAll()
                }
            }
            onTextEdited: {
                searchField.forceActiveFocus(Qt.ShortcutFocusReason)
            }
            onAccepted: {
                plasmoid.rootItem.contentArea.currentItem.action.triggered()
                plasmoid.rootItem.contentArea.currentItem.forceActiveFocus(Qt.ShortcutFocusReason)
            }
            Keys.priority: Keys.AfterItem
            Keys.forwardTo: plasmoid.rootItem.contentArea.view
            Keys.onLeftPressed: if (activeFocus) {
                if (LayoutMirroring.enabled) {
                    nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                } else {
                    nextItemInFocusChain(false).forceActiveFocus(Qt.BacktabFocusReason)
                }
            }
            Keys.onRightPressed: if (activeFocus) {
                if (!LayoutMirroring.enabled) {
                    nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                } else {
                    nextItemInFocusChain(false).forceActiveFocus(Qt.BacktabFocusReason)
                }
            }
        }

        PC3.ToolButton {
            id: pinButton
            checkable: true
            checked: plasmoid.configuration.pin
            icon.name: "window-pin"
            text: i18n("Keep Open")
            display: PC3.ToolButton.IconOnly
            PC3.ToolTip.text: text
            PC3.ToolTip.delay: Kirigami.Units.toolTipDelay
            PC3.ToolTip.visible: hovered
            Binding {
                target: plasmoid
                property: "hideOnWindowDeactivate"
                value: !plasmoid.configuration.pin
            }
            KeyNavigation.tab: if (plasmoid.rootItem.sideBar) {
                return plasmoid.rootItem.sideBar
            } else {
                return nextItemInFocusChain()
            }
            Keys.onLeftPressed: if (!LayoutMirroring.enabled) {
                nextItemInFocusChain(false).forceActiveFocus(Qt.BacktabFocusReason)
            }
            Keys.onRightPressed: if (LayoutMirroring.enabled) {
                nextItemInFocusChain(false).forceActiveFocus(Qt.BacktabFocusReason)
            }
            onToggled: plasmoid.configuration.pin = checked
        }
    }
}
