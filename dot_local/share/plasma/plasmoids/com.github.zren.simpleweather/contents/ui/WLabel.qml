import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaComponents3.Label {
	font.pointSize: -1
	font.pixelSize: 12 * PlasmaCore.Units.devicePixelRatio
	font.family: forecastLayout.fontFamily
	font.weight: forecastLayout.fontBold
	color: forecastLayout.textColor
	style: forecastLayout.showOutline ? Text.Outline : Text.Normal
	styleColor: forecastLayout.outlineColor
}
