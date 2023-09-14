/*
    SPDX-FileCopyrightText: 2011 Martin Gräßlin <mgraesslin@kde.org>
    SPDX-FileCopyrightText: 2012 Gregor Taetzner <gregor@freenet.de>
    SPDX-FileCopyrightText: 2015-2018 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2021 Mikel Johnson <mikel5764@gmail.com>
    SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
    SPDX-FileCopyrightText: 2022 Himprakash Deka <himprakashd@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick 2.15
import QtQml 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3
import org.kde.kirigami 2.16 as Kirigami

// ScrollView makes it difficult to control implicit size using the contentItem.
// Using EmptyPage instead.
EmptyPage {
    id: root
    property alias model: view.model
    property alias count: view.count
    property alias currentIndex: view.currentIndex
    property alias currentItem: view.currentItem
    property alias delegate: view.delegate
    property alias section: view.section
    property alias view: view
    property real preferredHeight: 0
    property real preferredWidth: 0
    property bool mainContentView: false

    clip: view.height < view.contentHeight

    header: MouseArea {
        implicitHeight: KickoffSingleton.listItemMetrics.margins.top
        hoverEnabled: true
        onEntered: {
            if (containsMouse) {
                let targetIndex = view.indexAt(mouseX + view.contentX, view.contentY)
                if (targetIndex >= 0) {
                    view.currentIndex = targetIndex
                    view.forceActiveFocus(Qt.MouseFocusReason)
                }
            }
        }
    }

    leftPadding: 0
    rightPadding: mainContentView ? 0 : plasmoid.rootItem.backgroundMetrics.rightPadding
    topPadding: 0
    bottomPadding: 0

    contentItem: ListView {
        id: view
        readonly property real availableWidth: (verticalScrollBar.visible ? (width - verticalScrollBar.width) : width)
        readonly property real availableHeight: height
        property bool movedWithKeyboard: false

        Accessible.role: Accessible.List

        implicitWidth: mainContentView ? KickoffSingleton.gridCellSize * plasmoid.configuration.gridColumns : (preferredWidth ? preferredWidth : contentWidth)
        implicitHeight: mainContentView ? preferredHeight : contentHeight

        currentIndex: count > 0 ? 0 : -1
        focus: true
        interactive: height < contentHeight
        pixelAligned: true
        reuseItems: true
        boundsBehavior: Flickable.StopAtBounds
        // default keyboard navigation doesn't allow focus reasons to be used
        // and eats up/down key events when at the beginning or end of the list.
        keyNavigationEnabled: false
        keyNavigationWraps: false

        // This is actually needed. The highlight will animate from thin to wide otherwise.
        highlightResizeDuration: 0
        highlightMoveDuration: 100
        highlight: PlasmaCore.FrameSvgItem {
            // The default Z value for delegates is 1. The default Z value for the section delegate is 2.
            // The highlight gets a value of 3 while the drag is active and then goes back to the default value of 0.
            z: root.currentItem && root.currentItem.Drag.active ?
                3 : 0
            opacity: view.activeFocus
                || (plasmoid.rootItem.contentArea === root
                    && plasmoid.rootItem.searchField.activeFocus) ? 1 : 0.5
            imagePath: "widgets/viewitem"
            prefix: "hover"
            visible: plasmoid.rootItem.contentArea !== root
                || ActionMenu.menu.status !== 1
        }

        delegate: KickoffItemDelegate {
            width: view.availableWidth
        }

        section {
            property: "group"
            criteria: ViewSection.FullString
            delegate: PC3.Label {
                //readonly property bool visualFocus: false
                width: Math.min(Math.ceil(implicitWidth), view.availableWidth)
                height: KickoffSingleton.listDelegateHeight
                horizontalAlignment: section.length === 1 ? Text.AlignHCenter : Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                maximumLineCount: 1
                elide: Text.ElideRight
                font.pixelSize: KickoffSingleton.listDelegateContentHeight
                enabled: false
                text: section.length === 1 ? section.toUpperCase() : section
            }
        }

        move: normalTransition
        moveDisplaced: normalTransition

        Transition {
            id: normalTransition
            NumberAnimation {
                duration: PlasmaCore.Units.shortDuration
                properties: "x, y"
                easing.type: Easing.OutCubic
            }
        }

        PC3.ScrollBar.vertical: PC3.ScrollBar {
            id: verticalScrollBar
            z: 2
            height: root.height
            anchors.right: parent.right
        }

        Kirigami.WheelHandler {
            target: view
            filterMouseEvents: true
            // `20 * Qt.styleHints.wheelScrollLines` is the default speed.
            // `* PlasmaCore.Units.devicePixelRatio` is needed on X11
            // because Plasma doesn't support Qt scaling.
            horizontalStepSize: 20 * Qt.styleHints.wheelScrollLines * PlasmaCore.Units.devicePixelRatio
            verticalStepSize: 20 * Qt.styleHints.wheelScrollLines * PlasmaCore.Units.devicePixelRatio
        }

        Connections {
            target: plasmoid
            function onExpandedChanged() {
                if(!plasmoid.expanded) {
                    view.currentIndex = 0
                    view.positionViewAtBeginning()
                }
            }
        }

        Timer {
            id: movedWithKeyboardTimer
            interval: 200
            onTriggered: view.movedWithKeyboard = false
        }

        function focusCurrentItem(event, focusReason) {
            currentItem.forceActiveFocus(focusReason)
            event.accepted = true
        }

        Keys.onMenuPressed: if (currentItem !== null) {
            currentItem.forceActiveFocus(Qt.ShortcutFocusReason)
            currentItem.openActionMenu()
        }
        Keys.onPressed: {
            let targetX = currentItem ? currentItem.x : contentX
            let targetY = currentItem ? currentItem.y : contentY
            let targetIndex = currentIndex
            let atFirst = currentIndex === 0
            let atLast = currentIndex === count - 1
            if (count > 1) {
                switch (event.key) {
                    case Qt.Key_Up: if (!atFirst) {
                        decrementCurrentIndex()
                        focusCurrentItem(event, Qt.BacktabFocusReason)
                    } break
                    case Qt.Key_Down: if (!atLast) {
                        incrementCurrentIndex()
                        focusCurrentItem(event, Qt.TabFocusReason)
                    } break
                    case Qt.Key_Home: if (!atFirst) {
                        currentIndex = 0
                        focusCurrentItem(event, Qt.BacktabFocusReason)
                    } break
                    case Qt.Key_End: if (!atLast) {
                        currentIndex = count - 1
                        focusCurrentItem(event, Qt.TabFocusReason)
                    } break
                    case Qt.Key_PageUp: if (!atFirst) {
                        targetY = targetY - height + 1
                        targetIndex = indexAt(targetX, targetY)
                        // TODO: Find a more efficient, but accurate way to do this
                        while (targetIndex === -1) {
                            targetY += 1
                            targetIndex = indexAt(targetX, targetY)
                        }
                        currentIndex = Math.max(targetIndex, 0)
                        focusCurrentItem(event, Qt.BacktabFocusReason)
                    } break
                    case Qt.Key_PageDown: if (!atLast) {
                        targetY = targetY + height - 1
                        targetIndex = indexAt(targetX, targetY)
                        // TODO: Find a more efficient, but accurate way to do this
                        while (targetIndex === -1) {
                            targetY -= 1
                            targetIndex = indexAt(targetX, targetY)
                        }
                        currentIndex = Math.min(targetIndex, count - 1)
                        focusCurrentItem(event, Qt.TabFocusReason)
                    } break
                }
            }
            movedWithKeyboard = event.accepted
            if (movedWithKeyboard) {
                movedWithKeyboardTimer.restart()
            }
        }
    }
}
