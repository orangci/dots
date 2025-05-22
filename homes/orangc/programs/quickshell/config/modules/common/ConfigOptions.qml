import QtQuick
import Quickshell
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    property QtObject appearance: QtObject {
        property int fakeScreenRounding: 1 // 0: None | 1: Always | 2: When not fullscreen
    }

    property QtObject apps: QtObject {
        property string bluetooth: "better-control --bluetooth"
        property string imageViewer: "gwenview"
        property string network: "better-control --wifi"
        property string settings: "better-control"
        property string taskManager: "btop"
        property string terminal: "kitty" // This is only for shell actions
    }

    property QtObject bar: QtObject {
        property int batteryLowThreshold: 20
        property string topLeftIcon: "spark" // Options: distro, spark
        property bool showBackground: true
        property bool borderless: false
        property QtObject resources: QtObject {
            property bool alwaysShowSwap: true
            property bool alwaysShowCpu: false
        }
        property QtObject workspaces: QtObject {
            property int shown: 7
            property bool alwaysShowNumbers: true
            property int showNumberDelay: 150 // milliseconds
        }
    }

    property QtObject networking: QtObject {
        property string userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
    }

    property QtObject osd: QtObject { property int timeout: 1000 }

    property QtObject overview: QtObject {
        property real scale: 0.14 // Relative to screen size
        property real numOfRows: 2
        property real numOfCols: 4
        property bool showXwaylandIndicator: true
    }

    property QtObject resources: QtObject { property int updateInterval: 3000 }

    property QtObject search: QtObject {
        property int nonAppResultDelay: 30 // This prevents lagging when typing
        property string engineBaseUrl: "https://www.google.com/search?q="
        property list<string> excludedSites: [ "quora.com" ]
        property QtObject prefix: QtObject {
            property string action: "/"
        }
    }

    property QtObject hacks: QtObject { property int arbitraryRaceConditionDelay: 20 } // milliseconds
}
