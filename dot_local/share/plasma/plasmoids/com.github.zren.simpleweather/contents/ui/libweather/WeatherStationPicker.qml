// Version 4
// Based On: https://invent.kde.org/plasma/kdeplasma-addons/-/blame/master/applets/weather/package/contents/ui/config/WeatherStationPicker.qml

/*
 * SPDX-FileCopyrightText: 2022 Chris Holland <zrenfire@gmail.com>
 * SPDX-FileCopyrightText: 2016, 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.9

import QtQuick.Controls 2.5 as QQC2
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.8 as Kirigami

import org.kde.plasma.private.weather 1.0 as WeatherPlugin


ColumnLayout {
	id: root

	// Use weather dataengine to list weather providers instead of plasmoid.nativeInterface.providers
	property alias providers: weatherDataSource.ionServiceList
	readonly property bool hasProviders: providers.length > 0
	property var weatherDataSource: PlasmaCore.DataSource {
		id: weatherDataSource
		engine: "weather"
		connectedSources: ['ions']

		// {"bbcukmet":"BBC Weather|bbcukmet","envcan":"Environment Canada|envcan","noaa":"NOAA's National Weather Service|noaa","wettercom":"wetter.com|wettercom"}
		readonly property var ions: data['ions']
		readonly property var ionServiceList: ions ? Object.keys(ions) : []
		// onIonsChanged: console.log('ions', JSON.stringify(ions))
		// onIonServiceListChanged: console.log('ionServiceList', JSON.stringify(ionServiceList))
	}

	property string source
	readonly property bool canSearch: !!searchStringEdit.text && hasProviders

	function searchLocation() {
		if (!canSearch) {
			return;
		}
		noSearchResultReport.visible = false;
		source = "";
		locationListModel.searchLocations(searchStringEdit.text, root.providers);
	}

	WeatherPlugin.LocationListModel {
		id: locationListModel
		onLocationSearchDone: {
			if (!success) {
				noSearchResultReport.text = i18ndc("plasma_applet_org.kde.plasma.weather", "@info", "No weather stations found for '%1'", searchString);
				noSearchResultReport.visible = true;
			} else {
				// If we got any results, pre-select the top item to potentially
				// save the user a step
				locationListView.currentIndex = 0;
				noSearchResultReport.visible = false;
			}
		}
	}

	RowLayout {
		Layout.fillWidth: true

		enabled: root.hasProviders

		Kirigami.SearchField {
			id: searchStringEdit

			Layout.fillWidth: true
			Layout.minimumWidth: implicitWidth
			focus: true
			placeholderText: i18ndc("plasma_applet_org.kde.plasma.weather", "@info:placeholder", "Enter location")

			Timer {
				id: searchDelayTimer
				interval: 500
				onTriggered: {
					searchLocation();
				}
			}

			onTextChanged: {
				searchDelayTimer.restart();
			}

			Keys.onPressed: {
				if (event.key == Qt.Key_Up) {
					if (locationListView.currentIndex != 0) {
						locationListView.currentIndex--;
					}
					event.accepted = true;
				} else if (event.key == Qt.Key_Down) {
					if (locationListView.currentIndex != locationListView.count - 1) {
						locationListView.currentIndex++;
					}
					event.accepted = true;
				} else {
					event.accepted = false;
				}
			}
		}
	}

	QQC2.ScrollView {
		Layout.fillWidth: true
		Layout.fillHeight: true

		enabled: root.hasProviders

		Component.onCompleted: {
			background.visible = true;
		}

		ListView {
			id: locationListView
			model: locationListModel
			clip: true
			focus: true
			activeFocusOnTab: true
			keyNavigationEnabled: true

			onCurrentItemChanged: {
				source = locationListModel.valueForListIndex(locationListView.currentIndex);
			}

			delegate: QQC2.ItemDelegate {
				width: locationListView.width
				text: model.display
				highlighted: ListView.isCurrentItem

				onClicked: {
					locationListView.forceActiveFocus();
					locationListView.currentIndex = index;
				}
			}

			QQC2.Label {
				id: noSearchResultReport

				anchors.fill: parent
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				wrapMode: Text.WordWrap
				visible: false
				enabled: false
			}

			QQC2.BusyIndicator {
				id: busy

				anchors.centerIn: parent

				visible: locationListModel.validatingInput
			}
		}
	}

	Component.onCompleted: {
		searchStringEdit.forceActiveFocus();
	}
}
