/*
    SPDX-FileCopyrightText: 2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2022 Himprakash Deka <himprakashd@gmail.com>
    
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtGraphicalEffects 1.15
// Deliberately imported after QtQuick to avoid missing restoreMode property in Binding. Fix in Qt 6.
import QtQml 2.15

import org.kde.kquickcontrolsaddons 2.0
import org.kde.kwindowsystem 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.private.shell 2.0

import org.kde.plasma.private.kicker 0.1 as Kicker

import "code/tools.js" as Tools

/* TODO
 * Reverse middleRow layout + keyboard nav + filter list text alignment in rtl locales.
 * Keep cursor column when arrow'ing down past non-full trailing rows into a lower grid.
 * Make DND transitions cleaner by performing an item swap instead of index reinsertion.
*/

Kicker.DashboardWindow {
    id: root

    property bool smallScreen: ((Math.floor(width / PlasmaCore.Units.iconSizes.huge) <= 22) || (Math.floor(height / PlasmaCore.Units.iconSizes.huge) <= 14))

    property int iconSize: smallScreen ? PlasmaCore.Units.iconSizes.large : PlasmaCore.Units.iconSizes.huge
    property int cellSize: iconSize + PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).height
        + (2 * PlasmaCore.Units.smallSpacing)
        + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                        highlightItemSvg.margins.left + highlightItemSvg.margins.right))
    property int columns: Math.floor(((smallScreen ? 85 : 80)/100) * Math.ceil(width / cellSize))
    property bool searching: searchField.text !== ""
    property var filterListIndex: 0

    keyEventProxy: searchField
    backgroundColor: Qt.rgba(0, 0, 0, 0.737)

    onKeyEscapePressed: {
        if (searching) {
            searchField.clear();
        } else {
            root.toggle();
        }
    }

    onVisibleChanged: {
        reset();

        if (visible) {
            preloadAllAppsTimer.restart();
        }
    }

    function reset() {
        searchField.clear();
        filterList.currentIndex = 0;
        mainGrid.currentIndex = -1;
        filterListScrollArea.focus = true;
    }

    mainItem: MouseArea {
        id: rootItem

        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
        LayoutMirroring.childrenInherit: true

        Connections {
            target: kicker

            function onReset() {
                if (!root.searching) {
                    filterList.applyFilter();
                    funnelModel.reset();
                }
            }

            function onDragSourceChanged() {
                if (!kicker.dragSource) {
                    // FIXME TODO HACK: Reset all views post-DND to work around
                    // mouse grab bug despite QQuickWindow::mouseGrabberItem==0x0.
                    // Needs a more involved hunt through Qt Quick sources later since
                    // it's not happening with near-identical code in the menu repr.
                    rootModel.refresh();
                }
            }
        }

        Connections {
            target: plasmoid
            function onUserConfiguringChanged() {
                if (plasmoid.userConfiguring) {
                    root.hide()
                }
            }
        }

        PlasmaComponents.Menu {
            id: contextMenu

            PlasmaComponents.MenuItem {
                action: plasmoid.action("configure")
            }
        }

        PlasmaExtras.Heading {
            id: dummyHeading
            height: PlasmaCore.Units.gridUnit * (smallScreen ? 2 : 4)
            visible: true
            level: 1
        }

        TextMetrics {
            id: headingMetrics
            font: dummyHeading.font
        }

        Kicker.FunnelModel {
            id: funnelModel

            onSourceModelChanged: {
                if (mainColumn.visible) {
                    mainGrid.currentIndex = -1;
                    mainGrid.forceLayout();
                }
            }
        }

        Timer {
            id: preloadAllAppsTimer

            property bool done: false

            interval: 1000
            repeat: false

            onTriggered: {
                if (done || root.searching) {
                    return;
                }

                for (var i = 0; i < rootModel.count; ++i) {
                    var model = rootModel.modelForRow(i);

                    if (model.description === "KICKER_FAVORITES_MODEL") {
                        funnelModel.sourceModel = rootModel.favoritesModel;
                        break;
                    } else if (model.description === "KICKER_ALL_MODEL") {
                        allAppsGrid.model = model;
                        break;
                    }
                }
            }

            function defer() {
                if (running && !done) {
                    restart();
                }
            }
        }

        PlasmaComponents.TextField {
            id: searchField

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: dummyHeading.bottom
            }

            width: 2*implicitWidth

            placeholderText: i18n("Type to search")
            clearButtonShown: false
            horizontalAlignment: Text.AlignHCenter

            inputMethodHints: Qt.ImhNoPredictiveText

            onTextChanged: {
                runnerModel.query = searchField.text;
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Tab || event.key === Qt.Key_Down) {
                    event.accepted = true;
                    mainColumn.tryActivate(0, 0);
                }
            }
            
            function clear() {
                text = "";
            }
        }

        Row {
            id: middleRow

            anchors {
                top: searchField.bottom
                bottom: parent.bottom
                topMargin: PlasmaCore.Units.gridUnit * (smallScreen ? 2 : 4)
                bottomMargin: PlasmaCore.Units.gridUnit * (smallScreen ? 2 : 4)
                horizontalCenter: parent.horizontalCenter
            }

            width: (root.columns * root.cellSize) + (2 * spacing)

            spacing: PlasmaCore.Units.gridUnit * 2

            Item {
                id: mainColumn

                anchors.top: parent.top

                width: (columns * root.cellSize) + PlasmaCore.Units.gridUnit
                height: Math.floor(parent.height / root.cellSize) * root.cellSize + mainGridContainer.headerHeight

                property int columns: root.columns  - filterListColumn.columns
                property Item visibleGrid: mainGrid

                function tryActivate(row, col) {
                    if (visibleGrid) {
                        visibleGrid.tryActivate(row, col);
                    }
                }

                Item {
                    id: mainGridContainer

                    anchors.fill: parent
                    z: (opacity === 1.0) ? 1 : 0

                    visible: opacity !== 0.0

                    property int headerHeight: PlasmaCore.Units.largeSpacing

                    opacity: {
                        if (root.searching) {
                            return 0.0;
                        }

                        if (filterList.allApps) {
                            return 0.0;
                        }

                        return 1.0;
                    }

                    onOpacityChanged: {
                        if (opacity === 1.0) {
                            mainColumn.visibleGrid = mainGrid;
                        }
                    }

                    ItemGridView {
                        id: mainGrid

                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }

                        width: parent.width

                        cellWidth: root.cellSize
                        cellHeight: cellWidth
                        iconSize: root.iconSize

                        model: funnelModel

                        onCurrentIndexChanged: {
                            preloadAllAppsTimer.defer();
                        }

                        onKeyNavRight: {
                            filterListScrollArea.focus = true;
                        }
                    }
                }

                ItemMultiGridView {
                    id: allAppsGrid

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }

                    z: (opacity === 1.0) ? 1 : 0
                    width: parent.width

                    visible: opacity !== 0.0

                    opacity: filterList.allApps ? 1.0 : 0.0

                    onOpacityChanged: {
                        if (opacity === 1.0) {
                            allAppsGrid.flickableItem.contentY = 0;
                            mainColumn.visibleGrid = allAppsGrid;
                        }
                    }

                    onKeyNavRight: {
                        filterListScrollArea.focus = true;
                    }
                }

                ItemMultiGridView {
                    id: runnerGrid

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }

                    z: (opacity === 1.0) ? 1 : 0
                    width: parent.width
                    height: implicitHeight

                    visible: opacity !== 0.0

                    model: runnerModel

                    grabFocus: true

                    opacity: root.searching ? 1.0 : 0.0

                    onOpacityChanged: {
                        if (opacity === 1.0) {
                            mainColumn.visibleGrid = runnerGrid;
                        }
                    }
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Tab) {
                        event.accepted = true;

                        if (filterList.enabled) {
                            filterList.forceActiveFocus();
                        }
                    } else if (event.key === Qt.Key_Backtab) {
                        event.accepted = true;

                        if (root.searching) {
                            cancelSearchButton.focus = true;
                        }
                    }
                }
            }

            Item {
                id: filterListColumn

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }

                width: columns * root.cellSize

                property int columns: 3

                PlasmaExtras.ScrollArea {
                    id: filterListScrollArea

                    x: root.visible ? 0 : PlasmaCore.Units.gridUnit

                    Behavior on x { SmoothedAnimation { duration: PlasmaCore.Units.longDuration; velocity: 0.01 } }

                    width: parent.width
                    height: mainGrid.height

                    enabled: !root.searching

                    property alias currentIndex: filterList.currentIndex

                    opacity: root.visible ? (root.searching ? 0.30 : 1.0) : 0.3

                    Behavior on opacity { SmoothedAnimation { duration: PlasmaCore.Units.longDuration; velocity: 0.01 } }

                    verticalScrollBarPolicy: (opacity === 1.0) ? Qt.ScrollBarAsNeeded : Qt.ScrollBarAlwaysOff

                    onEnabledChanged: {
                        if (!enabled) {
                            root.filterListIndex = filterList.currentIndex;
                            filterList.currentIndex = -1;
                        } else {
                            filterList.currentIndex = root.filterListIndex;
                        }
                    }

                    onCurrentIndexChanged: {
                        focus = (currentIndex !== -1);
                    }

                    ListView {
                        id: filterList

                        focus: true

                        property bool allApps: false
                        property int eligibleWidth: width
                        property int hItemMargins: Math.max(highlightItemSvg.margins.left + highlightItemSvg.margins.right,
                            listItemSvg.margins.left + listItemSvg.margins.right)

                        model: rootModel

                        boundsBehavior: Flickable.StopAtBounds
                        snapMode: ListView.SnapToItem
                        spacing: 0
                        keyNavigationWraps: true

                        delegate: MouseArea {
                            id: item

                            signal actionTriggered(string actionId, variant actionArgument)
                            signal aboutToShowActionMenu(variant actionMenu)

                            property var m: model
                            property int textWidth: label.contentWidth
                            property int mouseCol
                            property bool hasActionList: ((model.favoriteId !== null)
                                || (("hasActionList" in model) && (model.hasActionList === true)))
                            property Item menu: actionMenu

                            width: ListView.view.width
                            height: Math.ceil((label.paintedHeight
                                + Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                                listItemSvg.margins.top + listItemSvg.margins.bottom)) / 2) * 2

                            Accessible.role: Accessible.MenuItem
                            Accessible.name: model.display

                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            hoverEnabled: true

                            onContainsMouseChanged: {
                                if (!containsMouse) {
                                    updateCurrentItemTimer.stop();
                                }
                            }

                            onPositionChanged: mouse => { // Lazy menu implementation.
                                mouseCol = mouse.x;

                                if (justOpenedTimer.running || ListView.view.currentIndex === 0 || index === ListView.view.currentIndex) {
                                    updateCurrentItem();
                                } else if ((index === ListView.view.currentIndex - 1) && mouse.y < (height - 6)
                                    || (index === ListView.view.currentIndex + 1) && mouse.y > 5) {

                                    if (mouse.x > ListView.view.eligibleWidth - 5) {
                                        updateCurrentItem();
                                    }
                                } else if (mouse.x > ListView.view.eligibleWidth) {
                                    updateCurrentItem();
                                }

                                updateCurrentItemTimer.restart();
                            }

                            onPressed: mouse => {
                                if (mouse.buttons & Qt.RightButton) {
                                    if (hasActionList) {
                                        openActionMenu(item, mouse.x, mouse.y);
                                    }
                                }
                            }

                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton) {
                                    updateCurrentItem();
                                }
                            }

                            onAboutToShowActionMenu: {
                                var actionList = hasActionList ? model.actionList : [];
                                Tools.fillActionMenu(i18n, actionMenu, actionList, ListView.view.model.favoritesModel, model.favoriteId);
                            }

                            onActionTriggered: {
                                if (Tools.triggerAction(ListView.view.model, model.index, actionId, actionArgument) === true) {
                                    plasmoid.expanded = false;
                                }
                            }

                            function openActionMenu(visualParent, x, y) {
                                aboutToShowActionMenu(actionMenu);
                                actionMenu.visualParent = visualParent;
                                actionMenu.open(x, y);
                            }

                            function updateCurrentItem() {
                                ListView.view.currentIndex = index;
                                ListView.view.eligibleWidth = Math.min(width, mouseCol);
                            }

                            ActionMenu {
                                id: actionMenu

                                onActionClicked: {
                                    actionTriggered(actionId, actionArgument);
                                }
                            }

                            Timer {
                                id: updateCurrentItemTimer

                                interval: 50
                                repeat: false

                                onTriggered: parent.updateCurrentItem()
                            }

                            PlasmaExtras.Heading {
                                id: label

                                anchors {
                                    fill: parent
                                    leftMargin: highlightItemSvg.margins.left
                                    rightMargin: highlightItemSvg.margins.right
                                }

                                elide: Text.ElideRight
                                wrapMode: Text.NoWrap
                                opacity: 1.0

                                color: "white"

                                level: 1

                                text: model.display
                            }
                        }

                        highlight: PlasmaComponents.Highlight {
                            anchors {
                                top: filterList.currentItem ? filterList.currentItem.top : undefined
                                left: filterList.currentItem ? filterList.currentItem.left : undefined
                                bottom: filterList.currentItem ? filterList.currentItem.bottom : undefined
                            }

                            opacity: filterListScrollArea.focus ? 1.0 : 0.7

                            width: (highlightItemSvg.margins.left
                                + (filterList.currentItem ? filterList.currentItem.textWidth : 0)
                                + highlightItemSvg.margins.right
                                + PlasmaCore.Units.smallSpacing)

                            visible: filterList.currentItem
                        }

                        highlightFollowsCurrentItem: false
                        highlightMoveDuration: 0
                        highlightResizeDuration: 0

                        onCurrentIndexChanged: applyFilter()

                        onCountChanged: {
                            var width = 0;

                            for (var i = 0; i < rootModel.count; ++i) {
                                headingMetrics.text = rootModel.labelForRow(i);

                                if (headingMetrics.width > width) {
                                    width = headingMetrics.width;
                                }
                            }

                            filterListColumn.columns = Math.ceil(width / root.cellSize);
                            filterListScrollArea.width = width + hItemMargins + (PlasmaCore.Units.gridUnit * 2);
                        }

                        function applyFilter() {
                            if (!root.searching && currentIndex >= 0) {
                                if (preloadAllAppsTimer.running) {
                                    preloadAllAppsTimer.stop();
                                }

                                var model = rootModel.modelForRow(currentIndex);

                                if (model.description === "KICKER_ALL_MODEL") {
                                    allAppsGrid.model = model;
                                    allApps = true;
                                    funnelModel.sourceModel = null;
                                    preloadAllAppsTimer.done = true;
                                } else if (model.description === "KICKER_FAVORITES_MODEL") {
                                    funnelModel.sourceModel = rootModel.favoritesModel;
                                    allApps = false;
                                } else {
                                    funnelModel.sourceModel = model;
                                    allApps = false;
                                }
                            } else {
                                funnelModel.sourceModel = null;
                                allApps = false;
                            }
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Left) {
                                event.accepted = true;

                                const currentRow = Math.max(0, Math.ceil(currentItem.y / mainGrid.cellHeight) - 1);
                                mainColumn.tryActivate(currentRow, mainColumn.columns - 1);
                            } else if (event.key === Qt.Key_Tab) {
                                event.accepted = true;
                                mainColumn.tryActivate(0, 0);
                            }
                        }
                    }
                }
            }
        }

        onPressed: mouse => {
            if (mouse.button === Qt.RightButton) {
                contextMenu.open(mouse.x, mouse.y);
            }
        }

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                root.toggle();
            }
        }
    }
}
