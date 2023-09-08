// Version 2
// Based On: https://invent.kde.org/plasma/kdeplasma-addons/-/blame/master/applets/weather/package/contents/ui/config/ConfigWeatherStation.qml

/*
 * SPDX-FileCopyrightText: 2019, 2022 Chris Holland <zrenfire@gmail.com>
 * SPDX-FileCopyrightText: 2016, 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.0

import org.kde.kirigami 2.3 as Kirigami

RowLayout {
	id: configWeatherStationPicker
	Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label", "Location:")
	Layout.fillWidth: true

	property var configKey: 'source'
	readonly property var configValue: configKey ? plasmoid.configuration[configKey] : ''

	property var stationPicker: WeatherStationPickerDialog {
		id: stationPicker

		onAccepted: {
			if (configKey) {
				plasmoid.configuration[configKey] = source
			}
		}
	}

	QQC2.Label {
		id: locationDisplay
		Layout.fillWidth: true
		elide: Text.ElideRight
		visible: text != ""

		text: {
			var sourceDetails = configValue.split('|')
			if (sourceDetails.length > 2) {
				return i18ndc("plasma_applet_org.kde.plasma.weather",
					"A weather station location and the weather service it comes from",
					"%1 (%2)",
					sourceDetails[2], sourceDetails[0])
			}
			return ""
		}
	}
	QQC2.Button {
		id: selectButton
		Layout.fillWidth: true
		icon.name: "find-location"
		text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Choose…")
		onClicked: stationPicker.visible = true
	}
}
