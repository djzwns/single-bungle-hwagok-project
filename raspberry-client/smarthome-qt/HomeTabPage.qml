import QtQuick 2.0
import "colorhelper.js" as ColorHelper

Item {
    anchors.fill: parent
    QtObject {
        id: temperature
        property real value: 0
        property real newValue: 22
        property bool dirty: true

//        SequentialAnimation on value {
//            loops: Animation.Infinite
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//            NumberAnimation { to: radial.maxValue; duration: 2000 }
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//        }
        NumberAnimation on value {
            from: 0
            to: temperature.newValue
            duration: 1500
            running: temperature.dirty
        }
    }

    RadialBar {
        id: radial
        value: temperature.value
        progressColor: ColorHelper.colorStringHSVLerp("#ff3299ff", "#ffff0e0e", valueRate)
        width: 200
        height: 200
        anchors.centerIn: parent
    }

    function setTemp(temp) {
        temperature.newValue = temp;
    }
}
