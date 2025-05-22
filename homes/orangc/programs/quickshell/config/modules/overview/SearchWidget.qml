import "root:/"
import "root:/services/"
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/modules/common/functions/string_utils.js" as StringUtils
import Qt5Compat.GraphicalEffects
import Qt.labs.platform
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Item { // Wrapper
    id: root
    required property var panelWindow
    readonly property string xdgConfigHome: XdgDirectories.config
    property string searchingText: ""
    property bool showResults: searchingText != ""
    property real searchBarHeight: searchBar.height + Appearance.sizes.elevationMargin * 2
    implicitWidth: searchWidgetContent.implicitWidth + Appearance.sizes.elevationMargin * 2
    implicitHeight: searchWidgetContent.implicitHeight + Appearance.sizes.elevationMargin * 2

    property string mathResult: ""
    property var searchActions: [
        {
            action: "img", 
            execute: () => {
                executor.executeCommand(`${xdgConfigHome}/quickshell/scripts/switchwall.sh`.replace(/file:\/\//, ""))
            }
        },
        {
            action: "dark",
            execute: () => {
                executor.executeCommand(`${xdgConfigHome}/quickshell/scripts/switchwall.sh --mode dark --noswitch`.replace(/file:\/\//, ""))
            }
        },
        {
            action: "light",
            execute: () => {
                executor.executeCommand(`${xdgConfigHome}/quickshell/scripts/switchwall.sh --mode light --noswitch`.replace(/file:\/\//, ""))
            }
        },
        {
            action: "accentcolor",
            execute: (args) => {
                executor.executeCommand(
                    `${xdgConfigHome}/quickshell/scripts/switchwall.sh --noswitch --color ${args != '' ? ("'"+args+"'") : ""}`
                    .replace(/file:\/\//, ""))
            }
        },
        {
            action: "todo",
            execute: (args) => {
                Todo.addTask(args)
            }
        },
    ]

    function focusFirstItemIfNeeded() {
        if (searchInput.focus) appResults.currentIndex = 0; // Focus the first item
    }

    Timer {
        id: nonAppResultsTimer
        interval: ConfigOptions.search.nonAppResultDelay
        onTriggered: {
            mathProcess.calculateExpression(root.searchingText);
        }
    }

    Process {
        id: mathProcess
        property list<string> baseCommand: ["qalc", "-t"]
        function calculateExpression(expression) {
            // mathProcess.running = false
            mathProcess.command = baseCommand.concat(expression)
            mathProcess.running = true
        }
        stdout: SplitParser {
            onRead: data => {
                root.mathResult = data
                root.focusFirstItemIfNeeded()
            }
        }
    }

    Process {
        id: executor
        property list<string> baseCommand: ["bash", "-c"]
        function executeCommand(command) {
            executor.command = baseCommand.concat(
                `${command} || ${ConfigOptions.apps.terminal} fish -C 'echo "${qsTr("Searching for package with that command")}..." && pacman -F ${command}'`
            )
            executor.startDetached()
        }
    }

    Keys.onPressed: (event) => {
        // Prevent Esc and Backspace from registering
        if (event.key === Qt.Key_Escape) return;

        // Handle Backspace: focus and delete character if not focused
        if (event.key === Qt.Key_Backspace) {
            if (!searchInput.activeFocus) {
                searchInput.forceActiveFocus();
                if (event.modifiers & Qt.ControlModifier) {
                    // Delete word before cursor
                    let text = searchInput.text;
                    let pos = searchInput.cursorPosition;
                    if (pos > 0) {
                        // Find the start of the previous word
                        let left = text.slice(0, pos);
                        let match = left.match(/(\s*\S+)\s*$/);
                        let deleteLen = match ? match[0].length : 1;
                        searchInput.text = text.slice(0, pos - deleteLen) + text.slice(pos);
                        searchInput.cursorPosition = pos - deleteLen;
                    }
                } else {
                    // Delete character before cursor if any
                    if (searchInput.cursorPosition > 0) {
                        searchInput.text = searchInput.text.slice(0, searchInput.cursorPosition - 1) +
                            searchInput.text.slice(searchInput.cursorPosition);
                        searchInput.cursorPosition -= 1;
                    }
                }
                // Always move cursor to end after programmatic edit
                searchInput.cursorPosition = searchInput.text.length;
                event.accepted = true;
            }
            // If already focused, let TextField handle it
            return;
        }

        // Only handle visible printable characters (ignore control chars, arrows, etc.)
        if (
            event.text &&
            event.text.length === 1 &&
            event.key !== Qt.Key_Enter &&
            event.key !== Qt.Key_Return &&
            event.text.charCodeAt(0) >= 0x20 // ignore control chars like Backspace, Tab, etc.
        ) {
            if (!searchInput.activeFocus) {
                searchInput.forceActiveFocus();
                // Insert the character at the cursor position
                searchInput.text = searchInput.text.slice(0, searchInput.cursorPosition) +
                                event.text +
                                searchInput.text.slice(searchInput.cursorPosition);
                searchInput.cursorPosition += 1;
                event.accepted = true;
            }
        }
    }

    Rectangle { // Background
        id: searchWidgetContent
        anchors.centerIn: parent
        implicitWidth: columnLayout.implicitWidth
        implicitHeight: columnLayout.implicitHeight
        radius: Appearance.rounding.large
        color: Appearance.colors.colLayer0
        layer.enabled: true
        layer.effect: MultiEffect {
            source: searchWidgetContent
            anchors.fill: searchWidgetContent
            shadowEnabled: true
            shadowColor: Appearance.colors.colShadow
            shadowVerticalOffset: 1
            shadowBlur: 0.5
        }

        ColumnLayout {
            id: columnLayout
            anchors.centerIn: parent
            spacing: 0

            clip: true
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: searchWidgetContent.width
                    height: searchWidgetContent.width
                    radius: searchWidgetContent.radius
                }
            }

            RowLayout {
                id: searchBar
                spacing: 5
                MaterialSymbol {
                    id: searchIcon
                    Layout.leftMargin: 15
                    iconSize: Appearance.font.pixelSize.huge
                    color: Appearance.m3colors.m3onSurface
                    text: "search"
                }
                TextField { // Search box
                    id: searchInput

                    focus: root.panelWindow.visible || GlobalStates.overviewOpen
                    Layout.rightMargin: 15
                    padding: 15
                    renderType: Text.NativeRendering
                    color: activeFocus ? Appearance.m3colors.m3onSurface : Appearance.m3colors.m3onSurfaceVariant
                    selectedTextColor: Appearance.m3colors.m3onSecondaryContainer
                    selectionColor: Appearance.m3colors.m3secondaryContainer
                    placeholderText: qsTr("Search, calculate or run")
                    placeholderTextColor: Appearance.m3colors.m3outline
                    implicitWidth: root.searchingText == "" ? Appearance.sizes.searchWidthCollapsed : Appearance.sizes.searchWidth

                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }
                    }

                    onTextChanged: root.searchingText = text
                    Connections {
                        target: root
                        function onVisibleChanged() {
                            searchInput.selectAll()
                            root.searchingText = ""
                        }
                    }

                    onAccepted: {
                        if (appResults.count > 0) {
                            // Get the first visible delegate and trigger its click
                            let firstItem = appResults.itemAtIndex(0);
                            if (firstItem && firstItem.clicked) {
                                firstItem.clicked();
                            }
                        }
                    }

                    background: null

                    cursorDelegate: Rectangle {
                        width: 1
                        color: searchInput.activeFocus ? Appearance.m3colors.m3primary : "transparent"
                        radius: 1
                    }
                }
            }

            Rectangle { // Separator
                visible: root.showResults
                Layout.fillWidth: true
                height: 1
                color: Appearance.m3colors.m3outlineVariant
            }

            ListView { // App results
                id: appResults
                visible: root.showResults
                Layout.fillWidth: true
                implicitHeight: Math.min(600, appResults.contentHeight + topMargin + bottomMargin)
                clip: true
                topMargin: 10
                bottomMargin: 10
                spacing: 0
                KeyNavigation.up: searchBar

                onFocusChanged: {
                    if(focus) appResults.currentIndex = 1;
                }

                Connections {
                    target: root
                    function onSearchingTextChanged() {
                        if (appResults.count > 0)
                            appResults.currentIndex = 0;
                    }
                }

                model: ScriptModel {
                    id: model
                    values: {
                        if(root.searchingText == "") return [];

                        // Start math calculation, declare special result objects
                        nonAppResultsTimer.restart();
                        const mathResultObject = {
                            name: root.mathResult,
                            clickActionName: qsTr("Copy"),
                            type: qsTr("Math result"),
                            fontType: "monospace",
                            materialSymbol: 'calculate',
                            execute: () => {
                                Hyprland.dispatch(`exec wl-copy '${StringUtils.shellSingleQuoteEscape(root.mathResult)}'`)
                            }
                        }
                        const commandResultObject = {
                            name: searchingText,
                            clickActionName: qsTr("Run"),
                            type: qsTr("Run command"),
                            fontType: "monospace",
                            materialSymbol: 'terminal',
                            execute: () => {
                                executor.executeCommand(searchingText.startsWith('sudo') ? `${ConfigOptions.apps.terminal} fish -C '${root.searchingText}'` : root.searchingText);
                            }
                        }
                        const launcherActionObjects = root.searchActions
                            .map(action => {
                                const actionString = `${ConfigOptions.search.prefix.action}${action.action}`;
                                if (actionString.startsWith(root.searchingText) || root.searchingText.startsWith(actionString)) {
                                    return {
                                        name: root.searchingText.startsWith(actionString) ? root.searchingText : actionString,
                                        clickActionName: qsTr("Run"),
                                        type: qsTr("Action"),
                                        materialSymbol: 'settings_suggest',
                                        execute: () => {
                                            action.execute(root.searchingText.split(" ").slice(1).join(" "))
                                        },
                                    };
                                }
                                return null;
                            })
                            .filter(Boolean);

                        // Init result array
                        let result = [];

                        // Add filtered application entries
                        result = result.concat(
                            AppSearch.fuzzyQuery(root.searchingText)
                                .map((entry) => {
                                    entry.clickActionName = qsTr("Launch");
                                    entry.type = qsTr("App");
                                    return entry;
                                })
                        );

                        // Add launcher actions
                        result = result.concat(launcherActionObjects);

                        // Insert math result before command if search starts with a number
                        const startsWithNumber = /^\d/.test(root.searchingText);
                        if (startsWithNumber)
                            result.push(mathResultObject);

                        // Command
                        result.push(commandResultObject);

                        // If not already added, add math result after command
                        if (!startsWithNumber) {
                            result.push(mathResultObject);
                        }

                        // Web search
                        result.push({
                            name: root.searchingText,
                            clickActionName: qsTr("Search"),
                            type: qsTr("Search the web"),
                            materialSymbol: 'travel_explore',
                            execute: () => {
                                let url = ConfigOptions.search.engineBaseUrl + root.searchingText
                                for (let site of ConfigOptions.search.excludedSites) {
                                    url += ` -site:${site}`;
                                }
                                Qt.openUrlExternally(url);
                            }
                        });

                        return result;
                    }
                }
                delegate: SearchItem {
                    entry: modelData
                }
            }
            
        }
    }
}