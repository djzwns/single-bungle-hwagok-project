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

    signal toggled(var checkd, var type)
}
