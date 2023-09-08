import QtQuick 2.0
import org.kde.plasma.configuration 2.0
import org.kde.plasma.private.weather 1.0 as WeatherPlugin

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "configure"
		source: "config/ConfigGeneral.qml"
	}
	ConfigCategory {
		name: i18ndc("plasma_applet_org.kde.plasma.weather", "@title", "Units")
		icon: "preferences-other"
		source: "libweather/ConfigUnits.qml"
		visible: typeof WeatherPlugin["Util"] !== "undefined" // Plasma 5.13+
	}
}
