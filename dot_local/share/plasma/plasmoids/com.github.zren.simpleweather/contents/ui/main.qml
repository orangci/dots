import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import "./libweather" as LibWeather

Item {
	id: widget

	LibWeather.WeatherData {
		id: weatherData
	}

	Plasmoid.icon: weatherData.currentConditionIconName
	Plasmoid.toolTipMainText: weatherData.currentConditions

	Plasmoid.fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		property Item contentItem: weatherData.needsConfiguring ? configureButton : forecastLayout
		Layout.preferredWidth: 200 * PlasmaCore.Units.devicePixelRatio
		Layout.preferredHeight: 150 * PlasmaCore.Units.devicePixelRatio
		width: Layout.preferredWidth
		height: Layout.preferredHeight

		PlasmaComponents3.Button {
			id: configureButton
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18nd("plasma_applet_org.kde.plasma.weather", "Set location…")
			onClicked: plasmoid.action("configure").trigger()
			Layout.minimumWidth: implicitWidth
			Layout.minimumHeight: implicitHeight
		}

		ForecastLayout {
			id: forecastLayout
			anchors.fill: parent
			visible: !weatherData.needsConfiguring
		}

	}

	function action_refresh() {
		weatherData.refresh()
	}

	Component.onCompleted: {
		plasmoid.setAction("refresh", i18n("Refresh"), "view-refresh")

		// plasmoid.action("configure").trigger()
	}
}
