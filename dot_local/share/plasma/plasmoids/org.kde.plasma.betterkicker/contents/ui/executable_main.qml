/*
    SPDX-FileCopyrightText: 2014-2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2022 Himprakash Deka <himprakashd@gmail.com>
    
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    id: kicker

    anchors.fill: parent

    signal reset

    property bool isDash: plasmoid.pluginName === "org.kde.plasma.betterkickerdash"

    Plasmoid.switchWidth: isDash || !Plasmoid.fullRepresentationItem ? 0 : Plasmoid.fullRepresentationItem.Layout.minimumWidth
    Plasmoid.switchHeight: isDash || !Plasmoid.fullRepresentationItem ? 0 : Plasmoid.fullRepresentationItem.Layout.minimumHeight

    // this is a bit of a hack to prevent Plasma from spawning a dialog on its own when we're Dash
    Plasmoid.preferredRepresentation: isDash ? Plasmoid.fullRepresentation : null

    Plasmoid.compactRepresentation: isDash ? null : compactRepresentation
    Plasmoid.fullRepresentation: isDash ? compactRepresentation : menuRepresentation

    property Component itemListDialogComponent: Qt.createComponent(Qt.resolvedUrl("./ItemListDialog.qml"))
    property Item dragSource: null

    property QtObject globalFavorites: rootModel.favoritesModel
    property QtObject systemFavorites: rootModel.systemFavoritesModel

    Plasmoid.icon: plasmoid.configuration.useCustomButtonImage ? plasmoid.configuration.customButtonImage : plasmoid.configuration.icon

    onSystemFavoritesChanged: {
        systemFavorites.favorites = plasmoid.configuration.favoriteSystemActions;
    }

    function action_menuedit() {
        processRunner.runMenuEditor();
    }

    Component {
        id: compactRepresentation
        CompactRepresentation {}
    }

    Component {
        id: menuRepresentation
        MenuRepresentation {}
    }

    Kicker.RootModel {
        id: rootModel

        autoPopulate: false

        appNameFormat: plasmoid.configuration.appNameFormat
        flat: kicker.isDash || plasmoid.configuration.limitDepth
        sorted: plasmoid.configuration.alphaSort
        showSeparators: !kicker.isDash
        appletInterface: plasmoid

        showAllApps: kicker.isDash
        showAllAppsCategorized: true
        showTopLevelItems: !kicker.isDash
        showRecentApps: plasmoid.configuration.showRecentApps
        showRecentDocs: plasmoid.configuration.showRecentDocs
        showRecentContacts: plasmoid.configuration.showRecentContacts
        showFavoritesPlaceholder: plasmoid.configuration.showFavoritesPlaceholder
        recentOrdering: plasmoid.configuration.recentOrdering

        onShowRecentAppsChanged: {
            plasmoid.configuration.showRecentApps = showRecentApps;
        }

        onShowRecentDocsChanged: {
            plasmoid.configuration.showRecentDocs = showRecentDocs;
        }

        onShowRecentContactsChanged: {
            plasmoid.configuration.showRecentContacts = showRecentContacts;
        }

        onShowFavoritesPlaceholderChanged: {
            plasmoid.configuration.showFavoritesPlaceholder = showFavoritesPlaceholder;
        }

        onRecentOrderingChanged: {
            plasmoid.configuration.recentOrdering = recentOrdering;
        }

        Component.onCompleted: {
            favoritesModel.initForClient("org.kde.plasma.kicker.favorites.instance-" + plasmoid.id)

            if (!plasmoid.configuration.favoritesPortedToKAstats) {
                if (favoritesModel.count < 1) {
                    favoritesModel.portOldFavorites(plasmoid.configuration.favorites);
                }
                plasmoid.configuration.favoritesPortedToKAstats = true;
            }

            rootModel.refresh();
        }
    }

    Connections {
        target: globalFavorites

        function onFavoritesChanged() {
            plasmoid.configuration.favoriteApps = target.favorites;
        }
    }

    Connections {
        target: systemFavorites

        function onFavoritesChanged() {
            plasmoid.configuration.favoriteSystemActions = target.favorites;
        }
    }

    Connections {
        target: plasmoid.configuration

        function onFavoriteAppsChanged() {
            globalFavorites.favorites = plasmoid.configuration.favoriteApps;
        }

        function onFavoriteSystemActionsChanged() {
            systemFavorites.favorites = plasmoid.configuration.favoriteSystemActions;
        }
    }

    property Kicker.RunnerModel runnerModel: Kicker.RunnerModel {
        query: kickoff.searchField ? kickoff.searchField.text : ""
        appletInterface: plasmoid
        mergeResults: true
        favoritesModel: rootModel.favoritesModel
    }

    property Kicker.ComputerModel computerModel: Kicker.ComputerModel {
        appletInterface: plasmoid
        favoritesModel: rootModel.favoritesModel
        systemApplications: plasmoid.configuration.systemApplications
        Component.onCompleted: {
            //systemApplications = plasmoid.configuration.systemApplications;
        }
    }

    property Kicker.RecentUsageModel recentUsageModel: Kicker.RecentUsageModel {
        favoritesModel: rootModel.favoritesModel
    }

    property Kicker.RecentUsageModel frequentUsageModel: Kicker.RecentUsageModel {
        favoritesModel: rootModel.favoritesModel
        ordering: 1 // Popular / Frequently Used
    }

    Kicker.DragHelper {
        id: dragHelper

        dragIconSize: PlasmaCore.Units.iconSizes.medium
    }

    Kicker.ProcessRunner {
        id: processRunner
    }

    Kicker.WindowSystem {
        id: windowSystem
    }

    PlasmaCore.FrameSvgItem {
        id: highlightItemSvg

        visible: false

        imagePath: "widgets/viewitem"
        prefix: "hover"
    }

    PlasmaCore.FrameSvgItem {
        id: listItemSvg

        visible: false

        imagePath: "widgets/listitem"
        prefix: "normal"
    }

    PlasmaCore.Svg {
        id: arrows

        imagePath: "widgets/arrows"
        size: "16x16"
    }

    PlasmaCore.Svg {
        id: lineSvg
        imagePath: "widgets/line"

        property int horLineHeight
        property int vertLineWidth
    }

    PlasmaComponents.Label {
        id: toolTipDelegate

        width: contentWidth
        height: undefined

        property Item toolTip

        text: toolTip ? toolTip.text : ""
    }

    Timer {
        id: justOpenedTimer

        repeat: false
        interval: 600
    }

    Connections {
        target: plasmoid

        function onExpandedChanged(expanded) {
            if (expanded) {
                windowSystem.monitorWindowVisibility(plasmoid.fullRepresentationItem);
                justOpenedTimer.start();
            } else {
                kicker.reset();
            }
        }
    }

    function resetDragSource() {
        dragSource = null;
    }

    function enableHideOnWindowDeactivate() {
        plasmoid.hideOnWindowDeactivate = true;
    }

    Component.onCompleted: {
        if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            plasmoid.activationTogglesExpanded = !kicker.isDash
        }

        windowSystem.focusIn.connect(enableHideOnWindowDeactivate);
        plasmoid.hideOnWindowDeactivate = true;

        if (plasmoid.immutability !== PlasmaCore.Types.SystemImmutable) {
            plasmoid.setAction("menuedit", i18n("Edit Applications…"), "kmenuedit");
        }

        updateSvgMetrics();
        PlasmaCore.Theme.themeChanged.connect(updateSvgMetrics);

        rootModel.refreshed.connect(reset);

        dragHelper.dropped.connect(resetDragSource);
    }
}
