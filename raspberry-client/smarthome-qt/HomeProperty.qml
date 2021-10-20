pragma Singleton
import QtQuick 2.0

QtObject {
    property bool warning: false
    property real currentTemperature: 0
    property real currentHumidity: 0
    property real currentWishTemperature: 0

    property bool light: false
    property bool aircon: false
    property bool airfresher: false
    property bool secure: false

    signal lightToggle(var check)
    signal airconToggle(var check)
    signal airfresherToggle(var check)
    signal secureToggle(var check)
}
