/*
    SPDX-FileCopyrightText: 2021 qewer33
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.0
import QtQml 2.2

import org.kde.plasma.configuration 2.0

ConfigModel {
    id: configModel

    ConfigCategory {
         name: i18n("Appearance")
         icon: "preferences-desktop-color"
         source: "config/configAppearance.qml"
    }
}
