import QtQuick 2.0
import "colorhelper.js" as ColorHelper

Item {
    anchors.fill: parent
    QtObject {
        id: temperature
        property real value: 0
        property real startValue: 0
        property real endValue: 22
        property real duration: 500

//        SequentialAnimation on value {
//            loops: Animation.Infinite
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//            NumberAnimation { to: radial.maxValue; duration: 2000 }
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//        }
        NumberAnimation on value {
            id: anim
            from: temperature.startValue
            to: temperature.endValue
            duration: temperature.duration
        }
    }

    RadialBar {
        id: radial
        value: temperature.value
        progressColor: ColorHelper.tempColorLerp(valueRate)
        width: 200
        height: 200
        anchors.centerIn: parent
    }

    function setTemp(temp) {
        temperature.startValue = temperature.value;
        temperature.endValue = temp;

        let duration = Math.abs(temperature.endValue - temperature.startValue);
        duration = duration < 10 ? 200 : 500;
        temperature.duration = duration;
        anim.restart();
    }

    function animRestart() {
        temperature.startValue = 0;
        temperature.duration = temperature.endValue < 10 ? 200 : 500;
        anim.restart();
    }
}
