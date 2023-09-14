/*
    SPDX-FileCopyrightText: 2013-2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2022 Himprakash Deka <himprakashd@gmail.com>
    
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
// Deliberately imported after QtQuick to avoid missing restoreMode property in Binding. Fix in Qt 6.
import QtQml 2.15

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.kirigami 2.19 as Kirigami

FocusScope {
    id: root

    focus: true

    Layout.minimumWidth: (sideBar.width + (sideBar.width ? mainRow.spacing : 0)
        + Math.max(searchField.defaultWidth, runnerColumns.width))
    Layout.maximumWidth: Math.max(mainRow.width, Layout.minimumWidth); // mainRow.width is constrained by rootList.maximumWidth

    Layout.minimumHeight: Math.max(((rootModel.count - rootModel.separatorCount) * rootList.itemHeight) + ((rootModel.separatorCount + 1) * rootList.separatorHeight)
        + searchField.height, sideBar.margins.top + sideBar.margins.bottom
        + favoriteSystemActions.contentHeight)
    Layout.maximumHeight: Layout.minimumHeight

    signal appendSearchText(string text)

    function reset() {
        plasmoid.hideOnWindowDeactivate = true;

        rootList.currentIndex = -1;

        searchField.text = "";
        searchField.focus = true;
    }

    Row {
        id: mainRow

        height: parent.height

        spacing: PlasmaCore.Units.smallSpacing

        LayoutMirroring.enabled: ((plasmoid.location === PlasmaCore.Types.RightEdge)
            || (Qt.application.layoutDirection === Qt.RightToLeft && plasmoid.location !== PlasmaCore.Types.LeftEdge))

        PlasmaCore.FrameSvgItem {
            id: sideBar

            visible: width > 0

            width: systemFavorites && systemFavorites.count ? PlasmaCore.Units.iconSizes.medium + margins.left + margins.right : 0
            height: parent.height

            imagePath: "widgets/frame"
            prefix: "plain"

            SideBarSection {
                id: favoriteSystemActions

                anchors.bottom: parent.bottom
                anchors.bottomMargin: sideBar.margins.bottom

                model: systemFavorites
                usesPlasmaTheme: true

                states: [ State {
                    name: "top"
                    when: (plasmoid.location === PlasmaCore.Types.TopEdge)

                    AnchorChanges {
                        target: favoriteSystemActions
                        anchors.top: parent.top
                        anchors.bottom: undefined
                    }

                    PropertyChanges {
                        target: favoriteSystemActions
                        anchors.topMargin: sideBar.margins.top
                        anchors.bottomMargin: undefined
                    }
                }]
            }
        }

        ItemListView {
            id: rootList

            anchors.top: parent.top

            minimumWidth: root.Layout.minimumWidth - sideBar.width - mainRow.spacing
            height: ((rootModel.count - rootModel.separatorCount) * itemHeight) + (rootModel.separatorCount * separatorHeight)

            visible: searchField.text === ""

            iconsEnabled: plasmoid.configuration.showIconsRootLevel

            model: rootModel

            onKeyNavigationAtListEnd: {
                searchField.focus = true;
            }

            states: [ State {
                name: "top"
                when: (plasmoid.location === PlasmaCore.Types.TopEdge)

                AnchorChanges {
                    target: rootList
                    anchors.top: parent.top
                }
            }]

            Component.onCompleted: {
                rootList.exited.connect(root.reset);
            }
        }

        Row {
            id: runnerColumns

            height: parent.height

            signal focusChanged()

            visible: searchField.text !== "" && runnerModel.count > 0

            Repeater {
                id: runnerColumnsRepeater

                model: runnerModel

                delegate: RunnerResultsList {
                    id: runnerMatches

                    onKeyNavigationAtListEnd: {
                        searchField.focus = true;
                    }

                    onContainsMouseChanged: {
                        if (containsMouse) {
                            runnerMatches.focus = true;
                        }
                    }

                    onFocusChanged: {
                        if (focus) {
                            runnerColumns.focusChanged();
                        }
                    }

                    function focusChanged() {
                        if (!runnerMatches.focus && runnerMatches.currentIndex != -1) {
                            runnerMatches.currentIndex = -1;
                        }
                    }

                    Keys.onPressed: event => {
                        var target = null;

                        if (event.key === Qt.Key_Right) {
                            var targets = new Array();

                            for (var i = index + 1; i < runnerModel.count; ++i) {
                                targets[targets.length] = i;
                            }

                            for (var i = 0; i < index; ++i) {
                                targets[targets.length] = i;
                            }

                            for (var i = 0; i < targets.length; ++i) {
                                if (runnerModel.modelForRow(targets[i]).count) {
                                    target = runnerColumnsRepeater.itemAt(targets[i]);
                                    break;
                                }
                            }
                        } else if (event.key === Qt.Key_Left) {
                            var targets = new Array();

                            for (var i = index - 1; i >= 0; --i) {
                                targets[targets.length] = i;
                            }

                            for (var i = runnerModel.count - 1; i > index; --i) {
                                targets[targets.length] = i;
                            }

                            for (var i = 0; i < targets.length; ++i) {
                                if (runnerModel.modelForRow(targets[i]).count) {
                                    target = runnerColumnsRepeater.itemAt(targets[i]);
                                    break;
                                }
                            }
                        }

                        if (target) {
                            event.accepted = true;
                            currentIndex = -1;
                            target.currentIndex = 0;
                            target.focus = true;
                        }
                    }

                    Component.onCompleted: {
                        runnerColumns.focusChanged.connect(focusChanged);
                    }

                    Component.onDestruction: {
                        runnerColumns.focusChanged.disconnect(focusChanged);
                    }
                }
            }
        }
    }

    PlasmaExtras.SearchField {
        id: searchField

        anchors.bottom: mainRow.bottom
        anchors.left: parent.left
        anchors.leftMargin: sideBar.width + (sideBar.width ? mainRow.spacing : 0) + PlasmaCore.Units.smallSpacing

        readonly property real defaultWidth: PlasmaCore.Units.gridUnit * 14
        width: (runnerColumnsRepeater.count !== 0 ? runnerColumnsRepeater.itemAt(0).width
                                                  : (rootList.visible ? rootList.width : defaultWidth))
                - PlasmaCore.Units.smallSpacing

        focus: !Kirigami.InputMethod.willShowOnActive

        onTextChanged: {
            runnerModel.query = text;
        }

        onFocusChanged: {
            if (focus) {
                // FIXME: Cleanup arbitration between rootList/runnerCols here and in Keys.
                if (rootList.visible) {
                    rootList.currentIndex = -1;
                }

                if (runnerColumns.visible) {
                    runnerColumnsRepeater.itemAt(0).currentIndex = -1;
                }
            }
        }

        states: [ State {
            name: "top"
            when: plasmoid.location === PlasmaCore.Types.TopEdge

            AnchorChanges {
                target: searchField
                anchors.top: undefined
                anchors.bottom: mainRow.bottom
                anchors.left: parent.left
                anchors.right: undefined
            }

            PropertyChanges {
                target: searchField
                anchors.leftMargin: sideBar.width + mainRow.spacing + PlasmaCore.Units.smallSpacing
                anchors.rightMargin: undefined
            }
        },
        State {
            name: "right"
            when: (plasmoid.location === PlasmaCore.Types.RightEdge && Qt.application.layoutDirection === Qt.LeftToRight)
                || (plasmoid.location === PlasmaCore.Types.LeftEdge && Qt.application.layoutDirection === Qt.RightToLeft)

            AnchorChanges {
                target: searchField
                anchors.top: undefined
                anchors.bottom: mainRow.bottom
                anchors.left: undefined
                anchors.right: parent.right
            }

            PropertyChanges {
                target: searchField
                anchors.leftMargin: undefined
                anchors.rightMargin: sideBar.width + mainRow.spacing + PlasmaCore.Units.smallSpacing
            }
        }]

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up) {
                if (rootList.visible) {
                    rootList.showChildDialogs = false;
                    rootList.currentIndex = rootList.model.count - 1;
                    rootList.forceActiveFocus();
                    rootList.showChildDialogs = true;
                }

                if (runnerColumns.visible) {
                    for (var i = 0; i < runnerModel.count; ++i) {
                        if (runnerModel.modelForRow(i).count) {
                            var targetList = runnerColumnsRepeater.itemAt(i);
                            targetList.currentIndex = runnerModel.modelForRow(i).count - 1;
                            targetList.forceActiveFocus();
                            break;
                        }
                    }
                }
            } else if (event.key === Qt.Key_Down) {
                if (rootList.visible) {
                    rootList.showChildDialogs = false;
                    rootList.currentIndex = Math.min(1, rootList.count);
                    rootList.forceActiveFocus();
                    rootList.showChildDialogs = true;
                }

                if (runnerColumns.visible) {
                    for (var i = 0; i < runnerModel.count; ++i) {
                        if (runnerModel.modelForRow(i).count) {
                            var targetList = runnerColumnsRepeater.itemAt(i);
                            targetList.currentIndex = Math.min(1, targetList.count);
                            targetList.forceActiveFocus();
                            break;
                        }
                    }
                }
            } else if (event.key === Qt.Key_Left && cursorPosition === 0) {
                    for (var i = runnerModel.count; i >= 0; --i) {
                        if (runnerModel.modelForRow(i).count) {
                            var targetList = runnerColumnsRepeater.itemAt(i);
                            targetList.currentIndex = 0;
                            targetList.forceActiveFocus();
                            break;
                        }
                    }
            } else if (event.key === Qt.Key_Right && cursorPosition === length) {
                for (var i = 1; i < runnerModel.count; ++i) {
                    if (runnerModel.modelForRow(i).count) {
                        var targetList = runnerColumnsRepeater.itemAt(i);
                        targetList.currentIndex = 0;
                        targetList.forceActiveFocus();
                        break;
                    }
                }
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if (runnerColumns.visible && runnerModel.modelForRow(0).count) {
                    runnerModel.modelForRow(0).trigger(0, "", null);
                    plasmoid.expanded = false;
                }
            }
        }

        function appendText(newText) {
            focus = true;
            text = text + newText;
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape) {
            plasmoid.expanded = false;
        }
    }

    Component.onCompleted: {
        appendSearchText.connect(searchField.appendText);

        kicker.reset.connect(reset);
        windowSystem.hidden.connect(reset);
    }
}
