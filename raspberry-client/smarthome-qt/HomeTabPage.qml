import QtQuick 2.0

Item {
    QtObject {
        id: animObject
        property real value: 0

        SequentialAnimation on value {
            loops: Animation.Infinite
            NumberAnimation { to: radial.minValue; duration: 2000 }
            NumberAnimation { to: radial.maxValue; duration: 2000 }
            NumberAnimation { to: radial.minValue; duration: 2000 }
        }
    }

    RadialBar {
        id: radial
        value: animObject.value
    }
}
