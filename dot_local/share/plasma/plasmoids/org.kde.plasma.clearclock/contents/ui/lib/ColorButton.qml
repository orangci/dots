import QtQuick 2.4
import QtQuick.Controls 2.12 as QtControls
import QtQuick.Layouts 1.12 as QtLayouts
/*
    SPDX-FileCopyrightText: 2022 qewer33
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick.Dialogs 1.2

QtControls.Button {
    id: clockFontColorButton
    implicitWidth: 50
    implicitHeight: parent.height

    property color value

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 5
        radius: 3
        color: value
        opacity: if (enabled) 1
                 else 0.4
    }

    MouseArea {
        anchors.fill: parent
        onClicked: dialog.open()
    }

    ColorDialog {
        id: dialog
        title: "Select Background Color"
        color: value
        showAlphaChannel: true
        onAccepted: {
            value = dialog.color
        }
    }
}
